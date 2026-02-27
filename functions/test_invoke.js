const { initializeApp } = require('firebase/app');
const { getFunctions, httpsCallable } = require('firebase/functions');

const firebaseConfig = {
    projectId: "futbol-ai-app",
};

const app = initializeApp(firebaseConfig);
const functions = getFunctions(app, 'europe-west1');
const analyzeMatch = httpsCallable(functions, 'analyzeMatch');

async function test() {
    try {
        console.log("Calling analyzeMatch...");
        const result = await analyzeMatch({ matchId: "test_id" });
        console.log("Result:", result.data);
    } catch (err) {
        console.error("Error Code:", err.code);
        console.error("Error Message:", err.message);
        if (err.details) console.error("Details:", err.details);
    }
}

test();
