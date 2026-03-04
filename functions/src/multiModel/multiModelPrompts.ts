/**
 * Multi-Channel Prompt Builders
 * Şemaya göre 5 ayrı prompt: 3 kanal + 2 sentezci + 1 hakem
 */

// ═══════════════════════════════════════════════════════════
// KANAL 1: Gemini — Korelasyon Yorumu
// ═══════════════════════════════════════════════════════════

export function buildCorrelationInterpretPrompt(
  matchInfo: MatchInfo,
  correlationText: string
): string {
  return `Sen veri bilimci ve istatistik uzmanısın. Görevin korelasyon tespiti değil — korelasyon YORUMU.

═══════════════════════════════════════════
MAÇ BİLGİLERİ
═══════════════════════════════════════════
Ev Sahibi: ${matchInfo.homeTeam}
Deplasman: ${matchInfo.awayTeam}
Lig: ${matchInfo.league}
Maç Tarihi: ${matchInfo.matchDate}
${matchInfo.odds ? `Bahis Oranları: Ev ${matchInfo.odds.home} / Berab ${matchInfo.odds.draw} / Dep ${matchInfo.odds.away}` : ''}

═══════════════════════════════════════════
MATEMATİKSEL KORELASYON BULGULARI
═══════════════════════════════════════════
Aşağıdaki bulgular Spearman korelasyon analizi ile bu sezonun TÜM maçlarından
otomatik olarak taranmıştır. Bunlar istatistiksel olarak kanıtlanmış ilişkilerdir.

${correlationText}

═══════════════════════════════════════════
GÖREV
═══════════════════════════════════════════
Bu korelasyonları YORUMLA:
1. Her yüksek güvenli korelasyonun bu maçta ne anlama geldiğini açıkla.
2. Korelasyonlar arasındaki çelişkileri tespit et.
3. Bu korelasyonlara dayanarak maçın nasıl şekillenebileceğini tahmin et.
4. Korelasyonların güvenilirliğini değerlendir (örneklem büyüklüğü, etki gücü).

SADECE JSON formatında yanıt ver:

{
    "correlationInsights": [
        { "finding": "string", "matchImpact": "string", "confidence": "high/medium/low" }
    ],
    "contradictions": ["string"],
    "matchPrediction": {
        "favoredTeam": "home/away/neutral",
        "expectedGoals": number,
        "keyRisk": "string"
    },
    "overallNarrative": "Korelasyonlara dayalı kapsamlı yorum (min 150 kelime)",
    "confidenceScore": number (1-10)
}`;
}

// ═══════════════════════════════════════════════════════════
// KANAL 2A: GPT — İstatistik + Taktik Uzmanı
// ═══════════════════════════════════════════════════════════

export function buildStatsTacticsPrompt(
  matchInfo: MatchInfo,
  enrichmentText: string
): string {
  return `Sen taktik analist ve istatistik uzmanısın. SADECE sayısal veriler ve taktiksel yapıyı analiz et.
Hakem, hava durumu, sakatlar SENIN GÖREVİN DEĞİL — sadece istatistik ve taktik.

═══════════════════════════════════════════
MAÇ BİLGİLERİ
═══════════════════════════════════════════
Ev Sahibi: ${matchInfo.homeTeam}
Deplasman: ${matchInfo.awayTeam}
Lig: ${matchInfo.league}
Maç Tarihi: ${matchInfo.matchDate}
${matchInfo.odds ? `Bahis Oranları: Ev ${matchInfo.odds.home} / Berab ${matchInfo.odds.draw} / Dep ${matchInfo.odds.away}` : ''}

═══════════════════════════════════════════
SCRAPER VERİLERİ (İSTATİSTİK + TAKTİK)
═══════════════════════════════════════════
${enrichmentText}

═══════════════════════════════════════════
GÖREV — İSTATİSTİK + TAKTİK ANALİZİ
═══════════════════════════════════════════
Aşağıdaki konulara ODAKLAN:
1. xG analizi: İki takımın beklenen gol performansı, overperformance/underperformance
2. Topa sahip olma ve pas kalitesi: Possession, pas isabeti, progresif pas, uzun top
3. Formasyon ve taktik eşleşme: Hangi formasyon üstünlük sağlar?
4. Şut kalitesi ve verimliliği: İsabetli şut oranı, büyük şans sayısı
5. Pressing yoğunluğu (PPDA): Kim daha yüksek tempo oynuyor?
6. Ev/deplasman performans farkı
7. Son 5 maç formu ve trend analizi

SADECE JSON formatında yanıt ver:

{
    "xGAnalysis": {
        "homeXG": number, "awayXG": number,
        "homeOverperformance": number, "awayOverperformance": number,
        "insight": "string"
    },
    "possessionBattle": {
        "expectedPossession": { "home": number, "away": number },
        "passQualityAdvantage": "home/away",
        "insight": "string"
    },
    "tacticalMatchup": {
        "homeFormation": "string", "awayFormation": "string",
        "advantage": "home/away/balanced",
        "keyBattleZone": "string",
        "insight": "string"
    },
    "formTrend": {
        "homeForm": "improving/stable/declining",
        "awayForm": "improving/stable/declining",
        "insight": "string"
    },
    "prediction": {
        "homeWinProbability": number,
        "drawProbability": number,
        "awayWinProbability": number,
        "predictedScore": "X-Y",
        "over25Probability": number,
        "bttsProbability": number
    },
    "keyFactors": ["string", "string", "string"],
    "narrative": "İstatistik ve taktik bazlı kapsamlı analiz (min 200 kelime)",
    "confidenceScore": number (1-10)
}`;
}

// ═══════════════════════════════════════════════════════════
// KANAL 2B: GPT — Hakem + Kaos Uzmanı
// ═══════════════════════════════════════════════════════════

export function buildRefereeChaosPrompt(
  matchInfo: MatchInfo,
  enrichmentText: string
): string {
  return `Sen risk analisti ve kaos uzmanısın. SADECE dışsal faktörleri ve belirsizlikleri analiz et.
İstatistik ve taktik SENIN GÖREVİN DEĞİL — sadece kaos, risk ve dışsal etkenler.

═══════════════════════════════════════════
MAÇ BİLGİLERİ
═══════════════════════════════════════════
Ev Sahibi: ${matchInfo.homeTeam}
Deplasman: ${matchInfo.awayTeam}
Lig: ${matchInfo.league}
Maç Tarihi: ${matchInfo.matchDate}
${matchInfo.odds ? `Bahis Oranları: Ev ${matchInfo.odds.home} / Berab ${matchInfo.odds.draw} / Dep ${matchInfo.odds.away}` : ''}

═══════════════════════════════════════════
SCRAPER VERİLERİ (RİSK FAKTÖRLERİ)
═══════════════════════════════════════════
${enrichmentText}

═══════════════════════════════════════════
GÖREV — HAKEM + KAOS ANALİZİ
═══════════════════════════════════════════
Aşağıdaki konulara ODAKLAN:
1. Hakem profili: Kart eğilimi, penaltı verme oranı, VAR müdahale sıklığı, ev sahibi yanlılığı
2. Sakatlar ve cezalılar: Kilit oyuncu eksiklikleri, yerine kim oynar, performans farkı
3. Hava durumu etkisi: Sıcaklık/rüzgar/yağış oyun planını nasıl etkiler?
4. Maç önemi ve motivasyon: Küme düşme/şampiyonluk baskısı, psikolojik durum
5. Fikstür yoğunluğu: Takımların dinlenme süresi, kaç gün arayla maç?
6. Transfer penceresi etkisi: Yeni gelenler/gidenler, kadro morali
7. H2H psikolojisi: Geçmiş karşılaşmalardaki gerginlik, kırmızı kart geçmişi

SADECE JSON formatında yanıt ver:

{
    "refereeAnalysis": {
        "name": "string veya Bilinmiyor",
        "cardTendency": "strict/moderate/lenient",
        "penaltyRate": "high/average/low",
        "homeBias": "yes/no/unknown",
        "matchImpact": "string"
    },
    "injuriesAndSuspensions": {
        "homeImpact": "critical/moderate/minimal",
        "awayImpact": "critical/moderate/minimal",
        "keyMissing": ["string"],
        "insight": "string"
    },
    "weatherImpact": {
        "conditions": "string",
        "affectedAspects": ["string"],
        "advantageTeam": "home/away/neutral"
    },
    "motivationAndPressure": {
        "homeMotivation": "high/medium/low",
        "awayMotivation": "high/medium/low",
        "insight": "string"
    },
    "chaosFactors": [
        { "factor": "string", "probability": "high/medium/low", "impact": "string" }
    ],
    "riskAssessment": {
        "upsetProbability": number,
        "redCardProbability": number,
        "penaltyProbability": number,
        "varInterventionProbability": number
    },
    "narrative": "Dışsal faktörler ve kaos analizi (min 200 kelime)",
    "confidenceScore": number (1-10)
}`;
}

// ═══════════════════════════════════════════════════════════
// SENTEZCİ: Claude / Gemini — Nihai Tahmin
// ═══════════════════════════════════════════════════════════

export function buildSynthesisPrompt(
  matchInfo: MatchInfo,
  correlationInterpretation: string,
  statsTacticsAnalysis: string,
  refereeChaosAnalysis: string,
  targetModel: string
): string {
  return `Sen ${targetModel} olarak görev yapan baş analistsin. Üç uzman kanaldan gelen analizleri sentezleyerek tek bir nihai tahmin oluşturacaksın.

═══════════════════════════════════════════
MAÇ: ${matchInfo.homeTeam} vs ${matchInfo.awayTeam}
LİG: ${matchInfo.league} | TARİH: ${matchInfo.matchDate}
═══════════════════════════════════════════

═══ KANAL 1: KORELASYON YORUMU (Gemini 3.1 Pro) ═══
${correlationInterpretation}

═══ KANAL 2A: İSTATİSTİK + TAKTİK ANALİZİ (GPT-5.2) ═══
${statsTacticsAnalysis}

═══ KANAL 2B: HAKEM + KAOS ANALİZİ (GPT-5.2) ═══
${refereeChaosAnalysis}

═══════════════════════════════════════════
GÖREV — SENTEZ
═══════════════════════════════════════════
1. Üç kanalın bulgularını birleştir ve sentezle.
2. Kanallar arasında çelişen noktaları belirle ve hangisinin daha güçlü argümanı olduğuna karar ver.
3. Korelasyon bulgularını istatistik+taktik ve kaos analizleriyle çapraz doğrula.
4. Tüm kanalların güven skorlarını dikkate al.
5. Nihai, kapsamlı bir tahmin oluştur.

SADECE JSON formatında yanıt ver:

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
    "channelAgreements": ["Üç kanalın hemfikir olduğu noktalar"],
    "channelDisagreements": ["Kanalların ayrıştığı noktalar ve çözümün"],
    "gameNarrative": "Üç kanalın analizini sentezleyen kapsamlı maç hikayesi. Minimum 250 kelime. İlk yarı ve ikinci yarı ayrı değerlendir.",
    "confidenceScore": number (1-10)
}`;
}

// ═══════════════════════════════════════════════════════════
// NİHAİ HAKEM: GPT — Final Karar
// ═══════════════════════════════════════════════════════════

export function buildArbiterPrompt(
  matchInfo: MatchInfo,
  synthesisA: string,
  synthesisB: string
): string {
  return `Sen NİHAİ HAKEM'sin. İki bağımsız sentezci (Claude Opus 4.6 ve Gemini 3.1 Pro) aynı maçı analiz edip bağımsız tahminler oluşturdu. Senin görevin:

1. İKİ SENTEZCİYİ KARŞILAŞTIR
2. UYUMLULUYSA → Onayla ve güçlendir
3. ÇELİŞİYORSA → Çelişkiyi çöz, gerekçelendir, final kararı ver

═══════════════════════════════════════════
MAÇ: ${matchInfo.homeTeam} vs ${matchInfo.awayTeam}
LİG: ${matchInfo.league} | TARİH: ${matchInfo.matchDate}
═══════════════════════════════════════════

═══ SENTEZCİ A: Claude Opus 4.6 ═══
${synthesisA}

═══ SENTEZCİ B: Gemini 3.1 Pro ═══
${synthesisB}

═══════════════════════════════════════════
GÖREV — NİHAİ KARAR
═══════════════════════════════════════════
- Olasılıkları karşılaştır: %5'ten fazla sapma varsa açıkla neden birini tercih ettiğini.
- Tahmini skor: İkisi farklıysa hangisinin daha mantıklı olduğunu gerekçele.
- Güven skoru: Her iki sentezciyle de aynı fikirdeysen yüksek, çelişki varsa düşük.

SADECE JSON formatında yanıt ver:

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
    "agreementLevel": "full/partial/low",
    "disagreements": ["Çelişen nokta ve çözümü"],
    "arbiterReasoning": "İki sentezci arasındaki farkları ve neden bu karara vardığını detaylıca açıkla.",
    "gameNarrative": "Final maç hikayesi. Her iki sentezciyi de dikkate al. Minimum 300 kelime.",
    "confidenceScore": number (1-10)
}`;
}

// ═══════════════════════════════════════════════════════════
// SHARED TYPES
// ═══════════════════════════════════════════════════════════

export interface MatchInfo {
  homeTeam: string;
  awayTeam: string;
  league: string;
  matchDate: string;
  odds?: { home?: number; draw?: number; away?: number };
}

export function extractMatchInfo(md: Record<string, any>): MatchInfo {
  return {
    homeTeam: md.homeTeam?.name || md.homeTeam || 'Ev Sahibi',
    awayTeam: md.awayTeam?.name || md.awayTeam || 'Deplasman',
    league: md.league || md.competition || md.leagueName || 'Süper Lig',
    matchDate: md.matchDate || md.date || 'Bilinmiyor',
    odds: md.odds || undefined,
  };
}
