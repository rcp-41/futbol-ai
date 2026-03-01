import * as admin from 'firebase-admin';

const LIMITS: Record<string, number> = {
    free: 5,
    pro: 50,
};
const GLOBAL_DAILY_LIMIT = 1000;

/**
 * checkAndIncrementRateLimit — Atomik transaction ile rate limit kontrolü ve artırma
 * Race condition önlenir: check + increment tek transaction içinde yapılır.
 */
export async function checkAndIncrementRateLimit(
    db: admin.firestore.Firestore,
    userId: string,
    tier: string
): Promise<boolean> {
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
    const limit = LIMITS[tier] || LIMITS['free'];

    // User rate limit — atomik transaction
    const userRef = db.collection('rateLimits').doc(`${userId}_${today}`);
    const userAllowed = await db.runTransaction(async (tx) => {
        const doc = await tx.get(userRef);
        const count = doc.exists ? (doc.data()?.count || 0) : 0;
        if (count >= limit) return false;
        tx.set(userRef, {
            count: count + 1,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
        return true;
    });

    if (!userAllowed) return false;

    // Global rate limit — atomik transaction
    const globalRef = db.collection('rateLimits').doc(`global_${today}`);
    const globalAllowed = await db.runTransaction(async (tx) => {
        const doc = await tx.get(globalRef);
        const count = doc.exists ? (doc.data()?.count || 0) : 0;
        if (count >= GLOBAL_DAILY_LIMIT) return false;
        tx.set(globalRef, {
            count: count + 1,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
        return true;
    });

    if (!globalAllowed) {
        // Global limit aşıldı ama user counter artmıştı, geri al
        await db.runTransaction(async (tx) => {
            const doc = await tx.get(userRef);
            const count = doc.exists ? (doc.data()?.count || 0) : 0;
            if (count > 0) {
                tx.set(userRef, {
                    count: count - 1,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                }, { merge: true });
            }
        });
        return false;
    }

    return true;
}
