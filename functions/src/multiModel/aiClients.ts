import { logger } from 'firebase-functions/v2';

/**
 * Gemini API çağrısı — responseMimeType: application/json
 * gemini-3.1-pro-preview
 */
export async function callGemini(prompt: string, apiKey: string): Promise<string> {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${apiKey}`;

    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
            generationConfig: {
                temperature: 0.7,
                topP: 0.9,
                topK: 40,
                maxOutputTokens: 16384,
                responseMimeType: 'application/json',
            },
        }),
        signal: AbortSignal.timeout(180000), // 3 minutes timeout
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Gemini error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Gemini API error: ${response.status}`);
    }

    const result = await response.json();
    return result.candidates?.[0]?.content?.parts?.[0]?.text || '';
}

/**
 * Claude API çağrısı — Anthropic Messages API
 * claude-opus-4-6
 */
export async function callClaude(prompt: string, apiKey: string): Promise<string> {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
        },
        body: JSON.stringify({
            model: 'claude-opus-4-6', // User explicitly requested this exact string
            max_tokens: 8192,
            temperature: 0.7,
            messages: [{ role: 'user', content: prompt }],
        }),
        signal: AbortSignal.timeout(180000), // 3 minutes timeout
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Claude error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Claude API error: ${response.status}`);
    }

    const result = await response.json();
    return result.content?.[0]?.text || '';
}

/**
 * Consensus API çağrısı — Gemini 3.1 Pro Preview (konsensüs modeli)
 */
export async function callConsensus(prompt: string, apiKey: string): Promise<string> {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${apiKey}`;

    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            contents: [
                { role: 'user', parts: [{ text: 'Sen futbol analiz uzmanısın. İki AI modelini karşılaştırıp tek bir SADECE JSON sonucu üret.' }] },
                { role: 'user', parts: [{ text: prompt }] },
            ],
            generationConfig: {
                temperature: 0.5,
                maxOutputTokens: 8192,
                responseMimeType: 'application/json',
            },
        }),
        signal: AbortSignal.timeout(120000), // 2 minutes timeout
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Consensus (Gemini) error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Consensus API error: ${response.status}`);
    }

    const result = await response.json();
    return result.candidates?.[0]?.content?.parts?.[0]?.text || '';
}
