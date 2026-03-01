import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from 'firebase-functions';
import { db, admin } from './firebase';
import { buildAnalysisPrompt } from './prompts/analysisPrompt';
import { checkAndIncrementRateLimit } from './utils/rateLimiter';
import { parseAnalysisResponse } from './utils/responseParser';

const GEMINI_API_KEY = defineSecret('GEMINI_API_KEY');

/**
 * Team name normalizer — converts Turkish team names to slug format
 * used by the scraper (e.g. "Galatasaray" → "galatasaray")
 */
function normalizeTeamName(name: string): string {
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

/**
 * Look up enrichment data from the scraper's `matches` collection.
 * The scraper uses document keys like "2026-02-07_galatasaray_vs_genclerbirligi"
 * so we construct candidate keys and try direct lookups.
 */
async function findScraperEnrichmentData(
    matchData: Record<string, any>
): Promise<Record<string, any> | null> {
    const homeName = matchData.homeTeam?.name || '';
    const awayName = matchData.awayTeam?.name || '';

    if (!homeName || !awayName) return null;

    // Get match date string (YYYY-MM-DD)
    let dateStr = '';
    if (matchData.matchDate?.toDate) {
        const d = matchData.matchDate.toDate();
        dateStr = d.toISOString().split('T')[0];
    } else if (typeof matchData.matchDate === 'string') {
        dateStr = matchData.matchDate.split('T')[0];
    }

    if (!dateStr) return null;

    const homeSlug = normalizeTeamName(homeName);
    const awaySlug = normalizeTeamName(awayName);

    // Try exact key match (scraper format: YYYY-MM-DD_home-slug_vs_away-slug)
    const candidateKeys = [
        `${dateStr}_${homeSlug}_vs_${awaySlug}`,
        `${dateStr}_${awaySlug}_vs_${homeSlug}`,  // reversed in case scraper has it flipped
    ];

    // Also try ±1 day (date timezone differences)
    const baseDate = new Date(dateStr);
    for (const offset of [-1, 1]) {
        const altDate = new Date(baseDate);
        altDate.setDate(altDate.getDate() + offset);
        const altDateStr = altDate.toISOString().split('T')[0];
        candidateKeys.push(`${altDateStr}_${homeSlug}_vs_${awaySlug}`);
        candidateKeys.push(`${altDateStr}_${awaySlug}_vs_${homeSlug}`);
    }

    for (const key of candidateKeys) {
        try {
            const doc = await db.collection('matches').doc(key).get();
            if (doc.exists) {
                logger.info(`✅ Scraper enrichment data found: ${key}`);
                return doc.data()!;
            }
        } catch (err) {
            logger.warn(`Scraper lookup error for key ${key}: ${err}`);
        }
    }

    logger.info(`ℹ️ No scraper enrichment data found for ${homeName} vs ${awayName} (${dateStr})`);
    return null;
}

/**
 * Merge scraper enrichment data into sportoto match data.
 * Only adds fields that don't already exist in the match data.
 */
function mergeEnrichmentData(
    matchData: Record<string, any>,
    enrichment: Record<string, any>
): Record<string, any> {
    const merged = { ...matchData };

    // Copy fbref data
    if (enrichment.fbref && !merged.fbref) {
        merged.fbref = enrichment.fbref;
    }
    // Copy sofascore data
    if (enrichment.sofascore && !merged.sofascore) {
        merged.sofascore = enrichment.sofascore;
    }
    // Copy understat data
    if (enrichment.understat && !merged.understat) {
        merged.understat = enrichment.understat;
    }
    // Copy weather data
    if (enrichment.weather && !merged.weather) {
        merged.weather = enrichment.weather;
    }
    // Copy sources list
    if (enrichment.sources?.length && !merged.sources?.length) {
        merged.sources = enrichment.sources;
    }
    // Copy data completeness
    if (enrichment.dataCompleteness && !merged.dataCompleteness) {
        merged.dataCompleteness = enrichment.dataCompleteness;
    }
    // Copy odds from sofascore if not already present
    if (!merged.odds && enrichment.sofascore?.odds) {
        merged.odds = enrichment.sofascore.odds;
    }
    // Copy stadium from meta
    if (!merged.stadium && enrichment.meta?.stadium) {
        merged.stadium = enrichment.meta.stadium;
    }
    // Copy form data from meta/result if available
    if (!merged.homeTeam?.formLast5 && enrichment.meta) {
        // enrich team data from scraper meta
        if (enrichment.meta.homeTeam) {
            merged.homeTeam = { ...merged.homeTeam, scraperName: enrichment.meta.homeTeam };
        }
        if (enrichment.meta.awayTeam) {
            merged.awayTeam = { ...merged.awayTeam, scraperName: enrichment.meta.awayTeam };
        }
    }

    return merged;
}

// Gemini API response structure
interface GeminiResponse {
    candidates?: Array<{
        content?: { parts?: Array<{ text?: string }> };
    }>;
}

// Input validation regex
const MATCH_ID_PATTERN = /^[a-zA-Z0-9_-]{1,128}$/;

/**
 * analyzeMatch — Maç analizi Cloud Function
 * Gemini 3.1 Pro + Google Search Grounding
 */
export const analyzeMatch = onCall(
    {
        secrets: [GEMINI_API_KEY],
        timeoutSeconds: 300,
        memory: '512MiB',
        region: 'europe-west1',
    },
    async (request) => {
        // Auth check
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'Giriş yapmalısınız.');
        }

        const userId = request.auth.uid;
        const { matchId } = request.data;

        // Input validation
        if (!matchId || typeof matchId !== 'string') {
            throw new HttpsError('invalid-argument', 'matchId gerekli.');
        }
        if (!MATCH_ID_PATTERN.test(matchId)) {
            throw new HttpsError('invalid-argument', 'Geçersiz matchId formatı.');
        }

        // Rate limit check (atomik transaction)
        const userDoc = await db.collection('users').doc(userId).get();
        const tier = userDoc.exists ? (userDoc.data()?.tier || 'free') : 'free';
        const canProceed = await checkAndIncrementRateLimit(db, userId, tier);
        if (!canProceed) {
            throw new HttpsError(
                'resource-exhausted',
                'Günlük analiz limitinize ulaştınız.'
            );
        }

        // Cache check
        const existingAnalysis = await db
            .collection('analyses')
            .where('matchId', '==', matchId)
            .where('userId', '==', userId)
            .limit(1)
            .get();

        if (!existingAnalysis.empty) {
            const cached = existingAnalysis.docs[0].data();
            if (cached.status === 'completed') {
                return { analysisId: existingAnalysis.docs[0].id, cached: true, ...cached };
            }
        }

        // Get match data — check both collections
        let matchDoc = await db.collection('matches').doc(matchId).get();
        if (!matchDoc.exists) {
            matchDoc = await db.collection('sportoto_matches').doc(matchId).get();
        }
        if (!matchDoc.exists) {
            throw new HttpsError('not-found', 'Maç bulunamadı.');
        }
        const matchData = matchDoc.data()!;

        // ══════ SCRAPER DATA ENRICHMENT ══════
        // If the match came from sportoto_matches (basic data only),
        // try to find enrichment data from the scraper's `matches` collection
        const hasScraperData = !!(matchData.fbref || matchData.sofascore || matchData.understat);
        let enrichedMatchData = matchData;

        if (!hasScraperData) {
            logger.info(`Match ${matchId} has no scraper data, searching for enrichment...`);
            const enrichment = await findScraperEnrichmentData(matchData);
            if (enrichment) {
                enrichedMatchData = mergeEnrichmentData(matchData, enrichment);
                logger.info(`✅ Match enriched with scraper data (completeness: ${enrichment.dataCompleteness || 0}%)`);
            } else {
                logger.info(`ℹ️ No scraper enrichment found, proceeding with basic data only`);
            }
        }

        // Create pending analysis doc
        const analysisRef = db.collection('analyses').doc();
        await analysisRef.set({
            matchId,
            userId,
            status: 'pending',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        try {
            // Build prompt with enriched data
            const systemPrompt = buildAnalysisPrompt(enrichedMatchData);

            const apiKey = GEMINI_API_KEY.value();
            const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${apiKey}`;

            // ══════ SINGLE STEP: Offline data only — no internet search ══════
            // Scraper data (FBref, SofaScore, Understat) is already embedded in the prompt.
            // No google_search grounding → pure offline analysis with responseMimeType: JSON.
            const analysisPrompt = `${systemPrompt}

KRİTİK TALİMAT: Yukarıdaki çevrimdışı veri setini kullanarak ANALİZİNİ SADECE belirtilen JSON formatında döndür. JSON dışında HİÇBİR metin yazma. Açıklama yazma, sadece JSON döndür.`;

            const response = await fetch(geminiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    contents: [{ parts: [{ text: analysisPrompt }] }],
                    generationConfig: {
                        temperature: 0.7,
                        topP: 0.9,
                        topK: 40,
                        maxOutputTokens: 16384,
                        responseMimeType: 'application/json',
                    },
                }),
                signal: AbortSignal.timeout(180000),  // 3 min for pro model
            });

            if (!response.ok) {
                const errorBody = await response.text();
                logger.error(`Gemini API error: status=${response.status}`);
                logger.error(`Gemini error body (truncated): ${errorBody.substring(0, 300)}`);
                throw new Error(`Gemini API error: ${response.status}`);
            }

            const result = await response.json() as GeminiResponse;
            const rawText =
                result.candidates?.[0]?.content?.parts?.[0]?.text || '';
            const finishReason = (result as any).candidates?.[0]?.finishReason || 'UNKNOWN';
            logger.info(`Gemini rawText length: ${rawText.length}, finishReason: ${finishReason}`);

            // Parse & validate
            const analysisData = parseAnalysisResponse(rawText);

            // Save to Firestore
            // [FB-07] Dynamic cache TTL based on match proximity
            const matchDate = matchData.matchDate?.toDate?.() || new Date(matchData.matchDate);
            const hoursUntilMatch = (matchDate.getTime() - Date.now()) / (1000 * 60 * 60);
            let cacheTTLHours = 24;
            if (hoursUntilMatch <= 24) cacheTTLHours = 4;        // Today → 4h cache
            else if (hoursUntilMatch <= 168) cacheTTLHours = 12;  // Within 7 days → 12h cache

            await analysisRef.update({
                ...analysisData,
                status: 'completed',
                rawGeminiResponse: rawText,
                modelUsed: 'gemini-3.1-pro-preview',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                expiresAt: admin.firestore.Timestamp.fromDate(
                    new Date(Date.now() + cacheTTLHours * 60 * 60 * 1000)
                ),
            });

            return { analysisId: analysisRef.id, cached: false, ...analysisData };
        } catch (error: unknown) {
            // Mark as failed
            await analysisRef.update({
                status: 'failed',
                error: error instanceof Error ? error.message : 'Unknown error',
            });

            if (error instanceof Error && error.name === 'TimeoutError') {
                throw new HttpsError(
                    'deadline-exceeded',
                    'Analiz zaman aşımına uğradı. Tekrar deneyin.'
                );
            }

            throw new HttpsError(
                'internal',
                'Analiz sırasında hata oluştu. Tekrar deneyin.'
            );
        }
    }
);
