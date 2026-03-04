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
            model: 'claude-opus-4-6',
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
 * GPT-5.2 API çağrısı — OpenAI Chat Completions API
 * Kanal 2A (istatistik+taktik), Kanal 2B (hakem+kaos), Nihai Hakem rollerinde kullanılır.
 */
export async function callGPT(prompt: string, apiKey: string): Promise<string> {
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`,
        },
        body: JSON.stringify({
            model: 'gpt-5.2',
            messages: [
                {
                    role: 'system',
                    content: 'Sen uzman bir futbol veri bilimci ve taktik analistisin. Yanıtlarını SADECE JSON formatında ver.',
                },
                { role: 'user', content: prompt },
            ],
            temperature: 0.7,
            max_tokens: 8192,
            response_format: { type: 'json_object' },
        }),
        signal: AbortSignal.timeout(180000), // 3 minutes timeout
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`GPT error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`GPT API error: ${response.status}`);
    }

    const result = await response.json();
    return result.choices?.[0]?.message?.content || '';
}

/**
 * Nihai Hakem çağrısı — GPT-5.2
 * İki sentezci çıktısını karşılaştırır, uyumluysa onaylar, çelişiyorsa çözer.
 */
export async function callArbiter(prompt: string, apiKey: string): Promise<string> {
    const response = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`,
        },
        body: JSON.stringify({
            model: 'gpt-5.2',
            messages: [
                {
                    role: 'system',
                    content: 'Sen baş hakem ve nihai karar vericisin. İki bağımsız sentezciyi karşılaştırıp tek bir final karara var. Uyumlularsa onayla, çelişiyorlarsa çöz ve gerekçelendir. SADECE JSON formatında yanıt ver.',
                },
                { role: 'user', content: prompt },
            ],
            temperature: 0.5,
            max_tokens: 8192,
            response_format: { type: 'json_object' },
        }),
        signal: AbortSignal.timeout(120000), // 2 minutes timeout
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Arbiter (GPT) error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Arbiter API error: ${response.status}`);
    }

    const result = await response.json();
    return result.choices?.[0]?.message?.content || '';
}

