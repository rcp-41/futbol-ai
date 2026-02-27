const admin = require('firebase-admin');

admin.initializeApp({
    projectId: 'futbol-ai-app'
});

const db = admin.firestore();

async function checkRecentAnalyses() {
    try {
        const snapshot = await db.collection('analyses')
            .orderBy('createdAt', 'desc')
            .limit(5)
            .get();

        console.log("=== Recent 5 Analyses ===");
        snapshot.forEach(doc => {
            const data = doc.data();
            console.log(`ID: ${doc.id} | Status: ${data.status} | MatchInfo: ${data.matchId} | Error: ${data.error || 'None'}`);
            console.log(`CreatedAt: ${data.createdAt ? data.createdAt.toDate() : 'N/A'}`);
            console.log("------------------------");
        });
    } catch (err) {
        console.error("Error fetching rules:", err);
    }
}

checkRecentAnalyses();
