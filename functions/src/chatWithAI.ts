import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as admin from 'firebase-admin';
import { buildChatPrompt } from './prompts/chatPrompt';

const GEMINI_API_KEY = defineSecret('GEMINI_API_KEY');

if (!admin.apps.length) {
    admin.initializeApp();
}

const db = admin.firestore();

/**
 * chatWithAI — Maç analizi bağlamında AI sohbet
 */
export const chatWithAI = onCall(
    {
        secrets: [GEMINI_API_KEY],
        timeoutSeconds: 30,
        memory: '256MiB',
        region: 'europe-west1',
    },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'Giriş yapmalısınız.');
        }

        const userId = request.auth.uid;
        const { matchId, message, history } = request.data;

        if (!matchId || !message) {
            throw new HttpsError('invalid-argument', 'matchId ve message gerekli.');
        }

        // Get match data
        const matchDoc = await db.collection('matches').doc(matchId).get();
        if (!matchDoc.exists) {
            throw new HttpsError('not-found', 'Maç bulunamadı.');
        }
        const matchData = matchDoc.data()!;

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
        const systemPrompt = buildChatPrompt(matchData, analysisJson);
        const contents: Array<{ role: string; parts: Array<{ text: string }> }> = [
            { role: 'user', parts: [{ text: systemPrompt }] },
            { role: 'model', parts: [{ text: 'Anladım. Bu maç hakkında sorularınızı yanıtlamaya hazırım.' }] },
        ];

        // Add chat history
        if (history && Array.isArray(history)) {
            for (const msg of history.slice(-10)) {
                contents.push({
                    role: msg.role === 'user' ? 'user' : 'model',
                    parts: [{ text: msg.content }],
                });
            }
        }

        // Add current message
        contents.push({ role: 'user', parts: [{ text: message }] });

        try {
            const apiKey = GEMINI_API_KEY.value();
            const response = await fetch(
                `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${apiKey}`,
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        contents,
                        generationConfig: {
                            temperature: 0.8,
                            topP: 0.95,
                            topK: 50,
                            maxOutputTokens: 1024,
                        },
                        tools: [
                            {
                                google_search_retrieval: {
                                    dynamic_retrieval_config: {
                                        mode: 'MODE_DYNAMIC',
                                        dynamic_threshold: 0.6,
                                    },
                                },
                            },
                        ],
                    }),
                    signal: AbortSignal.timeout(20000),
                }
            );

            if (!response.ok) {
                throw new Error(`Gemini API error: ${response.status}`);
            }

            const result = await response.json() as Record<string, unknown>;
            const aiResponse =
                ((result as any).candidates?.[0]?.content?.parts?.[0]?.text) || 'Yanıt alınamadı.';

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
            if (error instanceof Error && error.name === 'TimeoutError') {
                throw new HttpsError('deadline-exceeded', 'Yanıt zaman aşımına uğradı.');
            }
            throw new HttpsError('internal', 'Sohbet sırasında hata oluştu.');
        }
    }
);
