# FutbolAI Scraper Yeniden Tasarım Planı
**Tarih:** 01 Mart 2026  
**Proje:** R:\YDev\futbol-data-scraper  
**Hedef:** SofaScore + Transfermarkt odaklı, sürekli çalışan, canlı veri destekli scraper

---

## 1. MEVCUT DURUM

### Mevcut Takımlar (FBref'ten çekilmiş — 8 lig, 150 takım)

| Lig | Takım Sayısı |
|-----|:---:|
| Premier League | 20 |
| La Liga | 20 |
| Serie A | 20 |
| Bundesliga | 18 |
| Ligue 1 | 18 |
| Süper Lig | 18 |
| Eredivisie | 18 |
| Primeira Liga | 18 |

> **Süper Lig Takımları:** Alanyaspor, Antalyaspor, Başakşehir, Beşiktaş, Eyüpspor, Fatih Karagümrük, Fenerbahçe, Galatasaray, Gaziantep FK, Gençlerbirliği, Göztepe, Kasımpaşa, Kayserispor, Kocaelispor, Konyaspor, Rizespor, Samsunspor, Trabzonspor

### Mevcut Sorunlar
- SofaScore ve Transfermarkt data klasörleri **boş** (hiç veri çekilmemiş)
- FBref, Understat, StatsBomb botları var ama **kaldırılacak**
- Scraper tek seferlik çalışıyor, sürekli çalışma modu yok
- Canlı maç verisi desteği yok

---

## 2. YENİ MİMARİ

```
┌─────────────────────────────────────────────────────────────────┐
│                        ORCHESTRATOR                             │
│                                                                 │
│  Mode 1: FULL SCRAPE (ilk çalıştırma, ~2-3 saat)              │
│  Mode 2: DELTA UPDATE (30 dk'da bir)                           │
│  Mode 3: LIVE TRACKER (sürekli, 30 sn'de bir)                  │
│                                                                 │
└────────┬──────────────┬──────────────┬──────────────────────────┘
         │              │              │
┌────────▼─────┐ ┌──────▼──────┐ ┌─────▼────────┐
│  SofaScore   │ │ SofaScore   │ │ Transfermarkt│
│  WEB SCRAPE  │ │ API (Live)  │ │ WEB SCRAPE   │
│  (Playwright)│ │ (Axios)     │ │ (Playwright) │
│              │ │             │ │              │
│ • xG         │ │ • Canlı skor│ │ • Kadro      │
│ • Şut harit. │ │ • Canlı stat│ │ • Sakatlıklar│
│ • Formasyon  │ │ • Canlı olay│ │ • TD bilgisi │
│ • Kadro      │ │ • Canlı oran│ │ • Söylentiler│
│ • İstatistik │ │ • Fikstür   │ │ • Hakem      │
│ • Olay       │ │ • Kadro     │ │ • Cezalılar  │
│ • Oranlar    │ │             │ │ • Piyasa değ.│
│ • H2H        │ │             │ │ • Form       │
│ • Puan tab.  │ │             │ │ • Transferler│
│ • Momentum   │ │             │ │ • Oyuncu st. │
│ • Hakem      │ │             │ │ • Haber      │
└──────────────┘ └─────────────┘ └──────────────┘
         │              │              │
         └──────────────┼──────────────┘
                        ▼
              ┌─────────────────┐
              │   Firestore DB  │
              │                 │
              │ leagues/        │
              │ teams/          │
              │ matches/        │
              │ players/        │
              │ live/           │  ← Canlı maç verisi
              │ scrape_history/ │
              └────────┬────────┘
                       │
            ┌──────────┴──────────┐
            ▼                     ▼
    ┌──────────────┐    ┌──────────────┐
    │  Web App     │    │  Mobile App  │
    │  (Firebase   │    │  (Flutter)   │
    │   Hosting)   │    │              │
    └──────────────┘    └──────────────┘
```

---

## 3. VERİ KATEGORİLERİ

### 3A. SofaScore WEB SCRAPE (Playwright)

Maç bazlı veriler — sezon başından bugüne tüm oynanan maçlar + gelecek fikstür.

| # | Veri | Kaynak URL Deseni | Çekilecek Alanlar |
|---|------|-------------------|-------------------|
| 1 | **Maç İstatistikleri** | sofascore.com/match/{slug}/{id} | Possession, shots, shots on target, corners, fouls, offsides, saves, passes, tackles |
| 2 | **xG (Beklenen Gol)** | Maç sayfası → Statistics tab | xG home, xG away, dakika bazlı xG grafiği |
| 3 | **Şut Haritası** | Maç sayfası → Shot Map | Her şut: x, y koordinat, xG, sonuç (gol/kurtarış/dışarı) |
| 4 | **Kadro & Formasyon** | Maç sayfası → Lineups | İlk 11, yedekler, formasyon (4-2-3-1 vb.), oyuncu pozisyonları |
| 5 | **Oyuncu Reytingleri** | Maç sayfası → Lineups | SofaScore rating (0-10) |
| 6 | **Maç Olayları** | Maç sayfası → incidents | Goller, kartlar, değişiklikler, VAR kararları, dakikaları |
| 7 | **Bahis Oranları** | Maç sayfası → Odds | 1X2, Ü/A 2.5, Handikap |
| 8 | **H2H** | Maç sayfası → H2H tab | Son karşılaşmalar, sonuçlar, tarihler |
| 9 | **Puan Tablosu** | Lig sayfası → Standings | Sıra, puan, gol, averaj, form |
| 10 | **Momentum** | Maç sayfası | Baskı grafiği verisi |
| 11 | **Hakem** | Maç sayfası → Info | Hakem adı |
| 12 | **Pre-match Kadro** | Gelecek maç sayfası | Beklenen kadro (açıklanmışsa) |

### 3B. Transfermarkt WEB SCRAPE (Playwright)

Takım bazlı veriler — her takım için ayrı ayrı çekilecek.

| # | Veri | Kaynak URL Deseni | Çekilecek Alanlar |
|---|------|-------------------|-------------------|
| 1 | **Takım Kadrosu** | transfermarkt.com/{team}/startseite/verein/{id}/saison_id/2025 | Tüm oyuncular: ad, pozisyon, yaş, numara, piyasa değeri, kontrat, durum |
| 2 | **Teknik Direktör** | Takım sayfası | İsim, göreve başlama tarihi, çalıştırdığı maç, galibiyet oranı |
| 3 | **Sakatlıklar** | transfermarkt.com/{team}/ausfaelle/verein/{id} | Sakatlık türü, tarih, beklenen dönüş, kaçırdığı maç |
| 4 | **Cezalı Oyuncular** | transfermarkt.com/{team}/sperren/verein/{id} | Kart cezaları, ceza süresi |
| 5 | **Transfer Söylentileri** | transfermarkt.com/ceapi/transferGeruechte/list/verein/{id} | Oyuncu adı, hedef/kaynak kulüp, tarih, güvenilirlik |
| 6 | **Haberler** | transfermarkt.com/{team}/news/verein/{id} | Başlık, tarih, özet |
| 7 | **Hakem Ataması** | Fikstür sayfası | Atanan hakem, hakem istatistikleri |
| 8 | **Takım Formu** | Puan tablosu sayfası | Son 5 maç sonucu |
| 9 | **Transfer Geçmişi** | transfermarkt.com/{team}/transfers/verein/{id}/saison_id/2025 | Gelen/giden oyuncular, transfer bedeli |
| 10 | **Oyuncu İstatistikleri** | Her oyuncu sayfası | Maç, gol, asist, dakika, kart |
| 11 | **Piyasa Değeri** | Her oyuncu sayfası | Güncel değer, değer geçmişi grafiği |
| 12 | **TD Geçmişi** | transfermarkt.com/{team}/mitarbeiter/verein/{id} | Önceki teknik direktörler |

### 3C. SofaScore API (Canlı Veri — Axios)

Sürekli polling ile çekilecek veriler.

| # | Veri | API Endpoint | Güncelleme Sıklığı |
|---|------|-------------|-------------------|
| 1 | **Canlı Skor** | `/event/{id}` | 30 saniye |
| 2 | **Canlı İstatistik** | `/event/{id}/statistics` | 1 dakika |
| 3 | **Canlı Olaylar** | `/event/{id}/incidents` | 30 saniye |
| 4 | **Canlı Oranlar** | `/event/{id}/odds/1/all` | 5 dakika |
| 5 | **Canlı Kadro** | `/event/{id}/lineups` | Maç başında 1 kez |
| 6 | **Günün Maçları** | `/sport/football/scheduled-events/{date}` | 30 dakika |
| 7 | **Lig Puan Tablosu** | `/unique-tournament/{id}/season/{sid}/standings/total` | 30 dakika |

---

## 4. ÇALIŞMA MODELİ

### Phase 1: Full Scrape (İlk Çalıştırma)

```
BAŞLANGIÇ
│
├─ 1. SofaScore Web: Sezon başından (Ağustos 2025) bugüne TÜM maçlar
│   ├─ Her lig için oynanmış maçları bul
│   ├─ Her maç için: istatistik + xG + kadro + oranlar + H2H + olaylar
│   └─ Gelecek fikstür maçları da çek (kadrosuz)
│
├─ 2. Transfermarkt Web: 150 takımın TÜM verileri
│   ├─ Kadro + sakatlık + cezalı + TD + transfer + söylenti + haber
│   └─ Her oyuncu: stats + piyasa değeri
│
├─ 3. SofaScore API: Puan tabloları
│   └─ Her lig için güncel sıralama
│
└─ 4. Firebase'e yaz
    └─ Tüm veriyi Firestore'a batch write
```

**Tahmini süre:** ~2-3 saat (rate limit koruması ile)

### Phase 2: Delta Update (Her 30 dakikada bir)

```
DELTA DÖNGÜ (30 dk)
│
├─ 1. SofaScore API: Bugün + yarın maçları
│   └─ Yeni maç var mı? Kadro açıklandı mı?
│
├─ 2. SofaScore Web: Son oynanan maçların detayları
│   └─ xG, şut haritası, reytingler (hâlâ güncellenmemişse)
│
├─ 3. Transfermarkt Web: Sakatlık + söylenti kontrolü
│   └─ Son 30 dk'da yeni sakatlık/haber/söylenti var mı?
│
├─ 4. Puan tablosu güncelle
│
└─ 5. Firebase: Sadece DEĞİŞEN veriyi yaz
    └─ Hash karşılaştırma: eski veri = yeni veri ise YAZMA
```

### Phase 3: Live Tracker (Canlı Maç Varsa)

```
CANLI MAÇ TESPİTİ
│
├─ SofaScore API'den status="inprogress" maçları bul
│
└─ Her canlı maç için 30 saniyede bir:
    ├─ Skor güncelle
    ├─ İstatistik güncelle
    ├─ Olaylar güncelle (gol, kart, değişiklik)
    ├─ Oranlar güncelle
    └─ Firebase "live/{matchKey}" koleksiyonuna yaz
        └─ Web/Mobil app onSnapshot() ile dinler
```

---

## 5. FİRESTORE ŞEMASI

### `leagues/{leagueKey}`
```json
{
  "name": "Süper Lig",
  "country": "Turkey",
  "season": "2025-26",
  "sofascoreId": 52,
  "standings": [
    { "rank": 1, "team": "Galatasaray", "played": 24, "won": 18, "drawn": 3, "lost": 3, "goalsFor": 55, "goalsAgainst": 18, "goalDifference": 37, "points": 57, "form": ["W","W","D","W","L"] }
  ],
  "lastUpdated": "2026-03-01T12:00:00Z"
}
```

### `teams/{teamSlug}`
```json
{
  "name": "Beşiktaş",
  "slug": "besiktas",
  "league": "super-lig",
  "ids": { "sofascore": 3050, "transfermarkt": "114" },
  "manager": { "name": "Giovanni van Bronckhorst", "since": "2025-06-15", "matches": 28, "winRate": 57 },
  "squad": [
    { "name": "Ciro Immobile", "position": "FW", "number": 17, "age": 36, "marketValue": 3500000, "status": "fit", "contractUntil": "2026-06-30" }
  ],
  "injuries": [
    { "player": "Rafa Silva", "type": "Hamstring", "since": "2026-02-15", "expectedReturn": "2026-03-15", "gamesMissed": 3 }
  ],
  "suspended": [
    { "player": "Gedson Fernandes", "reason": "5. sarı kart", "returnDate": "2026-03-08" }
  ],
  "transferRumors": [
    { "player": "X Player", "type": "in/out", "source": "...", "date": "2026-02-28", "reliability": "low/medium/high" }
  ],
  "news": [
    { "title": "...", "date": "2026-03-01", "summary": "..." }
  ],
  "recentForm": ["W", "W", "L", "D", "W"],
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `matches/{matchKey}`
```json
{
  "matchKey": "2026-03-08_besiktas_vs_galatasaray",
  "league": "super-lig",
  "season": "2025-26",
  "date": "2026-03-08T19:00:00Z",
  "status": "upcoming|live|finished",
  "homeTeam": { "slug": "besiktas", "name": "Beşiktaş", "sofascoreId": 3050 },
  "awayTeam": { "slug": "galatasaray", "name": "Galatasaray", "sofascoreId": 3061 },
  "referee": { "name": "Cüneyt Çakır", "stats": { "avgFouls": 24, "avgCards": 4.2 } },
  "score": { "home": null, "away": null, "ht": null },
  "statistics": {
    "possession": { "home": 52, "away": 48 },
    "shots": { "home": 14, "away": 11 },
    "shotsOnTarget": { "home": 6, "away": 4 },
    "corners": { "home": 7, "away": 5 },
    "fouls": { "home": 12, "away": 15 },
    "offsides": { "home": 2, "away": 3 }
  },
  "xg": { "home": 1.82, "away": 1.15, "timeline": [{"minute": 12, "team": "home", "xg": 0.35}] },
  "shotMap": [
    { "player": "Immobile", "team": "home", "minute": 23, "x": 88, "y": 45, "xg": 0.42, "result": "goal" }
  ],
  "lineups": {
    "home": {
      "formation": "4-2-3-1",
      "startXI": [{ "name": "...", "number": 1, "position": "GK", "rating": 7.2 }],
      "substitutes": [{ "name": "...", "number": 12, "position": "GK" }]
    },
    "away": { "..." : "..." }
  },
  "incidents": [
    { "type": "goal", "team": "home", "player": "Immobile", "minute": 23, "assist": "Gedson" },
    { "type": "yellowCard", "team": "away", "player": "...", "minute": 34 },
    { "type": "substitution", "team": "home", "playerIn": "...", "playerOut": "...", "minute": 65 }
  ],
  "odds": {
    "prematch": { "home": 2.10, "draw": 3.30, "away": 3.80, "over25": 1.75, "under25": 2.05 },
    "live": { "home": null, "draw": null, "away": null }
  },
  "h2h": {
    "totalMatches": 15,
    "homeWins": 6, "draws": 4, "awayWins": 5,
    "lastMatches": [
      { "date": "2025-12-15", "home": "Galatasaray", "away": "Beşiktaş", "score": "2-1" }
    ]
  },
  "momentum": [{ "minute": 1, "value": 0 }, { "minute": 2, "value": 15 }],
  "playerRatings": {
    "home": [{ "name": "...", "rating": 7.8 }],
    "away": [{ "name": "...", "rating": 6.2 }]
  },
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `live/{matchKey}` (Canlı maçlar için geçici koleksiyon)
```json
{
  "matchKey": "...",
  "minute": 67,
  "score": { "home": 2, "away": 1 },
  "statistics": { "..." : "..." },
  "lastIncident": { "type": "goal", "player": "...", "minute": 65 },
  "odds": { "home": 1.35, "draw": 5.50, "away": 9.00 },
  "updatedAt": "2026-03-01T20:15:30Z"
}
```

### `players/{playerId}` (Opsiyonel — detaylı oyuncu verisi)
```json
{
  "name": "Ciro Immobile",
  "transfermarktId": "105521",
  "team": "besiktas",
  "position": "FW",
  "seasonStats": { "matches": 22, "goals": 14, "assists": 5, "minutes": 1890, "yellowCards": 3 },
  "marketValue": 3500000,
  "marketValueHistory": [{ "date": "2025-12-01", "value": 4000000 }],
  "injuries": [{ "type": "...", "from": "...", "to": "...", "days": 21 }],
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

---

## 6. DOSYA DEĞİŞİKLİKLERİ

### SİLİNECEK DOSYALAR
```
src/bots/fbref/           (6 dosya — FBrefBot, parser, urls, scrapers)
src/bots/understat/       (1 dosya — UnderstatBot)
src/bots/statsbomb/       (1 dosya — StatsBombBot)
data/fbref/               (135 JSON dosyası — eski FBref verisi)
data/understat/           (boş)
data/statsbomb/           (boş)
```

### GÜNCELLENECEK DOSYALAR

| Dosya | Değişiklik |
|-------|-----------|
| `src/orchestrator.ts` | 3 fazlı mimari: Full → Delta → Live. setInterval döngüsü |
| `src/bots/sofascore/SofaScoreBot.ts` | Web scrape ekleme: xG, şut haritası, momentum, H2H. API live tracker ayrılacak |
| `src/bots/transfermarkt/TransfermarktBot.ts` | Doğrudan web scrape: söylenti, haber, hakem, cezalı, form |
| `src/config/leagues.ts` | `fbrefId`, `understatName` kaldır. `transfermarktId` ekle |
| `src/types/index.ts` | Yeni tipler: LiveMatch, TransferRumor, News, ShotMap, xGData |
| `src/types/match.ts` | xG, shotMap, momentum, h2h alanları ekle |
| `src/types/team.ts` | injuries, suspended, rumors, news, manager detay |
| `src/db/writer.ts` | Live collection yazma, player yazma, delta (hash) kontrolü |
| `src/db/schemas.ts` | Yeni: `live`, `players` koleksiyonları |
| `src/index.ts` | Sürekli çalışma: `process.stdin.resume()`, graceful shutdown |
| `package.json` | `playwright` bağımlılığını güncelle |

### YENİ DOSYALAR

| Dosya | İçerik |
|-------|--------|
| `src/bots/sofascore/SofaScoreWebScraper.ts` | Playwright ile SofaScore web scrape |
| `src/bots/sofascore/SofaScoreLiveTracker.ts` | API ile canlı maç takibi |
| `src/bots/transfermarkt/TransfermarktWebScraper.ts` | Playwright ile Transfermarkt web scrape |
| `src/config/teamMappings.ts` | SofaScore ID ↔ Transfermarkt ID ↔ slug eşleme (150 takım) |
| `src/utils/hashCompare.ts` | Delta güncelleme için veri hash karşılaştırma |
| `src/utils/dateValidator.ts` | Tarih/sezon/güncellik doğrulama |

---

## 7. GÜNCELLİK & DOĞRULAMA KURALLARI

### Tarih Kontrolü
```
1. Sezon kontrolü: Sadece 2025-26 sezonu verisi kabul et
2. Maç tarihi: Gelecek tarihteki maçlar "upcoming" olarak işaretle
3. Geçmiş maçlar: İstatistik eksiksiz olmalı (score, stats, lineups)
4. Takım verisi: "lastUpdated" 7 günden eski ise yeniden scrape et
```

### Delta Güncelleme Kuralları
```
1. Hash kontrolü: Yeni veri ≠ eski veri → güncelle
2. Maç durumu değişikliği: upcoming → live → finished
3. Kadro açıklaması: lineups boş → dolu olunca güncelle
4. Sakatlık güncelleme: Yeni sakatlık veya dönüş olunca güncelle
5. Transfer söylentisi: Yeni söylenti geldiğinde ekle
```

### Veri Kalitesi
```
1. Boş/eksik veri: null olarak kaydet, uydurma değer yazma
2. Lig eşleşme: Maçı doğru lige eşle (sofascoreId → leagueKey)
3. Takım eşleşme: slug normalleştirme ile SofaScore ↔ TM eşle
4. Tarih format: ISO 8601 (UTC) standart kullan
```

---

## 8. RATE LIMITING & KORUMA

| Kaynak | Delay | Max Request/dk | Koruma |
|--------|-------|:---:|---------|
| SofaScore Web | 4-6 sn (random) | ~12 | Playwright stealth, random UA, cookie |
| SofaScore API | 2-3 sn | ~25 | Axios, retry + backoff |
| Transfermarkt Web | 5-8 sn (random) | ~10 | Playwright stealth, random UA |

### Cloudflare/Bot Koruma Stratejisi
```
1. playwright-extra + stealth plugin
2. Random User-Agent rotation (10+ farklı UA)
3. Random delay (min + Math.random() * range)
4. Cookie persistence (session devam)
5. 403 → 5 dakika bekle → retry
6. 429 → Exponential backoff (1dk, 2dk, 4dk, 8dk)
7. Headless: false (testte), true (production)
```

---

## 9. CANLI VERİ → MOBİL/WEB APP ENTEGRASYONU

### Web App (Firebase Hosting)
```javascript
// Canlı maçları dinle
db.collection('live').onSnapshot(snapshot => {
  snapshot.docChanges().forEach(change => {
    if (change.type === 'modified') {
      updateLiveScore(change.doc.data());
    }
  });
});
```

### Mobile App (Flutter)
```dart
// Canlı maçları dinle
FirebaseFirestore.instance
  .collection('live')
  .snapshots()
  .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      updateLiveMatch(change.doc.data());
    }
  });
```

### Canlı Veri Akışı
```
Scraper (30sn)  →  Firestore "live/"  →  onSnapshot()  →  UI Update
                                        (realtime listener)
```

---

## 10. ÇALIŞMA PLANI (Tahmini Süre)

| Adım | İş | Süre |
|------|---|------|
| 1 | Eski botları sil, yapıyı temizle | 30 dk |
| 2 | Team mappings oluştur (150 takım: slug ↔ sofascoreId ↔ tmId) | 1 saat |
| 3 | SofaScore Web Scraper yaz | 2-3 saat |
| 4 | Transfermarkt Web Scraper yaz | 2-3 saat |
| 5 | SofaScore Live Tracker yaz | 1-2 saat |
| 6 | Orchestrator yeniden yaz (3 fazlı) | 1-2 saat |
| 7 | Firestore Writer güncelle (delta, hash, live) | 1 saat |
| 8 | Types/schemas güncelle | 30 dk |
| 9 | Test & debug | 2-3 saat |
| 10 | Web/Mobile app live entegrasyonu | 2-3 saat |
| **TOPLAM** | | **~14-18 saat** |

---

## 11. ÇEKİLEMEYEN VERİLER (Final Liste)

| Veri | Neden | Alternatif |
|------|-------|-----------|
| **Hava durumu** | Her iki sitede yok | OpenWeatherMap API (ücretsiz, kolay entegre) |
| **Detaylı hakem istatistikleri** | TM'de kısmen var ama sınırlı | Gemini'nin bilgi tabanı |
| **Oyuncu ısı haritası (heatmap)** | SofaScore'da var ama aşırı rate limit riski | Öncelik dışı, ileride eklenebilir |
| **VAR karar detayları** | Yapılandırılmış veri yok | Incidents içinde gelebilir |

---

## 12. KARAR GEREKTİREN NOKTALAR

1. **Champions League, Europa League, Conference League** da dahil mi? (Bu 3 kupa için takım listesi farklı olacak, ayrı mantık gerekir)
2. **Player koleksiyonu** yazılsın mı? (Firestore maliyet artışı — 150 takım × ~25 oyuncu = ~3750 oyuncu)
3. **Hava durumu API** eklensin mi? (OpenWeatherMap ücretsiz plan: 1000 call/gün)
4. **Scraper nerede çalışacak?** Lokal PC / Cloud Run / VPS? (Sürekli açık kalması gerekiyor)

---

## Claude Revizyon:

> Aşağıdaki revizyon, mevcut kod tabanının (`R:\YDev\futbol-data-scraper`) satır satır incelenmesine dayanmaktadır. Plan genel olarak güçlü ve ihtiyaçları karşılıyor, ancak aşağıdaki eksikler ve iyileştirmeler kritik önem taşıyor.

---

### R1. LİG SAYISI TUTARSIZLIĞI (KRİTİK)

Plan "8 lig, 150 takım" diyor ve "CL/EL/ECL dahil mi?" soruyor. Ancak **mevcut kodda zaten 11 lig** tanımlı (`src/config/leagues.ts`):

```
8 lig (Premier League, La Liga, Serie A, Bundesliga, Ligue 1, Süper Lig, Eredivisie, Primeira Liga)
+ Champions League (sofascoreId: 7)
+ Europa League (sofascoreId: 679)
+ Conference League (sofascoreId: 17015)
```

**Revizyon:** Plan "8 lig + 3 kupa = 11 turnuva" olarak güncellenmeli. Kupa takımları zaten lig takımlarının alt kümesi olduğu için ekstra takım sayısı yok — sadece maç sayısı artıyor.

---

### R2. EKSİK SOFASCORE API ENDPOINT'LERİ (KRİTİK)

Plan sadece 7 API endpoint listeliyor. SofaScore API'den çekilebilecek ama planda **hiç bahsedilmeyen** veriler:

| # | Endpoint | Veri | Kategori |
|---|----------|------|----------|
| 1 | `/event/{id}/shotmap` | Şut haritası (API ile, Playwright'a gerek yok) | Maç |
| 2 | `/event/{id}/graph` | Dakika dakika baskı/momentum grafiği (detaylı) | Maç |
| 3 | `/event/{id}/best-players` | Maçın en iyi oyuncuları + MOTM | Maç |
| 4 | `/event/{id}/pregame-form` | Maç öncesi form verisi (son 5-10 maç) | Pre-match |
| 5 | `/event/{id}/votes` | Taraftar oylama sonuçları | Maç |
| 6 | `/event/{id}/highlights` | Video özet linkleri | Maç |
| 7 | `/event/{id}/managers` | Maç bazlı TD bilgisi | Maç |
| 8 | `/event/{id}/pregame-odds` | Maç öncesi detaylı bahis oranları | Pre-match |
| 9 | `/unique-tournament/{id}/season/{sid}/top-players/goals` | Sezon gol krallığı | Sezon |
| 10 | `/unique-tournament/{id}/season/{sid}/top-players/assists` | Sezon asist krallığı | Sezon |
| 11 | `/unique-tournament/{id}/season/{sid}/top-players/rating` | Sezon reyting sıralaması | Sezon |
| 12 | `/unique-tournament/{id}/season/{sid}/team-events/total/{teamId}` | Takımın sezon maçları | Takım |
| 13 | `/team/{id}/near-events` | Takımın yaklaşan/son maçları | Takım |
| 14 | `/team/{id}/players` | Takım kadrosu (SofaScore perspektifinden) | Takım |
| 15 | `/unique-tournament/{id}/season/{sid}/statistics` | Lig istatistikleri (genel) | Sezon |

**Revizyon:** Bölüm 3C'ye bu endpoint'ler eklenmeli. Özellikle `/event/{id}/shotmap` zaten API'den çekilebiliyor — Playwright'a gerek yok.

---

### R3. EKSİK TRANSFERMARKT VERİLERİ

Planda 12 veri kategorisi var, ancak Transfermarkt'tan şunlar da çekilebilir:

| # | Veri | Detay |
|---|------|-------|
| 1 | **Stadyum bilgisi** | Kapasite, adres, koordinatlar, yapım yılı |
| 2 | **Takım toplam piyasa değeri** | Kadronun toplam piyasa değeri |
| 3 | **Kadro yaş ortalaması** | Takım kadro demografisi |
| 4 | **Kontratı biten oyuncular** | 2026'da kontratı biten oyuncular (ayrı filtre) |
| 5 | **Milli takım oyuncuları** | Milli takım görevi nedeniyle eksik olabilecek oyuncular |
| 6 | **Oyuncu kariyer geçmişi** | Önceki kulüpler, toplam kariyer istatistikleri |
| 7 | **Takım performans geçmişi** | Son 5-10 sezon performans karşılaştırması |
| 8 | **Devre arası transferleri** | 2026 Ocak transfer penceresi hareketleri |

---

### R4. TRANSFERMARKT API vs DOĞRUDAN WEB SCRAPE (KRİTİK)

Mevcut kod `transfermarkt-api.fly.dev` (topluluk API'si) kullanıyor. Plan ise "Playwright ile doğrudan web scrape" diyor.

**Sorun:** Topluluk API'si:
- Sınırlı veri sunuyor (sadece kadro, sakatlık, profil)
- Her an kapanabilir (üçüncü parti)
- Söylenti, haber, cezalı, hakem, form verisi **yok**

**Öneri:** Hibrit yaklaşım:
1. Mevcut API ile hızlı çekilebilen verileri çek (kadro, sakatlık, profil)
2. API'de olmayan veriler için Playwright ile doğrudan `transfermarkt.com.tr` scrape et (söylenti, haber, cezalı, hakem ataması, stadyum)
3. API çökerse Playwright'a tam fallback mekanizması

---

### R5. MATCH STATUS TUTARSIZLIĞI

Plandaki Firestore şemasında maç durumu: `upcoming | live | finished`
Mevcut koddaki MatchResult type'ında: `finished | scheduled | postponed | cancelled`

**Revizyon:** Her iki durumu birleştir:
```typescript
status: 'scheduled' | 'upcoming' | 'prematch' | 'live' | 'halftime' | 'finished' | 'postponed' | 'cancelled' | 'abandoned'
```
SofaScore API `statusCode` döndürür: 0=notStarted, 6=inProgress, 7=halftime, 100=finished, vb. Bu kodları doğru map'lemek gerekir.

---

### R6. CHECKPOINT / RESUME MEKANİZMASI (KRİTİK EKSİK)

Plan, Full Scrape'in ~2-3 saat süreceğini söylüyor. Ancak **bu süre içinde scraper çökerse ne olacak** konusunda hiçbir plan yok.

**Eklenmesi gereken:**
```
scrape_state/{sessionId}
├── phase: "full" | "delta" | "live"
├── currentLeague: "super-lig"
├── currentTeamIndex: 12
├── completedLeagues: ["premier-league", "la-liga", ...]
├── completedMatches: ["2026-03-01_besiktas_vs_galatasaray", ...]
├── lastSuccessfulScrape: "2026-03-01T14:22:00Z"
└── resumable: true
```
Scraper başlarken bu state'i kontrol etmeli. Önceki çalışma yarım kaldıysa, kaldığı yerden devam edebilmeli.

---

### R7. SOFASCORE SEASON ID YÖNETİMİ (EKSİK)

SofaScore API'de standings ve top-players endpoint'leri `seasonId` gerektirir. Bu ID her sezon değişir ve lig bazlıdır.

**Eklenmesi gereken:** `src/config/leagues.ts` dosyasına:
```typescript
{
  key: 'super-lig',
  sofascoreId: 52,
  sofascoreSeasonId: 63814,  // 2025-26 sezonu için
  // ...
}
```
İlk çalıştırmada `/unique-tournament/{id}/seasons` endpoint'inden dinamik olarak da çekilebilir.

---

### R8. CANLI VERİ DETAY EKSİKLİĞİ

Plandaki Phase 3 (Live Tracker) iyi tasarlanmış ama **maç yaşam döngüsünün 3 aşaması** yeterince detaylandırılmamış:

**Maç Öncesi (Pre-match, T-60dk → T-0):**
- Tahmini/açıklanan kadro → `/event/{id}/lineups`
- Maç öncesi form → `/event/{id}/pregame-form`
- Isınma kadrosu açıklanınca → kadro güncelle
- Oranlar → `/event/{id}/pregame-odds`
- H2H → `/event/{id}/h2h`

**Maç Sırası (In-match, 0' → 90'+):**
- Skor + dakika → `/event/{id}` (30 sn)
- İstatistikler → `/event/{id}/statistics` (1 dk)
- Olaylar (gol, kart, değişiklik, VAR) → `/event/{id}/incidents` (30 sn)
- Canlı oranlar → `/event/{id}/odds` (2 dk)
- Momentum → `/event/{id}/graph` (2 dk)
- Şut haritası (canlı güncellenen) → `/event/{id}/shotmap` (2 dk)

**Maç Sonrası (Post-match, FT → +2 saat):**
- Final istatistikler (düzeltilmiş)
- Oyuncu reytingleri → `/event/{id}/best-players`
- xG final değerleri
- Şut haritası (final)
- MOTM
- Oylama sonuçları → `/event/{id}/votes`

**Revizyon:** Live tracker'a bu 3 aşama ayrı ayrı eklenmeli. Firestore `live/` koleksiyonuna `phase: 'prematch' | 'inplay' | 'postmatch'` alanı eklenmeli.

---

### R9. PARALEL SCRAPE STRATEJİSİ (PERFORMANS)

Plan tüm ligleri sırayla işliyor. 11 lig × ortalama 300 maç = ~3300 maç tek sırayla çekmek çok yavaş.

**Öneri:**
- SofaScore API: 2-3 paralel worker (farklı ligler), her biri kendi rate limiti ile
- Transfermarkt Web: 1 Playwright instance (ban riski yüksek, paralel yapılmamalı)
- Her worker kendi progress'ini raporlamalı

---

### R10. PROXY / IP ROTATION (GÜVENLİK EKSİĞİ)

Plan sadece User-Agent rotation'dan bahsediyor. Ancak:
- SofaScore ve Transfermarkt IP bazlı da ban uygular
- Aynı IP'den saatlerce scrape yapmak ban riski taşır

**Öneri (opsiyonel ama önerilir):**
- Residential proxy havuzu (SmartProxy, BrightData vb.)
- En azından 3-5 farklı proxy IP ile rotation
- Ban tespitinde otomatik proxy değiştirme
- Alternatif: VPN rotation script'i

---

### R11. FIRESTORE ŞEMASINA EKLEMELER

Mevcut kodda `COLLECTIONS` sadece 6 koleksiyon tanımlıyor. Plandaki `live` ve `players` eklenmeli, ayrıca:

```typescript
export const COLLECTIONS = {
  seasons: 'seasons',
  leagues: 'leagues',
  teams: 'teams',
  matches: 'matches',
  players: 'players',          // YENİ
  live: 'live',                // YENİ
  referees: 'referees',
  scrapeHistory: 'scrapeHistory',
  scrapeState: 'scrapeState',  // YENİ — checkpoint/resume için
  seasonStats: 'seasonStats',  // YENİ — gol/asist krallığı vb.
} as const;
```

---

### R12. DELTA GÜNCELLEME İÇİN HASH ALGORİTMASI DETAYI

Plan "hash karşılaştırma" diyor ama detay yok. Önerilen yaklaşım:

```typescript
import crypto from 'crypto';

function dataHash(data: any): string {
  // lastUpdated, sources gibi meta alanları hash dışı bırak
  const { lastUpdated, sources, ...core } = data;
  return crypto.createHash('md5')
    .update(JSON.stringify(core, Object.keys(core).sort()))
    .digest('hex');
}

// Kullanım:
const oldHash = existingDoc.dataHash;
const newHash = dataHash(newData);
if (oldHash !== newHash) {
  await writer.writeMatch(key, { ...newData, dataHash: newHash });
}
```

Her Firestore dokümanına `dataHash` alanı eklenmeli.

---

### R13. WEB/MOBİL APP ENTEGRASYONU EKSİKLERİ

Plandaki entegrasyon kodu sadece `live/` koleksiyonunu dinliyor. Ancak app'te şunlar da lazım:

1. **Bugünün maçları listesi** → `matches` koleksiyonundan `date == today && status in ['scheduled','live']` query
2. **Lig puan tablosu** → `leagues/{leagueKey}` → `standings` alanı
3. **Takım detay sayfası** → `teams/{slug}` → kadro, sakatlık, söylenti
4. **Oyuncu detay sayfası** → `players/{id}` → istatistik, değer, sakatlık geçmişi
5. **Push notification** → Gol atıldığında Firebase Cloud Messaging (FCM)

**Push notification eklenmeli:** Canlı maçta gol/kart olayı tespit edildiğinde FCM ile mobil app'e bildirim gönderilmeli.

---

### R14. MEVCUT KODDAKİ FBref VERİSİ İLE ENTEGRASYON

Plan "FBref, Understat, StatsBomb silinecek" diyor. Ancak:
- `data/fbref/` klasöründe **3.456 maç** verisi var (oyuncu istatistikleri, şut haritası, formasyon, pas tipleri)
- Bu veri hâlâ değerli — SofaScore'da olmayan pas tipleri (short/medium/long/progressive) burada var

**Öneri:** FBref botunu silmek yerine:
1. FBref botunu **pasif moda** al (yeni veri çekmesin)
2. Mevcut 3.456 maç verisini Firestore'a migrate et (bir seferlik)
3. `MatchData` type'ında `fbref?` alanını koru — geçmiş veri için
4. Sadece SofaScore + Transfermarkt aktif scraper olarak çalışsın

---

### R15. SOFASCORE WEB SCRAPE vs API KARARI

Plan, SofaScore için hem Web Scrape (Playwright) hem API kullanıyor. Ancak mevcut incelemeye göre:

- Planda "Playwright ile web scrape" denilen verilerin çoğu (xG, şut haritası, momentum, kadro, olaylar, oranlar, H2H) **zaten API'den çekilebiliyor**
- Playwright sadece API'de olmayan veriler için gerekli (heatmap, bazı detaylı görsel veriler)

**Öneri:** Playwright kullanımını minimuma indir:
- **API ile çek:** İstatistikler, xG, şut haritası, kadro, olaylar, oranlar, H2H, momentum, reytingler, form, best players
- **Playwright ile çek (sadece gerekirse):** Oyuncu ısı haritası, maç grafiği (eğer API yetmezse)

Bu yaklaşım ban riskini büyük ölçüde azaltır ve hızı artırır.

---

## Claude Yorumları:

### Y1. Genel Değerlendirme
Plan **güçlü bir temel** oluşturuyor. 3 fazlı mimari (Full → Delta → Live), Firestore şeması ve rate limiting stratejisi doğru tasarlanmış. Kullanıcının istekleri — "aynı takımlar için transfermarkt ve sofascore scrape, 30 dk delta, canlı veri" — büyük ölçüde karşılanıyor.

### Y2. En Kritik Eksikler (Hemen Eklenmeli)
1. **Checkpoint/Resume** (R6): 2-3 saatlik full scrape'de çökme riski yüksek. Bu olmadan production'a çıkılmamalı.
2. **Eksik API endpoint'leri** (R2): SofaScore'dan çekilebilecek 15+ veri noktası eksik. "Çekilebilecek tüm verileri çekmek istiyorum" isteğini tam karşılamıyor.
3. **Season ID yönetimi** (R7): Bu olmadan standings ve top-players çekilemez.
4. **Maç yaşam döngüsü** (R8): Pre-match → In-match → Post-match ayrımı yapılmadan canlı veri eksik kalır.

### Y3. Maliyet Analizi
Firestore maliyet tahmini yapılmamış. Yaklaşık hesap:
- 11 turnuva × ~300 maç = ~3.300 maç dokümanı
- 150+ takım dokümanı
- ~3.750 oyuncu dokümanı (eğer players koleksiyonu açılırsa)
- Live koleksiyonu: Günde ~20-30 maç × 30 sn güncelleme = günde ~50.000-80.000 write
- Delta update: 48 çalışma/gün × ~200 kontrol = ~10.000 read/gün
- **Tahmini aylık Firestore maliyeti:** ~$15-30 (Spark plan ücretsiz sınırları içinde başlangıçta yeterli olabilir ama canlı veri ile aşılır)

### Y4. Önemli Tasarım Kararı: SofaScore API Rate Limit
Mevcut kodda SofaScore bot'u **25 saniye** delay kullanıyor (çok yavaş). Plan **2-3 saniye** diyor.
- SofaScore API gerçek rate limit'i yaklaşık **60-100 request/dakika** civarında (deneyimsel)
- Ancak 403 ban yedikten sonra recovery uzun sürüyor
- **Öneri:** 3-4 saniye delay ile başla, 403 gelirse otomatik 10 saniyeye çık, 3 ardışık 403'te 5 dakika bekle

### Y5. Güçlü Yönler (Değiştirmeye Gerek Yok)
- Hash bazlı delta güncelleme konsepti mükemmel
- Firestore `merge: true` kullanımı doğru (mevcut kodda var)
- Cloudflare koruma stratejisi (stealth plugin, UA rotation, backoff) iyi
- Web/Mobil app entegrasyonu için `onSnapshot()` realtime listener yaklaşımı doğru
- Orchestrator'ın 3 fazlı mimarisi uygun

### Y6. Risk Değerlendirmesi

| Risk | Olasılık | Etki | Önlem |
|------|----------|------|-------|
| SofaScore API ban | Yüksek | Kritik | Proxy rotation, adaptive rate limit |
| Transfermarkt Cloudflare block | Yüksek | Yüksek | Stealth plugin, düşük frekans |
| Topluluk TM API kapanması | Orta | Yüksek | Playwright fallback hazır olmalı |
| Firestore maliyet patlaması | Düşük | Orta | Write sayısı monitoring, budget alert |
| Scraper crash (memory leak) | Orta | Orta | Checkpoint/resume, process manager (PM2) |
| Veri tutarsızlığı (kaynaklar arası) | Orta | Düşük | Cross-validation checks |

### Y7. Önerilen Uygulama Öncelik Sırası
Plandaki "10 adım" doğru ama sıralama şöyle olmalı:

1. Types/schemas güncelle (temel, her şey buna bağlı)
2. Team mappings oluştur (150+ takım: slug ↔ sofascoreId ↔ tmId ↔ seasonId)
3. Firestore Writer güncelle (delta hash, live, players, scrapeState)
4. SofaScore API scraper'ı yeniden yaz (tüm endpoint'lerle)
5. SofaScore Live Tracker yaz
6. Transfermarkt hibrit scraper yaz (API + Playwright fallback)
7. Orchestrator yeniden yaz (3 faz + checkpoint/resume)
8. Eski botları sil / pasif al
9. Test & debug
10. Web/Mobile app entegrasyonu + push notification
