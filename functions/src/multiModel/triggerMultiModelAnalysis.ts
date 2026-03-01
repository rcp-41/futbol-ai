import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getFirestore } from 'firebase-admin/firestore';
import { logger } from 'firebase-functions/v2';

/**
 * Bu fonksiyon mobil uygulamadan çağrılır.
 * Amacı analiz sürecini veritabanında (Firestore) başlatmaktır.
 * Asıl ağır iş `onMultiAnalysisCreated` trigger'ında yapılacaktır.
 */
export const triggerMultiModelAnalysis = onCall({
    region: 'europe-west1',
    timeoutSeconds: 60,
    memory: '256MiB',
    invoker: 'public',
    cors: true,
}, async (request) => {
    // 1. Kimlik Doğrulama
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'Bu işlemi yapmak için giriş yapmalısınız.');
    }
    const userId = request.auth.uid;

    const { matchId, matchData } = request.data;
    if (!matchId || !matchData) {
        throw new HttpsError('invalid-argument', 'matchId ve matchData gereklidir.');
    }

    const db = getFirestore();

    // 2. Cache Kontrolü (Aynı maç için zaten analiz var mı?)
    const docId = `${matchId}_${userId}`;
    const analysisRef = db.collection('multi_analyses').doc(docId);

    // Check if a recent or completed analysis exists
    const docSnap = await analysisRef.get();
    if (docSnap.exists) {
        const data = docSnap.data();
        if (data?.status === 'completed') {
            const updatedAt = data.updatedAt?.toDate();
            // Eğer 24 saatten eskiyse yeniden yapılabilir, aksi halde mevcut olanı döndür
            if (updatedAt && (Date.now() - updatedAt.getTime()) < 24 * 60 * 60 * 1000) {
                return {
                    success: true,
                    analysisId: docId,
                    message: 'Mevcut analiz sonucu döndürülüyor.',
                    status: 'cached'
                };
            }
        } else if (['pending', 'verifying', 'analyzing', 'ai_processing'].includes(data?.status || '')) {
            return {
                success: true,
                analysisId: docId,
                message: 'Analiz zaten devam ediyor.',
                status: 'in_progress'
            };
        }
    }

    // 3. Oranı Aşma Kontrolü (Rate Limiting) - Günde en fazla 5 analiz
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const countQuery = await db.collection('multi_analyses')
        .where('userId', '==', userId)
        .where('createdAt', '>=', startOfDay)
        .count()
        .get();

    if (countQuery.data().count >= 100) { // For testing, bumped to 100. Adjust in production.
        throw new HttpsError('resource-exhausted', 'Günlük çoklu analiz limitine (100) ulaştınız.');
    }

    // 4. Analiz Dokümanını Başlat (Bu trigger'ı ateşler)
    try {
        await analysisRef.set({
            matchId,
            userId,
            status: 'pending',
            statusMessage: 'Analiz sıraya alındı...',
            createdAt: new Date(),
            updatedAt: new Date(),
            expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days expiration
            matchData: matchData, // Store matchData temporarily for the pipeline
        });

        logger.info(`Multi-model analysis triggered for match ${matchId} by user ${userId}`);

        return {
            success: true,
            analysisId: docId,
            message: 'Analiz başarıyla başlatıldı.',
            status: 'pending'
        };
    } catch (error) {
        logger.error(`Error triggering analysis: ${error}`);
        throw new HttpsError('internal', 'Analiz başlatılamadı.', error);
    }
});
