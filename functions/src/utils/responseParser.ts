/**
 * parseAnalysisResponse — Gemini JSON çıktısını parse ve validate
 */
export function parseAnalysisResponse(raw: string): Record<string, unknown> {
    let parsed: Record<string, unknown>;

    try {
        // Temizle — Gemini bazen ```json wrapper ekler
        let cleaned = raw.trim();
        if (cleaned.startsWith('```json')) {
            cleaned = cleaned.slice(7);
        }
        if (cleaned.startsWith('```')) {
            cleaned = cleaned.slice(3);
        }
        if (cleaned.endsWith('```')) {
            cleaned = cleaned.slice(0, -3);
        }
        cleaned = cleaned.trim();

        parsed = JSON.parse(cleaned);
    } catch {
        console.error('JSON parse failed. Raw response:', raw.substring(0, 500));
        // Fallback — boş analiz döndür
        return getDefaultAnalysis();
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
