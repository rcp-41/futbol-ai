import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { logger } from 'firebase-functions/v2';
import { defineSecret } from 'firebase-functions/params';
import { verifyData } from './dataVerification';
import { runDeepAnalysis } from './deepAnalysis';
import {
    buildCorrelationInterpretPrompt,
    buildStatsTacticsPrompt,
    buildRefereeChaosPrompt,
    buildSynthesisPrompt,
    buildArbiterPrompt,
    extractMatchInfo,
} from './multiModelPrompts';
import { callGemini, callClaude, callGPT, callArbiter } from './aiClients';
import { parseAIResult } from './multiModelParser';
import { enrichMatchData, formatEnrichmentForPrompt } from './scraperEnrichment';
import { runFullCombinatorialScan, formatCorrelationsForPrompt } from './correlationEngine';

const geminiApiKey = defineSecret('GEMINI_API_KEY');
const anthropicApiKey = defineSecret('ANTHROPIC_API_KEY');
const openaiApiKey = defineSecret('OPENAI_API_KEY');

// Deep analysis modül adları (Türkçe) — fallback durumunda kullanılır
const MODULE_NAMES: Record<string, string> = {
    weather: 'Hava Durumu Analizi',
    missingPlayers: 'Eksik Oyuncu Analizi',
    homeAwayForm: 'Ev/Deplasman Form Analizi',
    h2h: 'Kafa Kafaya Geçmiş',
    xg: 'xG (Beklenen Gol) Analizi',
    setPieces: 'Duran Top Analizi',
    referee: 'Hakem Etkisi Analizi',
    tactics: 'Taktik/Formasyon Analizi',
};

export const onMultiAnalysisCreated = onDocumentCreated({
    document: 'multi_analyses/{analysisId}',
    region: 'europe-west1',
    timeoutSeconds: 540, // 9 minutes
    memory: '1GiB',
    secrets: [geminiApiKey, anthropicApiKey, openaiApiKey],
}, async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const docRef = snap.ref;
    const matchData = data.matchData;

    try {
        // ══════════════════════════════════════════
        // STAGE 1: VERIFICATION
        // ══════════════════════════════════════════
        await docRef.update({ status: 'verifying', statusMessage: 'Maç verileri doğrulanıyor...', updatedAt: new Date() });
        const verification = await verifyData(matchData, geminiApiKey.value());
        await docRef.update({ verification, updatedAt: new Date() });

        if (!verification.verified) {
            await docRef.update({
                status: 'failed',
                statusMessage: 'Veri doğrulama başarısız. Analiz için yeterli veri yok.',
                error: verification.warnings.join(' | '),
                updatedAt: new Date()
            });
            return;
        }

        // ══════════════════════════════════════════
        // STAGE 1.5: SCRAPER ENRICHMENT
        // ══════════════════════════════════════════
        await docRef.update({
            status: 'enriching',
            statusMessage: 'Scraper verileri çekiliyor (takım, oyuncu, TD, hakem)...',
            updatedAt: new Date()
        });

        const enrichment = await enrichMatchData(matchData);
        const enrichmentText = formatEnrichmentForPrompt(enrichment);

        const enrichedMatchData = {
            ...matchData,
            _enrichment: enrichment,
            _enrichmentText: enrichmentText,
        };

        await docRef.update({
            enrichmentSummary: {
                homeTeam: !!enrichment.homeTeamData,
                awayTeam: !!enrichment.awayTeamData,
                homePlayers: enrichment.homeKeyPlayers.length,
                awayPlayers: enrichment.awayKeyPlayers.length,
                homeManager: !!enrichment.homeManagerData,
                awayManager: !!enrichment.awayManagerData,
                referee: !!enrichment.refereeData,
                league: !!enrichment.leagueData,
                news: enrichment.relatedNews.length,
            },
            updatedAt: new Date()
        });

        // ══════════════════════════════════════════
        // STAGE 2: KORELASYON MOTORU
        // ══════════════════════════════════════════
        await docRef.update({
            status: 'scanning',
            statusMessage: 'Korelasyon motoru çalışıyor — tüm metrik çiftleri taranıyor...',
            updatedAt: new Date()
        });

        const homeTeamSlug = normalizeSlug(matchData.homeTeam?.name || matchData.homeTeam || '');
        const awayTeamSlug = normalizeSlug(matchData.awayTeam?.name || matchData.awayTeam || '');
        const season = matchData.season || extractSeason(matchData.matchDate || matchData.date);

        let correlationText = '';
        try {
            const correlationResults = await runFullCombinatorialScan(
                homeTeamSlug, awayTeamSlug, enrichedMatchData, season
            );
            correlationText = formatCorrelationsForPrompt(correlationResults);

            await docRef.update({
                correlationResults: {
                    scanStats: correlationResults.scanStats,
                    topFindings: correlationResults.topFindings.slice(0, 15),
                },
                updatedAt: new Date()
            });

            logger.info(`[Pipeline] Korelasyon taraması tamamlandı: ` +
                `${correlationResults.scanStats.significantFound} anlamlı, ` +
                `${correlationResults.scanStats.relevantToMatch} maça uygun`);
        } catch (corrErr: any) {
            logger.warn(`[Pipeline] Korelasyon motoru hatası (devam ediliyor): ${corrErr.message}`);
        }

        const matchInfo = extractMatchInfo(enrichedMatchData);

        // ══════════════════════════════════════════
        // STAGE 3: 3 KANAL PARALEL
        // ══════════════════════════════════════════
        // Kanal 1: Gemini — Korelasyon Yorumu
        // Kanal 2A: GPT — İstatistik + Taktik
        // Kanal 2B: GPT — Hakem + Kaos
        // ══════════════════════════════════════════
        await docRef.update({
            status: 'channels',
            statusMessage: '3 uzman kanalı paralel çalışıyor (Korelasyon + İstatistik + Kaos)...',
            updatedAt: new Date()
        });

        // Kanal 1 prompt'u — korelasyon yoksa fallback deep analysis
        let channel1Promise: Promise<ChannelResult>;

        if (correlationText.length > 100) {
            // Korelasyon verisi var → Gemini yorumlasın
            const corrPrompt = buildCorrelationInterpretPrompt(matchInfo, correlationText);
            channel1Promise = callGemini(corrPrompt, geminiApiKey.value())
                .then(value => ({ ok: true as const, value, error: '' }))
                .catch(reason => ({ ok: false as const, value: '', error: String(reason) }));
        } else {
            // Korelasyon verisi yetersiz → Deep Analysis fallback
            logger.info('[Pipeline] Korelasyon verisi yetersiz — deep analysis fallback çalışıyor...');
            channel1Promise = (async () => {
                try {
                    const deepResult = await runDeepAnalysis(
                        enrichedMatchData, geminiApiKey.value(),
                        async (moduleName: string, index: number) => {
                            const turkishName = MODULE_NAMES[moduleName] || moduleName;
                            await docRef.update({
                                statusMessage: `Fallback analiz: ${turkishName} (${index + 1}/8)...`,
                                updatedAt: new Date()
                            });
                        }
                    );
                    await docRef.update({ deepAnalysis: deepResult, updatedAt: new Date() });
                    return { ok: true as const, value: JSON.stringify(deepResult), error: '' };
                } catch (err: any) {
                    return { ok: false as const, value: '', error: String(err) };
                }
            })();
        }

        // Kanal 2A — İstatistik + Taktik (GPT)
        const statsTacticsPrompt = buildStatsTacticsPrompt(matchInfo, enrichmentText);
        const channel2APromise: Promise<ChannelResult> = callGPT(statsTacticsPrompt, openaiApiKey.value())
            .then(value => ({ ok: true as const, value, error: '' }))
            .catch(reason => ({ ok: false as const, value: '', error: String(reason) }));

        // Kanal 2B — Hakem + Kaos (GPT)
        const refereeChaosPrompt = buildRefereeChaosPrompt(matchInfo, enrichmentText);
        const channel2BPromise: Promise<ChannelResult> = callGPT(refereeChaosPrompt, openaiApiKey.value())
            .then(value => ({ ok: true as const, value, error: '' }))
            .catch(reason => ({ ok: false as const, value: '', error: String(reason) }));

        // 3 kanal paralel çalışır
        const [ch1Result, ch2AResult, ch2BResult] = await Promise.all([
            channel1Promise, channel2APromise, channel2BPromise
        ]);

        // Sonuçları topla
        const ch1Text = ch1Result.ok ? ch1Result.value : '{"error": "Kanal 1 başarısız"}';
        const ch2AText = ch2AResult.ok ? ch2AResult.value : '{"error": "Kanal 2A başarısız"}';
        const ch2BText = ch2BResult.ok ? ch2BResult.value : '{"error": "Kanal 2B başarısız"}';

        // Kanal sonuçlarını kaydet
        await docRef.update({
            channelResults: {
                correlation: ch1Result.ok ? safeParseJSON(ch1Text) : { error: ch1Result.error },
                statsTactics: ch2AResult.ok ? safeParseJSON(ch2AText) : { error: ch2AResult.error },
                refereeChaos: ch2BResult.ok ? safeParseJSON(ch2BText) : { error: ch2BResult.error },
            },
            updatedAt: new Date()
        });

        const successfulChannels = [ch1Result, ch2AResult, ch2BResult].filter(r => r.ok).length;
        logger.info(`[Pipeline] Kanallar tamamlandı: ${successfulChannels}/3 başarılı`);

        if (successfulChannels === 0) {
            throw new Error('Tüm kanallar başarısız oldu.');
        }

        // ══════════════════════════════════════════
        // STAGE 4: 2 SENTEZCİ PARALEL
        // ══════════════════════════════════════════
        // Sentezci A: Claude Opus 4.6
        // Sentezci B: Gemini 3.1 Pro
        // ══════════════════════════════════════════
        await docRef.update({
            status: 'synthesis',
            statusMessage: 'İki sentezci (Claude + Gemini) paralel analiz yapıyor...',
            updatedAt: new Date()
        });

        const synthesisPromptA = buildSynthesisPrompt(matchInfo, ch1Text, ch2AText, ch2BText, 'Claude Opus 4.6 — Sentezci A');
        const synthesisPromptB = buildSynthesisPrompt(matchInfo, ch1Text, ch2AText, ch2BText, 'Gemini 3.1 Pro — Sentezci B');

        const [synthARaw, synthBRaw] = await Promise.allSettled([
            callClaude(synthesisPromptA, anthropicApiKey.value()),
            callGemini(synthesisPromptB, geminiApiKey.value()),
        ]);

        let synthAJson = null;
        let synthBJson = null;

        if (synthARaw.status === 'fulfilled') {
            try {
                synthAJson = parseAIResult(synthARaw.value, 'Claude_Opus_4_6_SynthA');
                await docRef.update({ synthesisA: synthAJson, updatedAt: new Date() });
            } catch (e: any) {
                logger.error('Sentezci A (Claude) Parse Error:', e);
            }
        } else {
            logger.error('Sentezci A (Claude) API Error:', synthARaw.reason);
        }

        if (synthBRaw.status === 'fulfilled') {
            try {
                synthBJson = parseAIResult(synthBRaw.value, 'Gemini_3_1_Pro_SynthB');
                await docRef.update({ synthesisB: synthBJson, updatedAt: new Date() });
            } catch (e: any) {
                logger.error('Sentezci B (Gemini) Parse Error:', e);
            }
        } else {
            logger.error('Sentezci B (Gemini) API Error:', synthBRaw.reason);
        }

        if (!synthAJson && !synthBJson) {
            throw new Error('Her iki sentezci de başarısız oldu.');
        }

        // ══════════════════════════════════════════
        // STAGE 5: NİHAİ HAKEM (GPT-5.2)
        // ══════════════════════════════════════════
        if (synthAJson && synthBJson) {
            // İki sentezci de başarılı → Hakem karşılaştırsın
            await docRef.update({
                status: 'arbiter',
                statusMessage: 'Nihai hakem (GPT-5.2) iki sentezciyi karşılaştırıyor...',
                updatedAt: new Date()
            });

            const arbiterPrompt = buildArbiterPrompt(
                matchInfo,
                JSON.stringify(synthAJson),
                JSON.stringify(synthBJson)
            );
            const arbiterRaw = await callArbiter(arbiterPrompt, openaiApiKey.value());

            try {
                const arbiterJson = parseAIResult(arbiterRaw, 'GPT_5_2_Arbiter');
                await docRef.update({ consensusResult: arbiterJson });
            } catch (e) {
                logger.error('Hakem (GPT) Parse Error:', e);
                await docRef.update({
                    consensusResult: {
                        modelName: 'GPT_5_2_Arbiter_Fallback',
                        fallback: true,
                        arbiterReasoning: 'Hakem ayrıştırma hatası yaşandı. Lütfen sentezci sonuçlarını inceleyin.',
                        confidenceScore: 0
                    }
                });
            }
        } else {
            // Tek sentezci başarılı → direkt sonuç olarak kullan
            const singleResult = synthAJson || synthBJson;
            const failedModel = !synthAJson ? 'Claude (Sentezci A)' : 'Gemini (Sentezci B)';
            logger.warn(`Tek sentezci başarılı. ${failedModel} başarısız. Tek model sonucu kullanılıyor.`);

            await docRef.update({
                status: 'arbiter',
                statusMessage: `${failedModel} başarısız oldu. Tek sentezci sonucu kullanılıyor...`,
                updatedAt: new Date()
            });

            await docRef.update({
                consensusResult: {
                    ...singleResult,
                    modelName: `SingleSynthesis_${singleResult!.modelName}`,
                    singleSynthesisFallback: true,
                    fallbackNote: `${failedModel} modeli başarısız oldu. Sonuçlar yalnızca ${!synthAJson ? 'Gemini (Sentezci B)' : 'Claude (Sentezci A)'} modeline dayanmaktadır.`
                }
            });
        }

        // ══════════════════════════════════════════
        // FINALIZATION
        // ══════════════════════════════════════════
        await docRef.update({
            matchData: null,
            status: 'completed',
            statusMessage: 'Çok kanallı analiz tamamlandı!',
            updatedAt: new Date()
        });

        logger.info(`Pipeline completed successfully for ${docRef.id}`);

    } catch (error: any) {
        logger.error(`Pipeline failed for ${docRef.id}:`, error);
        await docRef.update({
            status: 'failed',
            statusMessage: 'Analiz sırasında beklenmeyen bir hata oluştu.',
            error: error.message,
            updatedAt: new Date()
        });
    }
});

// ─────────────────── TYPES ───────────────────

interface ChannelResult {
    ok: boolean;
    value: string;
    error: string;
}

// ─────────────────── HELPERS ───────────────────

function normalizeSlug(name: string): string {
    return name
        .toLowerCase()
        .replace(/ş/g, 's').replace(/ğ/g, 'g').replace(/ü/g, 'u')
        .replace(/ö/g, 'o').replace(/ç/g, 'c').replace(/ı/g, 'i')
        .replace(/İ/g, 'i').replace(/Ş/g, 's').replace(/Ğ/g, 'g')
        .replace(/Ü/g, 'u').replace(/Ö/g, 'o').replace(/Ç/g, 'c')
        .replace(/\s+/g, '-')
        .replace(/[^a-z0-9-]/g, '')
        .replace(/-+/g, '-')
        .trim();
}

function extractSeason(dateStr?: string): string {
    if (!dateStr) return '';
    try {
        const d = new Date(dateStr);
        const year = d.getFullYear();
        const month = d.getMonth();
        return month >= 7 ? `${year}-${year + 1}` : `${year - 1}-${year}`;
    } catch {
        return '';
    }
}

function safeParseJSON(text: string): any {
    try {
        return JSON.parse(text);
    } catch {
        return { rawText: text.substring(0, 2000) };
    }
}
