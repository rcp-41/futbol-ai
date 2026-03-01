import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { logger } from 'firebase-functions/v2';
import { defineSecret } from 'firebase-functions/params';
import { verifyData } from './dataVerification';
import { runDeepAnalysis } from './deepAnalysis';
import { buildInitialPrompt, buildConsensusPrompt } from './multiModelPrompts';
import { callGemini, callClaude, callConsensus } from './aiClients';
import { parseAIResult } from './multiModelParser';
import { enrichMatchData, formatEnrichmentForPrompt } from './scraperEnrichment';

const geminiApiKey = defineSecret('GEMINI_API_KEY');
const anthropicApiKey = defineSecret('ANTHROPIC_API_KEY');

// Deep analysis modül adları (Türkçe)
const MODULE_NAMES: Record<string, string> = {
    weather: 'Hava Durumu Analizi',
    missingPlayers: 'Eksik Oyuncu Analizi',
    homeAwayForm: 'Ev/Deplasman Form Analizi',
    h2h: 'Kafa Kafaya Geçmiş',
    xg: 'xG (Beklenen Gol) Analizi',
    setPieces: 'Duran Top Analizi',
    referee: 'Hakem Etkisi Analizi',
    tactics: 'Taktik/Formasyon Analizi',
    squadDepth: 'Kadro Derinliği Analizi',
    scoutingComparison: 'Scouting Karşılaştırma',
    transferImpact: 'Transfer Etkisi Analizi',
    newsSentiment: 'Haber Duygu Analizi',
};

export const onMultiAnalysisCreated = onDocumentCreated({
    document: 'multi_analyses/{analysisId}',
    region: 'europe-west1',
    timeoutSeconds: 540, // 9 minutes
    memory: '1GiB',
    secrets: [geminiApiKey, anthropicApiKey],
}, async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    const docRef = snap.ref;
    const matchData = data.matchData;

    try {
        // --- STAGE 1: VERIFICATION (AI-powered) ---
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

        // --- STAGE 1.5: SCRAPER ENRICHMENT ---
        await docRef.update({
            status: 'enriching',
            statusMessage: 'Scraper verileri çekiliyor (takım, oyuncu, TD, hakem)...',
            updatedAt: new Date()
        });

        const enrichment = await enrichMatchData(matchData);
        const enrichmentText = formatEnrichmentForPrompt(enrichment);

        // Enrichment verisini matchData'ya ekle (deep analysis ve AI prompt'ları için)
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

        // --- STAGE 2: AI-DRIVEN DEEP ANALYSIS (8+ modül) ---
        const totalModules = 8; // base modules (can expand later)
        await docRef.update({
            status: 'analyzing',
            statusMessage: `Derin analiz modülleri çalışıyor (0/${totalModules})...`,
            updatedAt: new Date()
        });

        const deepAnalysis = await runDeepAnalysis(
            enrichedMatchData,
            geminiApiKey.value(),
            async (moduleName: string, index: number) => {
                // Her modül başladığında progress güncelle
                const turkishName = MODULE_NAMES[moduleName] || moduleName;
                await docRef.update({
                    statusMessage: `Derin analiz: ${turkishName} (${index + 1}/${totalModules})...`,
                    updatedAt: new Date()
                });
            }
        );

        await docRef.update({ deepAnalysis, updatedAt: new Date() });

        // Deep analysis özeti oluştur
        const deepAnalysisSummary = Object.entries(deepAnalysis)
            .map(([key, result]) => `${MODULE_NAMES[key] || key}: ${result.summary} (Güven: ${result.confidence}/10)`)
            .join('\n');

        logger.info(`[Pipeline] Deep analysis tamamlandı. Özet:\n${deepAnalysisSummary}`);

        // --- STAGE 3: AI PROCESSING (PARALLEL) ---
        await docRef.update({
            status: 'ai_processing',
            statusMessage: 'Gemini ve Claude yapay zeka modelleri çalışıyor...',
            updatedAt: new Date()
        });

        const geminiPrompt = buildInitialPrompt(enrichedMatchData, deepAnalysis, 'Gemini 3.1 Pro Preview');
        const claudePrompt = buildInitialPrompt(enrichedMatchData, deepAnalysis, 'Claude Opus 4.6');

        const [geminiRaw, claudeRaw] = await Promise.allSettled([
            callGemini(geminiPrompt, geminiApiKey.value()),
            callClaude(claudePrompt, anthropicApiKey.value())
        ]);

        let geminiJson = null;
        let claudeJson = null;

        if (geminiRaw.status === 'fulfilled') {
            try {
                geminiJson = parseAIResult(geminiRaw.value, 'Gemini_3_1_Pro_Preview');
                await docRef.update({ geminiResult: geminiJson, updatedAt: new Date() });
            } catch (e: any) {
                logger.error('Gemini Parse Error:', e);
            }
        } else {
            logger.error('Gemini API Error:', geminiRaw.reason);
        }

        if (claudeRaw.status === 'fulfilled') {
            try {
                claudeJson = parseAIResult(claudeRaw.value, 'Claude_Opus_4_6');
                await docRef.update({ claudeResult: claudeJson, updatedAt: new Date() });
            } catch (e: any) {
                logger.error('Claude Parse Error:', e);
            }
        } else {
            logger.error('Claude API Error:', claudeRaw.reason);
        }

        if (!geminiJson && !claudeJson) {
            throw new Error('Tüm AI modelleri başarısız oldu.');
        }

        // --- STAGE 4: CONSENSUS ---
        if (geminiJson && claudeJson) {
            // Both models succeeded — generate proper consensus
            await docRef.update({ status: 'consensus', statusMessage: 'Modeller arası uzlaşma sağlanıyor...', updatedAt: new Date() });
            const consensusPrompt = buildConsensusPrompt(JSON.stringify(geminiJson), JSON.stringify(claudeJson));
            const consensusRaw = await callConsensus(consensusPrompt, geminiApiKey.value());

            try {
                const consensusJson = parseAIResult(consensusRaw, 'Consensus_Gemini_3_1_Pro_Preview');
                await docRef.update({ consensusResult: consensusJson });
            } catch (e) {
                logger.error('Consensus Parse Error:', e);
                await docRef.update({
                    consensusResult: {
                        modelName: 'Consensus_Gemini_Fallback',
                        fallback: true,
                        consensusReasoning: 'Konsensüs ayrıştırma hatası yaşandı. Lütfen bireysel model sonuçlarını inceleyin.',
                        confidenceScore: 0
                    }
                });
            }
        } else {
            // Single-model fallback — use whichever model succeeded as the "consensus"
            const singleResult = geminiJson || claudeJson;
            const failedModel = !geminiJson ? 'Gemini' : 'Claude';
            logger.warn(`Only one AI model succeeded. ${failedModel} failed. Using single-model fallback.`);

            await docRef.update({
                status: 'consensus',
                statusMessage: `${failedModel} başarısız oldu. Tek model sonucu kullanılıyor...`,
                updatedAt: new Date()
            });

            await docRef.update({
                consensusResult: {
                    ...singleResult,
                    modelName: `SingleModel_${singleResult!.modelName}`,
                    singleModelFallback: true,
                    fallbackNote: `${failedModel} modeli başarısız oldu. Sonuçlar yalnızca ${!geminiJson ? 'Claude' : 'Gemini'} modeline dayanmaktadır.`
                }
            });
        }

        // --- FINALIZATION ---
        // Clean up matchData to save space since we have deepAnalysis
        await docRef.update({
            matchData: null,
            status: 'completed',
            statusMessage: 'Çoklu model analizi tamamlandı!',
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
