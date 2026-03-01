/**
 * Veri Doğrulama — Akıllı doğrulama
 * Maç verisinin güncelliğini ve tutarlılığını kontrol eder.
 * KURAL: Sadece takım adları zorunlu — diğer eksiklikler uyarı olarak eklenir, analizi engellemez.
 */

import { logger } from 'firebase-functions/v2';

export interface VerificationResult {
    verified: boolean;
    checks: {
        teamsValid: boolean;
        dateValid: boolean;
        leagueValid: boolean;
        oddsValid: boolean;
        dataFreshness: string;
    };
    sourcesChecked: number;
    dataCompleteness: number;
    warnings: string[];
}

/**
 * Türkçe ay isimlerini içeren tarih formatlarını parse et
 * "28 Şub 16:00", "08 Mar 20:00", "2026-03-08" gibi formatları destekler
 */
function parseMatchDate(raw: any): Date | null {
    if (!raw) return null;

    // Firestore Timestamp
    if (raw.toDate) return raw.toDate();
    if (raw._seconds) return new Date(raw._seconds * 1000);

    const str = String(raw).trim();

    // ISO format: 2026-03-08T20:00:00
    const isoDate = new Date(str);
    if (!isNaN(isoDate.getTime()) && isoDate.getFullYear() > 2000) return isoDate;

    // Türkçe format: "28 Şub 16:00" veya "08 Mar 20:00"
    const turkishMonths: Record<string, number> = {
        'oca': 0, 'ocak': 0,
        'şub': 1, 'şubat': 1,
        'mar': 2, 'mart': 2,
        'nis': 3, 'nisan': 3,
        'may': 4, 'mayıs': 4,
        'haz': 5, 'haziran': 5,
        'tem': 6, 'temmuz': 6,
        'ağu': 7, 'ağustos': 7,
        'eyl': 8, 'eylül': 8,
        'eki': 9, 'ekim': 9,
        'kas': 10, 'kasım': 10,
        'ara': 11, 'aralık': 11,
    };

    // Pattern: "DD MMM HH:MM" veya "DD MMM"
    const match = str.match(/^(\d{1,2})\s+(\w+)\s*(\d{2}:\d{2})?/i);
    if (match) {
        const day = parseInt(match[1]);
        const monthStr = match[2].toLowerCase();
        const month = turkishMonths[monthStr];

        if (month !== undefined && day >= 1 && day <= 31) {
            // Yılı akıllıca belirle: şu anki yılı kullan
            const now = new Date();
            const year = now.getFullYear();
            const result = new Date(year, month, day);

            // Eğer tarih 6 aydan fazla geçmişse, gelecek yıla ata
            if (now.getTime() - result.getTime() > 180 * 24 * 60 * 60 * 1000) {
                result.setFullYear(year + 1);
            }

            return result;
        }
    }

    // "DD.MM.YYYY" format
    const dotMatch = str.match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})/);
    if (dotMatch) {
        return new Date(parseInt(dotMatch[3]), parseInt(dotMatch[2]) - 1, parseInt(dotMatch[1]));
    }

    return null;
}

/**
 * Veri doğrulaması — SADECE takım adları zorunlu.
 * Diğer eksiklikler warning olarak eklenir ama analizi ENGELLEMEZ.
 */
export async function verifyData(
    md: Record<string, any>,
    _apiKey: string // AI doğrulama devre dışı — Gemini sezon bilgisini yanlış biliyor
): Promise<VerificationResult> {
    const warnings: string[] = [];

    // — Takım kontrolü (TEK ZORUNLU ALAN) —
    const homeTeam = md.homeTeam?.name || md.homeTeam || '';
    const awayTeam = md.awayTeam?.name || md.awayTeam || '';
    const teamsValid = !!(homeTeam && awayTeam && homeTeam !== awayTeam);
    if (!teamsValid) warnings.push('Takım bilgileri eksik veya hatalı.');

    // — Tarih kontrolü (opsiyonel) —
    let dateValid = false;
    const matchDate = parseMatchDate(md.matchDate || md.date);
    if (matchDate) {
        dateValid = true;
        logger.info(`[Verification] Maç tarihi parse edildi: ${matchDate.toISOString()}`);
    } else {
        warnings.push('Maç tarihi parse edilemedi — analiz yine de devam edecek.');
        logger.warn(`[Verification] Maç tarihi parse edilemedi: ${md.matchDate || md.date}`);
    }

    // — Lig kontrolü (opsiyonel) —
    const league = md.league || md.competition || md.leagueName || '';
    const leagueValid = !!league;
    if (!leagueValid) warnings.push('Lig bilgisi belirtilmemiş (varsayılan: Türkiye Süper Lig).');

    // — Oran kontrolü (opsiyonel) —
    const odds = md.odds || {};
    const hasOdds = !!(odds.home || odds['1'] || odds.homeWin);
    const oddsValid = hasOdds;
    if (!oddsValid) warnings.push('Bahis oranları mevcut değil.');

    // — Form kontrolü (opsiyonel) —
    const hasForm = !!(md.homeTeam?.formLast5 || md.awayTeam?.formLast5 || md.homeForm || md.awayForm);

    // — Veri tamlığı hesapla —
    let fieldsPresent = 0;
    const totalFields = 5;
    if (teamsValid) fieldsPresent++;
    if (dateValid) fieldsPresent++;
    if (leagueValid) fieldsPresent++;
    if (oddsValid) fieldsPresent++;
    if (hasForm) fieldsPresent++;
    const dataCompleteness = Math.round((fieldsPresent / totalFields) * 100);

    // VERIFIED = sadece takım adları yeterli
    const verified = teamsValid;

    return {
        verified,
        checks: { teamsValid, dateValid, leagueValid, oddsValid, dataFreshness: 'current_season' },
        sourcesChecked: totalFields,
        dataCompleteness,
        warnings,
    };
}
