/**
 * parseAnalysisResponse — Gemini JSON çıktısını parse ve validate
 */
export function parseAnalysisResponse(raw: string): Record<string, unknown> {
    let parsed: Record<string, unknown>;

    try {
        // Robust JSON extraction from Gemini response
        let cleaned = raw.trim();

        // Method 1: Extract from ```json ... ``` code fence (regex handles newlines)
        const codeFenceMatch = cleaned.match(/```(?:json)?\s*\n?([\s\S]*?)\n?\s*```/);
        if (codeFenceMatch) {
            cleaned = codeFenceMatch[1].trim();
        }

        // Method 2: If still not valid JSON, find the outermost { ... } block
        if (!cleaned.startsWith('{') && !cleaned.startsWith('[')) {
            const firstBrace = cleaned.indexOf('{');
            const lastBrace = cleaned.lastIndexOf('}');
            if (firstBrace !== -1 && lastBrace > firstBrace) {
                cleaned = cleaned.substring(firstBrace, lastBrace + 1);
            }
        }

        parsed = JSON.parse(cleaned);
    } catch (parseError: unknown) {
        const { logger } = require('firebase-functions');
        const errMsg = parseError instanceof Error ? parseError.message : String(parseError);
        logger.error(`JSON parse error: ${errMsg}`);
        logger.error('Raw response length:', raw.length);
        logger.error('Raw response LAST 200 chars:', raw.substring(raw.length - 200));
        logger.error('Raw response FIRST 200 chars:', raw.substring(0, 200));

        // Attempt to repair truncated JSON (close unclosed braces)
        try {
            let repaired = raw.trim();
            if (repaired.startsWith('```')) {
                const m = repaired.match(/```(?:json)?\s*\n?([\s\S]*)/);
                if (m) repaired = m[1].replace(/```\s*$/, '').trim();
            }
            if (!repaired.startsWith('{')) {
                const idx = repaired.indexOf('{');
                if (idx !== -1) repaired = repaired.substring(idx);
            }
            // Count unclosed braces and brackets, then close them
            let openBraces = 0, openBrackets = 0;
            let inString = false, escape = false;
            for (const ch of repaired) {
                if (escape) { escape = false; continue; }
                if (ch === '\\') { escape = true; continue; }
                if (ch === '"') { inString = !inString; continue; }
                if (inString) continue;
                if (ch === '{') openBraces++;
                if (ch === '}') openBraces--;
                if (ch === '[') openBrackets++;
                if (ch === ']') openBrackets--;
            }
            // Remove trailing comma if present
            repaired = repaired.replace(/,\s*$/, '');
            // Close unclosed structures
            for (let i = 0; i < openBrackets; i++) repaired += ']';
            for (let i = 0; i < openBraces; i++) repaired += '}';

            parsed = JSON.parse(repaired);
            logger.info('JSON repair succeeded!');
        } catch (repairError: unknown) {
            const repairMsg = repairError instanceof Error ? repairError.message : String(repairError);
            logger.error(`JSON repair also failed: ${repairMsg}`);
            return getDefaultAnalysis();
        }
    }

    // Validate required fields
    if (!parsed.prediction || typeof parsed.prediction !== 'object') {
        parsed.prediction = getDefaultPrediction();
    }
    if (!parsed.categories || typeof parsed.categories !== 'object') {
        parsed.categories = getDefaultCategories();
    }
    if (!Array.isArray(parsed.vetoRules)) {
        parsed.vetoRules = [];
    }
    if (!parsed.weightedTotal || typeof parsed.weightedTotal !== 'object') {
        parsed.weightedTotal = { home: 0, away: 0 };
    }
    if (!parsed.dataIntelligence || typeof parsed.dataIntelligence !== 'object') {
        parsed.dataIntelligence = getDefaultDataIntelligence();
    }

    // [A-11] Score range validation (0-10 arası)
    if (parsed.categories && typeof parsed.categories === 'object') {
        const cats = parsed.categories as Record<string, Record<string, unknown>>;
        for (const key of Object.keys(cats)) {
            const cat = cats[key];
            if (cat && typeof cat === 'object') {
                if (typeof cat.homeScore === 'number') {
                    cat.homeScore = Math.min(10, Math.max(0, cat.homeScore));
                }
                if (typeof cat.awayScore === 'number') {
                    cat.awayScore = Math.min(10, Math.max(0, cat.awayScore));
                }
                if (typeof cat.weight === 'number') {
                    cat.weight = Math.min(1, Math.max(0, cat.weight));
                }
            }
        }
    }

    // Prediction confidence validation (0-1 arası)
    const pred = parsed.prediction as Record<string, unknown> | undefined;
    if (pred && typeof pred.confidence === 'number') {
        pred.confidence = Math.min(1, Math.max(0, pred.confidence));
    }

    return parsed;
}

function getDefaultPrediction(): Record<string, unknown> {
    return {
        result: 'X',
        resultLabel: 'Veri yetersiz',
        confidence: 0,
        surpriseAlert: false,
        bankoLevel: 'KAPAT',
        mainReason: 'Analiz tamamlanamadı.',
    };
}

function getDefaultCategories(): Record<string, unknown> {
    const empty = { homeScore: 5, awayScore: 5, weight: 0, detail: 'Veri bulunamadı.' };
    return {
        power: { ...empty, weight: 0.20 },
        tactics: { ...empty, weight: 0.20 },
        psychology: { ...empty, weight: 0.18 },
        externalFactors: { ...empty, weight: 0.10 },
        market: { ...empty, weight: 0.07 },
        referee: { ...empty, weight: 0.08 },
        setPieces: { ...empty, weight: 0.07 },
        physical: { ...empty, weight: 0.10 },
    };
}

function getDefaultDataIntelligence(): Record<string, unknown> {
    return {
        weather: { temperature: '', humidity: '', rain: '', wind: '', impact: '' },
        injuries: { homeTeamOut: [], awayTeamOut: [], homeTeamDoubtful: [], awayTeamDoubtful: [] },
        referee: { name: '', avgFoulsPerMatch: 0, avgYellowCards: 0, avgPenalties: 0, varReferee: '' },
        restDays: { home: 0, away: 0, lastMatchHome: '', lastMatchAway: '' },
        xgData: { homeXg: 0, homeXga: 0, awayXg: 0, awayXga: 0, source: '' },
        headToHead: { last5: '', homeWins: 0, draws: 0, awayWins: 0 },
        stadiumInfo: { name: '', capacity: 0, altitude: 0, pitchType: '', pitchDimensions: '' },
        fixtureContext: { homeNextMatch: '', awayNextMatch: '', targetMatchSyndrome: '' },
    };
}

function getDefaultAnalysis(): Record<string, unknown> {
    return {
        prediction: getDefaultPrediction(),
        categories: getDefaultCategories(),
        vetoRules: [],
        weightedTotal: { home: 0, away: 0 },
        dataIntelligence: getDefaultDataIntelligence(),
        xgAnalysis: '',
        fixtureAnalysis: '',
        injuryReport: '',
        setPieceBreakdown: '',
        refereeImpact: '',
        detailedNarrative: 'Analiz tamamlanamadı. Lütfen tekrar deneyin.',
    };
}
