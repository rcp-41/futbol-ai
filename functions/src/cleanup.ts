import { onSchedule } from 'firebase-functions/v2/scheduler';
import { logger } from 'firebase-functions';
import { db } from './firebase';

/**
 * [FB-03] Scheduled cleanup — eski rate limit dokümanlarını temizle
 * Her gün 03:00 (Europe/Istanbul) çalışır, 7 günden eski dokümanları siler.
 */
export const cleanupRateLimits = onSchedule(
    {
        schedule: '0 3 * * *',
        timeZone: 'Europe/Istanbul',
        region: 'europe-west1',
    },
    async () => {
        const cutoffDate = new Date();
        cutoffDate.setDate(cutoffDate.getDate() - 7);
        const cutoffStr = cutoffDate.toISOString().split('T')[0]; // YYYY-MM-DD

        const rateLimitsRef = db.collection('rateLimits');
        const snapshot = await rateLimitsRef.get();

        if (snapshot.empty) return;

        let deletedCount = 0;
        let batch = db.batch();
        let batchCount = 0;

        for (const doc of snapshot.docs) {
            // Doküman ID formatı: userId_YYYY-MM-DD veya global_YYYY-MM-DD
            const parts = doc.id.split('_');
            const dateStr = parts[parts.length - 1];

            // Geçerli tarih formatı mı kontrol et
            if (!/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) continue;

            if (dateStr < cutoffStr) {
                batch.delete(doc.ref);
                batchCount++;
                deletedCount++;

                if (batchCount >= 400) {
                    await batch.commit();
                    batch = db.batch();
                    batchCount = 0;
                }
            }
        }

        if (batchCount > 0) {
            await batch.commit();
        }

        logger.info(`[Cleanup] ${deletedCount} eski rate limit dokümanı silindi`);
    }
);
