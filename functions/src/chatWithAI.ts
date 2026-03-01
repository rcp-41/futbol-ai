import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from 'firebase-functions';
import { db, admin } from './firebase';
import { buildChatPrompt } from './prompts/chatPrompt';

const GEMINI_API_KEY = defineSecret('GEMINI_API_KEY');

// Gemini API response structure
interface GeminiResponse {
    candidates?: Array<{
        content?: { parts?: Array<{ text?: string }> };
    }>;
}

// Input validation
const MATCH_ID_PATTERN = /^[a-zA-Z0-9_-]{1,128}$/;
const MAX_MESSAGE_LENGTH = 2000;
const MAX_HISTORY_ITEMS = 20;
const MAX_HISTORY_ITEM_LENGTH = 3000;

/**
 * Team name normalizer — converts Turkish team names to slug format
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
 */
async function findScraperEnrichmentData(
    matchData: Record<string, any>
): Promise<Record<string, any> | null> {
    const homeName = matchData.homeTeam?.name || '';
    const awayName = matchData.awayTeam?.name || '';
    if (!homeName || !awayName) return null;

    let dateStr = '';
    if (matchData.matchDate?.toDate) {
        dateStr = matchData.matchDate.toDate().toISOString().split('T')[0];
    } else if (typeof matchData.matchDate === 'string') {
        dateStr = matchData.matchDate.split('T')[0];
    }
    if (!dateStr) return null;

    const homeSlug = normalizeTeamName(homeName);
    const awaySlug = normalizeTeamName(awayName);

    const candidateKeys = [
        `${dateStr}_${homeSlug}_vs_${awaySlug}`,
        `${dateStr}_${awaySlug}_vs_${homeSlug}`,
    ];

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
                logger.info(`✅ Chat: Scraper enrichment data found: ${key}`);
                return doc.data()!;
            }
        } catch (err) {
            logger.warn(`Chat: Scraper lookup error for key ${key}: ${err}`);
        }
    }
    return null;
}

/**
 * Merge scraper enrichment data into match data.
 */
function mergeEnrichmentData(
    matchData: Record<string, any>,
    enrichment: Record<string, any>
): Record<string, any> {
    const merged = { ...matchData };
    if (enrichment.fbref && !merged.fbref) merged.fbref = enrichment.fbref;
    if (enrichment.sofascore && !merged.sofascore) merged.sofascore = enrichment.sofascore;
    if (enrichment.understat && !merged.understat) merged.understat = enrichment.understat;
    if (enrichment.weather && !merged.weather) merged.weather = enrichment.weather;
    if (enrichment.sources?.length && !merged.sources?.length) merged.sources = enrichment.sources;
    if (enrichment.dataCompleteness && !merged.dataCompleteness) merged.dataCompleteness = enrichment.dataCompleteness;
    if (!merged.odds && enrichment.sofascore?.odds) merged.odds = enrichment.sofascore.odds;
    if (!merged.stadium && enrichment.meta?.stadium) merged.stadium = enrichment.meta.stadium;
    return merged;
}

/**
 * chatWithAI — Maç analizi bağlamında AI sohbet
 * Gemini 3.1 Pro + Google Search (sezon kapsamlı) + Scraper enrichment
 */
export const chatWithAI = onCall(
    {
        secrets: [GEMINI_API_KEY],
        timeoutSeconds: 300,
        memory: '512MiB',
        region: 'europe-west1',
        cors: [/futbol-ai-app\.web\.app$/, /futbol-ai-app\.firebaseapp\.com$/, /localhost/],
        invoker: 'public',
    },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'Giriş yapmalısınız.');
        }

        const userId = request.auth.uid;
        const { matchId, message, history } = request.data;

        // Input validation
        if (!matchId || typeof matchId !== 'string' || !MATCH_ID_PATTERN.test(matchId)) {
            throw new HttpsError('invalid-argument', 'Geçersiz matchId.');
        }
        if (!message || typeof message !== 'string') {
            throw new HttpsError('invalid-argument', 'message gerekli.');
        }
        if (message.length > MAX_MESSAGE_LENGTH) {
            throw new HttpsError('invalid-argument', `Mesaj en fazla ${MAX_MESSAGE_LENGTH} karakter olabilir.`);
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
        const hasScraperData = !!(matchData.fbref || matchData.sofascore || matchData.understat);
        let enrichedMatchData = matchData;

        if (!hasScraperData) {
            logger.info(`Chat: Match ${matchId} has no scraper data, searching for enrichment...`);
            const enrichment = await findScraperEnrichmentData(matchData);
            if (enrichment) {
                enrichedMatchData = mergeEnrichmentData(matchData, enrichment);
                logger.info(`✅ Chat: Match enriched (completeness: ${enrichment.dataCompleteness || 0}%)`);
            }
        }

        // Get analysis if exists
        const analysisSnap = await db
            .collection('analyses')
            .where('matchId', '==', matchId)
            .where('userId', '==', userId)
            .where('status', '==', 'completed')
            .limit(1)
            .get();

        const analysisJson = analysisSnap.empty
            ? 'Henüz analiz yapılmadı.'
            : JSON.stringify(analysisSnap.docs[0].data());

        // Build chat contents (multi-turn)
        const systemPrompt = buildChatPrompt(enrichedMatchData, analysisJson);
        const contents: Array<{ role: string; parts: Array<{ text: string }> }> = [
            { role: 'user', parts: [{ text: systemPrompt }] },
            { role: 'model', parts: [{ text: 'Anladım. Bu maç hakkında tüm istatistiklere ve analize sahibim. Sorularınızı yanıtlamaya hazırım.' }] },
        ];

        // Add chat history with length validation
        if (history && Array.isArray(history)) {
            const safeHistory = history.slice(-MAX_HISTORY_ITEMS);
            for (const msg of safeHistory) {
                if (msg && typeof msg.content === 'string' && typeof msg.role === 'string') {
                    const truncatedContent = msg.content.substring(0, MAX_HISTORY_ITEM_LENGTH);
                    contents.push({
                        role: msg.role === 'user' ? 'user' : 'model',
                        parts: [{ text: truncatedContent }],
                    });
                }
            }
        }

        // Add current message
        contents.push({ role: 'user', parts: [{ text: message }] });

        try {
            const apiKey = GEMINI_API_KEY.value();
            const response = await fetch(
                `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${apiKey}`,
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        contents,
                        generationConfig: {
                            temperature: 0.8,
                            topP: 0.95,
                            topK: 50,
                            maxOutputTokens: 4096,
                        },
                        tools: [
                            {
                                google_search: {},
                            },
                        ],
                    }),
                    signal: AbortSignal.timeout(120000),  // 2 min for pro model
                }
            );

            if (!response.ok) {
                const errorBody = await response.text();
                logger.error(`Gemini chat API error: status=${response.status}`);
                logger.error(`Gemini chat error body: ${errorBody.substring(0, 300)}`);
                throw new Error(`Gemini API error: ${response.status}`);
            }

            const result = await response.json() as GeminiResponse;

            // Collect ALL text parts (google_search may split response into multiple parts)
            const parts = result.candidates?.[0]?.content?.parts || [];
            const aiResponse = parts
                .filter((p: { text?: string }) => p.text)
                .map((p: { text?: string }) => p.text)
                .join('\n') || 'Yanıt alınamadı.';

            // Save messages to Firestore
            const chatRef = db
                .collection('chats')
                .doc(userId)
                .collection('matchChats')
                .doc(matchId)
                .collection('messages');

            const batch = db.batch();
            batch.set(chatRef.doc(), {
                role: 'user',
                content: message,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });
            batch.set(chatRef.doc(), {
                role: 'model',
                content: aiResponse,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });
            await batch.commit();

            return { response: aiResponse };
        } catch (error: unknown) {
            logger.error(`Chat error: ${error instanceof Error ? error.message : 'Unknown'}`);
            if (error instanceof Error && error.name === 'TimeoutError') {
                throw new HttpsError('deadline-exceeded', 'Yanıt zaman aşımına uğradı. Tekrar deneyin.');
            }
            throw new HttpsError('internal', 'Sohbet sırasında hata oluştu. Tekrar deneyin.');
        }
    }
);
