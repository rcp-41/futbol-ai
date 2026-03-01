/**
 * AI-Driven Derin Analiz — 8 modül
 * Her modül Gemini API'ye ayrı bir çağrı yaparak tarihsel pattern araştırması yapar.
 * Scraper verisi gerektirmez — Gemini kendi bilgi tabanından araştırır.
 */

import { logger } from 'firebase-functions/v2';
import { callGemini } from './aiClients';

// ─────────────────── TYPES ───────────────────

interface MatchContext {
  homeTeam: string;
  awayTeam: string;
  league: string;
  matchDate: string;
  season: string;
  homeForm?: string;
  awayForm?: string;
  odds?: { home?: number; draw?: number; away?: number };
}

interface ModuleResult {
  moduleName: string;
  analysis: Record<string, any>;
  summary: string;
  confidence: number; // 1-10: modül verisine ne kadar güveniyor
}

// ─────────────────── HELPERS ───────────────────

function extractMatchContext(md: Record<string, any>): MatchContext {
  const homeTeam = md.homeTeam?.name || md.homeTeam || 'Bilinmeyen';
  const awayTeam = md.awayTeam?.name || md.awayTeam || 'Bilinmeyen';
  const league = md.league || md.competition || md.leagueName || 'Süper Lig';

  let matchDate = '';
  if (md.matchDate) {
    if (typeof md.matchDate === 'string') matchDate = md.matchDate;
    else if (md.matchDate.toDate) matchDate = md.matchDate.toDate().toISOString();
    else matchDate = String(md.matchDate);
  } else if (md.date) {
    matchDate = String(md.date);
  }

  // Sezonu tarihden çıkar
  const year = new Date(matchDate || Date.now()).getFullYear();
  const month = new Date(matchDate || Date.now()).getMonth();
  const season = month >= 7 ? `${year}-${year + 1}` : `${year - 1}-${year}`;

  return {
    homeTeam,
    awayTeam,
    league,
    matchDate,
    season,
    homeForm: md.homeTeam?.formLast5 || md.homeForm || '',
    awayForm: md.awayTeam?.formLast5 || md.awayForm || '',
    odds: md.odds || {},
  };
}

/**
 * Gemini'den JSON yanıt parse et — hata durumunda fallback döndür
 */
function safeParseJSON(raw: string, moduleName: string): Record<string, any> {
  try {
    // JSON bloğunu bul (bazen Gemini markdown wrapper ekliyor)
    let cleaned = raw.trim();
    if (cleaned.startsWith('```json')) cleaned = cleaned.slice(7);
    if (cleaned.startsWith('```')) cleaned = cleaned.slice(3);
    if (cleaned.endsWith('```')) cleaned = cleaned.slice(0, -3);
    return JSON.parse(cleaned.trim());
  } catch (e) {
    logger.warn(`[DeepAnalysis] ${moduleName} JSON parse hatası, raw text kullanılacak`);
    return { rawText: raw, parseError: true };
  }
}

/**
 * Tek bir modülü Gemini ile çalıştır — hata durumunda fallback döndür
 */
async function runModule(
  moduleName: string,
  prompt: string,
  apiKey: string
): Promise<ModuleResult> {
  try {
    const raw = await callGemini(prompt, apiKey);
    const parsed = safeParseJSON(raw, moduleName);
    return {
      moduleName,
      analysis: parsed,
      summary: parsed.summary || parsed.ozet || `${moduleName} analizi tamamlandı.`,
      confidence: parsed.confidence || parsed.guvenSeviyesi || 5,
    };
  } catch (error: any) {
    logger.error(`[DeepAnalysis] ${moduleName} hatası:`, error.message);
    return {
      moduleName,
      analysis: { error: error.message },
      summary: `${moduleName} analizi başarısız oldu: ${error.message}`,
      confidence: 0,
    };
  }
}

// ─────────────────── SYSTEM PROMPT ───────────────────

function systemPreamble(ctx: MatchContext): string {
  const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
  return `Sen uzman bir futbol veri bilimci ve taktik analistisin.
BUGÜNÜN TARİHİ: ${today}. Şu an ${ctx.season} sezonu devam etmektedir.

Analiz ettiğin maç:
- Ev Sahibi: ${ctx.homeTeam}
- Deplasman: ${ctx.awayTeam}
- Lig: ${ctx.league}
- Sezon: ${ctx.season}
- Maç Tarihi: ${ctx.matchDate || 'Bilinmiyor'}
${ctx.homeForm ? `- Ev Sahibi Son Form: ${ctx.homeForm}` : ''}
${ctx.awayForm ? `- Deplasman Son Form: ${ctx.awayForm}` : ''}
${ctx.odds?.home ? `- Bahis Oranları: Ev ${ctx.odds.home} / Berab ${ctx.odds.draw} / Dep ${ctx.odds.away}` : ''}

ÖNEMLİ KURALLAR:
1. SADECE ${ctx.season} sezonu verilerini kullan. Bu sezon ŞU AN devam ediyor.
2. Bu maç gelecek bir maç — sonucu bilinmiyor, tahmin yapıyorsun.
3. Bilmediğin veriyi uydurma. Emin olmadığın bilgilerde güven skorunu düşür.
4. Yanıtını SADECE JSON formatında ver, başka metin ekleme.
`;
}

// ─────────────────── 8 MODÜL ───────────────────

function buildWeatherPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Hava Durumu Etkisi Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.matchDate} tarihinde ${ctx.homeTeam}'ın ev sahasında beklenen hava durumu nedir? (sıcaklık, yağış, rüzgar, nem)
2. Bu sezon ${ctx.homeTeam} benzer hava koşullarında maç oynadı mı? Oynadıysa:
   - Hangi maçlar?
   - Oyun planı değişti mi? (daha fazla uzun top, daha az kısa pas?)
   - Gol ortalaması değişti mi?
   - Top hakimiyeti nasıl etkilendi?
3. ${ctx.awayTeam} benzer koşullarda nasıl performans gösterdi?
4. Bu hava koşulları hangi takıma avantaj sağlar?

JSON formatı:
{
  "matchDateWeather": { "temperature": "°C", "condition": "güneşli/yağmurlu/karlı/bulutlu", "wind": "km/h", "humidity": "%" },
  "impact": "low/medium/high",
  "homeTeamInSimilarWeather": { "matches": ["maç1", "maç2"], "goalAvg": number, "possessionChange": "%, artış/azalış", "longBallChange": "%", "result": "G/B/M pattern" },
  "awayTeamInSimilarWeather": { "matches": ["maç1", "maç2"], "goalAvg": number, "result": "G/B/M pattern" },
  "advantageTeam": "home/away/neutral",
  "keyInsight": "En önemli bulgu",
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildMissingPlayersPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Eksik Oyuncu ve Kadro Durumu Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.homeTeam}'da şu an cezalı veya sakat olan oyuncular kimler?
   - Her eksik oyuncu için: pozisyonu, bu sezon etki düzeyi (gol, asist, xG katkısı)
   - Bu oyuncu yokken takım hangi formasyonla oynadı? (bu sezon maçları)
   - Yerine kim oynadı? O oyuncunun performansı nasıldı?
   - Takım o oyuncu yokken kazandı mı, kaybetti mi? İstatistikler nasıl değişti?
2. ${ctx.awayTeam}'da şu an cezalı veya sakat olan oyuncular kimler?
   - Aynı detaylı analiz
3. Transfer penceresi açık mı? Yeni transfer var mı?
4. Kadro eksiklikleri hangi takımı daha çok etkiler?

JSON formatı:
{
  "homeTeam": {
    "missingPlayers": [
      { "name": "string", "position": "string", "reason": "cezalı/sakat", "seasonGoals": number, "seasonAssists": number, "impactLevel": "critical/high/medium/low", "replacement": "string", "replacementPerformance": "string", "teamWithout": { "played": number, "won": number, "lost": number, "goalAvg": number } }
    ],
    "formationWithout": "string",
    "overallImpact": "string"
  },
  "awayTeam": {
    "missingPlayers": [...],
    "formationWithout": "string",
    "overallImpact": "string"
  },
  "moreAffectedTeam": "home/away/equal",
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildHomeAwayFormPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Ev Sahibi / Deplasman Form Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.homeTeam}'ın bu sezon SON 5 EV MAÇI:
   - Her maçın skoru, rakibi, gol atma/yeme zamanları
   - xG (beklenen gol) vs gerçek gol farkı
   - Top hakimiyeti, şut sayısı, isabetli şut oranı
   - İlk yarı/ikinci yarı performans farkı
   - Trend: son 5 maçta form yükseliyor mu düşüyor mu?
2. ${ctx.awayTeam}'ın bu sezon SON 5 DEPLASMAN MAÇI:
   - Aynı detaylı analiz
3. ${ctx.homeTeam}'ın ev sahibi avantajı ne kadar güçlü? (ev vs deplasman puan farkı)
4. ${ctx.awayTeam}'ın deplasman performansı ligde kaçıncı sırada?

JSON formatı:
{
  "homeTeam": {
    "last5HomeMatches": [
      { "opponent": "string", "score": "X-Y", "xG": "X.X-Y.Y", "possession": "%, ", "shots": number, "shotsOnTarget": number, "result": "G/B/M" }
    ],
    "homeGoalAvg": number, "homeConcededAvg": number,
    "homePoints": "X/15", "trend": "improving/stable/declining",
    "firstHalfGoals": number, "secondHalfGoals": number,
    "homeAdvantageStrength": "strong/moderate/weak"
  },
  "awayTeam": {
    "last5AwayMatches": [...],
    "awayGoalAvg": number, "awayConcededAvg": number,
    "awayPoints": "X/15", "trend": "improving/stable/declining",
    "firstHalfGoals": number, "secondHalfGoals": number,
    "awayPerformanceRank": "ligde X. sıra"
  },
  "formComparison": "string",
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildH2HPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Kafa Kafaya (H2H) Geçmiş Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.homeTeam} vs ${ctx.awayTeam} — Son 10 karşılaşma (tüm yarışmalar):
   - Her maçın tarihi, skoru, ev/deplasman bilgisi, yarışma türü
   - Gol zamanları ve maçın gidişatı
2. Bu 10 maçta istatistiksel trendler:
   - Toplam gol ortalaması
   - Ev sahibi galibiyeti yüzdesi, beraberlik yüzdesi, deplasman galibiyeti yüzdesi
   - Karşılıklı gol olan maç yüzdesi (BTTS)
   - 2.5 üstü gol olan maç yüzdesi
3. Son 3 yılda ${ctx.homeTeam}'ın bu rakibe karşı EV SAHASINDAKİ performansı
4. Bu iki takım arasındaki "psikolojik üstünlük" var mı?
5. Son karşılaşmadan bugüne kadrolarda önemli değişiklikler oldu mu?

JSON formatı:
{
  "last10Matches": [
    { "date": "YYYY-MM-DD", "homeTeam": "string", "score": "X-Y", "competition": "Lig/Kupa", "venue": "home/away" }
  ],
  "stats": {
    "totalMatches": number, "homeWins": number, "draws": number, "awayWins": number,
    "avgGoals": number, "bttsPercentage": number, "over25Percentage": number,
    "homeTeamGoalAvg": number, "awayTeamGoalAvg": number
  },
  "last3YearsAtHome": { "played": number, "homeWins": number, "draws": number, "awayWins": number },
  "psychologicalEdge": "home/away/neutral",
  "keyPattern": "En belirgin pattern (ör: son 5 maçta hep 2+ gol)",
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildXGPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: xG (Beklenen Gol) Derinlemesine Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.homeTeam}'ın bu sezon xG performansı:
   - Sezon xG ortalaması (maç başı)
   - Sezon xGA ortalaması (beklenen yenilen gol)
   - Gerçek gol vs xG farkı (overperforming/underperforming)
   - Son 5 maçtaki xG trendi (artıyor mu azalıyor mu?)
   - Şut kalitesi: büyük şans, orta şans, düşük şans dağılımı
2. ${ctx.awayTeam}'ın bu sezon xG performansı:
   - Aynı detaylı analiz
3. İki takımın xG profili karşılaştırması:
   - Kim daha kaliteli pozisyon üretiyor?
   - Kim daha iyi savunma yapıyor (xGA)?
   - Kim şansının üstünde/altında oynuyor?
4. Bu maçta beklenen xG tahmini

JSON formatı:
{
  "homeTeam": {
    "seasonXG": number, "seasonXGA": number,
    "actualGoals": number, "actualConceded": number,
    "overperformance": number, "xgTrend": "increasing/stable/decreasing",
    "bigChancesCreated": number, "bigChancesMissed": number,
    "last5MatchXG": [number]
  },
  "awayTeam": { ... },
  "comparison": {
    "betterAttack": "home/away", "betterDefense": "home/away",
    "moreOverperforming": "home/away"
  },
  "expectedMatchXG": { "home": number, "away": number },
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildSetPiecesPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Duran Top (Set Piece) Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.homeTeam}'ın bu sezon duran top istatistikleri:
   - Maç başı korner ortalaması
   - Kornerden gol yüzdesi
   - Serbest vuruştan gol sayısı
   - Penaltı istatistikleri (kazanılan, kaçırılan, atılan)
   - Duran toplardan yenilen gol sayısı (savunma)
2. ${ctx.awayTeam}'ın bu sezon duran top istatistikleri:
   - Aynı detaylı analiz
3. Hangi takım duran toplardan daha tehlikeli?
4. Hangi takım duran toplarda savunmada daha zayıf?
5. Bu maçta duran toplar belirleyici olabilir mi?

JSON formatı:
{
  "homeTeam": {
    "cornersPerMatch": number, "cornerGoalRate": "%",
    "freeKickGoals": number, "penaltiesWon": number, "penaltiesScored": number,
    "setPieceGoalsConceded": number, "aerialDuelWinRate": "%"
  },
  "awayTeam": { ... },
  "moreDangerousFromSetPieces": "home/away",
  "weakerDefensively": "home/away",
  "setPieceImportance": "low/medium/high",
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildRefereePrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Hakem Etkisi Analizi

Aşağıdaki soruları yanıtla:
1. Bu maça atanmış hakem var mı? Biliniyorsa:
   - Hakem adı ve deneyimi
   - Bu sezon yönettiği maç sayısı
   - Maç başı ortalama sarı kart sayısı
   - Maç başı ortalama faul sayısı
   - Penaltı verme oranı
   - VAR müdahalesi alma oranı
2. Bu hakemin ${ctx.homeTeam} ve ${ctx.awayTeam} maçlarındaki geçmişi:
   - Kaç maç yönetti?
   - Ev sahibi yanlılığı var mı?
   - Kartlarda aşırılık var mı?
3. Hakemin yönetim stili oyun akışını nasıl etkiler?
   - Sert faullere toleranslı mı değil mi?
   - Oyunun hızını kesiyor mu?
4. Hakem bilgisi bulunamıyorsa "bilinmiyor" olarak belirt.

JSON formatı:
{
  "refereeName": "string veya Bilinmiyor",
  "refereeKnown": boolean,
  "stats": {
    "matchesThisSeason": number, "avgYellowCards": number,
    "avgFouls": number, "penaltyRate": "%, maç başı",
    "varInterventionRate": "%"
  },
  "historyWithTeams": {
    "homeTeamMatches": number, "awayTeamMatches": number,
    "homeTeamWinRate": "%", "anyBias": "home/away/neutral"
  },
  "styleImpact": "string",
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

function buildTacticsPrompt(ctx: MatchContext): string {
  return `${systemPreamble(ctx)}

GÖREV: Taktik ve Formasyon Analizi

Aşağıdaki soruları yanıtla:
1. ${ctx.homeTeam}'ın bu sezon tercih ettiği formasyon(lar):
   - Ana formasyon ve alternatif formasyonlar
   - Güçlü yanları (bu formasyonla en iyi yaptığı şey)
   - Zayıf yanları (bu formasyonun açıkları)
   - Baskı yoğunluğu (PPDA — maç başı izin verilen pas sayısı)
   - Oyun stili: topa sahip / kontratak / pressing / pragmatik
2. ${ctx.awayTeam}'ın bu sezon tercih ettiği formasyon(lar):
   - Aynı detaylı analiz
3. İki takımın taktik uyumu/çatışması:
   - Bu formasyon eşleşmesi hangi takıma avantaj sağlar?
   - Kilit bölge: maç hangi alanda kazanılır? (kanat, orta saha, hava topu)
   - Tempo beklentisi: açık mı, kapalı mı bir maç bekleniyor?
4. Teknik direktörlerin bu tür maçlardaki tercihleri

JSON formatı:
{
  "homeTeam": {
    "mainFormation": "string", "alternativeFormations": ["string"],
    "playStyle": "string", "pressingIntensity": "high/medium/low",
    "ppda": number, "strengths": ["string"], "weaknesses": ["string"],
    "manager": "string"
  },
  "awayTeam": { ... },
  "tacticalMatchup": {
    "advantage": "home/away/balanced",
    "keyBattleZone": "string",
    "expectedTempo": "high/medium/low",
    "expectedPossession": { "home": "%", "away": "%" }
  },
  "summary": "2-3 cümle özet",
  "confidence": number (1-10)
}`;
}

// ─────────────────── ANA FONKSİYON ───────────────────

/**
 * AI-Driven derin analiz — 8 modül sıralı olarak Gemini ile çalıştırılır.
 * Her modül arası 300ms bekleme (rate limit koruması).
 */
export async function runDeepAnalysis(
  md: Record<string, any>,
  apiKey: string,
  onProgress?: (moduleName: string, index: number) => Promise<void>
): Promise<Record<string, ModuleResult>> {
  const ctx = extractMatchContext(md);

  const modules: { name: string; prompt: string }[] = [
    { name: 'weather', prompt: buildWeatherPrompt(ctx) },
    { name: 'missingPlayers', prompt: buildMissingPlayersPrompt(ctx) },
    { name: 'homeAwayForm', prompt: buildHomeAwayFormPrompt(ctx) },
    { name: 'h2h', prompt: buildH2HPrompt(ctx) },
    { name: 'xg', prompt: buildXGPrompt(ctx) },
    { name: 'setPieces', prompt: buildSetPiecesPrompt(ctx) },
    { name: 'referee', prompt: buildRefereePrompt(ctx) },
    { name: 'tactics', prompt: buildTacticsPrompt(ctx) },
  ];

  const results: Record<string, ModuleResult> = {};

  for (let i = 0; i < modules.length; i++) {
    const mod = modules[i];
    logger.info(`[DeepAnalysis] Modül ${i + 1}/8: ${mod.name} başlıyor...`);

    if (onProgress) {
      await onProgress(mod.name, i);
    }

    results[mod.name] = await runModule(mod.name, mod.prompt, apiKey);

    logger.info(`[DeepAnalysis] Modül ${i + 1}/8: ${mod.name} tamamlandı (güven: ${results[mod.name].confidence}/10)`);

    // Rate limit koruması — modüller arası bekleme
    if (i < modules.length - 1) {
      await new Promise(resolve => setTimeout(resolve, 300));
    }
  }

  return results;
}
