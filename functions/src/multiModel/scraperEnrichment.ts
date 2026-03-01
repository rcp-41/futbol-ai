/**
 * Scraper Enrichment Module
 * Firestore'daki scraper koleksiyonlarından (teams, players, managers, referees, leagues, news)
 * veri çekip AI analiz pipeline'ına besler.
 */

import { logger } from 'firebase-functions/v2';
import { db } from '../firebase';

// ─────────────────── TYPES ───────────────────

export interface EnrichedMatchData {
    homeTeamData: Record<string, any> | null;
    awayTeamData: Record<string, any> | null;
    homeKeyPlayers: Record<string, any>[];
    awayKeyPlayers: Record<string, any>[];
    homeManagerData: Record<string, any> | null;
    awayManagerData: Record<string, any> | null;
    refereeData: Record<string, any> | null;
    leagueData: Record<string, any> | null;
    relatedNews: Record<string, any>[];
}

// ─────────────────── HELPERS ───────────────────

function normalizeTeamName(name: string): string {
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

async function safeGet(collection: string, docId: string): Promise<Record<string, any> | null> {
    try {
        const doc = await db.collection(collection).doc(docId).get();
        return doc.exists ? (doc.data() as Record<string, any>) : null;
    } catch (e: any) {
        logger.warn(`[Enrichment] ${collection}/${docId} fetch error: ${e.message}`);
        return null;
    }
}

async function queryByField(
    collection: string,
    field: string,
    value: any,
    limit = 10
): Promise<Record<string, any>[]> {
    try {
        const snap = await db.collection(collection)
            .where(field, '==', value)
            .limit(limit)
            .get();
        return snap.docs.map(d => ({ id: d.id, ...d.data() }));
    } catch (e: any) {
        logger.warn(`[Enrichment] ${collection} query error: ${e.message}`);
        return [];
    }
}

// ─────────────────── TEAM DATA ───────────────────

async function fetchTeamData(teamName: string): Promise<Record<string, any> | null> {
    const slug = normalizeTeamName(teamName);

    // Try slug-based lookup first
    let data = await safeGet('teams', slug);
    if (data) return data;

    // Try query by name
    const results = await queryByField('teams', 'slug', slug, 1);
    if (results.length > 0) return results[0];

    // Try partial name match
    const nameResults = await queryByField('teams', 'name', teamName, 1);
    if (nameResults.length > 0) return nameResults[0];

    logger.info(`[Enrichment] Team not found: ${teamName} (slug: ${slug})`);
    return null;
}

// ─────────────────── PLAYER DATA ───────────────────

async function fetchKeyPlayers(teamSlug: string, limit = 5): Promise<Record<string, any>[]> {
    try {
        const snap = await db.collection('players')
            .where('team', '==', teamSlug)
            .limit(limit)
            .get();
        return snap.docs.map(d => {
            const data = d.data();
            // Return only essential fields to keep token count manageable
            return {
                name: data.name,
                position: data.position,
                number: data.number,
                nationality: data.nationality,
                marketValue: data.marketValue,
                contractUntil: data.contractUntil,
                weeklyWage: data.weeklyWage,
                scouting: data.scouting || null,
                seasonStats: data.seasonStats || null,
            };
        });
    } catch (e: any) {
        logger.warn(`[Enrichment] Players query for ${teamSlug} error: ${e.message}`);
        return [];
    }
}

// ─────────────────── MANAGER DATA ───────────────────

async function fetchManagerData(teamSlug: string): Promise<Record<string, any> | null> {
    try {
        const snap = await db.collection('managers')
            .where('currentTeam', '==', teamSlug)
            .limit(1)
            .get();

        if (snap.empty) return null;
        const data = snap.docs[0].data();
        return {
            name: data.name,
            nationality: data.nationality,
            currentStats: data.currentStats || null,
            preferredFormation: data.preferredFormation || null,
            careerHistory: (data.careerHistory || []).slice(0, 5),
        };
    } catch (e: any) {
        logger.warn(`[Enrichment] Manager for ${teamSlug} error: ${e.message}`);
        return null;
    }
}

// ─────────────────── REFEREE DATA ───────────────────

async function fetchRefereeData(refereeName: string): Promise<Record<string, any> | null> {
    if (!refereeName || refereeName === 'Bilinmiyor') return null;
    const slug = normalizeTeamName(refereeName);

    let data = await safeGet('referees', slug);
    if (data) return data;

    const results = await queryByField('referees', 'name', refereeName, 1);
    return results.length > 0 ? results[0] : null;
}

// ─────────────────── LEAGUE DATA ───────────────────

async function fetchLeagueData(leagueName: string): Promise<Record<string, any> | null> {
    const slug = normalizeTeamName(leagueName);

    let data = await safeGet('leagues', slug);
    if (data) return data;

    // Try common alternatives
    const altSlugs = [
        slug,
        slug.replace('-league', ''),
        `${slug}-2025-26`,
    ];

    for (const alt of altSlugs) {
        data = await safeGet('leagues', alt);
        if (data) return data;
    }

    const results = await queryByField('leagues', 'name', leagueName, 1);
    return results.length > 0 ? results[0] : null;
}

// ─────────────────── NEWS DATA ───────────────────

async function fetchRelatedNews(
    homeTeamSlug: string,
    awayTeamSlug: string,
    daysBack = 7,
    limit = 5
): Promise<Record<string, any>[]> {
    try {
        const cutoff = new Date();
        cutoff.setDate(cutoff.getDate() - daysBack);

        const homeNews = await db.collection('news')
            .where('relatedTeam', '==', homeTeamSlug)
            .where('date', '>=', cutoff.toISOString())
            .orderBy('date', 'desc')
            .limit(limit)
            .get();

        const awayNews = await db.collection('news')
            .where('relatedTeam', '==', awayTeamSlug)
            .where('date', '>=', cutoff.toISOString())
            .orderBy('date', 'desc')
            .limit(limit)
            .get();

        const allNews: Record<string, any>[] = [
            ...homeNews.docs.map(d => ({ team: homeTeamSlug, ...d.data() } as Record<string, any>)),
            ...awayNews.docs.map(d => ({ team: awayTeamSlug, ...d.data() } as Record<string, any>)),
        ];

        // Return only essential fields
        return allNews.map(n => ({
            title: n.title,
            summary: n.summary,
            date: n.date,
            source: n.source,
            team: n.team,
        })).slice(0, limit * 2);
    } catch (e: any) {
        logger.warn(`[Enrichment] News query error: ${e.message}`);
        return [];
    }
}

// ─────────────────── MAIN ENRICHMENT ───────────────────

/**
 * Tüm scraper koleksiyonlarından maçla ilgili zengin veri çeker.
 * Pipeline'dan erken aşamada çağrılır ve AI prompt'larına eklenir.
 */
export async function enrichMatchData(
    matchData: Record<string, any>
): Promise<EnrichedMatchData> {
    const homeTeamName = matchData.homeTeam?.name || matchData.homeTeam || '';
    const awayTeamName = matchData.awayTeam?.name || matchData.awayTeam || '';
    const league = matchData.league || matchData.competition || '';
    const refereeName = matchData.referee?.name || matchData.referee || '';

    const homeSlug = normalizeTeamName(homeTeamName);
    const awaySlug = normalizeTeamName(awayTeamName);

    logger.info(`[Enrichment] Fetching data for: ${homeTeamName} vs ${awayTeamName} (${league})`);

    // Fetch all data in parallel for speed
    const [
        homeTeamData,
        awayTeamData,
        homeKeyPlayers,
        awayKeyPlayers,
        homeManagerData,
        awayManagerData,
        refereeData,
        leagueData,
        relatedNews,
    ] = await Promise.all([
        fetchTeamData(homeTeamName),
        fetchTeamData(awayTeamName),
        fetchKeyPlayers(homeSlug),
        fetchKeyPlayers(awaySlug),
        fetchManagerData(homeSlug),
        fetchManagerData(awaySlug),
        fetchRefereeData(refereeName),
        fetchLeagueData(league),
        fetchRelatedNews(homeSlug, awaySlug),
    ]);

    const found = [
        homeTeamData && 'homeTeam',
        awayTeamData && 'awayTeam',
        homeKeyPlayers.length && 'homePlayers',
        awayKeyPlayers.length && 'awayPlayers',
        homeManagerData && 'homeManager',
        awayManagerData && 'awayManager',
        refereeData && 'referee',
        leagueData && 'league',
        relatedNews.length && 'news',
    ].filter(Boolean);

    logger.info(`[Enrichment] Found data for: ${found.join(', ') || 'none'}`);

    return {
        homeTeamData,
        awayTeamData,
        homeKeyPlayers,
        awayKeyPlayers,
        homeManagerData,
        awayManagerData,
        refereeData,
        leagueData,
        relatedNews,
    };
}

/**
 * Enriched data'yı AI prompt'una eklenecek metin formatına dönüştürür
 */
export function formatEnrichmentForPrompt(enrichment: EnrichedMatchData): string {
    const sections: string[] = [];

    // Team data
    if (enrichment.homeTeamData) {
        const t = enrichment.homeTeamData;
        sections.push(`
═══ EV SAHİBİ TAKIM VERİLERİ (Scraper) ═══
Kadro Büyüklüğü: ${t.squad?.length || '?'} oyuncu
Kadro Toplam Değeri: €${(t.totalSquadValue || 0).toLocaleString()}
Ortalama Yaş: ${t.averageAge || '?'}
Son Form: ${(t.recentForm || []).join('')}
Sakatlar: ${(t.injuries || []).map((i: any) => `${i.player} (${i.type}, dönüş: ${i.expectedReturn})`).join(', ') || 'Yok'}
Cezalılar: ${(t.suspended || []).map((s: any) => `${s.player} (${s.reason})`).join(', ') || 'Yok'}
Transfer Söylentileri: ${(t.transferRumors || []).map((r: any) => `${r.player} (${r.type})`).join(', ') || 'Yok'}
Son Transferler: Gelen: ${(t.transfers?.in || []).map((x: any) => `${x.player} (€${x.fee?.toLocaleString()})`).join(', ') || 'Yok'} | Giden: ${(t.transfers?.out || []).map((x: any) => `${x.player} (€${x.fee?.toLocaleString()})`).join(', ') || 'Yok'}
Kontratı Bitenler: ${(t.squad || []).filter((p: any) => p.contractUntil && new Date(p.contractUntil) < new Date('2026-07-01')).map((p: any) => p.name).join(', ') || 'Yok'}
Sezon İstatistikleri: ${JSON.stringify(t.seasonStats || {}, null, 0).substring(0, 500)}`);
    }

    if (enrichment.awayTeamData) {
        const t = enrichment.awayTeamData;
        sections.push(`
═══ DEPLASMAN TAKIM VERİLERİ (Scraper) ═══
Kadro Büyüklüğü: ${t.squad?.length || '?'} oyuncu
Kadro Toplam Değeri: €${(t.totalSquadValue || 0).toLocaleString()}
Ortalama Yaş: ${t.averageAge || '?'}
Son Form: ${(t.recentForm || []).join('')}
Sakatlar: ${(t.injuries || []).map((i: any) => `${i.player} (${i.type}, dönüş: ${i.expectedReturn})`).join(', ') || 'Yok'}
Cezalılar: ${(t.suspended || []).map((s: any) => `${s.player} (${s.reason})`).join(', ') || 'Yok'}
Transfer Söylentileri: ${(t.transferRumors || []).map((r: any) => `${r.player} (${r.type})`).join(', ') || 'Yok'}
Son Transferler: Gelen: ${(t.transfers?.in || []).map((x: any) => `${x.player} (€${x.fee?.toLocaleString()})`).join(', ') || 'Yok'} | Giden: ${(t.transfers?.out || []).map((x: any) => `${x.player} (€${x.fee?.toLocaleString()})`).join(', ') || 'Yok'}
Sezon İstatistikleri: ${JSON.stringify(t.seasonStats || {}, null, 0).substring(0, 500)}`);
    }

    // Key Players with scouting data
    if (enrichment.homeKeyPlayers.length > 0) {
        sections.push(`
═══ EV SAHİBİ KİLİT OYUNCULAR (Scouting) ═══
${enrichment.homeKeyPlayers.map(p => {
            const scouting = p.scouting?.percentiles || {};
            const stats = Object.values(p.seasonStats || {})[0] as any || {};
            return `• ${p.name} (${p.position}) — Değer: €${(p.marketValue || 0).toLocaleString()}
  Sezon: ${stats.goals || 0}G ${stats.assists || 0}A ${stats.matches || 0}M, Rating: ${stats.rating || '?'}
  Scouting: Gol/90: %${scouting.goalsP90 || '?'}, xG/90: %${scouting.xGP90 || '?'}, Asist/90: %${scouting.assistsP90 || '?'}, Pressing/90: %${scouting.pressuresP90 || '?'}`;
        }).join('\n')}`);
    }

    if (enrichment.awayKeyPlayers.length > 0) {
        sections.push(`
═══ DEPLASMAN KİLİT OYUNCULAR (Scouting) ═══
${enrichment.awayKeyPlayers.map(p => {
            const scouting = p.scouting?.percentiles || {};
            const stats = Object.values(p.seasonStats || {})[0] as any || {};
            return `• ${p.name} (${p.position}) — Değer: €${(p.marketValue || 0).toLocaleString()}
  Sezon: ${stats.goals || 0}G ${stats.assists || 0}A ${stats.matches || 0}M, Rating: ${stats.rating || '?'}
  Scouting: Gol/90: %${scouting.goalsP90 || '?'}, xG/90: %${scouting.xGP90 || '?'}, Asist/90: %${scouting.assistsP90 || '?'}, Pressing/90: %${scouting.pressuresP90 || '?'}`;
        }).join('\n')}`);
    }

    // Manager data
    if (enrichment.homeManagerData) {
        const m = enrichment.homeManagerData;
        const s = m.currentStats || {};
        sections.push(`
═══ EV SAHİBİ TEKNİK DİREKTÖR ═══
${m.name} (${m.nationality})
Tercih Edilen Formasyon: ${m.preferredFormation || '?'}
Bu Sezon: ${s.matches || 0} maç, ${s.wins || 0}G ${s.draws || 0}B ${s.losses || 0}M (Oran: %${s.winRate || 0})
Gol Ortalaması: Atılan ${s.avgGoalsFor || '?'} - Yenilen ${s.avgGoalsAgainst || '?'}
Kariyer: ${(m.careerHistory || []).map((c: any) => `${c.team} (%${c.winRate})`).join(' → ')}`);
    }

    if (enrichment.awayManagerData) {
        const m = enrichment.awayManagerData;
        const s = m.currentStats || {};
        sections.push(`
═══ DEPLASMAN TEKNİK DİREKTÖR ═══
${m.name} (${m.nationality})
Tercih Edilen Formasyon: ${m.preferredFormation || '?'}
Bu Sezon: ${s.matches || 0} maç, ${s.wins || 0}G ${s.draws || 0}B ${s.losses || 0}M (Oran: %${s.winRate || 0})
Gol Ortalaması: Atılan ${s.avgGoalsFor || '?'} - Yenilen ${s.avgGoalsAgainst || '?'}
Kariyer: ${(m.careerHistory || []).map((c: any) => `${c.team} (%${c.winRate})`).join(' → ')}`);
    }

    // Referee real data
    if (enrichment.refereeData) {
        const r = enrichment.refereeData;
        const s = r.seasonStats || {};
        sections.push(`
═══ HAKEM VERİLERİ (Gerçek Stats) ═══
${r.name} (${r.nationality || '?'})
Bu Sezon: ${s.matches || 0} maç
Ortalama Faul: ${s.avgFouls || '?'} | Ortalama Kart: ${s.avgCards || '?'}
Ortalama Sarı: ${s.avgYellowCards || '?'} | Ortalama Kırmızı: ${s.avgRedCards || '?'}
Verilen Penaltı: ${s.penaltiesGiven || '?'}
Son Maçlar: ${(r.recentMatches || []).slice(0, 3).map((m: any) => `${m.teams} (${m.cards} kart)`).join(', ')}`);
    }

    // League standings context
    if (enrichment.leagueData) {
        const l = enrichment.leagueData;
        const standings = l.standings?.total || [];
        if (standings.length > 0) {
            sections.push(`
═══ LİG PUAN TABLOSU BAĞLAMI ═══
${l.name} — ${l.season}
İlk 5: ${standings.slice(0, 5).map((t: any) => `${t.rank}. ${t.team} (${t.points}p)`).join(' | ')}
Gol Krallığı: ${(l.topScorers || []).slice(0, 3).map((p: any) => `${p.player} (${p.goals}G)`).join(', ')}
Asist Krallığı: ${(l.topAssists || []).slice(0, 3).map((p: any) => `${p.player} (${p.assists}A)`).join(', ')}`);
        }
    }

    // Related news
    if (enrichment.relatedNews.length > 0) {
        sections.push(`
═══ İLGİLİ HABERLER (Son 7 Gün) ═══
${enrichment.relatedNews.map(n => `• [${n.team}] ${n.title} (${n.date}) — ${n.summary || ''}`.substring(0, 200)).join('\n')}`);
    }

    return sections.join('\n');
}
