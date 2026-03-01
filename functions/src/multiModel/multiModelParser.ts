/**
 * JSON Parsing and validation utility for AI model outputs.
 */

export function parseAIResult(rawText: string, modelName: string) {
    let cleaned = rawText.trim();

    // Yalnızca JSON'u ayıklamak için Markdown oklarını temizle
    if (cleaned.startsWith('```json')) {
        cleaned = cleaned.replace(/^```json/, '');
    } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.replace(/^```/, '');
    }
    if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
    }

    cleaned = cleaned.trim();

    try {
        const parsed = JSON.parse(cleaned);

        // Temel alanların varlığını garanti altına al ve clamp yap
        const result = {
            modelName,
            homeWinProbability: clamp(parsed.homeWinProbability, 0, 100),
            drawProbability: clamp(parsed.drawProbability, 0, 100),
            awayWinProbability: clamp(parsed.awayWinProbability, 0, 100),
            over25Probability: clamp(parsed.over25Probability, 0, 100),
            under25Probability: clamp(parsed.under25Probability, 0, 100),
            predictedScore: parsed.predictedScore || '0-0',
            bttsProbability: clamp(parsed.bttsProbability, 0, 100),
            topPredictions: Array.isArray(parsed.topPredictions) ? parsed.topPredictions.slice(0, 3) : [],
            keyFactors: Array.isArray(parsed.keyFactors) ? parsed.keyFactors.slice(0, 5) : [],
            gameNarrative: String(parsed.gameNarrative || 'Analiz anlatımı bulunamadı.'),
            confidenceScore: clamp(parsed.confidenceScore, 0, 10),
            rawTokensUsed: 0 // Optional, handled elsewhere if needed
        };

        return result;
    } catch (e: any) {
        throw new Error(`${modelName} JSON Parse Hatası: ${e.message}\nRaw Output: ${rawText.substring(0, 200)}...`);
    }
}

function clamp(value: any, min: number, max: number): number {
    const num = parseFloat(value);
    if (isNaN(num)) return min;
    if (num < min) return min;
    if (num > max) return max;
    return num;
}
