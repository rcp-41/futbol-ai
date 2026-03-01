/**
 * buildChatPrompt — Enhanced chat system prompt with full match context
 * Includes scraper data (FBref, SofaScore, Understat) and team statistics
 */
export function buildChatPrompt(
    matchData: Record<string, any>,
    analysisJson: string
): string {
    const homeTeam = matchData.homeTeam?.name || 'Ev Sahibi';
    const awayTeam = matchData.awayTeam?.name || 'Deplasman';
    const league = matchData.league || 'Bilinmiyor';
    const leagueCountry = matchData.leagueCountry || '';

    let matchDate = '';
    let season = '';
    if (matchData.matchDate?.toDate) {
        const d = matchData.matchDate.toDate();
        matchDate = d.toISOString();
        const year = d.getFullYear();
        const month = d.getMonth();
        season = month >= 7 ? `${year}-${year + 1}` : `${year - 1}-${year}`;
    } else if (matchData.meta?.date) {
        matchDate = `${matchData.meta.date} ${matchData.meta.time || ''}`;
        season = matchData.meta?.season || '';
    } else {
        matchDate = matchData.matchDate || '';
    }

    const week = matchData.week || matchData.meta?.round || '';
    const stadium = matchData.stadium || matchData.meta?.stadium || matchData.venue || 'Bilinmiyor';

    // Form data
    const homeForm = matchData.homeTeam?.formLast5 || matchData.sofascore?.h2h?.homeForm || 'Bilgi yok';
    const awayForm = matchData.awayTeam?.formLast5 || matchData.sofascore?.h2h?.awayForm || 'Bilgi yok';

    // Odds
    const homeOdds = matchData.odds?.home || matchData.sofascore?.odds?.home || '-';
    const drawOdds = matchData.odds?.draw || matchData.sofascore?.odds?.draw || '-';
    const awayOdds = matchData.odds?.away || matchData.sofascore?.odds?.away || '-';

    // ═══ Compile detailed offline data ═══
    const detailedStats: string[] = [];

    // FBref data
    if (matchData.fbref) {
        detailedStats.push('═══ FBREF İSTATİSTİKLERİ ═══');
        if (matchData.fbref.teamStats) {
            const h = matchData.fbref.teamStats.home || {};
            const a = matchData.fbref.teamStats.away || {};
            detailedStats.push(`Ev Sahibi — Topla Oynama: ${h.possession ?? '-'}%, Şut: ${h.shots ?? '-'}, İsabetli Şut: ${h.shotsOnTarget ?? '-'}, xG: ${h.xG ?? '-'}, Pas: ${h.passes ?? '-'}, Pas İsabeti: ${h.passAccuracy ?? '-'}%, Faul: ${h.fouls ?? '-'}, Korner: ${h.corners ?? '-'}`);
            detailedStats.push(`Deplasman — Topla Oynama: ${a.possession ?? '-'}%, Şut: ${a.shots ?? '-'}, İsabetli Şut: ${a.shotsOnTarget ?? '-'}, xG: ${a.xG ?? '-'}, Pas: ${a.passes ?? '-'}, Pas İsabeti: ${a.passAccuracy ?? '-'}%, Faul: ${a.fouls ?? '-'}, Korner: ${a.corners ?? '-'}`);
        }
        if (matchData.fbref.formations) {
            detailedStats.push(`Dizilişler — Ev: ${matchData.fbref.formations.home || '-'}, Dep: ${matchData.fbref.formations.away || '-'}`);
        }
        if (matchData.fbref.playerStats) {
            // Top performers
            const homePlayers = matchData.fbref.playerStats.home || [];
            const awayPlayers = matchData.fbref.playerStats.away || [];
            if (homePlayers.length > 0) {
                const topHome = homePlayers.slice(0, 5).map((p: any) =>
                    `${p.player} (${p.position}, ${p.minutes}dk, ${p.goals}G ${p.assists}A, xG:${p.xG ?? '-'})`
                ).join(', ');
                detailedStats.push(`Ev Kadro (ilk 5): ${topHome}`);
            }
            if (awayPlayers.length > 0) {
                const topAway = awayPlayers.slice(0, 5).map((p: any) =>
                    `${p.player} (${p.position}, ${p.minutes}dk, ${p.goals}G ${p.assists}A, xG:${p.xG ?? '-'})`
                ).join(', ');
                detailedStats.push(`Dep Kadro (ilk 5): ${topAway}`);
            }
        }
        if (matchData.fbref.passTypes) {
            const hp = matchData.fbref.passTypes.home || {};
            const ap = matchData.fbref.passTypes.away || {};
            detailedStats.push(`Pas Türleri — Ev: Kısa=${hp.short ?? '-'}, Orta=${hp.medium ?? '-'}, Uzun=${hp.long ?? '-'}, İleriye=${hp.progressive ?? '-'}`);
            detailedStats.push(`Pas Türleri — Dep: Kısa=${ap.short ?? '-'}, Orta=${ap.medium ?? '-'}, Uzun=${ap.long ?? '-'}, İleriye=${ap.progressive ?? '-'}`);
        }
    }

    // SofaScore data
    if (matchData.sofascore) {
        detailedStats.push('\n═══ SOFASCORE VERİLERİ ═══');
        if (matchData.sofascore.odds) {
            const o = matchData.sofascore.odds;
            detailedStats.push(`Oranlar — 1: ${o.home ?? '-'}, X: ${o.draw ?? '-'}, 2: ${o.away ?? '-'}, Üst 2.5: ${o.over25 ?? '-'}, Alt 2.5: ${o.under25 ?? '-'}`);
        }
        if (matchData.sofascore.h2h) {
            const h2h = matchData.sofascore.h2h;
            detailedStats.push(`H2H — Ev Galibiyet: ${h2h.homeWins ?? '-'}, Beraberlik: ${h2h.draws ?? '-'}, Dep Galibiyet: ${h2h.awayWins ?? '-'}`);
        }
        if (matchData.sofascore.lineups) {
            const hl = matchData.sofascore.lineups.home || {};
            const al = matchData.sofascore.lineups.away || {};
            detailedStats.push(`Diziliş — Ev: ${hl.formation || '-'}, Dep: ${al.formation || '-'}`);
        }
        if (matchData.sofascore.statistics) {
            detailedStats.push(`Detaylı İstatistikler: ${JSON.stringify(matchData.sofascore.statistics)}`);
        }
    }

    // Understat data
    if (matchData.understat) {
        detailedStats.push('\n═══ UNDERSTAT xG VERİLERİ ═══');
        detailedStats.push(`xG — Ev: ${matchData.understat.homeXg ?? '-'}, Dep: ${matchData.understat.awayXg ?? '-'}`);
    }

    // Weather data
    if (matchData.weather) {
        const w = matchData.weather;
        detailedStats.push('\n═══ HAVA DURUMU ═══');
        detailedStats.push(`Sıcaklık: ${w.temperature ?? '-'}°C, Nem: ${w.humidity ?? '-'}%, Rüzgar: ${w.windSpeed ?? '-'} km/s, Basınç: ${w.pressure ?? '-'} hPa`);
    }

    const offlineDataBlock = detailedStats.length > 0
        ? detailedStats.join('\n')
        : 'Bu maç için çevrimdışı istatistik verisi bulunamadı.';

    return `SEN: Elit seviyede bir futbol analisti ve veri bilimcisisin. 15 yıllık profesyonel futbol analiz deneyimine sahipsin. Kullanıcıyla BU MAÇ hakkında sohbet ediyorsun.

═══════════════════════════════════════
MAÇ BİLGİSİ:
═══════════════════════════════════════
- Ev Sahibi: ${homeTeam}
- Deplasman: ${awayTeam}
- Lig: ${league} (${leagueCountry})
- Sezon: ${season}
- Tarih/Saat: ${matchDate}
- Hafta/Tur: ${week}
- Stadyum: ${stadium}
- Bahis Oranları: 1=${homeOdds} / X=${drawOdds} / 2=${awayOdds}
- Ev Sahibi Form: ${homeForm}
- Deplasman Form: ${awayForm}

═══════════════════════════════════════
MAÇ İSTATİSTİKLERİ (ÇEVRİMDIŞI VERİ):
═══════════════════════════════════════
${offlineDataBlock}

═══════════════════════════════════════
YAPILMIŞ ANALİZ:
═══════════════════════════════════════
${analysisJson}

═══════════════════════════════════════
SOHBET KURALLARI:
═══════════════════════════════════════
1. SADECE ${homeTeam} vs ${awayTeam} maçı hakkında konuş. Başka maç/konu sorulursa: "Bu sohbet sadece ${homeTeam} vs ${awayTeam} maçı hakkındadır." de.
2. Cevaplarını yukarıdaki İSTATİSTİK VERİLERİNE ve ANALİZ SONUÇLARINA dayandır.
3. İnternet aramasını SADECE bu maçla doğrudan ilgili, ${season} sezonu kapsamındaki bilgileri TEYIT etmek için kullan.
4. İNTERNETTEN ELDE ETTİĞİN BİLGİLERDE DİKKATLİ OL: Transfer olmuş oyuncuları, eski kadro bilgilerini veya farklı sezonlara ait verileri KULLANMA.
5. Geçerli kontrol tarihi: ${matchDate}. Bu tarihten SONRAKİ bilgileri kullanma.
6. Kısa, net, veri destekli cevaplar ver. İstatistiklere atıfta bulun.
7. Tahminini değiştirecek güçlü bir argüman sunulursa esnek ol.
8. Bahis tavsiyesi verme, sadece analiz yap.
9. Türkçe yanıt ver.
10. Her cevabında mümkünse yukarıdaki verilere sayısal referans ver (xG, topla oynama %, pas isabet oranı vb.).`;
}
