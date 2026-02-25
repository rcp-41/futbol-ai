import * as admin from 'firebase-admin';

const LIMITS: Record<string, number> = {
    free: 5,
    pro: 50,
};
const GLOBAL_DAILY_LIMIT = 1000;

/**
 * checkRateLimit — Kullanıcı ve global rate limit kontrolü
 */
export async function checkRateLimit(
    db: admin.firestore.Firestore,
    userId: string,
    tier: string
): Promise<boolean> {
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD

    // User rate limit
    const userLimitRef = db.collection('rateLimits').doc(`${userId}_${today}`);
    const userLimitDoc = await userLimitRef.get();
    const userCount = userLimitDoc.exists ? (userLimitDoc.data()?.count || 0) : 0;
    const limit = LIMITS[tier] || LIMITS['free'];

    if (userCount >= limit) {
        return false;
    }

    // Global rate limit
    const globalRef = db.collection('rateLimits').doc(`global_${today}`);
    const globalDoc = await globalRef.get();
    const globalCount = globalDoc.exists ? (globalDoc.data()?.count || 0) : 0;

    if (globalCount >= GLOBAL_DAILY_LIMIT) {
        return false;
    }

    return true;
}

/**
 * incrementRateLimit — Kullanıcı ve global sayacı artır
 */
export async function incrementRateLimit(
    db: admin.firestore.Firestore,
    userId: string
): Promise<void> {
    const today = new Date().toISOString().split('T')[0];

    const batch = db.batch();

    // User counter
    const userRef = db.collection('rateLimits').doc(`${userId}_${today}`);
    batch.set(
        userRef,
        {
            count: admin.firestore.FieldValue.increment(1),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
    );

    // Global counter
    const globalRef = db.collection('rateLimits').doc(`global_${today}`);
    batch.set(
        globalRef,
        {
            count: admin.firestore.FieldValue.increment(1),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
    );

    await batch.commit();
}
