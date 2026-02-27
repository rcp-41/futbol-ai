import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as admin from 'firebase-admin';
import { buildAnalysisPrompt } from './prompts/analysisPrompt';
import { checkRateLimit, incrementRateLimit } from './utils/rateLimiter';
import { parseAnalysisResponse } from './utils/responseParser';

const GEMINI_API_KEY = defineSecret('GEMINI_API_KEY');

if (!admin.apps.length) {
    admin.initializeApp();
}

const db = admin.firestore();

/**
 * analyzeMatch — Maç analizi Cloud Function
 * Gemini 3.1 Pro + Google Search Grounding
 */
export const analyzeMatch = onCall(
    {
        secrets: [GEMINI_API_KEY],
        timeoutSeconds: 120,
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

        if (!matchId) {
            throw new HttpsError('invalid-argument', 'matchId gerekli.');
        }

        // Rate limit check
        const userDoc = await db.collection('users').doc(userId).get();
        const tier = userDoc.exists ? (userDoc.data()?.tier || 'free') : 'free';
        const canProceed = await checkRateLimit(db, userId, tier);
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

        // Get match data
        const matchDoc = await db.collection('matches').doc(matchId).get();
        if (!matchDoc.exists) {
            throw new HttpsError('not-found', 'Maç bulunamadı.');
        }
        const matchData = matchDoc.data()!;

        // Create pending analysis doc
        const analysisRef = db.collection('analyses').doc();
        await analysisRef.set({
            matchId,
            userId,
            status: 'pending',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        try {
            // Build prompt
            const systemPrompt = buildAnalysisPrompt(matchData);

            // Call Gemini API with search grounding
            const apiKey = GEMINI_API_KEY.value();
            const response = await fetch(
                `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${apiKey}`,
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        contents: [{ parts: [{ text: systemPrompt }] }],
                        generationConfig: {
                            temperature: 0.7,
                            topP: 0.9,
                            topK: 40,
                            maxOutputTokens: 8192,
                            responseMimeType: 'application/json',
                        },
                        tools: [
                            {
                                google_search_retrieval: {
                                    dynamic_retrieval_config: {
                                        mode: 'MODE_DYNAMIC',
                                        dynamic_threshold: 0.7,
                                    },
                                },
                            },
                        ],
                    }),
                    signal: AbortSignal.timeout(60000),
                }
            );

            if (!response.ok) {
                const errorBody = await response.text();
                console.error('Gemini API error:', response.status, errorBody);
                throw new Error(`Gemini API error: ${response.status}`);
            }

            const result = await response.json() as Record<string, unknown>;
            const rawText =
                ((result as any).candidates?.[0]?.content?.parts?.[0]?.text) || '';

            // Parse & validate
            const analysisData = parseAnalysisResponse(rawText);

            // Save to Firestore
            await analysisRef.update({
                ...analysisData,
                status: 'completed',
                rawGeminiResponse: rawText,
                modelUsed: 'gemini-3.1-pro-preview',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                expiresAt: admin.firestore.Timestamp.fromDate(
                    new Date(Date.now() + 24 * 60 * 60 * 1000)
                ),
            });

            // Increment rate limit
            await incrementRateLimit(db, userId);

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
