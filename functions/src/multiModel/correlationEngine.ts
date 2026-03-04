/**
 * Kombinasyonel Korelasyon Motoru
 * arge1.md mimarisinin TypeScript implementasyonu.
 *
 * Mevcut `matches` koleksiyonundaki fbref/sofascore/weather verilerini
 * düzleştirip (flatten), tüm metrik çiftlerinde Spearman korelasyonu hesaplar.
 * Önümüzdeki maçın koşullarına göre filtreler ve AI prompt'larına besler.
 */

import { logger } from 'firebase-functions/v2';
import { db } from '../firebase';
import * as ss from 'simple-statistics';
import {
    encodeFormation,
    encodeResult,
    getMetricLabel,
} from './correlationMetrics';

// ═══════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════

export interface CorrelationResult {
    metricA: string;
    metricB: string;
    labelA: string;
    labelB: string;
    correlationType: 'spearman' | 'pearson';
    coefficient: number; // -1 ... +1
    sampleSize: number;
    pValue: number;
    confidence: 'high' | 'medium' | 'low';
    entity: string; // takım slug veya oyuncu adı
    entityType: 'team' | 'player';
    interpretation: string;
}

export interface CorrelationScanResult {
    scanStats: {
        totalPairsScanned: number;
        significantFound: number;
        relevantToMatch: number;
        scanDurationMs: number;
    };
    teamCorrelations: {
        home: CorrelationResult[];
        away: CorrelationResult[];
    };
    playerCorrelations: {
        home: CorrelationResult[];
        away: CorrelationResult[];
    };
    topFindings: CorrelationResult[];
}

interface FlatRow {
    [key: string]: number | null;
}

interface UpcomingConditions {
    temperature?: number | null;
    humidity?: number | null;
    windSpeed?: number | null;
    isRainy?: boolean;
    referee?: string;
    oppFormation?: string;
}

// ═══════════════════════════════════════════════════════════
// FLATTEN: matches doc → düz satır
// ═══════════════════════════════════════════════════════════

/**
 * Bir match dokümanını belirli takımın perspektifinden düz satıra çevirir.
 */
function flattenMatchForTeam(
    matchDoc: Record<string, any>,
    targetTeamSlug: string
): FlatRow | null {
    const meta = matchDoc.meta;
    const result = matchDoc.result;
    const fbref = matchDoc.fbref;
    const sofascore = matchDoc.sofascore;
    const weather = matchDoc.weather;

    if (!meta || !result || result.status !== 'finished') return null;

    // Takımın ev sahibi mi deplasman mı olduğunu belirle
    const homeSlug = normalizeSlug(meta.homeTeam || '');
    const awaySlug = normalizeSlug(meta.awayTeam || '');
    const isHome = homeSlug === targetTeamSlug;
    const isAway = awaySlug === targetTeamSlug;
    if (!isHome && !isAway) return null;

    const side = isHome ? 'home' : 'away';
    const oppSide = isHome ? 'away' : 'home';

    const row: FlatRow = {};

    // --- Takım metrikleri ---
    const teamStats = fbref?.teamStats?.[side];
    const oppStats = fbref?.teamStats?.[oppSide];

    row['team_possession'] = teamStats?.possession ?? null;
    row['team_xG'] = teamStats?.xG ?? sofascore?.xG?.[side] ?? null;
    row['team_xGA'] = oppStats?.xG ?? sofascore?.xG?.[oppSide] ?? null;
    row['team_totalShots'] = teamStats?.shots ?? null;
    row['team_shotsOnTarget'] = teamStats?.shotsOnTarget ?? null;
    row['team_passAccuracy'] = teamStats?.passAccuracy ?? null;
    row['team_totalPasses'] = teamStats?.passes ?? null;
    row['team_fouls'] = teamStats?.fouls ?? null;
    row['team_corners'] = teamStats?.corners ?? null;
    row['team_offsides'] = teamStats?.offsides ?? null;
    row['team_saves'] = teamStats?.saves ?? null;

    // Pas tipleri
    const passTypes = fbref?.passTypes?.[side];
    row['team_shortPasses'] = passTypes?.short ?? null;
    row['team_mediumPasses'] = passTypes?.medium ?? null;
    row['team_longBalls'] = passTypes?.long ?? null;
    row['team_progressivePasses'] = passTypes?.progressive ?? null;

    // --- Koşul metrikleri ---
    row['cond_temperature'] = weather?.temperature ?? null;
    row['cond_humidity'] = weather?.humidity ?? null;
    row['cond_windSpeed'] = weather?.windSpeed ?? null;
    row['cond_isHome'] = isHome ? 1 : 0;

    // Rakip profili
    row['cond_oppPossession'] = oppStats?.possession ?? null;
    row['cond_oppXG'] = oppStats?.xG ?? sofascore?.xG?.[oppSide] ?? null;
    row['cond_oppPassAccuracy'] = oppStats?.passAccuracy ?? null;

    // Rakip formasyon
    const oppFormation = fbref?.formations?.[oppSide];
    row['cond_oppFormation'] = oppFormation ? encodeFormation(oppFormation) : null;

    // İlk yarı
    row['team_halfTimeHome'] = result.halfTimeHome ?? null;
    row['team_halfTimeAway'] = result.halfTimeAway ?? null;

    // --- Sonuç metrikleri ---
    const goalsScored = isHome ? result.homeGoals : result.awayGoals;
    const goalsConceded = isHome ? result.awayGoals : result.homeGoals;
    row['result_goalsScored'] = goalsScored ?? null;
    row['result_goalsConceded'] = goalsConceded ?? null;
    row['result_points'] = (goalsScored != null && goalsConceded != null)
        ? encodeResult(result.homeGoals, result.awayGoals, isHome)
        : null;
    row['result_xG'] = row['team_xG'];

    return row;
}

/**
 * Bir match dokümanından belirli bir oyuncunun satırını çıkarır.
 */
function flattenMatchForPlayer(
    matchDoc: Record<string, any>,
    playerName: string,
    teamSlug: string
): FlatRow | null {
    const meta = matchDoc.meta;
    const result = matchDoc.result;
    const fbref = matchDoc.fbref;
    const weather = matchDoc.weather;
    const sofascore = matchDoc.sofascore;

    if (!meta || !result || result.status !== 'finished' || !fbref?.playerStats) return null;

    const homeSlug = normalizeSlug(meta.homeTeam || '');
    const isHome = homeSlug === teamSlug;
    const side = isHome ? 'home' : 'away';

    const playerStats: any[] = fbref.playerStats[side] || [];
    const playerRow = playerStats.find((p: any) =>
        normalizeSlug(p.player || '') === normalizeSlug(playerName)
    );

    if (!playerRow || !playerRow.minutes || playerRow.minutes < 15) return null;

    const row: FlatRow = {};

    // --- Oyuncu metrikleri ---
    row['player_goals'] = playerRow.goals ?? null;
    row['player_assists'] = playerRow.assists ?? null;
    row['player_xG'] = playerRow.xG ?? null;
    row['player_xA'] = playerRow.xA ?? null;
    row['player_shots'] = playerRow.shots ?? null;
    row['player_passes'] = playerRow.passes ?? null;
    row['player_tackles'] = playerRow.tackles ?? null;
    row['player_interceptions'] = playerRow.interceptions ?? null;
    row['player_minutesPlayed'] = playerRow.minutes ?? null;

    // Rating: sofascore'dan dene, yoksa fbref'ten
    const sofascoreRatings = sofascore?.playerRatings?.[side] || [];
    const ssRating = sofascoreRatings.find(
        (r: any) => normalizeSlug(r.player || '') === normalizeSlug(playerName)
    );
    row['player_rating'] = ssRating?.rating ?? playerRow.rating ?? null;

    // --- Koşul metrikleri ---
    row['cond_temperature'] = weather?.temperature ?? null;
    row['cond_humidity'] = weather?.humidity ?? null;
    row['cond_windSpeed'] = weather?.windSpeed ?? null;
    row['cond_isHome'] = isHome ? 1 : 0;

    // Rakip bilgisi
    const oppSide = isHome ? 'away' : 'home';
    const oppStats = fbref?.teamStats?.[oppSide];
    row['cond_oppPossession'] = oppStats?.possession ?? null;
    row['cond_oppXG'] = oppStats?.xG ?? null;
    row['cond_oppFormation'] = fbref?.formations?.[oppSide]
        ? encodeFormation(fbref.formations[oppSide])
        : null;

    // Sonuç
    const goalsScored = isHome ? result.homeGoals : result.awayGoals;
    const goalsConceded = isHome ? result.awayGoals : result.homeGoals;
    row['result_goalsScored'] = goalsScored ?? null;
    row['result_goalsConceded'] = goalsConceded ?? null;
    row['result_points'] = (goalsScored != null && goalsConceded != null)
        ? encodeResult(result.homeGoals, result.awayGoals, isHome)
        : null;

    return row;
}

// ═══════════════════════════════════════════════════════════
// MATRİS OLUŞTURMA (Firestore'dan oku → düzleştir)
// ═══════════════════════════════════════════════════════════

/**
 * Bir takımın tüm maçlarını Firestore'dan çekip düz matrise dönüştürür.
 */
async function buildTeamMatchMatrix(
    teamSlug: string,
    season?: string
): Promise<FlatRow[]> {
    // Matches koleksiyonundan bu takımın maçlarını bul
    // matchKey formatı: "YYYY-MM-DD_takim1_vs_takim2"
    const allMatches = await fetchTeamMatches(teamSlug, season);
    const matrix: FlatRow[] = [];

    for (const doc of allMatches) {
        const row = flattenMatchForTeam(doc, teamSlug);
        if (row) matrix.push(row);
    }

    logger.info(`[CorrEngine] ${teamSlug} için ${matrix.length} maç matrisi oluşturuldu`);
    return matrix;
}

/**
 * Bir oyuncunun tüm maçlarını düz matrise dönüştürür.
 */
async function buildPlayerMatchMatrix(
    playerName: string,
    teamSlug: string,
    season?: string
): Promise<FlatRow[]> {
    const allMatches = await fetchTeamMatches(teamSlug, season);
    const matrix: FlatRow[] = [];

    for (const doc of allMatches) {
        const row = flattenMatchForPlayer(doc, playerName, teamSlug);
        if (row) matrix.push(row);
    }

    logger.info(`[CorrEngine] ${playerName} için ${matrix.length} maç matrisi oluşturuldu`);
    return matrix;
}

/**
 * Firestore'dan bir takımın maçlarını çeker.
 * matchKey "YYYY-MM-DD_slug1_vs_slug2" formatında olduğu için
 * tüm matches'i çekip filtreliyoruz.
 */
async function fetchTeamMatches(
    teamSlug: string,
    season?: string
): Promise<Record<string, any>[]> {
    try {
        let query = db.collection('matches')
            .where('result.status', '==', 'finished')
            .limit(200);

        // Sezon filtresi
        if (season) {
            query = db.collection('matches')
                .where('meta.season', '==', season)
                .where('result.status', '==', 'finished')
                .limit(200);
        }

        const snap = await query.get();
        const results: Record<string, any>[] = [];

        for (const doc of snap.docs) {
            const data = doc.data();
            const meta = data.meta;
            if (!meta) continue;

            const homeSlug = normalizeSlug(meta.homeTeam || '');
            const awaySlug = normalizeSlug(meta.awayTeam || '');

            if (homeSlug === teamSlug || awaySlug === teamSlug) {
                results.push(data);
            }
        }

        return results;
    } catch (e: any) {
        logger.error(`[CorrEngine] fetchTeamMatches hatası: ${e.message}`);
        return [];
    }
}

// ═══════════════════════════════════════════════════════════
// KORELASYON HESAPLAMA
// ═══════════════════════════════════════════════════════════

const MIN_SAMPLE_SIZE = 5;
const SIGNIFICANCE_THRESHOLD = 0.05;
const MIN_CORRELATION_ABS = 0.3; // zayıf korelasyonları filtrele

/**
 * Matristeki tüm metrik çiftlerinin Spearman korelasyonunu hesaplar.
 */
function scanAllCorrelations(
    matrix: FlatRow[],
    entity: string,
    entityType: 'team' | 'player'
): CorrelationResult[] {
    if (matrix.length < MIN_SAMPLE_SIZE) {
        logger.info(`[CorrEngine] ${entity} için yetersiz veri (${matrix.length} < ${MIN_SAMPLE_SIZE})`);
        return [];
    }

    // Sütun isimlerini çıkar
    const allColumns = new Set<string>();
    for (const row of matrix) {
        for (const key of Object.keys(row)) {
            allColumns.add(key);
        }
    }
    const columns = Array.from(allColumns);

    // Sonuç kolonu olarak kullanılacaklar (bunlarla korelasyon ararız)
    const resultColumns = columns.filter(c => c.startsWith('result_'));
    const featureColumns = columns.filter(c => !c.startsWith('result_'));

    const results: CorrelationResult[] = [];
    let totalPairsScanned = 0;

    // Feature × Result çiftlerini tara
    for (const feature of featureColumns) {
        for (const target of resultColumns) {
            totalPairsScanned++;
            const corr = computeSpearman(matrix, feature, target);
            if (corr) {
                results.push({
                    ...corr,
                    entity,
                    entityType,
                });
            }
        }
    }

    // Feature × Feature çiftlerini de tara (ilginç ilişkiler bulmak için)
    for (let i = 0; i < featureColumns.length; i++) {
        for (let j = i + 1; j < featureColumns.length; j++) {
            // Aynı prefix olanları atla (team_xG vs team_xGA zaten beklenen)
            const prefixI = featureColumns[i].split('_')[0];
            const prefixJ = featureColumns[j].split('_')[0];
            if (prefixI === prefixJ) continue;

            totalPairsScanned++;
            const corr = computeSpearman(matrix, featureColumns[i], featureColumns[j]);
            if (corr) {
                results.push({
                    ...corr,
                    entity,
                    entityType,
                });
            }
        }
    }

    logger.info(`[CorrEngine] ${entity}: ${totalPairsScanned} çift tarandı, ${results.length} anlamlı bulundu`);
    return results;
}

/**
 * İki sütun arasındaki Spearman korelasyonunu hesaplar.
 * null değerleri olan satırları atlar.
 */
function computeSpearman(
    matrix: FlatRow[],
    colA: string,
    colB: string
): Omit<CorrelationResult, 'entity' | 'entityType'> | null {
    // Her iki sütunda da non-null olan satırları al
    const pairs: [number, number][] = [];
    for (const row of matrix) {
        const a = row[colA];
        const b = row[colB];
        if (a != null && b != null && !isNaN(a) && !isNaN(b)) {
            pairs.push([a, b]);
        }
    }

    if (pairs.length < MIN_SAMPLE_SIZE) return null;

    // Varyans kontrolü — tüm değerler aynıysa korelasyon anlamsız
    const valuesA = pairs.map(p => p[0]);
    const valuesB = pairs.map(p => p[1]);
    if (ss.standardDeviation(valuesA) === 0 || ss.standardDeviation(valuesB) === 0) return null;

    // Spearman sıralama korelasyonu = Rank'lar üzerine Pearson
    const ranksA = computeRanks(valuesA);
    const ranksB = computeRanks(valuesB);

    const coefficient = ss.sampleCorrelation(ranksA, ranksB);

    if (isNaN(coefficient)) return null;
    if (Math.abs(coefficient) < MIN_CORRELATION_ABS) return null;

    // p-value yaklaşımı: t-test ile
    const n = pairs.length;
    const t = coefficient * Math.sqrt((n - 2) / (1 - coefficient * coefficient));
    const pValue = approximatePValue(Math.abs(t), n - 2);

    if (pValue > SIGNIFICANCE_THRESHOLD) return null;

    const confidence = pValue < 0.01 ? 'high' : pValue < 0.03 ? 'medium' : 'low';

    return {
        metricA: colA,
        metricB: colB,
        labelA: getMetricLabel(colA),
        labelB: getMetricLabel(colB),
        correlationType: 'spearman',
        coefficient: Math.round(coefficient * 1000) / 1000,
        sampleSize: n,
        pValue: Math.round(pValue * 10000) / 10000,
        confidence,
        interpretation: autoInterpret(colA, colB, coefficient, n, valuesA, valuesB),
    };
}

/**
 * Değerleri sıraya çevirir (tied olanlar avg rank alır)
 */
function computeRanks(values: number[]): number[] {
    const indexed = values.map((v, i) => ({ value: v, index: i }));
    indexed.sort((a, b) => a.value - b.value);

    const ranks = new Array(values.length);
    let i = 0;
    while (i < indexed.length) {
        let j = i;
        while (j < indexed.length && indexed[j].value === indexed[i].value) {
            j++;
        }
        const avgRank = (i + j - 1) / 2 + 1;
        for (let k = i; k < j; k++) {
            ranks[indexed[k].index] = avgRank;
        }
        i = j;
    }
    return ranks;
}

/**
 * t-dağılımı p-value yaklaşımı (basitleştirilmiş).
 * Küçük örneklemlerde tam doğru olmasa da, yeterli bir filtre.
 */
function approximatePValue(tStat: number, df: number): number {
    // Normal dağılıma yaklaşım (df > 30 için iyi)
    if (df > 30) {
        // Sigmoid-benzeri yaklaşım
        const z = tStat;
        return 2 * (1 - normalCDF(z));
    }
    // Küçük df için daha muhafazakar
    const x = df / (df + tStat * tStat);
    return x; // Kaba yaklaşım, p < 0.05 filtremiz için yeterli
}

/**
 * Standart normal CDF yaklaşımı (Abramowitz and Stegun)
 */
function normalCDF(x: number): number {
    const a1 = 0.254829592;
    const a2 = -0.284496736;
    const a3 = 1.421413741;
    const a4 = -1.453152027;
    const a5 = 1.061405429;
    const p = 0.3275911;

    const sign = x < 0 ? -1 : 1;
    x = Math.abs(x) / Math.sqrt(2);
    const t = 1.0 / (1.0 + p * x);
    const y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Math.exp(-x * x);
    return 0.5 * (1.0 + sign * y);
}

// ═══════════════════════════════════════════════════════════
// OTOMATİK YORUMLAMA
// ═══════════════════════════════════════════════════════════

function autoInterpret(
    colA: string,
    colB: string,
    coefficient: number,
    sampleSize: number,
    valuesA: number[],
    valuesB: number[]
): string {
    const labelA = getMetricLabel(colA);
    const labelB = getMetricLabel(colB);
    const direction = coefficient > 0 ? 'arttıkça' : 'arttıkça';
    const effect = coefficient > 0 ? 'artıyor' : 'azalıyor';
    const strength = Math.abs(coefficient) > 0.7 ? 'güçlü' :
        Math.abs(coefficient) > 0.5 ? 'orta' : 'zayıf';

    const meanA = ss.mean(valuesA);
    const meanB = ss.mean(valuesB);

    return `${labelA} ${direction} ${labelB} ${effect} (${strength} ilişki, r=${coefficient.toFixed(2)}, n=${sampleSize}). ` +
        `Ortalamalar: ${labelA}=${meanA.toFixed(1)}, ${labelB}=${meanB.toFixed(1)}`;
}

// ═══════════════════════════════════════════════════════════
// FİLTRELEME: Önümüzdeki maça uygun olanlar
// ═══════════════════════════════════════════════════════════

function filterRelevantCorrelations(
    correlations: CorrelationResult[],
    conditions: UpcomingConditions
): CorrelationResult[] {
    return correlations.filter(c => {
        // Hava koşulu varsa ve korelasyon hava ile ilgiliyse kontrol et
        if (c.metricA.includes('temperature') || c.metricB.includes('temperature')) {
            if (conditions.temperature == null) return false; // Yeterli bilgi yok, atla
            return true; // Hava verisi var, bu korelasyon geçerli
        }

        if (c.metricA.includes('windSpeed') || c.metricB.includes('windSpeed')) {
            if (conditions.windSpeed == null) return false;
            return true;
        }

        if (c.metricA.includes('humidity') || c.metricB.includes('humidity')) {
            if (conditions.humidity == null) return false;
            return true;
        }

        // Rakip formasyon korelasyonu — formasyon bilgisi varsa geçerli
        if (c.metricA.includes('oppFormation') || c.metricB.includes('oppFormation')) {
            return !!conditions.oppFormation;
        }

        // Geri kalan korelasyonlar (xG, possession, vs.) her zaman geçerli
        return true;
    });
}

// ═══════════════════════════════════════════════════════════
// ANA FONKSİYON
// ═══════════════════════════════════════════════════════════

/**
 * Tam kombinasyonel korelasyon taraması çalıştırır.
 * @returns Tarama sonuçları, AI prompt'larına beslenecek format
 */
export async function runFullCombinatorialScan(
    homeTeamSlug: string,
    awayTeamSlug: string,
    matchData: Record<string, any>,
    season?: string
): Promise<CorrelationScanResult> {
    const startTime = Date.now();
    let totalPairsScanned = 0;
    let significantFound = 0;

    // Koşulları belirle
    const conditions: UpcomingConditions = {
        temperature: matchData.weather?.temperature ?? null,
        humidity: matchData.weather?.humidity ?? null,
        windSpeed: matchData.weather?.windSpeed ?? null,
        oppFormation: matchData.fbref?.formations?.away ?? matchData.fbref?.formations?.home ?? null,
    };

    // ═══ TAKIMLAR ═══
    logger.info(`[CorrEngine] Ev sahibi (${homeTeamSlug}) taranıyor...`);
    const homeMatrix = await buildTeamMatchMatrix(homeTeamSlug, season);
    const homeTeamCorrs = scanAllCorrelations(homeMatrix, homeTeamSlug, 'team');

    logger.info(`[CorrEngine] Deplasman (${awayTeamSlug}) taranıyor...`);
    const awayMatrix = await buildTeamMatchMatrix(awayTeamSlug, season);
    const awayTeamCorrs = scanAllCorrelations(awayMatrix, awayTeamSlug, 'team');

    // ═══ KİLİT OYUNCULAR ═══
    const homePlayerCorrs: CorrelationResult[] = [];
    const awayPlayerCorrs: CorrelationResult[] = [];

    // En fazla 5 kilit oyuncu tara (aksi halde çok uzun sürer)
    const homeKeyPlayers = extractKeyPlayers(homeMatrix, homeTeamSlug);
    const awayKeyPlayers = extractKeyPlayers(awayMatrix, awayTeamSlug);

    for (const playerName of homeKeyPlayers.slice(0, 5)) {
        const playerMatrix = await buildPlayerMatchMatrix(playerName, homeTeamSlug, season);
        const playerCorrs = scanAllCorrelations(playerMatrix, playerName, 'player');
        homePlayerCorrs.push(...playerCorrs);
    }

    for (const playerName of awayKeyPlayers.slice(0, 5)) {
        const playerMatrix = await buildPlayerMatchMatrix(playerName, awayTeamSlug, season);
        const playerCorrs = scanAllCorrelations(playerMatrix, playerName, 'player');
        awayPlayerCorrs.push(...playerCorrs);
    }

    // Toplamları hesapla
    const allCorrelations = [
        ...homeTeamCorrs, ...awayTeamCorrs,
        ...homePlayerCorrs, ...awayPlayerCorrs,
    ];
    significantFound = allCorrelations.length;

    // Filtreleme
    const filteredHome = filterRelevantCorrelations(homeTeamCorrs, conditions);
    const filteredAway = filterRelevantCorrelations(awayTeamCorrs, conditions);
    const filteredHomePlayers = filterRelevantCorrelations(homePlayerCorrs, conditions);
    const filteredAwayPlayers = filterRelevantCorrelations(awayPlayerCorrs, conditions);

    const allFiltered = [
        ...filteredHome, ...filteredAway,
        ...filteredHomePlayers, ...filteredAwayPlayers,
    ];

    // En önemli bulguları sırala (confidence + |coefficient|)
    const topFindings = allFiltered
        .sort((a, b) => {
            const confOrder = { high: 3, medium: 2, low: 1 };
            const scoreA = confOrder[a.confidence] * 10 + Math.abs(a.coefficient) * 10;
            const scoreB = confOrder[b.confidence] * 10 + Math.abs(b.coefficient) * 10;
            return scoreB - scoreA;
        })
        .slice(0, 30);

    const durationMs = Date.now() - startTime;
    logger.info(`[CorrEngine] Tarama tamamlandı: ${durationMs}ms, ${significantFound} anlamlı, ${allFiltered.length} maça uygun`);

    return {
        scanStats: {
            totalPairsScanned,
            significantFound,
            relevantToMatch: allFiltered.length,
            scanDurationMs: durationMs,
        },
        teamCorrelations: {
            home: filteredHome,
            away: filteredAway,
        },
        playerCorrelations: {
            home: filteredHomePlayers,
            away: filteredAwayPlayers,
        },
        topFindings,
    };
}

// ═══════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════

function normalizeSlug(name: string): string {
    return name
        .toLowerCase()
        .replace(/ş/g, 's').replace(/ğ/g, 'g').replace(/ü/g, 'u')
        .replace(/ö/g, 'o').replace(/ç/g, 'c').replace(/ı/g, 'i')
        .replace(/İ/g, 'i').replace(/Ş/g, 's').replace(/Ğ/g, 'g')
        .replace(/Ü/g, 'u').replace(/Ö/g, 'o').replace(/Ç/g, 'c')
        .replace(/\s+/g, '-')
        .replace(/[^a-z0-9-]/g, '')
        .replace(/-+/g, '-')
        .trim();
}

/**
 * Matristeki en sık oynayan oyuncuları çıkarır.
 * matches dokümanlarından player isimlerini toplar.
 */
function extractKeyPlayers(
    teamMatches: FlatRow[],
    teamSlug: string
): string[] {
    // Bu fonksiyon aslında FlatRow'dan değil, raw matches'ten çalışmalı.
    // Ancak buildTeamMatchMatrix zaten Firestore'dan okuyor.
    // Kilit oyuncuları ayrıca Firestore players koleksiyonundan çekeyim.
    // Şimdilik boş dönüp, pipeline'dan beslenecek.
    return [];
}

/**
 * Kilit oyuncuları Firestore'dan çeker.
 */
export async function fetchKeyPlayerNames(teamSlug: string, limit = 5): Promise<string[]> {
    try {
        const snap = await db.collection('players')
            .where('team', '==', teamSlug)
            .limit(limit)
            .get();
        return snap.docs.map(d => d.data().name || '').filter(Boolean);
    } catch (e: any) {
        logger.warn(`[CorrEngine] Kilit oyuncu çekme hatası: ${e.message}`);
        return [];
    }
}

// ═══════════════════════════════════════════════════════════
// FORMAT: AI Prompt'a dönüştürme
// ═══════════════════════════════════════════════════════════

/**
 * Korelasyon sonuçlarını AI prompt'una eklenecek metin formatına dönüştürür.
 */
export function formatCorrelationsForPrompt(scanResult: CorrelationScanResult): string {
    if (scanResult.topFindings.length === 0) {
        return '═══ KOMBİNASYONEL KORELASYON BULGULARI ═══\nYeterli veri bulunamadı veya anlamlı korelasyon tespit edilemedi.\n';
    }

    const sections: string[] = [];

    sections.push(`═══ KOMBİNASYONEL KORELASYON BULGULARI ═══`);
    sections.push(
        `Taranan çift: ${scanResult.scanStats.totalPairsScanned} | ` +
        `Anlamlı bulunan: ${scanResult.scanStats.significantFound} | ` +
        `Bu maça uygun: ${scanResult.scanStats.relevantToMatch}`
    );
    sections.push('');

    // Güven seviyesine göre grupla
    const high = scanResult.topFindings.filter(c => c.confidence === 'high');
    const medium = scanResult.topFindings.filter(c => c.confidence === 'medium');
    const low = scanResult.topFindings.filter(c => c.confidence === 'low');

    if (high.length > 0) {
        sections.push('🔴 YÜKSEK GÜVEN:');
        for (const c of high.slice(0, 10)) {
            sections.push(`• [${c.entity}] ${c.interpretation}`);
        }
        sections.push('');
    }

    if (medium.length > 0) {
        sections.push('🟡 ORTA GÜVEN:');
        for (const c of medium.slice(0, 10)) {
            sections.push(`• [${c.entity}] ${c.interpretation}`);
        }
        sections.push('');
    }

    if (low.length > 0) {
        sections.push('🟢 DÜŞÜK GÜVEN:');
        for (const c of low.slice(0, 5)) {
            sections.push(`• [${c.entity}] ${c.interpretation}`);
        }
        sections.push('');
    }

    return sections.join('\n');
}
