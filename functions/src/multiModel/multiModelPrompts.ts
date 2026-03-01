/**
 * Multi-Model Prompt Builders
 * Deep analysis çıktılarını zengin şekilde Gemini ve Claude'a iletir.
 */

export function buildInitialPrompt(
  md: Record<string, any>,
  deepAnalysis: Record<string, any>,
  targetModel: string
): string {
  const homeTeam = md.homeTeam?.name || md.homeTeam || 'Ev Sahibi';
  const awayTeam = md.awayTeam?.name || md.awayTeam || 'Deplasman';
  const league = md.league || md.competition || md.leagueName || 'Süper Lig';
  const matchDate = md.matchDate || md.date || 'Bilinmiyor';
  const odds = md.odds || {};

  // Scraper enrichment text (teams, players, managers, referees, league, news)
  const enrichmentText = md._enrichmentText || '';

  // Deep analysis modül özetlerini birleştir
  const modulesSummary = Object.entries(deepAnalysis)
    .map(([key, result]: [string, any]) => {
      const name = {
        weather: '🌤 Hava Durumu',
        missingPlayers: '🏥 Eksik Oyuncular',
        homeAwayForm: '📊 Ev/Deplasman Formu',
        h2h: '⚔️ Kafa Kafaya Geçmiş',
        xg: '📈 xG Analizi',
        setPieces: '🎯 Duran Toplar',
        referee: '👨‍⚖️ Hakem Etkisi',
        tactics: '🧩 Taktik Analiz',
      }[key] || key;

      const confidence = result.confidence || 0;
      const summary = result.summary || 'Veri bulunamadı.';
      const analysis = result.analysis || {};

      // Her modülün detaylı JSON verisini de dahil et
      return `### ${name} (Güven: ${confidence}/10)
Özet: ${summary}
Detay: ${JSON.stringify(analysis, null, 0).substring(0, 2000)}`;
    })
    .join('\n\n');

  return `Sen uzman bir futbol veri bilimci ve taktik analistisin. Deneyimli bir bahis analistisinsin.
Bu analizi ${targetModel} perspektifinden yapıyorsun.

═══════════════════════════════════════════
MAÇ BİLGİLERİ
═══════════════════════════════════════════
Ev Sahibi: ${homeTeam}
Deplasman: ${awayTeam}
Lig: ${league}
Maç Tarihi: ${matchDate}
${odds.home ? `Bahis Oranları: Ev ${odds.home} / Berab ${odds.draw} / Dep ${odds.away}` : 'Bahis oranları mevcut değil.'}
${enrichmentText ? `
═══════════════════════════════════════════
SCRAPER VERİLERİ (Gerçek Veriler)
═══════════════════════════════════════════
Aşağıdaki veriler 3 kaynaktan (FBref, SofaScore, Transfermarkt) canlı olarak çekilmiştir.
Bu verilere yüksek güven ile yaklaş — bunlar gerçek istatistiktir, tahmin değil.

${enrichmentText}` : ''}

═══════════════════════════════════════════
DERİN ANALİZ SONUÇLARI (8 MODÜL)
═══════════════════════════════════════════
Aşağıdaki 8 modül, maç öncesi bağımsız olarak analiz edildi.
Her modülün güven skoru, o veriye ne kadar güvenildiğini gösterir.

${modulesSummary}

═══════════════════════════════════════════
GÖREV
═══════════════════════════════════════════
Yukarıdaki 8 modülün detaylı çıktılarını sentezle.
Her modülün güven skorunu dikkate al — düşük güvenli modüllere az ağırlık ver.
Maçın nasıl geçeceğine dair kapsamlı bir analiz ve tahmin oluştur.

YANITI SADECE aşağıdaki JSON formatında ver (başka metin ekleme):

{
  "homeWinProbability": number (0-100),
  "drawProbability": number (0-100),
  "awayWinProbability": number (0-100),
  "over25Probability": number (0-100),
  "under25Probability": number (0-100),
  "bttsProbability": number (0-100),
  "predictedScore": "X-Y",
  "topPredictions": [
    "Tahmin 1 (ör: Maç Sonucu 1)",
    "Tahmin 2 (ör: Karşılıklı Gol Var)",
    "Tahmin 3 (ör: Üst 2.5 Gol)"
  ],
  "keyFactors": [
    "Faktör 1 — en belirleyici etken",
    "Faktör 2",
    "Faktör 3",
    "Faktör 4",
    "Faktör 5"
  ],
  "gameNarrative": "Maçın nasıl geçeceğine dair taktiksel ve istatistiksel hikaye. Minimum 200 kelime. Her modülün önemli bulgularını sentezle. İlk yarı ve ikinci yarı ayrı ayrı değerlendir.",
  "confidenceScore": number (1-10)
}`;
}

export function buildConsensusPrompt(geminiText: string, claudeText: string): string {
  return `Sen baş analist ve hakemsin. Ekibindeki iki uzman analist (Gemini ve Claude) aynı maçı derin analiz modülleri ile inceledi ve bağımsız tahminlerini oluşturdu.

═══════════════════════════════════════════
GEMİNİ 3.1 PRO PREVIEW ANALİZİ:
═══════════════════════════════════════════
${geminiText}

═══════════════════════════════════════════
CLAUDE OPUS 4.6 ANALİZİ:
═══════════════════════════════════════════
${claudeText}

═══════════════════════════════════════════
GÖREV: KONSENSÜS OLUŞTUR
═══════════════════════════════════════════
1. İki modelin ortaklaştığı ve ayrıştığı noktaları analiz et.
2. Her iki modelin güven skorlarını dikkate al — daha güvenli model daha fazla ağırlık alsın.
3. Olasılıkları mantıksal tutarlılıkla birleştir (toplamlar %100 olmalı).
4. En güvenilir nihai tahmini oluştur.

SADECE aşağıdaki JSON formatında yanıtla:

{
  "homeWinProbability": number (0-100),
  "drawProbability": number (0-100),
  "awayWinProbability": number (0-100),
  "over25Probability": number (0-100),
  "under25Probability": number (0-100),
  "bttsProbability": number (0-100),
  "predictedScore": "X-Y",
  "topPredictions": ["Tahmin1", "Tahmin2", "Tahmin3"],
  "keyFactors": ["Faktör1", "Faktör2", "Faktör3", "Faktör4", "Faktör5"],
  "gameNarrative": "İki analistin görüşlerini sentezleyen kapsamlı bir maç hikayesi. Hemfikir oldukları noktaları vurgula, farklı düşündükleri yerlerde hangisinin daha güçlü argümanı olduğunu belirt. Minimum 250 kelime.",
  "consensusReasoning": "İki analistin neden bu sonuca vardığını, hemfikir ve ayrışma noktalarını detaylıca açıkla.",
  "confidenceScore": number (1-10)
}`;
}
