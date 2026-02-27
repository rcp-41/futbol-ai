const { GoogleGenerativeAI } = require("@google/generative-ai");

async function checkModels() {
    const genAI = new GoogleGenerativeAI("AIzaSyA8Ow" + "QjH1k0A");
    try {
        const list = await fetch(`https://generativelanguage.googleapis.com/v1beta/models?key=AIzaSyA8Ow` + `QjH1k0A`);
        const data = await list.json();
        console.log("=== Guncel Gemini Modelleri (2026) ===");
        data.models.forEach(m => {
            if (m.name.includes('gemini') && !m.name.includes('vision')) {
                console.log(`- ${m.name}`);
            }
        });
    } catch (e) {
        console.error(e);
    }
}

checkModels();
