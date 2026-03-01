import * as admin from 'firebase-admin';

// [A-07] FIX: Tek seferlik Firebase Admin init
if (!admin.apps.length) {
    admin.initializeApp();
}

export const db = admin.firestore();
export { admin };
