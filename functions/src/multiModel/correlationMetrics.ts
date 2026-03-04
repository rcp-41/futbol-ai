/**
 * Metrik Kataloğu — arge1.md Bölüm 1
 * Korelasyon motorunun tarayacağı tüm metrikler ve encoder fonksiyonları.
 */

// ═══════════════════════════════════════════════════════════
// OYUNCU METRİKLERİ
// ═══════════════════════════════════════════════════════════

export const PLAYER_METRICS: Record<string, string> = {
    // Hücum
    goals: 'Gol sayısı',
    assists: 'Asist sayısı',
    xG: 'Beklenen gol',
    xA: 'Beklenen asist',
    shots: 'Şut sayısı',
    passes: 'Pas sayısı',
    tackles: 'Müdahale',
    interceptions: 'Top kesme',
    minutesPlayed: 'Oynanan dakika',
    rating: 'Maç puanı',
};

// ═══════════════════════════════════════════════════════════
// TAKIM METRİKLERİ
// ═══════════════════════════════════════════════════════════

export const TEAM_METRICS: Record<string, string> = {
    // Genel
    possession: 'Topa sahip olma (%)',
    xG: 'Takım xG',
    xGA: 'Verilen xG',
    goalsScored: 'Atılan gol',
    goalsConceded: 'Yenilen gol',

    // Şut
    totalShots: 'Toplam şut',
    shotsOnTarget: 'İsabetli şut',

    // Pas
    passAccuracy: 'Pas isabeti (%)',
    totalPasses: 'Toplam pas',
    shortPasses: 'Kısa pas',
    mediumPasses: 'Orta pas',
    longBalls: 'Uzun pas',
    progressivePasses: 'Progresif pas',

    // Defans
    fouls: 'Toplam faul',
    corners: 'Korner',
    offsides: 'Ofsayt',
    saves: 'Kaleci kurtarışı',

    // Sonuç
    halfTimeHome: 'İlk yarı ev sahibi gol',
    halfTimeAway: 'İlk yarı deplasman gol',
};

// ═══════════════════════════════════════════════════════════
// KOŞUL METRİKLERİ
// ═══════════════════════════════════════════════════════════

export const CONDITION_METRICS: Record<string, string> = {
    // Hava
    temperature: 'Sıcaklık (°C)',
    humidity: 'Nem (%)',
    windSpeed: 'Rüzgar (km/s)',

    // Maç bağlamı
    isHome: 'Ev sahibi mi (0/1)',

    // Rakip profili
    oppPossession: 'Rakip topa sahip olma',
    oppXG: 'Rakip xG',
    oppFormation: 'Rakip formasyon kodu',
    oppPassAccuracy: 'Rakip pas isabeti',
};

// ═══════════════════════════════════════════════════════════
// ENCODER FONKSİYONLARI
// ═══════════════════════════════════════════════════════════

export function encodeFormation(val: string): number {
    const formations: Record<string, number> = {
        '4-4-2': 1, '4-3-3': 2, '4-2-3-1': 3, '3-5-2': 4,
        '3-4-3': 5, '5-3-2': 6, '5-4-1': 7, '4-1-4-1': 8,
        '4-4-1-1': 9, '3-4-2-1': 10, '4-3-1-2': 11,
    };
    return formations[val] || 0;
}

export function encodeResult(homeGoals: number, awayGoals: number, isHome: boolean): number {
    if (isHome) {
        if (homeGoals > awayGoals) return 3; // W
        if (homeGoals === awayGoals) return 1; // D
        return 0; // L
    } else {
        if (awayGoals > homeGoals) return 3;
        if (homeGoals === awayGoals) return 1;
        return 0;
    }
}

// ═══════════════════════════════════════════════════════════
// ETİKET HELPER
// ═══════════════════════════════════════════════════════════

const ALL_LABELS: Record<string, string> = {
    ...Object.fromEntries(Object.entries(PLAYER_METRICS).map(([k, v]) => [`player_${k}`, v])),
    ...Object.fromEntries(Object.entries(TEAM_METRICS).map(([k, v]) => [`team_${k}`, v])),
    ...Object.fromEntries(Object.entries(CONDITION_METRICS).map(([k, v]) => [`cond_${k}`, v])),
    result_goalsScored: 'Atılan gol (sonuç)',
    result_goalsConceded: 'Yenilen gol (sonuç)',
    result_points: 'Puan (sonuç)',
    result_xG: 'xG (sonuç)',
};

export function getMetricLabel(col: string): string {
    if (ALL_LABELS[col]) return ALL_LABELS[col];

    // Fallback: clean prefix
    const clean = col
        .replace('team_', '')
        .replace('player_', '')
        .replace('cond_', '')
        .replace('opp_', 'rakip ')
        .replace('result_', 'sonuç:');

    return PLAYER_METRICS[clean] || TEAM_METRICS[clean] || CONDITION_METRICS[clean] || clean;
}
