# FutbolAI Scraper Plan v2 — FBref + SofaScore + Transfermarkt
**Tarih:** 01 Mart 2026
**Proje:** R:\YDev\futbol-data-scraper
**Hedef:** 3 kaynak (FBref + SofaScore + Transfermarkt) odakli, tum veriyi ceken, canli veri destekli scraper
**Revizyon:** v2 — FBref dahil, eski veri sifirlanacak, 3 kaynaktan TUM veriler cekilecek

---

## 1. MEVCUT DURUM & v1 FARKLARI

### v1 → v2 Karsilastirma Tablosu

| Ozellik | v1 (Orijinal Plan) | v2 (Bu Plan) |
|---------|-------------------|--------------|
| **Kaynak sayisi** | 2 (SofaScore + Transfermarkt) | 3 (FBref + SofaScore + Transfermarkt) |
| **FBref** | Silinecekti | Kalacak, genisletilecek (3. kaynak) |
| **Understat** | Silinecekti | Silinecek (xG icin SofaScore yeterli) |
| **StatsBomb** | Silinecekti | Silinecek (sinirli veri) |
| **Eski veri** | Migration dusunuluyordu | Tum eski veri silinecek, sifirdan baslanacak |
| **Veri kapsami** | Secili kategoriler | TUM cekilebilen veriler (haber/dergi dahil) |
| **FBref STAT_TYPES** | 8 tip | 12 tip (passing_types, playingtime, keeper_adv, wages eklendi) |
| **SofaScore endpoint** | 7 endpoint | 42 endpoint (event, turnuva, takim, oyuncu, canli, arama) |
| **Transfermarkt** | Sadece community API | Hibrit: Community API + Playwright fallback |
| **Firestore koleksiyon** | 6 koleksiyon | 12 koleksiyon |
| **Oyuncu verisi** | Opsiyonel | Zorunlu — detayli oyuncu profili |
| **TD verisi** | Minimal | Detayli — kariyer, taktik, gecmis |
| **Haber/Icerik** | Yok | Transfermarkt + FBref haberleri cekilecek |
| **Push Notification** | Yok | FCM entegrasyonu |
| **Checkpoint/Resume** | Yok | scrapeState koleksiyonu ile |
| **xG kaynagi** | SofaScore + FBref | Sadece SofaScore (FBref Ocak 2026'da xG kaldirdi) |

### 11 Lig/Turnuva Listesi (Mevcut Kodda Tanimli)

| # | Lig | Ulke | FBref ID | SofaScore ID | Takim Sayisi |
|---|-----|------|:---:|:---:|:---:|
| 1 | Premier League | England | 9 | 17 | 20 |
| 2 | La Liga | Spain | 12 | 8 | 20 |
| 3 | Serie A | Italy | 11 | 23 | 20 |
| 4 | Bundesliga | Germany | 20 | 35 | 18 |
| 5 | Ligue 1 | France | 13 | 34 | 18 |
| 6 | Super Lig | Turkey | 26 | 52 | 18 |
| 7 | Eredivisie | Netherlands | 23 | 37 | 18 |
| 8 | Primeira Liga | Portugal | 32 | 238 | 18 |
| 9 | Champions League | Europe | 8 | 7 | Degisken |
| 10 | Europa League | Europe | 19 | 679 | Degisken |
| 11 | Conference League | Europe | 882 | 17015 | Degisken |

> **Toplam:** 8 lig (~170 takim) + 3 Avrupa kupasi (takim tekrari olabilir, ek mac sayisi)

---

## 2. YENi MiMARi

```
┌──────────────────────────────────────────────────────────────────────────┐
│                        ORCHESTRATOR v2                                   │
│                                                                          │
│  Mode 1: FULL SCRAPE  (ilk calistirma, ~4-6 saat)                      │
│  Mode 2: DELTA UPDATE (30 dk'da bir, hash bazli)                        │
│  Mode 3: LIVE TRACKER (surekli, pre/in/post-match)                      │
│                                                                          │
│  + Checkpoint/Resume (scrapeState koleksiyonu)                           │
│  + Worker Manager (paralel scrape kontrolu)                              │
│                                                                          │
└───────┬──────────────┬──────────────┬────────────────────────────────────┘
        │              │              │
┌───────▼──────┐ ┌─────▼──────┐ ┌─────▼────────┐
│   FBref      │ │  SofaScore │ │ Transfermarkt│
│  WORKER      │ │  WORKER    │ │ WORKER       │
│ (Playwright  │ │ (Axios +   │ │ (API +       │
│  + Cheerio)  │ │  Playwright│ │  Playwright) │
│              │ │  fallback) │ │              │
│ • Fikstur    │ │            │ │ • Kadro API  │
│ • Mac raporu │ │ • 19 Event │ │ • Sakatlik   │
│ • 12 stat    │ │   endpoint │ │ • Profil     │
│   tipi       │ │ • 11 Turnu.│ │ • TD bilgisi │
│ • Oyuncu pg. │ │   endpoint │ │              │
│ • Scouting   │ │ • 5 Takim  │ │ [Playwright] │
│ • Wages      │ │   endpoint │ │ • Soylenti   │
│              │ │ • 7 Oyuncu │ │ • Haber      │
│              │ │   endpoint │ │ • Cezali     │
│              │ │ • Canli    │ │ • Hakem      │
│              │ │ • Arama    │ │ • Transfer   │
│              │ │            │ │ • Stadyum    │
│              │ │            │ │ • Form       │
│              │ │            │ │ • Oyuncu st. │
│              │ │            │ │ • Piyasa deg │
│              │ │            │ │ • TD gecmisi │
│              │ │            │ │ • Kontrat    │
└──────────────┘ └────────────┘ └──────────────┘
        │              │              │
        └──────────────┼──────────────┘
                       ▼
             ┌─────────────────┐
             │   DATA MERGER   │
             │                 │
             │ • matchKey esle  │
             │ • capraz kontrol│
             │ • dataHash uret │
             │ • completeness  │
             │   skoru hesapla │
             └────────┬────────┘
                      │
             ┌────────▼────────┐
             │  Firestore DB   │
             │                 │
             │ leagues/        │
             │ teams/          │
             │ matches/        │
             │ players/        │  ← Detayli oyuncu
             │ managers/       │  ← Teknik direktorler
             │ live/           │  ← Canli mac verisi
             │ referees/       │
             │ news/           │  ← Haber/icerik
             │ scrapeHistory/  │
             │ scrapeState/    │  ← Checkpoint/resume
             │ seasonStats/    │  ← Gol/asist kralligi
             │ seasons/        │
             └────────┬────────┘
                      │
           ┌──────────┴──────────┐
           ▼                     ▼
   ┌──────────────┐    ┌──────────────┐
   │  Flutter App │    │  FCM Push    │
   │  (Firestore  │    │  Notification│
   │   Realtime)  │    │              │
   └──────────────┘    └──────────────┘
```

---

## 3. VERi KAYNAKLARI & ENDPOINT'LER

### 3A. FBref (Playwright + Cheerio)

FBref HTML scraping ile cekilecek veriler. **Onemli:** FBref Ocak 2026'da xG/xA verilerini kaldirdi — xG artik tek kaynak SofaScore.

#### Fikstur & Mac Raporu

| # | Veri | URL Deseni | Aciklama |
|---|------|-----------|----------|
| 1 | **Lig Fiksturu** | `fbref.com/en/comps/{compId}/schedule/{LeagueName}-Scores-and-Fixtures` | Tum sezon maclari, tarih, skor, stadyum, hakem, mac raporu linki |
| 2 | **Mac Raporu** | `fbref.com/en/matches/{matchId}/{slug}` | Detayli mac istatistikleri (asagidaki tum veriler) |
| 3 | **Takim Istatistikleri** | `fbref.com/en/comps/{compId}/{statType}` | Sezon geneli takim ortalama istatistikleri |

#### 12 STAT_TYPES (8'den 12'ye genisletildi)

| # | statType | Aciklama | Mevcut | Yeni |
|---|----------|----------|:---:|:---:|
| 1 | `stats` | Genel istatistikler (mac, gol, asist, kart) | ✓ | |
| 2 | `keepers` | Kaleci istatistikleri (kurtaris, clean sheet) | ✓ | |
| 3 | `shooting` | Sut istatistikleri (sut, isabetli, sut/90dk) | ✓ | |
| 4 | `passing` | Pas istatistikleri (toplam, kisa, orta, uzun, key pass) | ✓ | |
| 5 | `gca` | Gol yaratan aksiyonlar (SCA, GCA) | ✓ | |
| 6 | `defense` | Defans (tackle, interception, bloklama) | ✓ | |
| 7 | `possession` | Top kontrolu (dokunma, dribling, tasima) | ✓ | |
| 8 | `misc` | Cesitli (sari/kirmizi, faul, ofsayt, top kaybi) | ✓ | |
| 9 | `passing_types` | Pas tipleri (canli pas, serbest vurus, kose vurus, uzun top, cros) | | ✓ |
| 10 | `playingtime` | Oynama suresi (baslangic 11, yedek giriş, dakika/90) | | ✓ |
| 11 | `keeper_adv` | Gelismis kaleci (PSxG, cikis, uzun pas, dagitim) | | ✓ |
| 12 | `wages` | Maas bilgileri (haftalik maas, yillik, % takım toplami) | | ✓ |

#### Oyuncu Sayfasi & Scouting

| # | Veri | URL Deseni | Cekilecek |
|---|------|-----------|-----------|
| 1 | **Oyuncu Profili** | `fbref.com/en/players/{playerId}/{slug}` | Dogum tarihi, milliyet, pozisyon, boy, kilo, ayak |
| 2 | **Oyuncu Scouting** | `fbref.com/en/players/{playerId}/scout/365_m1/{slug}-Scouting-Report` | Percentile rank (90dk basina), radar grafik verileri |
| 3 | **Oyuncu Mac Kaydi** | `fbref.com/en/players/{playerId}/matchlogs/2025-2026/{slug}` | Mac bazli performans kayitlari |
| 4 | **Oyuncu Karsilastirma** | `fbref.com/en/players/{playerId}/similar` | Benzer oyuncu onerileri (FBref similarity) |

---

### 3B. SofaScore API (Axios) — Tum Endpoint'ler

**Base URL:** `https://api.sofascore.com/api/v1`
**Not:** Asagidaki endpoint'lerin cogu Playwright gerektirmez, dogrudan Axios ile cekilebilir.

#### Event (Mac) Endpoint'leri — 19 Adet

| # | Endpoint | Veri | Guncelleme |
|---|----------|------|-----------|
| 1 | `GET /event/{id}` | Mac detay: takim, skor, durum, tarih, stadyum, hakem, sezon | Her zaman |
| 2 | `GET /event/{id}/statistics` | Mac istatistikleri: possession, sut, kose vurus, faul, ofsayt, pas, kurtaris | Bitince/canli |
| 3 | `GET /event/{id}/lineups` | Kadro: formasyon, ilk 11, yedekler, oyuncu rating | Mac basi |
| 4 | `GET /event/{id}/incidents` | Olaylar: gol, kart, degisiklik, VAR, penalti | Canli 30sn |
| 5 | `GET /event/{id}/odds/1/all` | Bahis oranlari: 1X2, U/A, handikap, tum marketler | Pre-match / canli |
| 6 | `GET /event/{id}/shotmap` | Sut haritasi: x,y koordinat, xG, sonuc, oyuncu | Bitince |
| 7 | `GET /event/{id}/graph` | Momentum/baski grafigi: dakika bazli degerler | Bitince/canli |
| 8 | `GET /event/{id}/best-players` | Macin en iyi oyunculari + MOTM | Bitince |
| 9 | `GET /event/{id}/h2h/events` | Kafa kafaya: son karsilasma sonuclari, tarihler | Pre-match |
| 10 | `GET /event/{id}/pregame-form` | Mac oncesi form: son 5-10 mac performansi | Pre-match |
| 11 | `GET /event/{id}/votes` | Taraftar oylama sonuclari (MOTM oylama) | Bitince |
| 12 | `GET /event/{id}/highlights` | Video ozet linkleri | Bitince |
| 13 | `GET /event/{id}/managers` | Mac bazli TD bilgisi | Her zaman |
| 14 | `GET /event/{id}/pregame-odds` | Mac oncesi detayli bahis oranlari | Pre-match |
| 15 | `GET /event/{id}/comments` | Mac yorumlari/canli yazi | Canli/bitince |
| 16 | `GET /event/{id}/missing-players` | Eksik oyuncular (sakatlik, ceza, milli takim) | Pre-match |
| 17 | `GET /event/{id}/standings` | Mac sirasindaki guncel puan tablosu | Her zaman |
| 18 | `GET /event/{id}/media` | Gorseller, fotograflar | Bitince |
| 19 | `GET /event/{id}/tweets` | Sosyal medya tepkileri | Bitince |

#### Turnuva (Lig) Endpoint'leri — 11 Adet

| # | Endpoint | Veri |
|---|----------|------|
| 1 | `GET /unique-tournament/{id}/season/{sid}/standings/total` | Genel puan tablosu |
| 2 | `GET /unique-tournament/{id}/season/{sid}/standings/home` | Ev sahibi puan tablosu |
| 3 | `GET /unique-tournament/{id}/season/{sid}/standings/away` | Deplasman puan tablosu |
| 4 | `GET /unique-tournament/{id}/season/{sid}/top-players/goals` | Gol kralligi |
| 5 | `GET /unique-tournament/{id}/season/{sid}/top-players/assists` | Asist kralligi |
| 6 | `GET /unique-tournament/{id}/season/{sid}/top-players/rating` | Reyting siralamasi |
| 7 | `GET /unique-tournament/{id}/season/{sid}/top-players/yellowCards` | Sari kart siralamasi |
| 8 | `GET /unique-tournament/{id}/season/{sid}/statistics` | Lig genel istatistikleri |
| 9 | `GET /unique-tournament/{id}/season/{sid}/rounds` | Hafta/tur bilgileri |
| 10 | `GET /unique-tournament/{id}/seasons` | Tum sezon ID'leri (dinamik seasonId bulma) |
| 11 | `GET /unique-tournament/{id}/season/{sid}/team-events/total/{teamId}` | Takimin sezon maclari |

#### Takim Endpoint'leri — 5 Adet

| # | Endpoint | Veri |
|---|----------|------|
| 1 | `GET /team/{id}/near-events` | Yaklasan + son maclar |
| 2 | `GET /team/{id}/players` | Takim kadrosu (SofaScore perspektifi) |
| 3 | `GET /team/{id}/transfers` | Transfer hareketleri |
| 4 | `GET /team/{id}/manager-history` | TD gecmisi |
| 5 | `GET /team/{id}/statistics/season/{sid}` | Takim sezon istatistikleri |

#### Oyuncu Endpoint'leri — 7 Adet

| # | Endpoint | Veri |
|---|----------|------|
| 1 | `GET /player/{id}` | Oyuncu profili: ad, dogum, milliyet, boy, pozisyon, numara |
| 2 | `GET /player/{id}/statistics/season/{sid}` | Sezon istatistikleri |
| 3 | `GET /player/{id}/transfer-history` | Transfer gecmisi |
| 4 | `GET /player/{id}/national-team-statistics` | Milli takim istatistikleri |
| 5 | `GET /player/{id}/characteristics` | Oyuncu ozellikleri (guc, hiz vb.) |
| 6 | `GET /player/{id}/last-year-summary` | Son yil ozet istatistik |
| 7 | `GET /player/{id}/heatmap/season/{sid}` | Sezon isi haritasi |

#### Canli & Arama

| # | Endpoint | Veri | Guncelleme |
|---|----------|------|-----------|
| 1 | `GET /sport/football/scheduled-events/{date}` | Gunun tum maclari | 30 dk |
| 2 | `GET /sport/football/live-events` | Su an canli olan maclar | 30 sn |
| 3 | `GET /search/multi?q={query}` | Oyuncu/takim/turnuva arama | Ihtiyac halinde |

---

### 3C. Transfermarkt (Community API + Playwright Fallback)

**Hibrit yaklasim:** Topluluk API'si (`transfermarkt-api.fly.dev`) ile hizli cekilebilen verileri cek, API'de olmayan veriler icin dogrudan `transfermarkt.com.tr` Playwright ile scrape et.

#### Community API Endpoint'leri — 11 Adet (Axios)

| # | Endpoint | Veri |
|---|----------|------|
| 1 | `GET /clubs/{slug}/players` | Takim kadrosu: oyuncu listesi, pozisyon, yas, deger |
| 2 | `GET /clubs/{slug}/injuries` | Sakatlik listesi: oyuncu, tur, tarih, beklenen donus |
| 3 | `GET /clubs/{slug}/profile` | Takim profili: TD, stadyum, kuruluş |
| 4 | `GET /clubs/{slug}/transfers` | Transfer gecmisi: gelen/giden, bedel |
| 5 | `GET /players/{id}/profile` | Oyuncu profili: detayli bilgi |
| 6 | `GET /players/{id}/transfers` | Oyuncu transfer gecmisi |
| 7 | `GET /players/{id}/stats` | Oyuncu kariyer istatistikleri |
| 8 | `GET /players/{id}/market-value` | Piyasa degeri gecmisi |
| 9 | `GET /competitions/{id}/clubs` | Lig takimlari listesi |
| 10 | `GET /competitions/{id}/table` | Puan tablosu |
| 11 | `GET /search?q={query}` | Arama (oyuncu, takim, TD) |

#### Playwright Scrape Kategorileri — 12 Adet (API'de Olmayan Veriler)

| # | Veri | URL Deseni | Cekilecek |
|---|------|-----------|-----------|
| 1 | **Transfer Soylentileri** | `transfermarkt.com.tr/ceapi/transferGeruechte/list/verein/{id}` | Oyuncu, hedef/kaynak kulup, tarih, guvenilirlik |
| 2 | **Haberler** | `transfermarkt.com.tr/{team}/news/verein/{id}` | Baslik, tarih, ozet, icerik, yazar |
| 3 | **Cezali Oyuncular** | `transfermarkt.com.tr/{team}/sperren/verein/{id}` | Kart cezalari, ceza suresi, donus tarihi |
| 4 | **Hakem Atamasi** | `transfermarkt.com.tr/{league}/schiedsrichter/wettbewerb/{id}` | Atanan hakem, hakem istatistikleri |
| 5 | **Stadyum Bilgisi** | `transfermarkt.com.tr/{team}/stadion/verein/{id}` | Kapasite, adres, koordinatlar, yapim yili |
| 6 | **Takim Formu** | `transfermarkt.com.tr/{team}/spielplan/verein/{id}` | Son maclar, sonuclar, seri |
| 7 | **TD Gecmisi** | `transfermarkt.com.tr/{team}/mitarbeiter/verein/{id}` | Onceki TD'ler, gorev suresi, basari |
| 8 | **Kontrati Bitenler** | `transfermarkt.com.tr/{team}/vertragsende/verein/{id}` | 2026'da kontrati biten oyuncular |
| 9 | **Oyuncu Detay Stat** | `transfermarkt.com.tr/{player}/leistungsdatendetails/spieler/{id}` | Mac bazli detayli istatistik |
| 10 | **Kadro Yaş Ort.** | `transfermarkt.com.tr/{team}/kader/verein/{id}` | Yas dagilimi, kadro ortalama yas |
| 11 | **Takimin Toplam Degeri** | `transfermarkt.com.tr/{team}/startseite/verein/{id}` | Kadronun toplam piyasa degeri |
| 12 | **Devre Arasi Transferleri** | `transfermarkt.com.tr/{team}/transfers/verein/{id}/saison_id/2025` | Ocak 2026 transfer penceresi |

---

## 4. CALISMA MODELi

### Mode 1: Full Scrape (Ilk Calistirma — ~4-6 saat)

```
BASLANGIC
│
├─ 0. Eski veriyi sil (data/ klasorleri + Firestore koleksiyonlari temizle)
│
├─ 1. SofaScore API: Tum sezon maclari
│   ├─ Her lig icin /scheduled-events/{date} ile Agustos 2025 → bugun
│   ├─ Her mac icin: 19 event endpoint (stats, shotmap, lineups, incidents, odds, H2H, graph, vb.)
│   ├─ Gelecek fikstur maclari da cek (kadrosuz)
│   ├─ Turnuva endpoint'leri: puan tablosu, gol/asist kralligi, istatistikler
│   └─ Checkpoint: her lig bitiminde scrapeState kaydet
│
├─ 2. FBref Scrape: Tum sezon verileri
│   ├─ Her lig icin fikstur sayfasindan mac listesi
│   ├─ Her oynanmis mac icin mac raporu (12 stat tipi)
│   ├─ Takim sezon ortalama istatistikleri
│   ├─ Oyuncu scouting raporlari (percentile)
│   └─ Maas bilgileri (wages stat type)
│
├─ 3. Transfermarkt: 170+ takimin TUM verileri
│   ├─ API: Kadro, sakatlik, profil, transfer gecmisi, piyasa degeri
│   ├─ Playwright: Soylenti, haber, cezali, hakem, stadyum, TD gecmisi
│   └─ Her oyuncu: detayli stat + deger gecmisi + kariyer
│
├─ 4. Data Merger: Capraz kaynak esleme
│   ├─ matchKey bazli: FBref + SofaScore mac verilerini birlestir
│   ├─ slug bazli: Takim verilerini birlestir (3 kaynak)
│   └─ dataHash uret (delta kontrol icin)
│
└─ 5. Firestore'a yaz
    └─ 12 koleksiyona batch write
```

**Tahmini sure:** ~4-6 saat (rate limit korumasiyla, 3 kaynak paralel)

### Mode 2: Delta Update (Her 30 dakikada bir)

```
DELTA DONGU (30 dk)
│
├─ 1. SofaScore API: Bugun + yarin maclari
│   └─ Yeni mac var mi? Kadro aciklandi mi? Stat guncellendi mi?
│
├─ 2. FBref: Son oynanan maclarin raporlari
│   └─ Henuz cekilmemis mac raporlari
│
├─ 3. Transfermarkt: Sakatlik + soylenti + haber kontrolu
│   └─ Son 30 dk'da degisiklik var mi?
│
├─ 4. Data Merger: Hash karsilastirma
│   └─ oldHash !== newHash → guncelle, ayni ise YAZMA
│
├─ 5. Puan tablosu + gol kralligi guncelle
│
└─ 6. Firestore: Sadece DEGISEN veriyi yaz
    └─ Tasarruf: ~%70-80 daha az write
```

### Mode 3: Live Tracker (Pre/In/Post-Match)

```
CANLI MAC YASAM DONGUSU

PRE-MATCH (Mac oncesi, T-60dk → T-0)
├─ /event/{id}/lineups → Beklenen/aciklanan kadro
├─ /event/{id}/pregame-form → Mac oncesi form
├─ /event/{id}/pregame-odds → Mac oncesi oranlar
├─ /event/{id}/h2h/events → Kafa kafaya
├─ /event/{id}/missing-players → Eksik oyuncular
└─ Firestore live/{matchKey} → phase: 'prematch'

IN-MATCH (Mac sirasi, 0' → 90'+)
├─ /event/{id} → Skor + dakika (30 sn)
├─ /event/{id}/statistics → Istatistikler (1 dk)
├─ /event/{id}/incidents → Olaylar: gol, kart, degisiklik, VAR (30 sn)
├─ /event/{id}/odds/1/all → Canli oranlar (2 dk)
├─ /event/{id}/graph → Momentum (2 dk)
├─ /event/{id}/shotmap → Sut haritasi canli (2 dk)
├─ Gol/kart tespitinde → FCM push notification
└─ Firestore live/{matchKey} → phase: 'inplay'

POST-MATCH (Mac sonrasi, FT → +2 saat)
├─ /event/{id}/statistics → Final istatistikler (duzeltilmis)
├─ /event/{id}/best-players → MOTM + en iyi oyuncular
├─ /event/{id}/shotmap → Final sut haritasi + xG
├─ /event/{id}/votes → Taraftar oylama sonuclari
├─ /event/{id}/highlights → Video ozet linkleri
├─ /event/{id}/comments → Mac yorumlari
├─ Firestore matches/{matchKey} → final veri yaz
├─ Firestore live/{matchKey} → phase: 'postmatch', 2 saat sonra sil
└─ Puan tablosu + gol/asist kralligi guncelle
```

---

## 5. FiRESTORE SEMASI (12 Koleksiyon)

### `leagues/{leagueKey}`
```json
{
  "name": "Super Lig",
  "country": "Turkey",
  "season": "2025-26",
  "sofascoreId": 52,
  "fbrefId": 26,
  "sofascoreSeasonId": 63814,
  "transfermarktId": "TR1",
  "standings": {
    "total": [
      { "rank": 1, "team": "galatasaray", "played": 24, "won": 18, "drawn": 3, "lost": 3, "goalsFor": 55, "goalsAgainst": 18, "goalDifference": 37, "points": 57, "form": ["W","W","D","W","L"] }
    ],
    "home": [],
    "away": []
  },
  "topScorers": [{ "player": "...", "team": "...", "goals": 14, "playerId": "..." }],
  "topAssists": [{ "player": "...", "team": "...", "assists": 9, "playerId": "..." }],
  "topRatings": [{ "player": "...", "team": "...", "rating": 7.8, "playerId": "..." }],
  "dataHash": "a1b2c3d4e5f6...",
  "lastUpdated": "2026-03-01T12:00:00Z"
}
```

### `teams/{teamSlug}`
```json
{
  "name": "Besiktas",
  "slug": "besiktas",
  "league": "super-lig",
  "ids": { "sofascore": 3050, "transfermarkt": "114", "fbref": "d6c0a960" },
  "manager": {
    "name": "Giovanni van Bronckhorst",
    "since": "2025-06-15",
    "matches": 28,
    "winRate": 57,
    "nationality": "Netherlands",
    "previousClubs": ["Rangers", "Feyenoord"]
  },
  "stadium": {
    "name": "Tupras Stadyumu",
    "capacity": 42590,
    "city": "Istanbul",
    "coordinates": { "lat": 41.0397, "lng": 28.9950 },
    "builtYear": 2016
  },
  "squad": [
    {
      "name": "Ciro Immobile", "position": "FW", "number": 17, "age": 36,
      "marketValue": 3500000, "contractUntil": "2026-06-30", "status": "fit",
      "nationality": "Italy", "sofascoreId": 87246, "transfermarktId": "105521",
      "weeklyWage": null
    }
  ],
  "injuries": [
    { "player": "Rafa Silva", "type": "Hamstring", "since": "2026-02-15", "expectedReturn": "2026-03-15", "gamesMissed": 3 }
  ],
  "suspended": [
    { "player": "Gedson Fernandes", "reason": "5. sari kart", "returnDate": "2026-03-08" }
  ],
  "transferRumors": [
    { "player": "X Player", "type": "in", "source": "...", "date": "2026-02-28", "reliability": "medium" }
  ],
  "transfers": {
    "in": [{ "player": "...", "from": "...", "fee": 5000000, "date": "2026-01-15" }],
    "out": [{ "player": "...", "to": "...", "fee": 3000000, "date": "2026-01-20" }]
  },
  "news": [
    { "title": "...", "date": "2026-03-01", "summary": "...", "source": "transfermarkt", "url": "..." }
  ],
  "recentForm": ["W", "W", "L", "D", "W"],
  "totalSquadValue": 85000000,
  "averageAge": 27.3,
  "managerHistory": [
    { "name": "Senol Gunes", "from": "2024-01-01", "to": "2025-05-30", "matches": 45, "winRate": 48 }
  ],
  "seasonStats": {
    "2025-2026": {
      "fbref": { "possession": 55.2, "shotsPerGame": 14.1, "passAccuracy": 84.3 },
      "sofascore": { "avgRating": 6.85, "cleanSheets": 8 }
    }
  },
  "dataHash": "...",
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
  "status": "finished",
  "round": "26",
  "homeTeam": { "slug": "besiktas", "name": "Besiktas", "sofascoreId": 3050 },
  "awayTeam": { "slug": "galatasaray", "name": "Galatasaray", "sofascoreId": 3061 },
  "referee": { "name": "Cuneyt Cakir", "sofascoreId": null },
  "stadium": "Tupras Stadyumu",
  "attendance": 41250,
  "score": { "home": 2, "away": 1, "ht": { "home": 1, "away": 0 } },
  "statistics": {
    "possession": { "home": 52, "away": 48 },
    "shots": { "home": 14, "away": 11 },
    "shotsOnTarget": { "home": 6, "away": 4 },
    "corners": { "home": 7, "away": 5 },
    "fouls": { "home": 12, "away": 15 },
    "offsides": { "home": 2, "away": 3 },
    "saves": { "home": 3, "away": 4 },
    "passes": { "home": 456, "away": 412 },
    "passAccuracy": { "home": 84, "away": 81 },
    "tackles": { "home": 18, "away": 22 },
    "interceptions": { "home": 11, "away": 14 }
  },
  "xg": {
    "home": 1.82,
    "away": 1.15,
    "source": "sofascore"
  },
  "shotMap": [
    { "player": "Immobile", "team": "home", "minute": 23, "x": 88.5, "y": 45.2, "xg": 0.42, "result": "goal", "bodyPart": "right-foot" }
  ],
  "lineups": {
    "home": {
      "formation": "4-2-3-1",
      "startXI": [{ "name": "...", "number": 1, "position": "GK", "rating": 7.2, "sofascoreId": 12345 }],
      "substitutes": [{ "name": "...", "number": 12, "position": "GK" }]
    },
    "away": {}
  },
  "incidents": [
    { "type": "goal", "team": "home", "player": "Immobile", "minute": 23, "assist": "Gedson", "detail": "right-foot" },
    { "type": "yellowCard", "team": "away", "player": "...", "minute": 34 },
    { "type": "substitution", "team": "home", "playerIn": "...", "playerOut": "...", "minute": 65 },
    { "type": "var", "team": "away", "minute": 70, "detail": "Goal cancelled - offside" }
  ],
  "odds": {
    "prematch": { "home": 2.10, "draw": 3.30, "away": 3.80, "over25": 1.75, "under25": 2.05 },
    "live": null
  },
  "h2h": {
    "totalMatches": 15,
    "homeWins": 6, "draws": 4, "awayWins": 5,
    "lastMatches": [
      { "date": "2025-12-15", "home": "Galatasaray", "away": "Besiktas", "score": "2-1" }
    ]
  },
  "momentum": [{ "minute": 1, "value": 0 }, { "minute": 45, "value": 35 }],
  "bestPlayers": {
    "motm": { "name": "Immobile", "rating": 8.5 },
    "home": [{ "name": "...", "rating": 8.5 }],
    "away": [{ "name": "...", "rating": 7.1 }]
  },
  "votes": { "home": 65, "draw": 15, "away": 20 },
  "highlights": [{ "title": "...", "url": "..." }],
  "fbref": {
    "playerStats": { "home": [], "away": [] },
    "passTypes": { "home": {}, "away": {} },
    "formations": { "home": "4-2-3-1", "away": "4-3-3" }
  },
  "sources": ["sofascore", "fbref", "transfermarkt"],
  "dataCompleteness": 0.92,
  "dataHash": "...",
  "lastUpdated": "2026-03-08T21:15:00Z"
}
```

### `players/{playerId}`
```json
{
  "name": "Ciro Immobile",
  "slug": "ciro-immobile",
  "ids": { "sofascore": 87246, "transfermarkt": "105521", "fbref": "a1b2c3d4" },
  "team": "besiktas",
  "league": "super-lig",
  "position": "FW",
  "nationality": "Italy",
  "dateOfBirth": "1990-02-20",
  "height": 185,
  "weight": 85,
  "preferredFoot": "right",
  "number": 17,
  "contractUntil": "2026-06-30",
  "weeklyWage": null,
  "marketValue": 3500000,
  "marketValueHistory": [
    { "date": "2025-12-01", "value": 4000000 },
    { "date": "2025-06-01", "value": 5000000 }
  ],
  "seasonStats": {
    "2025-2026": {
      "matches": 22, "goals": 14, "assists": 5, "minutes": 1890,
      "yellowCards": 3, "redCards": 0,
      "shotsPerGame": 3.2, "passAccuracy": 78,
      "rating": 7.45,
      "xG": 12.8, "xA": 3.2
    }
  },
  "careerHistory": [
    { "team": "Lazio", "from": "2016", "to": "2024", "matches": 280, "goals": 207 },
    { "team": "Besiktas", "from": "2024", "to": null, "matches": 45, "goals": 22 }
  ],
  "scouting": {
    "percentiles": {
      "goalsP90": 95, "assistsP90": 72, "shotsP90": 88,
      "xGP90": 91, "pressuresP90": 35
    },
    "source": "fbref"
  },
  "injuries": [
    { "type": "Knee", "from": "2025-10-01", "to": "2025-11-15", "days": 45 }
  ],
  "nationalTeam": {
    "team": "Italy",
    "caps": 57,
    "goals": 17
  },
  "dataHash": "...",
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `managers/{managerId}`
```json
{
  "name": "Giovanni van Bronckhorst",
  "slug": "giovanni-van-bronckhorst",
  "ids": { "sofascore": null, "transfermarkt": "5765" },
  "nationality": "Netherlands",
  "dateOfBirth": "1975-02-05",
  "currentTeam": "besiktas",
  "currentLeague": "super-lig",
  "since": "2025-06-15",
  "currentStats": {
    "matches": 28,
    "wins": 16,
    "draws": 5,
    "losses": 7,
    "winRate": 57.1,
    "goalsFor": 48,
    "goalsAgainst": 28,
    "avgGoalsFor": 1.71,
    "avgGoalsAgainst": 1.00
  },
  "preferredFormation": "4-2-3-1",
  "careerHistory": [
    { "team": "Rangers", "from": "2021-11", "to": "2022-11", "matches": 55, "winRate": 60 },
    { "team": "Feyenoord", "from": "2015-05", "to": "2019-05", "matches": 190, "winRate": 52 }
  ],
  "dataHash": "...",
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `live/{matchKey}` (Canli maclar icin gecici koleksiyon)
```json
{
  "matchKey": "2026-03-08_besiktas_vs_galatasaray",
  "phase": "inplay",
  "minute": 67,
  "score": { "home": 2, "away": 1 },
  "statistics": {
    "possession": { "home": 54, "away": 46 },
    "shots": { "home": 12, "away": 8 }
  },
  "xg": { "home": 1.65, "away": 0.92 },
  "lastIncident": { "type": "goal", "player": "Immobile", "team": "home", "minute": 65 },
  "odds": { "home": 1.35, "draw": 5.50, "away": 9.00 },
  "momentum": { "current": 65, "trend": "home" },
  "updatedAt": "2026-03-08T20:15:30Z"
}
```

### `referees/{refereeSlug}`
```json
{
  "name": "Cuneyt Cakir",
  "slug": "cuneyt-cakir",
  "nationality": "Turkey",
  "league": "super-lig",
  "seasonStats": {
    "matches": 12,
    "avgFouls": 24.5,
    "avgCards": 4.2,
    "avgYellowCards": 3.8,
    "avgRedCards": 0.4,
    "penaltiesGiven": 3
  },
  "recentMatches": [
    { "matchKey": "...", "date": "...", "teams": "...", "cards": 5, "fouls": 28 }
  ],
  "dataHash": "...",
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `news/{newsId}`
```json
{
  "title": "Besiktas, transfer bombasini patlatti!",
  "date": "2026-03-01T10:00:00Z",
  "summary": "...",
  "content": "...",
  "source": "transfermarkt",
  "sourceUrl": "https://...",
  "author": "...",
  "relatedTeam": "besiktas",
  "relatedPlayers": ["player-slug-1"],
  "category": "transfer",
  "dataHash": "...",
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `scrapeHistory/{autoId}`
```json
{
  "startedAt": "2026-03-01T10:00:00Z",
  "completedAt": "2026-03-01T14:30:00Z",
  "duration": "4h 30m",
  "mode": "full",
  "bots": {
    "fbref": { "status": "completed", "matches": 2100, "teams": 170, "errors": 3 },
    "sofascore": { "status": "completed", "matches": 3300, "events": 15400, "errors": 12 },
    "transfermarkt": { "status": "completed", "teams": 170, "players": 3750, "errors": 5 }
  },
  "totalWrites": 25000,
  "totalErrors": 20
}
```

### `scrapeState/{sessionId}` (Checkpoint/Resume)
```json
{
  "phase": "full",
  "currentBot": "sofascore",
  "currentLeague": "super-lig",
  "currentLeagueIndex": 5,
  "currentMatchIndex": 142,
  "completedLeagues": ["premier-league", "la-liga", "serie-a", "bundesliga", "ligue-1"],
  "completedMatches": ["2026-03-01_besiktas_vs_galatasaray"],
  "totalCompleted": 1850,
  "totalRemaining": 1450,
  "lastSuccessfulScrape": "2026-03-01T14:22:00Z",
  "resumable": true,
  "errors": []
}
```

### `seasonStats/{leagueKey}`
```json
{
  "league": "super-lig",
  "season": "2025-26",
  "topScorers": [{ "player": "...", "team": "...", "goals": 14, "sofascoreId": 12345 }],
  "topAssists": [{ "player": "...", "team": "...", "assists": 9 }],
  "topRatings": [{ "player": "...", "team": "...", "rating": 7.82 }],
  "topYellowCards": [{ "player": "...", "team": "...", "cards": 8 }],
  "leagueStats": {
    "totalGoals": 580,
    "avgGoalsPerMatch": 2.62,
    "totalCards": 890,
    "cleanSheets": 45
  },
  "dataHash": "...",
  "lastUpdated": "2026-03-01T12:30:00Z"
}
```

### `seasons/{seasonKey}`
```json
{
  "key": "2025-2026",
  "name": "2025-26 Sezonu",
  "start": "2025-08-01",
  "end": "2026-06-30",
  "leagues": ["premier-league", "la-liga", "serie-a", "bundesliga", "ligue-1", "super-lig", "eredivisie", "primeira-liga"],
  "cups": ["champions-league", "europa-league", "conference-league"],
  "sofascoreSeasonIds": {
    "premier-league": 61627,
    "la-liga": 62150,
    "super-lig": 63814
  },
  "lastUpdated": "2026-03-01T12:00:00Z"
}
```

---

## 6. CAPRAZ KAYNAK KARSILASTIRMA MATRiSi

Hangi veri, hangi kaynaktan cekilecek. Birden fazla kaynak varsa **oncelik** belirtilmistir.

| # | Veri Kategorisi | FBref | SofaScore | Transfermarkt | Oncelik |
|---|----------------|:---:|:---:|:---:|---------|
| 1 | Mac skoru | ✓ | ✓ | - | SofaScore (canli) |
| 2 | Mac istatistikleri (possession, sut vb.) | ✓ | ✓ | - | SofaScore (daha detayli) |
| 3 | xG (Beklenen Gol) | ~~✓~~ | ✓ | - | SofaScore (FBref Ocak 2026'da kaldirdi) |
| 4 | Sut haritasi (shotmap) | ✓* | ✓ | - | SofaScore API (Playwright gerektirmez) |
| 5 | Kadro & Formasyon | ✓ | ✓ | - | SofaScore (canli guncelleme) |
| 6 | Oyuncu reytingleri | - | ✓ | - | SofaScore (tek kaynak) |
| 7 | Mac olaylari (gol, kart, degisiklik) | ✓ | ✓ | - | SofaScore (canli) |
| 8 | Bahis oranlari | - | ✓ | - | SofaScore (tek kaynak) |
| 9 | H2H (Kafa kafaya) | - | ✓ | - | SofaScore (tek kaynak) |
| 10 | Momentum/baski grafigi | - | ✓ | - | SofaScore (tek kaynak) |
| 11 | Hakem bilgisi | ✓ | ✓ | ✓ | Transfermarkt (detayli stat) |
| 12 | Puan tablosu | - | ✓ | ✓ | SofaScore (ev/dep ayrimli) |
| 13 | Gol/Asist kralligi | - | ✓ | - | SofaScore (tek kaynak) |
| 14 | Takim kadrosu | - | ✓ | ✓ | Transfermarkt (detayli) |
| 15 | Oyuncu detay profili | ✓ | ✓ | ✓ | Birlestirilir (3 kaynak) |
| 16 | Oyuncu mac istatistigi | ✓ | ✓ | ✓ | FBref (en detayli: 12 stat tipi) |
| 17 | Oyuncu scouting (percentile) | ✓ | - | - | FBref (tek kaynak) |
| 18 | Pas tipleri (short/medium/long) | ✓ | - | - | FBref (tek kaynak) |
| 19 | Gelismis kaleci stat | ✓ | - | - | FBref (tek kaynak, PSxG vb.) |
| 20 | Maas bilgileri | ✓ | - | - | FBref (tek kaynak) |
| 21 | Piyasa degeri | - | - | ✓ | Transfermarkt (tek kaynak) |
| 22 | Piyasa degeri gecmisi | - | - | ✓ | Transfermarkt (tek kaynak) |
| 23 | Sakatliklar | - | ✓* | ✓ | Transfermarkt (detayli tur/sure) |
| 24 | Cezali oyuncular | - | ✓* | ✓ | Transfermarkt (detayli) |
| 25 | Transfer soylentileri | - | - | ✓ | Transfermarkt (tek kaynak) |
| 26 | Haberler | - | - | ✓ | Transfermarkt (tek kaynak) |
| 27 | TD bilgisi (kariyer, stat) | - | ✓ | ✓ | Transfermarkt (detayli) |
| 28 | Stadyum bilgisi | - | - | ✓ | Transfermarkt (tek kaynak) |
| 29 | Transfer gecmisi | - | ✓ | ✓ | Transfermarkt (detayli) |
| 30 | Kontrat bilgisi | - | - | ✓ | Transfermarkt (tek kaynak) |
| 31 | Canli skor (realtime) | - | ✓ | - | SofaScore (tek kaynak) |
| 32 | Canli oranlar | - | ✓ | - | SofaScore (tek kaynak) |
| 33 | Video ozet linkleri | - | ✓ | - | SofaScore (tek kaynak) |
| 34 | Taraftar oylama | - | ✓ | - | SofaScore (tek kaynak) |
| 35 | Oyuncu isi haritasi | - | ✓ | - | SofaScore (tek kaynak) |

> `*` FBref sut haritasinda xG Ocak 2026'da kaldirildi, sadece koordinat bilgisi var.
> `*` SofaScore missing-players endpoint'i sinirli bilgi verir.

---

## 7. DOSYA DEGiSiKLiKLERi

### SiLiNECEK DOSYALAR

```
# Botlar (artik kullanilmayacak)
src/bots/understat/UnderstatBot.ts        ← xG icin SofaScore yeterli
src/bots/statsbomb/StatsBombBot.ts        ← Sinirli/eski veri

# Eski veri (TAMAMEN silinecek, sifirdan baslanacak)
data/fbref/                               ← 135+ JSON — yeniden cekilecek
data/sofascore/                           ← Bos klasor
data/statsbomb/                           ← Bos klasor
data/transfermarkt/                       ← Bos klasor
data/understat/                           ← Bos klasor

# Firestore eski veri (programatik silme)
Firestore: matches/*                      ← Sifirdan yazilacak
Firestore: teams/*                        ← Sifirdan yazilacak
Firestore: leagues/*                      ← Sifirdan yazilacak
Firestore: scrapeHistory/*                ← Opsiyonel temizlik
```

### GUNCELLENECEK DOSYALAR (~20 dosya)

| Dosya | Degisiklik |
|-------|-----------|
| `src/orchestrator.ts` | 3 fazli mimari: Full → Delta → Live. Worker Manager, checkpoint/resume, paralel kontrol |
| `src/bots/sofascore/SofaScoreBot.ts` | Tamamen yeniden: 42 endpoint, canli tracker, Playwright fallback |
| `src/bots/fbref/FBrefBot.ts` | 12 STAT_TYPES, oyuncu scouting, wages desteği |
| `src/bots/fbref/urls.ts` | STAT_TYPES 8→12, oyuncu/scouting URL generator'leri ekle |
| `src/bots/fbref/matchReportScraper.ts` | Yeni stat type parser'lari (passing_types, playingtime, keeper_adv, wages) |
| `src/bots/fbref/teamStatsScraper.ts` | 12 stat tipi icin genisletilmis scraping |
| `src/bots/transfermarkt/TransfermarktBot.ts` | Tamamen yeniden: hibrit API+Playwright, 12 kategori |
| `src/config/leagues.ts` | `transfermarktId` + `sofascoreSeasonId` alanlari ekle |
| `src/config/botConfig.ts` | Rate config guncelle: SofaScore 25s→3-4s, yeni adaptive limiter |
| `src/config/constants.ts` | Yeni sabitler: DELTA_INTERVAL, LIVE_POLL_INTERVAL, MAX_PARALLEL_WORKERS |
| `src/config/seasons.ts` | Season ID map ekle |
| `src/types/match.ts` | Yeni alanlar: xg, shotMap, momentum, bestPlayers, votes, highlights, dataHash |
| `src/types/team.ts` | Genisletme: stadium, manager detay, transfers, news, totalSquadValue, managerHistory |
| `src/types/bot.ts` | WorkerStatus, CheckpointState tipleri ekle |
| `src/types/index.ts` | Yeni type export'lari |
| `src/db/schemas.ts` | 6→12 koleksiyon (players, managers, live, news, scrapeState, seasonStats) |
| `src/db/writer.ts` | Yeni metodlar: writePlayer, writeManager, writeLive, writeNews, delta hash kontrolu |
| `src/db/matchMerger.ts` | 3 kaynak birlestirme, dataHash uretimi, completeness guncelleme |
| `src/utils/teamMatcher.ts` | Alias veritabanini genislet (170+ takim) |
| `src/index.ts` | Surekli calisma: process.stdin.resume(), graceful shutdown, delta/live timer |
| `package.json` | Yeni dependency yok (mevcut yeterli), script'ler guncelle |

### YENi DOSYALAR (~20 dosya)

| Dosya | Icerik |
|-------|--------|
| `src/bots/sofascore/SofaScoreEventScraper.ts` | 19 event endpoint'i ile mac detay scraper |
| `src/bots/sofascore/SofaScoreTournamentScraper.ts` | 11 turnuva endpoint'i: puan tablosu, gol kralligi, sezon stats |
| `src/bots/sofascore/SofaScoreTeamScraper.ts` | 5 takim endpoint'i: yaklasan maclar, kadro, transferler |
| `src/bots/sofascore/SofaScorePlayerScraper.ts` | 7 oyuncu endpoint'i: profil, stat, transfer, heatmap |
| `src/bots/sofascore/SofaScoreLiveTracker.ts` | Canli mac takibi: pre/in/post-match 3 faz |
| `src/bots/fbref/playerScraper.ts` | Oyuncu profili, scouting raporu, mac kaydi scraping |
| `src/bots/transfermarkt/TransfermarktApiClient.ts` | Community API wrapper (11 endpoint) |
| `src/bots/transfermarkt/TransfermarktPlaywrightScraper.ts` | Playwright fallback (12 kategori) |
| `src/bots/transfermarkt/TransfermarktNewsScraper.ts` | Haber/soylenti/icerik scraper |
| `src/config/teamMappings.ts` | 170+ takim: slug ↔ sofascoreId ↔ transfermarktId ↔ fbrefId esleme |
| `src/config/sofascoreSeasonIds.ts` | Statik + dinamik seasonId yonetimi |
| `src/utils/hashCompare.ts` | MD5 bazli delta guncelleme hash fonksiyonlari |
| `src/utils/dataCleaner.ts` | Eski veri temizleme (Firestore + local) |
| `src/utils/workerManager.ts` | Paralel scrape kontrol: worker havuzu, kuyruk, rate limit |
| `src/utils/matchStatusMapper.ts` | SofaScore statusCode → MatchStatus mapping |
| `src/utils/proxyRotator.ts` | Proxy rotation yonetimi (opsiyonel) |
| `src/utils/fcmNotifier.ts` | Firebase Cloud Messaging push notification |
| `src/types/player.ts` | PlayerData, PlayerScouting, PlayerCareer tipleri |
| `src/types/manager.ts` | ManagerData, ManagerCareer, ManagerStats tipleri |
| `src/types/news.ts` | NewsArticle, TransferRumor tipleri |

---

## 8. SOFASCORE SEASON ID YONETiMi

SofaScore API'de standings, top-players ve statistics endpoint'leri `seasonId` gerektirir. Bu ID her sezon degisir.

### Statik Yaklasim (Basta tanimla)

```typescript
// src/config/sofascoreSeasonIds.ts
export const SOFASCORE_SEASON_IDS: Record<string, number> = {
  'premier-league': 61627,    // 2025-26
  'la-liga': 62150,           // 2025-26
  'serie-a': 62153,           // 2025-26
  'bundesliga': 62154,        // 2025-26
  'ligue-1': 62155,           // 2025-26
  'super-lig': 63814,         // 2025-26
  'eredivisie': 62160,        // 2025-26
  'primeira-liga': 62161,     // 2025-26
  'champions-league': 62148,  // 2025-26
  'europa-league': 62149,     // 2025-26
  'conference-league': 62151, // 2025-26
};
```

### Dinamik Yaklasim (Otomatik bulma)

```typescript
// Ilk calistirmada season ID'leri otomatik bul
async function fetchSeasonId(tournamentId: number): Promise<number> {
  const resp = await axios.get(
    `https://api.sofascore.com/api/v1/unique-tournament/${tournamentId}/seasons`
  );
  const seasons = resp.data?.seasons || [];
  // En son (aktif) sezonu dondur
  return seasons[0]?.id || 0;
}

// Tum ligler icin toplu cek ve cache'le
async function initializeSeasonIds(): Promise<Record<string, number>> {
  const seasonIds: Record<string, number> = {};
  for (const league of LEAGUES) {
    seasonIds[league.key] = await fetchSeasonId(league.sofascoreId);
    await sleep(2000); // rate limit
  }
  return seasonIds;
}
```

### Guncelleme Stratejisi
- Uygulama basladiginda: Statik ID'leri kullan
- Haftada 1: Dinamik kontrol yap, degismis mi bak
- Sezon degisiminde (Temmuz-Agustos): Dinamik olarak yeni ID'leri cek ve statik dosyayi guncelle

---

## 9. HASH BAZLI DELTA GUNCELLEME

### Algoritma

```typescript
// src/utils/hashCompare.ts
import crypto from 'crypto';

/**
 * Veri hash'i uret — meta alanlarini disarda birak
 * Sadece icerik degisikligi tespit etmek icin kullanilir
 */
export function dataHash(data: Record<string, any>): string {
  // Hash disinda birakilacak meta alanlar
  const excludeKeys = ['lastUpdated', 'dataHash', 'sources', 'dataCompleteness'];

  const filtered: Record<string, any> = {};
  for (const [key, value] of Object.entries(data)) {
    if (!excludeKeys.includes(key)) {
      filtered[key] = value;
    }
  }

  // Tutarli JSON: key'leri sirala
  const json = JSON.stringify(filtered, Object.keys(filtered).sort());
  return crypto.createHash('md5').update(json).digest('hex');
}

/**
 * Delta kontrol: Eski ve yeni veriyi karsilastir
 * true donerse guncelleme gerekli, false donerse atla
 */
export function needsUpdate(oldDoc: any, newData: any): boolean {
  if (!oldDoc || !oldDoc.dataHash) return true; // Ilk yazim
  const newHash = dataHash(newData);
  return oldDoc.dataHash !== newHash;
}
```

### Kullanim Akisi

```
Yeni veri geldi
│
├─ Firestore'dan mevcut doc'u oku (sadece dataHash alani yeterli)
├─ Yeni verinin hash'ini hesapla
├─ oldHash === newHash ?
│   ├─ EVET → Atla (write tasarrufu)
│   └─ HAYIR → Yaz (guncellenmis veri)
│
└─ Yazarken: { ...newData, dataHash: newHash, lastUpdated: now }
```

### Tahmini Tasarruf

| Senaryo | Hash Olmadan (Write/gun) | Hash ile (Write/gun) | Tasarruf |
|---------|:---:|:---:|:---:|
| Delta update (48/gun) | ~48,000 | ~12,000 | %75 |
| Canli mac (20 mac/gun) | ~50,000 | ~50,000 | %0 (canli veri her zaman yeni) |
| Takim guncelleme | ~8,000 | ~1,500 | %81 |
| **TOPLAM** | **~106,000** | **~63,500** | **~%40** |

---

## 10. RATE LiMiTiNG & KORUMA

### Kaynak Bazli Delay Ayarlari

| Kaynak | Method | Min Delay | Max Delay | Max Req/dk | Concurrency |
|--------|--------|:---------:|:---------:|:----------:|:-----------:|
| FBref HTML | Playwright+Cheerio | 5 sn | 8 sn | ~10 | 1 |
| SofaScore API | Axios | 3 sn | 5 sn | ~15 | 2 (farkli lig) |
| SofaScore Web (fallback) | Playwright | 5 sn | 8 sn | ~10 | 1 |
| Transfermarkt API | Axios | 3 sn | 6 sn | ~12 | 1 |
| Transfermarkt Web | Playwright | 6 sn | 10 sn | ~8 | 1 |

### Adaptive Rate Limiter

```typescript
class AdaptiveRateLimiter {
  private baseDelay: number;
  private currentDelay: number;
  private consecutiveErrors: number = 0;
  private readonly maxDelay = 60000; // 1 dakika

  async onSuccess(): Promise<void> {
    this.consecutiveErrors = 0;
    // Basari durumunda yavasca normale don
    this.currentDelay = Math.max(this.baseDelay, this.currentDelay * 0.9);
  }

  async onError(statusCode: number): Promise<void> {
    this.consecutiveErrors++;

    if (statusCode === 429) {
      // Rate limit — delay'i 3x artir
      this.currentDelay = Math.min(this.currentDelay * 3, this.maxDelay);
    } else if (statusCode === 403) {
      // Cloudflare block — 5 dakika bekle
      this.currentDelay = 300000;
      if (this.consecutiveErrors >= 3) {
        throw new Error('BLOCKED: 3 ardisik 403, bot durduruluyor');
      }
    } else if (statusCode === 503) {
      // Server overload — 2x artir
      this.currentDelay = Math.min(this.currentDelay * 2, this.maxDelay);
    }
  }
}
```

### Anti-Bot Stratejisi

```
1. playwright-extra + stealth plugin (mevcut kodda var)
2. Random User-Agent rotation (10+ farkli UA)
3. Random delay: baseDelay + Math.random() * range
4. Cookie persistence (session devam)
5. Realistic browsing pattern:
   - Sayfada 2-4 sn bekle
   - Bazen scroll yap
   - Tab arasi gecis simule et
6. Referrer header: onceki sayfa URL'ini gonder
7. Accept-Language: tr-TR,tr;q=0.9,en-US;q=0.8
```

### Proxy Rotation (Opsiyonel ama Onerilir)

```typescript
// src/utils/proxyRotator.ts
const PROXY_LIST = [
  'http://user:pass@proxy1.example.com:8080',
  'http://user:pass@proxy2.example.com:8080',
  'http://user:pass@proxy3.example.com:8080',
];

class ProxyRotator {
  private index = 0;
  private bannedProxies = new Set<string>();

  getNext(): string {
    let attempts = 0;
    while (attempts < PROXY_LIST.length) {
      const proxy = PROXY_LIST[this.index % PROXY_LIST.length];
      this.index++;
      if (!this.bannedProxies.has(proxy)) return proxy;
      attempts++;
    }
    throw new Error('Tum proxy\'ler banlandi!');
  }

  markBanned(proxy: string): void {
    this.bannedProxies.add(proxy);
    // 30 dk sonra ban kaldir
    setTimeout(() => this.bannedProxies.delete(proxy), 30 * 60 * 1000);
  }
}
```

> **Not:** Proxy kullanmadan baslamak mumkun. Ban sorunu yasanirsa SmartProxy veya BrightData gibi residential proxy servisleri entegre edilebilir.

---

## 11. PUSH NOTiFiCATiON (FCM)

### Tetikleme Kosullari

| Olay | Tetikleyici | Oncelik | Mesaj Ornegi |
|------|------------|---------|-------------|
| Gol | `incident.type === 'goal'` | HIGH | "GOL! Besiktas 2-1 Galatasaray (Immobile 65')" |
| Kirmizi kart | `incident.type === 'redCard'` | HIGH | "KIRMIZI KART! X Oyuncu (67')" |
| Mac basladi | `status: notStarted → inProgress` | NORMAL | "MAC BASLADI: Besiktas vs Galatasaray" |
| Mac bitti | `status: inProgress → finished` | NORMAL | "MAC BITTI: Besiktas 2-1 Galatasaray" |
| Kadro aciklandi | `lineups: null → populated` | LOW | "Kadro aciklandi: Besiktas vs Galatasaray" |
| VAR karari | `incident.type === 'var'` | NORMAL | "VAR: Gol iptal — ofsayt" |

### Implementasyon

```typescript
// src/utils/fcmNotifier.ts
import { getMessaging } from 'firebase-admin/messaging';

interface NotificationPayload {
  title: string;
  body: string;
  matchKey: string;
  type: 'goal' | 'redCard' | 'matchStart' | 'matchEnd' | 'lineup' | 'var';
}

export async function sendMatchNotification(payload: NotificationPayload): Promise<void> {
  const messaging = getMessaging();

  await messaging.sendToTopic(`match_${payload.matchKey}`, {
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data: {
      matchKey: payload.matchKey,
      type: payload.type,
      timestamp: new Date().toISOString(),
    },
    android: { priority: 'high' },
    apns: { payload: { aps: { sound: 'default' } } },
  });

  // Takim bazli topic'e de gonder
  // Ornek: topic "team_besiktas" dinleyenlere
}
```

---

## 12. PARALEL SCRAPE STRATEJiSi

### Worker Manager Diyagrami

```
┌─────────────────────────────────────────────────────────┐
│                    WORKER MANAGER                        │
│                                                          │
│  Max Workers: 4 (eslesmeli calisabilir)                  │
│  Kuyruk: FIFO (lig bazli onceliklendirme)               │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐│
│  │ Worker 1 │  │ Worker 2 │  │ Worker 3 │  │ Worker 4 ││
│  │ SofaScore│  │ SofaScore│  │  FBref   │  │Transferm.││
│  │ PL maclar│  │ LL maclar│  │ PL maclar│  │ PL takim. ││
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘│
│       │              │              │              │     │
│       └──────────────┼──────────────┼──────────────┘     │
│                      ▼                                   │
│              Progress Reporter                           │
│              (her 5sn status emit)                       │
└─────────────────────────────────────────────────────────┘
```

### Paralel Calisma Kurallari

| Kural | Aciklama |
|-------|----------|
| SofaScore API: 2 worker | Farkli ligler icin paralel calisabilir, ayni lig icin SIRA ile |
| FBref HTML: 1 worker | Tek Playwright instance, ban riski yuksek |
| Transfermarkt API: 1 worker | Rate limit dusuk, sira ile |
| Transfermarkt Web: 1 worker | Playwright, ban riski en yuksek |
| **Ayni mac icin:** | Birden fazla kaynak SIRA ile (capraz kontrol icin) |
| **Farkli mac icin:** | Farkli kaynaklar PARALEL olabilir |

### Onceliklendirme

```
1. Super Lig (kullanicinin ana ilgi alani)
2. Champions League / Europa League / Conference League
3. Premier League
4. La Liga
5. Serie A
6. Bundesliga
7. Ligue 1
8. Eredivisie
9. Primeira Liga
```

---

## 13. MAC DURUMU HARiTASI

### SofaScore statusCode → MatchStatus Mapping

| SofaScore statusCode | SofaScore Aciklama | Bizim Status | Aksiyon |
|:---:|------|------|---------|
| 0 | Not started | `scheduled` | Delta update bekle |
| 6 | 1st half | `live` | Live tracker basla (30sn) |
| 7 | Halftime | `halftime` | Live tracker devam (1dk) |
| 8 | 2nd half | `live` | Live tracker devam (30sn) |
| 9 | Extra time | `live` | Live tracker devam (30sn) |
| 10 | Penalty | `live` | Live tracker devam (15sn) |
| 11 | Break time | `halftime` | Live tracker yavas (2dk) |
| 31 | Halftime (extra) | `halftime` | Live tracker yavas (2dk) |
| 100 | Ended | `finished` | Post-match veri cek, live/ sil |
| 60 | Postponed | `postponed` | Log + atla |
| 70 | Cancelled | `cancelled` | Log + atla |
| 80 | Abandoned | `abandoned` | Log + atla |

### TypeScript Status Enum

```typescript
export type MatchStatus =
  | 'scheduled'    // Planlanmis, henuz baslamadi
  | 'prematch'     // Mac oncesi (T-60dk, kadro aciklanmis)
  | 'live'         // Oynanıyor (1. yari, 2. yari, uzatma, penalti)
  | 'halftime'     // Devre arasi
  | 'finished'     // Tamamlandi
  | 'postponed'    // Ertelendi
  | 'cancelled'    // Iptal edildi
  | 'abandoned';   // Tatil edildi (yarida kalan mac)
```

---

## 14. GUNCELLiK & DOGRULAMA KURALLARI

### Veri Kalite Kontrol

```
1. Bos/eksik veri: null olarak kaydet, ASLA uydurma deger yazma
2. Lig esleme: sofascoreId ile dogrula — bilinmeyen lig maclarini atla
3. Takim esleme: normalizeTeamName() + alias veritabani ile 3 kaynak esle
4. Tarih format: ISO 8601 (UTC) standart — "2026-03-08T19:00:00Z"
5. Skor tutarliligi: homeGoals + awayGoals == toplam gol sayisi
6. Oyuncu esleme: isim + takim + pozisyon ile capraz dogrulama
7. Mac cift kayit kontrolu: matchKey unique olmali, duplicate tespit et
```

### Veri Tazeligi Kurallari

| Veri Tipi | Max Yas | Yeniden Cekme Kosulu |
|-----------|:---:|------|
| Canli mac verisi | 30 sn | Her polling dongusu |
| Puan tablosu | 30 dk | Her delta update |
| Gol/asist kralligi | 30 dk | Her delta update |
| Takim kadrosu | 24 saat | Gunluk kontrol |
| Sakatlik bilgisi | 6 saat | Delta update sirasi |
| Transfer soylentisi | 6 saat | Delta update sirasi |
| Haberler | 6 saat | Delta update sirasi |
| Oyuncu profili | 7 gun | Haftalik kontrol |
| TD bilgisi | 7 gun | Haftalik kontrol |
| Stadyum bilgisi | 30 gun | Aylik kontrol |
| Piyasa degeri | 7 gun | Haftalik kontrol |
| Maas bilgisi (FBref) | 30 gun | Aylik kontrol |

### Dogrulama Pipeline

```
Ham veri geldi (herhangi bir kaynaktan)
│
├─ 1. Null/undefined kontrolu → bos ise null yaz
├─ 2. Tip kontrolu → sayi olmasi gereken alanlarda string var mi?
├─ 3. Aralik kontrolu → possession 0-100, rating 0-10, xG 0-5
├─ 4. Tarih kontrolu → 2025-08-01 ile 2026-06-30 arasi mi?
├─ 5. Takim esleme → normalizeTeamName() ile slug uret
├─ 6. Lig esleme → sofascoreId/fbrefId ile dogrula
├─ 7. Duplicate kontrolu → matchKey zaten var mi?
└─ 8. Hash uret → delta karsilastirma icin dataHash
```

---

## 15. FiRESTORE MALiYET TAHMiNi

### Write Analizi (Aylik)

| Kaynak | Write Tipi | Write/Ay Tahmini |
|--------|-----------|:---:|
| Full scrape (ayda 2x) | Matches: 3300×2 = 6600 | ~6,600 |
| Full scrape (ayda 2x) | Teams: 170×2 = 340 | ~340 |
| Full scrape (ayda 2x) | Players: 3750×2 = 7500 | ~7,500 |
| Full scrape (ayda 2x) | Managers: 170×2 = 340 | ~340 |
| Delta update (48/gun × 30 gun) | Degisen maclar: ~200/gun | ~6,000 |
| Delta update | Degisen takimlar: ~50/gun | ~1,500 |
| Delta update | Haberler/soylenti: ~30/gun | ~900 |
| Canli mac (20 mac/gun, ortalama) | live/ write: ~3000/mac | ~60,000 * |
| Puan tablosu (48/gun) | leagues/ write | ~1,440 |
| Gol/asist kralligi | seasonStats/ write | ~1,440 |
| scrapeState/History | Checkpoint + log | ~5,000 |
| **TOPLAM** | | **~91,000 - 683,000** |

> `*` Canli mac write sayisi mac yogunluguna gore degisir. Hafta sonlari ~40-50 mac, hafta ici ~5-10 mac.

### Read Analizi (Aylik)

| Kaynak | Read/Ay Tahmini |
|--------|:---:|
| Delta hash kontrolu (48/gun × ~500 doc) | ~720,000 |
| Flutter app okumalari | Degisken (kullanici sayisina bagli) |
| onSnapshot listeners | Ucretsiz (Firestore realtime) |
| **TOPLAM (scraper)** | **~720,000** |

### Fiyatlandirma Tahmini

| Birim | Ucretsiz Limit | Tahmini Kullanim | Maliyet |
|-------|:---:|:---:|:---:|
| Writes | 20,000/gun (~600K/ay) | ~91K-683K/ay | $0 - $0.50 |
| Reads | 50,000/gun (~1.5M/ay) | ~720K/ay | $0 |
| Storage | 1 GiB | ~200 MB | $0 |
| **TOPLAM** | | | **~$0 - $4/ay** |

> **Not:** Spark (ucretsiz) plan ile baslamak mumkun. Canli mac yogunlugunun yuksek oldugu gunlerde gunluk write limiti (20K) asilaabilir — bu durumda Blaze planina gecmek gerekir (~$4-8/ay).

---

## 16. CALISMA PLANI (14 Adim, ~30 saat)

| Adim | Is | Oncelik | Tahmini Sure | Bagimlilik |
|:---:|---|:---:|:---:|:---:|
| 1 | Types/schemas olustur: match.ts, player.ts, manager.ts, news.ts guncellemeleri + schemas.ts 12 koleksiyon | Kritik | 1.5 saat | - |
| 2 | Team mappings olustur: 170+ takim icin slug ↔ sofascoreId ↔ transfermarktId ↔ fbrefId | Kritik | 2 saat | - |
| 3 | SofaScore Season ID konfigurasyon: statik + dinamik | Yuksek | 1 saat | 1 |
| 4 | Hash utility + Data Cleaner (eski veri silme scripti) | Yuksek | 1 saat | 1 |
| 5 | Firestore Writer v2: writePlayer, writeManager, writeLive, writeNews, delta hash | Kritik | 2 saat | 1, 4 |
| 6 | SofaScore Event Scraper: 19 endpoint, tum mac verileri | Kritik | 3 saat | 1, 3 |
| 7 | SofaScore Tournament + Team + Player Scraper | Yuksek | 2 saat | 6 |
| 8 | SofaScore Live Tracker: pre/in/post-match 3 faz | Yuksek | 2 saat | 6 |
| 9 | FBref Bot genisletme: 12 STAT_TYPES + oyuncu scouting + wages | Yuksek | 2 saat | 1 |
| 10 | Transfermarkt hibrit scraper: API client + Playwright fallback | Yuksek | 3 saat | 1, 2 |
| 11 | Data Merger v2: 3 kaynak birlestirme, completeness skoru | Yuksek | 1.5 saat | 5, 6, 9, 10 |
| 12 | Orchestrator v2: 3 faz + Worker Manager + checkpoint/resume | Kritik | 3 saat | 5-11 |
| 13 | FCM Push Notification + Match Status Mapper | Normal | 1.5 saat | 8 |
| 14 | Eski botlari sil + Test & Debug + Integration test | Kritik | 4.5 saat | 1-13 |
| **TOPLAM** | | | **~30 saat** | |

---

## 17. RiSK DEGERLENDiRMESi

| # | Risk | Olasilik | Etki | Onlem |
|---|------|:---:|:---:|-------|
| 1 | SofaScore API ban (403/429) | Yuksek | Kritik | Adaptive rate limiter, proxy rotation, 3-4sn delay |
| 2 | FBref Cloudflare block | Yuksek | Yuksek | Stealth plugin, 5-8sn delay, cookie persistence |
| 3 | Transfermarkt Cloudflare block | Yuksek | Yuksek | Hibrit yaklasim: API + Playwright fallback |
| 4 | Community TM API kapanmasi | Orta | Yuksek | Playwright tam fallback hazir olmali |
| 5 | Firestore gunluk write limit asimi (Spark plan) | Orta | Orta | Hash bazli delta, Blaze plana gecis |
| 6 | Scraper crash (memory leak, uzun calisma) | Orta | Orta | Checkpoint/resume, PM2 process manager |
| 7 | FBref web sitesi yapi degisikligi | Dusuk | Yuksek | Cheerio selector'leri modular, hizli guncelleme |
| 8 | SofaScore API endpoint degisikligi | Dusuk | Yuksek | Versiyon kontrolu, hata loglama, hizli fix |
| 9 | Veri tutarsizligi (kaynaklar arasi) | Orta | Dusuk | Cross-validation, oncelik sirasi, log |
| 10 | IP ban (tum kaynaklar) | Dusuk | Kritik | Proxy rotation, VPN, farkli IP'lerden calistirma |

---

## 18. CEKiLEMEYEN VERiLER

| Veri | Neden | Alternatif |
|------|-------|-----------|
| **Hava durumu** | Hicbir kaynakta yok | OpenWeatherMap API (ucretsiz, 1000 call/gun) |
| **GPS/Izleme verisi** | Opta/Stats Perform exclusive | Yok (lisansli veri) |
| **Antrenman verisi** | Halka acik degil | Yok |
| **Oyuncu fitness/kondisyon** | Kulup ici veri | Yok |
| **xG (FBref)** | Ocak 2026'da kaldirildi | SofaScore xG tek kaynak |
| **Detayli VAR karar gerekceleri** | Yapilandirilmis veri yok | incidents icerisinde sinirli bilgi |
| **Isi haritasi (detayli piksel)** | SofaScore API sinirli | `/player/{id}/heatmap` kismi veri verir |
| **Oyuncu sosyal medya** | Scrape riski cok yuksek | Yok |
| **Taktikal analiz (faz analizi)** | Insan analizi gerektirir | Gemini AI ile uretilabilir |
| **Alt lig verileri** | Kapsam disi (11 turnuva) | Gerekirse leagues.ts'ye eklenebilir |

---

## 19. FLUTTER APP GUNCELLEME

### Yeni FirestorePaths

```dart
// lib/core/constants/firestore_paths.dart
class FirestorePaths {
  // Mevcut
  static const leagues = 'leagues';
  static const teams = 'teams';
  static const matches = 'matches';
  static const seasons = 'seasons';
  static const referees = 'referees';

  // YENi
  static const players = 'players';
  static const managers = 'managers';
  static const live = 'live';
  static const news = 'news';
  static const seasonStats = 'seasonStats';
  static const scrapeHistory = 'scrapeHistory';
  static const scrapeState = 'scrapeState';
}
```

### Canli Mac Dinleme (Flutter)

```dart
// lib/features/live/data/live_match_repository.dart
class LiveMatchRepository {
  final _firestore = FirebaseFirestore.instance;

  /// Tum canli maclari dinle
  Stream<List<LiveMatch>> watchLiveMatches() {
    return _firestore
        .collection(FirestorePaths.live)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LiveMatch.fromJson(doc.data()))
            .toList());
  }

  /// Belirli bir macı dinle
  Stream<LiveMatch?> watchMatch(String matchKey) {
    return _firestore
        .collection(FirestorePaths.live)
        .doc(matchKey)
        .snapshots()
        .map((doc) => doc.exists ? LiveMatch.fromJson(doc.data()!) : null);
  }

  /// Bugunun maclarini getir
  Future<List<MatchData>> getTodayMatches() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final snapshot = await _firestore
        .collection(FirestorePaths.matches)
        .where('date', isGreaterThanOrEqualTo: '${today}T00:00:00Z')
        .where('date', isLessThanOrEqualTo: '${today}T23:59:59Z')
        .get();
    return snapshot.docs.map((d) => MatchData.fromJson(d.data())).toList();
  }
}
```

### Push Notification Alma (Flutter)

```dart
// lib/core/services/fcm_service.dart
class FCMService {
  final _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Izin iste
    await _messaging.requestPermission();

    // Takip edilen takimlarin topic'lerine abone ol
    final favTeams = ['besiktas', 'galatasaray', 'fenerbahce'];
    for (final team in favTeams) {
      await _messaging.subscribeToTopic('team_$team');
    }
  }

  void setupHandlers() {
    FirebaseMessaging.onMessage.listen((message) {
      // Uygulama acikken gelen bildirim
      showInAppNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Bildirime tiklayarak uygulama acildi
      navigateToMatch(message.data['matchKey']);
    });
  }
}
```

---

## 20. FiRESTORE RULES

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Lig verileri — herkes okuyabilir
    match /leagues/{leagueKey} {
      allow read: if true;
      allow write: if false; // Sadece scraper (admin SDK)
    }

    // Takim verileri — herkes okuyabilir
    match /teams/{teamSlug} {
      allow read: if true;
      allow write: if false;
    }

    // Mac verileri — herkes okuyabilir
    match /matches/{matchKey} {
      allow read: if true;
      allow write: if false;
    }

    // Oyuncu verileri — herkes okuyabilir
    match /players/{playerId} {
      allow read: if true;
      allow write: if false;
    }

    // TD verileri — herkes okuyabilir
    match /managers/{managerId} {
      allow read: if true;
      allow write: if false;
    }

    // Canli mac — herkes okuyabilir
    match /live/{matchKey} {
      allow read: if true;
      allow write: if false;
    }

    // Haberler — herkes okuyabilir
    match /news/{newsId} {
      allow read: if true;
      allow write: if false;
    }

    // Hakem verileri — herkes okuyabilir
    match /referees/{refereeSlug} {
      allow read: if true;
      allow write: if false;
    }

    // Sezon istatistikleri — herkes okuyabilir
    match /seasonStats/{leagueKey} {
      allow read: if true;
      allow write: if false;
    }

    // Sezon metadata — herkes okuyabilir
    match /seasons/{seasonKey} {
      allow read: if true;
      allow write: if false;
    }

    // Scrape gecmisi — sadece admin
    match /scrapeHistory/{docId} {
      allow read: if false;
      allow write: if false;
    }

    // Scrape durumu — sadece admin
    match /scrapeState/{sessionId} {
      allow read: if false;
      allow write: if false;
    }
  }
}
```

> **Not:** Scraper, Firebase Admin SDK kullanir — Rules'a tabi degildir. Rules sadece client-side (Flutter app) erisimini kontrol eder.

---

## 21. SONUC & ONERiLER

### Tasarim Kararlari Ozeti

| # | Karar | Gerekce |
|---|-------|---------|
| 1 | FBref kalacak (3. kaynak) | Pas tipleri, scouting percentile, maas — baska kaynakta yok |
| 2 | xG tek kaynak: SofaScore | FBref Ocak 2026'da xG kaldirdi |
| 3 | Tum eski veri silinecek | Temiz baslangic, tutarsiz veri riski yok |
| 4 | Transfermarkt hibrit | API hizli ama sinirli, Playwright kapsamli ama yavas |
| 5 | Hash bazli delta | ~%40 write tasarrufu, Firestore maliyetini dusurur |
| 6 | 12 Firestore koleksiyonu | Oyuncu, TD, haber ayri koleksiyonlarda — query performansi |
| 7 | 3 fazli canli mac | Pre/in/post-match ayrimli — daha zengin veri |
| 8 | FCM push notification | Canli mac olaylari icin kullanici bildirimi |
| 9 | Checkpoint/resume | Uzun calismalarda cokmeden kurtulma |
| 10 | Adaptive rate limiter | Ban riskini minimize eder, dinamik delay |

### Kritik Yol (Siralama)

```
Types/Schemas → Team Mappings → Season IDs → Hash Utility
                                                  │
                    ┌─────────────────────────────┤
                    ▼                             ▼
              Writer v2                    Data Cleaner
                    │
    ┌───────────────┼───────────────┐
    ▼               ▼               ▼
SofaScore      FBref Bot      Transfermarkt
Event Scraper  Genisletme     Hibrit Scraper
    │               │               │
    ▼               ▼               ▼
SofaScore      FBref Player    TM News
Live Tracker   Scouting        Scraper
    │               │               │
    └───────────────┼───────────────┘
                    ▼
              Data Merger v2
                    │
                    ▼
            Orchestrator v2
            (3 faz + checkpoint)
                    │
                    ▼
            FCM + Status Mapper
                    │
                    ▼
            Test & Debug
                    │
                    ▼
            Flutter App Guncelleme
```

### Baslamadan Once Kontrol Listesi

- [ ] FBref'in xG/xA kaldirilmasini dogrula (Ocak 2026)
- [ ] SofaScore Season ID'lerini dogrula (2025-26 sezonu)
- [ ] Transfermarkt community API'nin canli oldugundan emin ol
- [ ] Firebase Spark plan gunluk limitlerini kontrol et
- [ ] 170+ takimin esleme tablosunu olustur (en zaman alan is)
- [ ] Mevcut Firestore verisinin yedeğini al (silmeden once)
- [ ] Node.js ve Playwright surumleri guncel mi?
- [ ] `.env` dosyasinda gerekli key'ler var mi? (FIREBASE_CRED, API_KEY)

---

---
---

# BOLUM 22: DETAYLI IMPLEMENTASYON REHBERI

> Bu bolum, Bolum 16'daki 14 adimin her birini **satir satir** aciklar.
> Her adim icin: hangi dosyada ne degisecek, ne eklenecek, ne cikarilacak, tam kod yapisi.

---

## ADIM 1: Types & Schemas Olustur (~1.5 saat)

> **Amac:** Tum sisteme temel olusturacak type tanimlari ve Firestore koleksiyon semasinı olustur.
> **Bagimlilik:** Yok — ilk yapilmali.

---

### 1.1 — `src/types/match.ts` GUNCELLE

**Mevcut dosya:** 128 satir — MatchMeta, MatchResult, TeamMatchStats, PlayerStat, ShotData, FBrefData, SofaScoreData, UnderstatData, MatchWeather, MatchData

**Yapilacaklar:**

#### A) `MatchResult.status` tipini genislet (satir 19)

```
CIKAR:
  status: 'finished' | 'scheduled' | 'postponed' | 'cancelled';

EKLE:
  status: MatchStatus;
```

Dosyanin basina MatchStatus type tanimini ekle:

```typescript
export type MatchStatus =
  | 'scheduled'
  | 'prematch'
  | 'live'
  | 'halftime'
  | 'finished'
  | 'postponed'
  | 'cancelled'
  | 'abandoned';
```

#### B) `SofaScoreData` interface'ini genislet (satir 78-98)

Mevcut `SofaScoreData` tamamen yeniden yazilacak. Eski 7 alanli interface yerine:

```typescript
export interface SofaScoreData {
  eventId: number;
  // Mac istatistikleri (ham API response)
  statistics: Record<string, any>;
  // Bahis oranlari
  odds: {
    home: number | null;
    draw: number | null;
    away: number | null;
    over25: number | null;
    under25: number | null;
  };
  // Kadro bilgisi
  lineups: {
    home: { formation: string; startingXI: any[]; substitutes: any[] };
    away: { formation: string; startingXI: any[]; substitutes: any[] };
  };
  // Mac olaylari
  incidents: Array<{
    type: string;        // goal, yellowCard, redCard, substitution, var, penaltyMissed
    minute: number;
    player: string;
    team: string;        // 'home' | 'away'
    detail: string;
    assist?: string;
    playerIn?: string;   // degisiklik icin
    playerOut?: string;
  }>;
  // Kafa kafaya
  h2h: {
    totalMatches?: number;
    homeWins?: number;
    draws?: number;
    awayWins?: number;
    lastMatches?: Array<{ date: string; home: string; away: string; score: string }>;
  };
  // Oyuncu reytingleri
  playerRatings: {
    home: Array<{ player: string; rating: number; sofascoreId?: number }>;
    away: Array<{ player: string; rating: number; sofascoreId?: number }>;
  };
  // v2 YENi ALANLAR
  shotMap: Array<{
    player: string;
    team: string;
    minute: number;
    x: number;
    y: number;
    xG: number;
    result: string;      // goal, saved, blocked, miss, post
    bodyPart: string;
    situation: string;    // open-play, set-piece, penalty, counter-attack
  }>;
  xG: { home: number | null; away: number | null };
  momentum: Array<{ minute: number; value: number }>;  // -100 ile +100 arasi
  bestPlayers: {
    motm?: { name: string; rating: number; sofascoreId?: number };
    home: Array<{ name: string; rating: number }>;
    away: Array<{ name: string; rating: number }>;
  } | null;
  votes: { home: number; draw: number; away: number } | null;
  highlights: Array<{ title: string; url: string }>;
  pregameForm: {
    home: Array<{ result: string; score: string; opponent: string }>;
    away: Array<{ result: string; score: string; opponent: string }>;
  } | null;
  missingPlayers: {
    home: Array<{ name: string; reason: string }>;
    away: Array<{ name: string; reason: string }>;
  } | null;
  managers: {
    home: { name: string; sofascoreId?: number } | null;
    away: { name: string; sofascoreId?: number } | null;
  } | null;
}
```

#### C) `FBrefData` interface'ine yeni stat type alanlari ekle (satir 61-76)

Mevcut `passTypes` alaninin altina 4 yeni alan ekle:

```typescript
export interface FBrefData {
  teamStats: {
    home: Partial<TeamMatchStats> & Record<string, any>;
    away: Partial<TeamMatchStats> & Record<string, any>;
  };
  playerStats: {
    home: PlayerStat[];
    away: PlayerStat[];
  };
  shotMap: ShotData[];
  formations: { home: string; away: string };
  passTypes: {
    home: { short: number; medium: number; long: number; progressive: number };
    away: { short: number; medium: number; long: number; progressive: number };
  };
  // v2 YENi
  passingTypes: Record<string, any> | null;   // canli pas, serbest vurus, kose vurus, cros, uzun top
  playingTime: Record<string, any> | null;     // baslangic 11, yedek, dk/90
  keeperAdv: Record<string, any> | null;       // PSxG, cikis, uzun pas, dagitim
  wages: Record<string, any> | null;           // haftalik/yillik maas
}
```

#### D) `UnderstatData` interface'ini SIL (satir 100-104)

```
CIKAR (tamamen sil):
  export interface UnderstatData { ... }
```

#### E) `MatchData` interface'ini guncelle (satir 116-127)

```typescript
export interface MatchData {
  matchKey: string;
  meta: MatchMeta;
  result: MatchResult;
  // Kaynak bazli ham veriler
  fbref?: FBrefData;
  sofascore?: SofaScoreData;
  // transfermarkt mac bazli veri (hakem atamasi vb.)
  transfermarkt?: { refereeId?: string; refereeStats?: Record<string, any> };
  weather?: MatchWeather;
  // Birlesmis/hesaplanmis alanlar
  xG?: { home: number | null; away: number | null; source: string };
  shotMap?: SofaScoreData['shotMap'];  // SofaScore'dan (birincil kaynak)
  momentum?: Array<{ minute: number; value: number }>;
  bestPlayers?: SofaScoreData['bestPlayers'];
  votes?: SofaScoreData['votes'];
  highlights?: SofaScoreData['highlights'];
  // Meta
  sources: string[];
  dataCompleteness: number;
  dataHash: string;             // v2 YENi — delta kontrol icin
  lastUpdated: Date;
}
```

> **Not:** `understat?: UnderstatData` alanini SIL. Yerine `transfermarkt?` ekle.

---

### 1.2 — `src/types/player.ts` YENi DOSYA OLUSTUR

```typescript
// src/types/player.ts — YENi DOSYA

export interface PlayerData {
  name: string;
  slug: string;
  ids: {
    sofascore: number | null;
    transfermarkt: string | null;
    fbref: string | null;
  };
  team: string;            // takim slug
  league: string;          // lig key
  position: string;        // GK, DF, MF, FW
  nationality: string;
  dateOfBirth: string;     // YYYY-MM-DD
  height: number | null;   // cm
  weight: number | null;   // kg
  preferredFoot: string | null; // left, right, both
  number: number | null;
  contractUntil: string | null;
  weeklyWage: number | null;
  marketValue: number | null;
  marketValueHistory: Array<{ date: string; value: number }>;
  seasonStats: {
    [season: string]: {
      matches: number;
      goals: number;
      assists: number;
      minutes: number;
      yellowCards: number;
      redCards: number;
      shotsPerGame: number | null;
      passAccuracy: number | null;
      rating: number | null;     // SofaScore
      xG: number | null;
      xA: number | null;
    };
  };
  careerHistory: Array<{
    team: string;
    from: string;
    to: string | null;
    matches: number;
    goals: number;
  }>;
  scouting: {
    percentiles: Record<string, number>;  // goalsP90: 95, assistsP90: 72, vb.
    source: string;                        // 'fbref'
  } | null;
  injuries: Array<{
    type: string;
    from: string;
    to: string | null;
    days: number;
  }>;
  nationalTeam: {
    team: string;
    caps: number;
    goals: number;
  } | null;
  dataHash: string;
  lastUpdated: Date;
}
```

---

### 1.3 — `src/types/manager.ts` YENi DOSYA OLUSTUR

```typescript
// src/types/manager.ts — YENi DOSYA

export interface ManagerData {
  name: string;
  slug: string;
  ids: {
    sofascore: number | null;
    transfermarkt: string | null;
  };
  nationality: string;
  dateOfBirth: string | null;
  currentTeam: string | null;       // takim slug
  currentLeague: string | null;     // lig key
  since: string | null;             // goreve baslama tarihi
  currentStats: {
    matches: number;
    wins: number;
    draws: number;
    losses: number;
    winRate: number;
    goalsFor: number;
    goalsAgainst: number;
  } | null;
  preferredFormation: string | null;
  careerHistory: Array<{
    team: string;
    from: string;
    to: string | null;
    matches: number;
    winRate: number;
  }>;
  dataHash: string;
  lastUpdated: Date;
}
```

---

### 1.4 — `src/types/news.ts` YENi DOSYA OLUSTUR

```typescript
// src/types/news.ts — YENi DOSYA

export interface NewsArticle {
  title: string;
  date: string;
  summary: string;
  content: string | null;
  source: 'transfermarkt' | 'fbref';
  sourceUrl: string | null;
  author: string | null;
  relatedTeam: string | null;     // takim slug
  relatedPlayers: string[];       // oyuncu slug listesi
  category: 'transfer' | 'injury' | 'general' | 'rumor' | 'match';
  dataHash: string;
  lastUpdated: Date;
}

export interface TransferRumor {
  player: string;
  playerSlug: string | null;
  currentTeam: string | null;
  targetTeam: string | null;
  type: 'in' | 'out';
  source: string;
  date: string;
  reliability: 'low' | 'medium' | 'high';
  fee: number | null;
  dataHash: string;
  lastUpdated: Date;
}
```

---

### 1.5 — `src/types/live.ts` YENi DOSYA OLUSTUR

```typescript
// src/types/live.ts — YENi DOSYA

export type LivePhase = 'prematch' | 'inplay' | 'halftime' | 'postmatch';

export interface LiveMatchData {
  matchKey: string;
  league: string;
  phase: LivePhase;
  minute: number | null;
  score: { home: number; away: number } | null;
  statistics: Record<string, any> | null;
  xG: { home: number | null; away: number | null } | null;
  lastIncident: {
    type: string;
    player: string;
    team: string;
    minute: number;
  } | null;
  odds: {
    home: number | null;
    draw: number | null;
    away: number | null;
  } | null;
  momentum: { current: number; trend: 'home' | 'away' | 'neutral' } | null;
  lineups: Record<string, any> | null;      // prematch'te dolar
  missingPlayers: Record<string, any> | null; // prematch'te dolar
  updatedAt: string;
}
```

---

### 1.6 — `src/types/index.ts` GUNCELLE

**Mevcut:** 3 satir (match, team, bot export)

**Tamamen yeniden yaz:**

```typescript
export * from './match';
export * from './team';
export * from './bot';
export * from './player';
export * from './manager';
export * from './news';
export * from './live';
```

---

### 1.7 — `src/types/team.ts` GUNCELLE

**Mevcut:** 43 satir

**Yapilacaklar:**

#### A) `TeamIds` interface'inden `understat` cikar, degerlerini guncelle (satir 1-6)

```typescript
export interface TeamIds {
  fbref: string;
  sofascore: number | null;
  transfermarkt: string | null;
  // understat SILINDI
}
```

#### B) `PlayerInfo` interface'ini genislet (satir 8-14)

```typescript
export interface PlayerInfo {
  name: string;
  position: string;
  number: number | null;
  age: number;
  nationality: string | null;
  marketValue: number | null;       // string'den number'a degisti
  contractUntil: string | null;
  status: 'fit' | 'injured' | 'suspended' | 'doubtful';
  sofascoreId: number | null;
  transfermarktId: string | null;
  weeklyWage: number | null;
}
```

#### C) `ManagerInfo` interface'ini genislet (satir 24-27)

```typescript
export interface ManagerInfo {
  name: string;
  since: string;
  nationality: string | null;
  matches: number | null;
  winRate: number | null;
  previousClubs: string[];
}
```

#### D) `TeamData` interface'ini tamamen genislet (satir 29-42)

```typescript
export interface StadiumInfo {
  name: string;
  capacity: number | null;
  city: string | null;
  coordinates: { lat: number; lng: number } | null;
  builtYear: number | null;
}

export interface TransferRecord {
  player: string;
  playerSlug: string | null;
  from: string | null;        // takim adi (transferde geldigi yer)
  to: string | null;          // takim adi (transferde gittigi yer)
  fee: number | null;
  date: string;
  type: 'permanent' | 'loan' | 'loan-return' | 'free';
}

export interface TeamData {
  slug: string;
  name: string;
  league: string;
  aliases: string[];
  ids: TeamIds;
  manager: ManagerInfo | null;
  stadium: StadiumInfo | null;
  squad: PlayerInfo[];
  injuries: InjuryInfo[];
  suspended: Array<{
    player: string;
    reason: string;
    returnDate: string | null;
  }>;
  transferRumors: Array<{
    player: string;
    type: 'in' | 'out';
    source: string;
    date: string;
    reliability: 'low' | 'medium' | 'high';
  }>;
  transfers: {
    in: TransferRecord[];
    out: TransferRecord[];
  };
  news: Array<{
    title: string;
    date: string;
    summary: string;
    source: string;
    url: string | null;
  }>;
  recentForm: string[];           // ['W','W','L','D','W']
  totalSquadValue: number | null;
  averageAge: number | null;
  managerHistory: Array<{
    name: string;
    from: string;
    to: string | null;
    matches: number;
    winRate: number;
  }>;
  seasonStats?: Record<string, any>;
  dataHash: string;
  lastUpdated: Date;
}
```

> **Not:** Eski `squad?: { players, manager, injuries }` ic ic yapiyi duzlestirdik. Artik `squad`, `injuries`, `manager` ayri ust-seviye alanlar.

---

### 1.8 — `src/types/bot.ts` GUNCELLE

**Mevcut:** 40 satir

**Yapilacaklar:**

#### A) `LeagueConfig` interface'ine yeni alanlar ekle (satir 32-39)

```typescript
export interface LeagueConfig {
  key: string;
  name: string;
  country: string;
  fbrefId: number;
  sofascoreId: number;
  // v2 YENi
  transfermarktId: string | null;
  sofascoreSeasonId: number | null;  // Dinamik olarak da doldurulabilir
  // SILINEN
  // understatName: string | null;   ← SIL
}
```

#### B) `CheckpointState` interface ekle (dosyanin sonuna)

```typescript
export interface CheckpointState {
  phase: 'full' | 'delta' | 'live';
  currentBot: string;
  currentLeague: string;
  currentLeagueIndex: number;
  currentMatchIndex: number;
  completedLeagues: string[];
  completedMatchKeys: string[];  // Set olarak kullanilir
  totalCompleted: number;
  totalRemaining: number;
  lastSuccessfulScrape: string;  // ISO tarih
  resumable: boolean;
  errors: string[];
}

export interface WorkerTask {
  id: string;
  bot: string;
  league: string;
  type: 'full' | 'delta' | 'live';
  status: 'pending' | 'running' | 'completed' | 'failed';
  progress: number;  // 0-100
}
```

---

### 1.9 — `src/db/schemas.ts` GUNCELLE

**Mevcut:** 10 satir, 6 koleksiyon

**Tamamen yeniden yaz:**

```typescript
/** Firestore collection paths — v2: 12 koleksiyon */
export const COLLECTIONS = {
  seasons: 'seasons',
  leagues: 'leagues',
  teams: 'teams',
  matches: 'matches',
  players: 'players',           // YENi
  managers: 'managers',         // YENi
  live: 'live',                 // YENi
  referees: 'referees',
  news: 'news',                // YENi
  scrapeHistory: 'scrapeHistory',
  scrapeState: 'scrapeState',  // YENi
  seasonStats: 'seasonStats',  // YENi
} as const;

export type CollectionName = typeof COLLECTIONS[keyof typeof COLLECTIONS];
```

---

## ADIM 2: Team Mappings Olustur (~2 saat)

> **Amac:** 170+ takimin 3 kaynaktaki ID'lerini eslestiren merkezi bir tablo olustur.
> **Bagimlilik:** Yok — Adim 1 ile paralel yapilabilir.

---

### 2.1 — `src/config/teamMappings.ts` YENi DOSYA OLUSTUR

Bu dosya en cok zaman alacak is — her takimin sofascoreId, transfermarktId ve fbrefId degerlerini bulmak gerekiyor.

```typescript
// src/config/teamMappings.ts — YENi DOSYA

export interface TeamMapping {
  slug: string;
  name: string;
  league: string;
  sofascoreId: number;
  transfermarktId: string;
  fbrefId: string;              // FBref'teki takim hash ID'si
  aliases: string[];
}

/**
 * 170+ takim icin 3 kaynak arasi esleme tablosu.
 * sofascoreId: SofaScore API /team/{id}
 * transfermarktId: Transfermarkt URL'sindeki verein/{id}
 * fbrefId: FBref URL'sindeki /squads/{id}/ hash'i
 */
export const TEAM_MAPPINGS: TeamMapping[] = [
  // === PREMIER LEAGUE ===
  { slug: 'arsenal', name: 'Arsenal', league: 'premier-league', sofascoreId: 42, transfermarktId: '11', fbrefId: '18bb7c10', aliases: ['Arsenal FC'] },
  { slug: 'aston-villa', name: 'Aston Villa', league: 'premier-league', sofascoreId: 40, transfermarktId: '405', fbrefId: '8602292d', aliases: ['Aston Villa FC'] },
  { slug: 'bournemouth', name: 'Bournemouth', league: 'premier-league', sofascoreId: 60, transfermarktId: '989', fbrefId: 'b8fd03ef', aliases: ['AFC Bournemouth'] },
  { slug: 'brentford', name: 'Brentford', league: 'premier-league', sofascoreId: 50, transfermarktId: '1148', fbrefId: 'cd051869', aliases: ['Brentford FC'] },
  { slug: 'brighton', name: 'Brighton', league: 'premier-league', sofascoreId: 30, transfermarktId: '1237', fbrefId: 'd07537b9', aliases: ['Brighton & Hove Albion'] },
  { slug: 'chelsea', name: 'Chelsea', league: 'premier-league', sofascoreId: 38, transfermarktId: '631', fbrefId: 'cff3d9bb', aliases: ['Chelsea FC'] },
  { slug: 'crystal-palace', name: 'Crystal Palace', league: 'premier-league', sofascoreId: 31, transfermarktId: '873', fbrefId: '47c64c55', aliases: ['Crystal Palace FC'] },
  { slug: 'everton', name: 'Everton', league: 'premier-league', sofascoreId: 48, transfermarktId: '29', fbrefId: 'd3fd31cc', aliases: ['Everton FC'] },
  { slug: 'fulham', name: 'Fulham', league: 'premier-league', sofascoreId: 43, transfermarktId: '931', fbrefId: 'fd962109', aliases: ['Fulham FC'] },
  { slug: 'ipswich', name: 'Ipswich Town', league: 'premier-league', sofascoreId: 32, transfermarktId: '677', fbrefId: 'b2b47a98', aliases: ['Ipswich'] },
  { slug: 'leicester', name: 'Leicester City', league: 'premier-league', sofascoreId: 31, transfermarktId: '1003', fbrefId: 'a2d435b3', aliases: ['Leicester'] },
  { slug: 'liverpool', name: 'Liverpool', league: 'premier-league', sofascoreId: 44, transfermarktId: '31', fbrefId: '822bd0ba', aliases: ['Liverpool FC'] },
  { slug: 'manchester-city', name: 'Manchester City', league: 'premier-league', sofascoreId: 17, transfermarktId: '281', fbrefId: 'b8fd03ef', aliases: ['Man City'] },
  { slug: 'manchester-united', name: 'Manchester United', league: 'premier-league', sofascoreId: 35, transfermarktId: '985', fbrefId: '19538871', aliases: ['Man Utd', 'Man United'] },
  { slug: 'newcastle', name: 'Newcastle United', league: 'premier-league', sofascoreId: 39, transfermarktId: '762', fbrefId: 'b2b47a98', aliases: ['Newcastle Utd'] },
  { slug: 'nottingham-forest', name: 'Nottingham Forest', league: 'premier-league', sofascoreId: 14, transfermarktId: '703', fbrefId: 'e4a775cb', aliases: ["Nott'ham Forest"] },
  { slug: 'southampton', name: 'Southampton', league: 'premier-league', sofascoreId: 45, transfermarktId: '180', fbrefId: '33c895d4', aliases: ['Southampton FC'] },
  { slug: 'tottenham', name: 'Tottenham Hotspur', league: 'premier-league', sofascoreId: 33, transfermarktId: '148', fbrefId: '361ca564', aliases: ['Spurs', 'Tottenham'] },
  { slug: 'west-ham', name: 'West Ham United', league: 'premier-league', sofascoreId: 37, transfermarktId: '379', fbrefId: '7c21e445', aliases: ['West Ham', 'West Ham Utd'] },
  { slug: 'wolves', name: 'Wolverhampton Wanderers', league: 'premier-league', sofascoreId: 3, transfermarktId: '543', fbrefId: '8cec06e1', aliases: ['Wolves', 'Wolverhampton'] },

  // === SUPER LIG ===
  { slug: 'galatasaray', name: 'Galatasaray', league: 'super-lig', sofascoreId: 3061, transfermarktId: '141', fbrefId: 'a0f656f1', aliases: ['Galatasaray SK'] },
  { slug: 'fenerbahce', name: 'Fenerbahce', league: 'super-lig', sofascoreId: 3057, transfermarktId: '36', fbrefId: '4f5a0f07', aliases: ['Fenerbahce SK'] },
  { slug: 'besiktas', name: 'Besiktas', league: 'super-lig', sofascoreId: 3050, transfermarktId: '114', fbrefId: '7e81a5e6', aliases: ['Besiktas JK'] },
  { slug: 'trabzonspor', name: 'Trabzonspor', league: 'super-lig', sofascoreId: 3060, transfermarktId: '449', fbrefId: 'c1d8b884', aliases: [] },
  { slug: 'basaksehir', name: 'Istanbul Basaksehir', league: 'super-lig', sofascoreId: 6890, transfermarktId: '6890', fbrefId: 'ff734f3e', aliases: ['Basaksehir'] },
  // ... diger Super Lig takimlari (alanyaspor, antalyaspor, vb.)

  // === LA LIGA ===
  { slug: 'real-madrid', name: 'Real Madrid', league: 'la-liga', sofascoreId: 2829, transfermarktId: '418', fbrefId: '53a2f082', aliases: ['Real Madrid CF'] },
  { slug: 'barcelona', name: 'Barcelona', league: 'la-liga', sofascoreId: 2817, transfermarktId: '131', fbrefId: '206d90db', aliases: ['FC Barcelona'] },
  { slug: 'atletico-madrid', name: 'Atletico Madrid', league: 'la-liga', sofascoreId: 2836, transfermarktId: '13', fbrefId: 'db3b9613', aliases: ['Atletico de Madrid'] },
  // ... diger La Liga takimlari

  // === SERIE A ===
  { slug: 'inter', name: 'Inter Milan', league: 'serie-a', sofascoreId: 2697, transfermarktId: '46', fbrefId: 'd609edc0', aliases: ['Internazionale', 'FC Internazionale'] },
  { slug: 'ac-milan', name: 'AC Milan', league: 'serie-a', sofascoreId: 2572, transfermarktId: '5', fbrefId: 'dc56fe76', aliases: ['Milan'] },
  { slug: 'juventus', name: 'Juventus', league: 'serie-a', sofascoreId: 2687, transfermarktId: '506', fbrefId: 'e0652b02', aliases: ['Juventus FC'] },
  // ... diger Serie A takimlari

  // === BUNDESLIGA ===
  { slug: 'bayern-munich', name: 'Bayern Munich', league: 'bundesliga', sofascoreId: 2672, transfermarktId: '27', fbrefId: '054efa67', aliases: ['Bayern Munchen', 'FC Bayern Munchen'] },
  { slug: 'borussia-dortmund', name: 'Borussia Dortmund', league: 'bundesliga', sofascoreId: 2673, transfermarktId: '16', fbrefId: 'add600ae', aliases: ['Dortmund', 'BVB'] },
  // ... diger Bundesliga takimlari

  // === LIGUE 1 ===
  { slug: 'psg', name: 'Paris Saint-Germain', league: 'ligue-1', sofascoreId: 1644, transfermarktId: '583', fbrefId: 'e2d8892c', aliases: ['PSG', 'Paris SG'] },
  // ... diger Ligue 1 takimlari

  // === EREDIVISIE ===
  // ... 18 takim

  // === PRIMEIRA LIGA ===
  // ... 18 takim
];

// === HIZLI LOOKUP MAP'LERI ===

/** slug → TeamMapping */
export const SLUG_MAP = new Map(TEAM_MAPPINGS.map(t => [t.slug, t]));

/** sofascoreId → TeamMapping */
export const SOFASCORE_TEAM_MAP = new Map(TEAM_MAPPINGS.map(t => [t.sofascoreId, t]));

/** transfermarktId → TeamMapping */
export const TM_TEAM_MAP = new Map(TEAM_MAPPINGS.map(t => [t.transfermarktId, t]));

/** Belirli bir lig icin takimlari dondur */
export function getTeamsByLeague(leagueKey: string): TeamMapping[] {
  return TEAM_MAPPINGS.filter(t => t.league === leagueKey);
}
```

> **ONEMLI:** Bu dosyadaki ID'ler placeholder'dir. Gercek ID'ler SofaScore API `/team/{id}`, Transfermarkt URL'leri ve FBref `/squads/{id}/` sayfalarindan tek tek dogrulanmalidir. En cok zaman alan is budur (~2 saat).

---

### 2.2 — `src/utils/teamMatcher.ts` GUNCELLE

**Mevcut:** 111 satir, 50+ alias

**Yapilacaklar:** TEAM_MAPPINGS'den alias'lari otomatik yukle, manual TEAM_ALIASES silinsin:

Mevcut `TEAM_ALIASES` objesini (satir 6-69) SIL ve yerine:

```typescript
import { TEAM_MAPPINGS } from '../config/teamMappings';

// Otomatik olustur: TEAM_MAPPINGS'deki alias'lari + slug'lari kaydet
const aliasToSlug = new Map<string, string>();
for (const mapping of TEAM_MAPPINGS) {
  aliasToSlug.set(mapping.slug, mapping.slug);
  aliasToSlug.set(mapping.name.toLowerCase(), mapping.slug);
  for (const alias of mapping.aliases) {
    aliasToSlug.set(alias.toLowerCase(), mapping.slug);
  }
}
```

Mevcut `normalizeTeamName` ve `registerAlias` fonksiyonlarini koru (satir 84-110). Sadece `aliasToSlug` map'inin kaynak degisikligi yeterli.

---

## ADIM 3: SofaScore Season ID Konfigurasyonu (~1 saat)

> **Amac:** Her turnuva icin 2025-26 sezon ID'lerini tanimla.
> **Bagimlilik:** Adim 1 (LeagueConfig type)

---

### 3.1 — `src/config/sofascoreSeasonIds.ts` YENi DOSYA OLUSTUR

```typescript
// src/config/sofascoreSeasonIds.ts — YENi DOSYA

import axios from 'axios';
import { sleep } from '../utils/sleep';

/**
 * Statik season ID tablosu.
 * SofaScore API /unique-tournament/{id}/seasons endpoint'inden alinmistir.
 * Her sezon baslangicinda guncellenmeli.
 */
export const SOFASCORE_SEASON_IDS: Record<string, number> = {
  'premier-league': 61627,
  'la-liga': 62150,
  'serie-a': 62153,
  'bundesliga': 62154,
  'ligue-1': 62155,
  'super-lig': 63814,
  'eredivisie': 62160,
  'primeira-liga': 62161,
  'champions-league': 62148,
  'europa-league': 62149,
  'conference-league': 62151,
};

/**
 * SofaScore API'den dinamik olarak season ID cek.
 * Statik tablo gecersiz oldugunda veya yeni sezon basladiginda kullanilir.
 */
export async function fetchSeasonId(tournamentId: number): Promise<number | null> {
  try {
    const resp = await axios.get(
      `https://api.sofascore.com/api/v1/unique-tournament/${tournamentId}/seasons`,
      { timeout: 15000, headers: { 'User-Agent': 'Mozilla/5.0' } }
    );
    const seasons = resp.data?.seasons;
    if (Array.isArray(seasons) && seasons.length > 0) {
      return seasons[0].id;  // En guncel sezon
    }
    return null;
  } catch {
    return null;
  }
}

/**
 * Tum ligler icin season ID'leri dogrula ve eksikleri doldur.
 * Uygulama basladiginda bir kez cagrilir.
 */
export async function validateSeasonIds(
  leagues: Array<{ key: string; sofascoreId: number }>
): Promise<Record<string, number>> {
  const validated = { ...SOFASCORE_SEASON_IDS };

  for (const league of leagues) {
    if (!validated[league.key]) {
      const dynamicId = await fetchSeasonId(league.sofascoreId);
      if (dynamicId) {
        validated[league.key] = dynamicId;
      }
      await sleep(2000);
    }
  }

  return validated;
}
```

> **Not:** `SOFASCORE_SEASON_IDS`'deki sayilar placeholder'dir. Gercek degerler ilk calistirmada `/unique-tournament/{id}/seasons` endpoint'inden cekilip buraya yazilmali.

---

### 3.2 — `src/config/leagues.ts` GUNCELLE

**Mevcut:** 104 satir, 11 lig tanimli. Her lig'de `understatName` var.

**Yapilacaklar:**

#### A) `understatName` alanini SIL, yeni alanlar ekle

Her lig objesinde su degisiklik:

```
CIKAR:  understatName: 'EPL',      // veya null
EKLE:   transfermarktId: 'GB1',    // Transfermarkt lig kodu
EKLE:   sofascoreSeasonId: null,   // Dinamik doldurulacak
```

Ornek — Premier League girdisi (satir 4-11):

```typescript
{
  key: 'premier-league',
  name: 'Premier League',
  country: 'England',
  fbrefId: 9,
  sofascoreId: 17,
  transfermarktId: 'GB1',
  sofascoreSeasonId: null,  // validateSeasonIds() ile doldurulur
},
```

Tum 11 lig icin transfermarktId'ler:

```
premier-league  → 'GB1'
la-liga         → 'ES1'
serie-a         → 'IT1'
bundesliga      → 'L1'
ligue-1         → 'FR1'
super-lig       → 'TR1'
eredivisie      → 'NL1'
primeira-liga   → 'PO1'
champions-league → 'CL'
europa-league   → 'EL'
conference-league → 'ECLQ'
```

#### B) `UNDERSTAT_NAME_MAP` export'unu SIL (satir 101-103)

```
CIKAR:
export const UNDERSTAT_NAME_MAP = new Map(
  LEAGUES.filter(l => l.understatName).map(l => [l.understatName!, l.key])
);
```

---

### 3.3 — `src/config/seasons.ts` GUNCELLE

**Mevcut:** 10 satir

**Yapilacaklar:** `UNDERSTAT_SEASON` satirini SIL

```
CIKAR:
  export const UNDERSTAT_SEASON = '2025';
```

---

## ADIM 4: Hash Utility + Data Cleaner (~1 saat)

> **Amac:** Delta guncelleme icin hash fonksiyonu + eski veriyi silme scripti.
> **Bagimlilik:** Adim 1

---

### 4.1 — `src/utils/hashCompare.ts` YENi DOSYA OLUSTUR

```typescript
// src/utils/hashCompare.ts — YENi DOSYA

import crypto from 'crypto';

const EXCLUDE_KEYS = ['lastUpdated', 'dataHash', 'sources', 'dataCompleteness', 'updatedAt'];

/**
 * Veri iceriginden MD5 hash uret.
 * Meta alanlari (lastUpdated, dataHash vb.) haric tutulur.
 * Tutarli cikti icin key'ler siralanir.
 */
export function dataHash(data: Record<string, any>): string {
  const filtered: Record<string, any> = {};
  for (const [key, value] of Object.entries(data)) {
    if (!EXCLUDE_KEYS.includes(key) && value !== undefined) {
      filtered[key] = value;
    }
  }
  const sorted = JSON.stringify(filtered, Object.keys(filtered).sort());
  return crypto.createHash('md5').update(sorted).digest('hex');
}

/**
 * Mevcut doc ile yeni veriyi karsilastir.
 * true = guncelleme gerekli, false = ayni veri (yazma)
 */
export function needsUpdate(existingHash: string | null | undefined, newData: Record<string, any>): boolean {
  if (!existingHash) return true;
  return existingHash !== dataHash(newData);
}
```

---

### 4.2 — `src/utils/dataCleaner.ts` YENi DOSYA OLUSTUR

```typescript
// src/utils/dataCleaner.ts — YENi DOSYA

import * as fs from 'fs';
import * as path from 'path';
import { Firestore } from 'firebase-admin/firestore';
import { COLLECTIONS } from '../db/schemas';
import { Logger } from './logger';

const logger = Logger.getInstance();
const BATCH_SIZE = 500;

/**
 * Tum local data/ klasorlerini temizle.
 * data/fbref/, data/sofascore/, data/transfermarkt/, data/understat/, data/statsbomb/
 */
export function cleanLocalData(dataDir: string): void {
  const folders = ['fbref', 'sofascore', 'transfermarkt', 'understat', 'statsbomb'];
  for (const folder of folders) {
    const dir = path.join(dataDir, folder);
    if (fs.existsSync(dir)) {
      const files = fs.readdirSync(dir);
      for (const file of files) {
        fs.unlinkSync(path.join(dir, file));
      }
      logger.info(`Temizlendi: ${dir} (${files.length} dosya silindi)`, 'DataCleaner');
    }
  }
}

/**
 * Firestore koleksiyonlarini toplu sil.
 * Dikkat: Bu islem geri alinamaz!
 */
export async function cleanFirestoreCollections(db: Firestore): Promise<void> {
  const collectionsToClean = [
    COLLECTIONS.matches,
    COLLECTIONS.teams,
    COLLECTIONS.leagues,
    COLLECTIONS.players,
    COLLECTIONS.managers,
    COLLECTIONS.live,
    COLLECTIONS.news,
    COLLECTIONS.seasonStats,
    COLLECTIONS.referees,
  ];

  for (const colName of collectionsToClean) {
    let deleted = 0;
    let snapshot = await db.collection(colName).limit(BATCH_SIZE).get();

    while (!snapshot.empty) {
      const batch = db.batch();
      for (const doc of snapshot.docs) {
        batch.delete(doc.ref);
      }
      await batch.commit();
      deleted += snapshot.docs.length;
      logger.info(`${colName}: ${deleted} doc silindi...`, 'DataCleaner');

      snapshot = await db.collection(colName).limit(BATCH_SIZE).get();
    }

    logger.info(`${colName}: Temizleme tamamlandi (${deleted} doc)`, 'DataCleaner');
  }
}
```

---

### 4.3 — `src/utils/matchStatusMapper.ts` YENi DOSYA OLUSTUR

```typescript
// src/utils/matchStatusMapper.ts — YENi DOSYA

import { MatchStatus } from '../types/match';

/**
 * SofaScore API statusCode → bizim MatchStatus
 */
const STATUS_MAP: Record<number, MatchStatus> = {
  0: 'scheduled',        // Not started
  6: 'live',             // 1st half
  7: 'halftime',         // Halftime
  8: 'live',             // 2nd half
  9: 'live',             // Extra time
  10: 'live',            // Penalty shootout
  11: 'halftime',        // Break time (extra time arasi)
  31: 'halftime',        // Halftime (extra)
  100: 'finished',       // Ended
  60: 'postponed',       // Postponed
  70: 'cancelled',       // Cancelled
  80: 'abandoned',       // Abandoned
};

export function mapSofaScoreStatus(statusCode: number): MatchStatus {
  return STATUS_MAP[statusCode] || 'scheduled';
}

/** Mac canli mi? (live tracker baslatilmali mi?) */
export function isLiveStatus(statusCode: number): boolean {
  return [6, 7, 8, 9, 10, 11, 31].includes(statusCode);
}

/** Mac bitmis mi? (post-match veri cekilmeli mi?) */
export function isFinishedStatus(statusCode: number): boolean {
  return statusCode === 100;
}

/** Mac ertelenmis/iptal mi? (atlanmali mi?) */
export function isInactiveStatus(statusCode: number): boolean {
  return [60, 70, 80].includes(statusCode);
}
```

---

## ADIM 5: Firestore Writer v2 (~2 saat)

> **Amac:** Yeni koleksiyonlar icin write metodlari + delta hash kontrolu.
> **Bagimlilik:** Adim 1, Adim 4

---

### 5.1 — `src/db/writer.ts` GUNCELLE

**Mevcut:** 99 satir, 6 metod (writeMatch, writeTeam, writeMatchBatch, writeTeamBatch, writeScrapeHistory, writeLeague, writeReferee)

**Yapilacaklar:** Mevcut metodlari koru + yeni metodlar ekle + delta hash entegrasyonu

Import'lari guncelle (satir 1-6):

```typescript
import { Firestore } from 'firebase-admin/firestore';
import { getDb } from './firebase';
import { COLLECTIONS } from './schemas';
import { Logger } from '../utils/logger';
import { MatchData, TeamData } from '../types';
import { PlayerData } from '../types/player';
import { ManagerData } from '../types/manager';
import { NewsArticle } from '../types/news';
import { LiveMatchData } from '../types/live';
import { CheckpointState } from '../types/bot';
import { BATCH_WRITE_LIMIT } from '../config/constants';
import { dataHash, needsUpdate } from '../utils/hashCompare';
```

Mevcut `writeMatch` metodunu guncelle (satir 19-25) — delta hash ekle:

```typescript
/** Write match data — delta hash kontrolu ile */
async writeMatch(matchKey: string, data: Partial<MatchData>): Promise<boolean> {
  const ref = this.db.collection(COLLECTIONS.matches).doc(matchKey);
  // Delta kontrol: mevcut hash'i oku
  const existing = await ref.get();
  const existingHash = existing.data()?.dataHash;
  if (existingHash && !needsUpdate(existingHash, data as any)) {
    return false; // Degismemis, yazma
  }
  const hash = dataHash(data as any);
  await ref.set(
    { ...data, dataHash: hash, lastUpdated: new Date() },
    { merge: true }
  );
  return true; // Yazildi
}
```

Ayni delta mantigi `writeTeam` icin de uygulanir.

Dosyanin sonuna (satir 98'den sonra) yeni metodlari ekle:

```typescript
  // === v2 YENi METODLAR ===

  /** Write player data */
  async writePlayer(playerId: string, data: Partial<PlayerData>): Promise<boolean> {
    const ref = this.db.collection(COLLECTIONS.players).doc(playerId);
    const existing = await ref.get();
    if (existing.data()?.dataHash && !needsUpdate(existing.data()?.dataHash, data as any)) {
      return false;
    }
    const hash = dataHash(data as any);
    await ref.set({ ...data, dataHash: hash, lastUpdated: new Date() }, { merge: true });
    return true;
  }

  /** Write manager data */
  async writeManager(managerId: string, data: Partial<ManagerData>): Promise<boolean> {
    const ref = this.db.collection(COLLECTIONS.managers).doc(managerId);
    const existing = await ref.get();
    if (existing.data()?.dataHash && !needsUpdate(existing.data()?.dataHash, data as any)) {
      return false;
    }
    const hash = dataHash(data as any);
    await ref.set({ ...data, dataHash: hash, lastUpdated: new Date() }, { merge: true });
    return true;
  }

  /** Write live match data — hash yok (her zaman yaz) */
  async writeLive(matchKey: string, data: LiveMatchData): Promise<void> {
    const ref = this.db.collection(COLLECTIONS.live).doc(matchKey);
    await ref.set({ ...data, updatedAt: new Date().toISOString() });
  }

  /** Delete live match doc (mac bittikten 2 saat sonra) */
  async deleteLive(matchKey: string): Promise<void> {
    await this.db.collection(COLLECTIONS.live).doc(matchKey).delete();
  }

  /** Write news article */
  async writeNews(newsId: string, data: Partial<NewsArticle>): Promise<boolean> {
    const ref = this.db.collection(COLLECTIONS.news).doc(newsId);
    const existing = await ref.get();
    if (existing.data()?.dataHash && !needsUpdate(existing.data()?.dataHash, data as any)) {
      return false;
    }
    const hash = dataHash(data as any);
    await ref.set({ ...data, dataHash: hash, lastUpdated: new Date() }, { merge: true });
    return true;
  }

  /** Write season stats (gol/asist kralligi) */
  async writeSeasonStats(leagueKey: string, data: Record<string, unknown>): Promise<void> {
    const ref = this.db.collection(COLLECTIONS.seasonStats).doc(leagueKey);
    const hash = dataHash(data);
    await ref.set({ ...data, dataHash: hash, lastUpdated: new Date() }, { merge: true });
  }

  /** Write/Update checkpoint state */
  async writeCheckpoint(sessionId: string, data: CheckpointState): Promise<void> {
    const ref = this.db.collection(COLLECTIONS.scrapeState).doc(sessionId);
    await ref.set(data);
  }

  /** Read checkpoint (resume icin) */
  async readCheckpoint(sessionId: string): Promise<CheckpointState | null> {
    const doc = await this.db.collection(COLLECTIONS.scrapeState).doc(sessionId).get();
    return doc.exists ? (doc.data() as CheckpointState) : null;
  }

  /** Read existing doc hash (delta kontrol icin hizli) */
  async getDocHash(collection: string, docId: string): Promise<string | null> {
    const doc = await this.db.collection(collection).doc(docId).get();
    return doc.data()?.dataHash || null;
  }
```

---

## ADIM 6: SofaScore Event Scraper — 19 Endpoint (~3 saat)

> **Amac:** Mevcut SofaScoreBot'u tamamen yeniden yaz. 19 event endpoint + tum mac verileri.
> **Bagimlilik:** Adim 1, 3, 5

---

### 6.1 — `src/bots/sofascore/SofaScoreBot.ts` TAMAMEN YENIDEN YAZ

**Mevcut:** 233 satir — gun bazli event cekme, 3 endpoint (statistics, odds, lineups)

**Yeni dosya yapisi:** Mevcut dosyadaki tum kod silinecek ve yerine asagidaki yapi gelecek.

Temel degisiklikler:
- Delay 25s → 3-4s
- 3 endpoint → 19 endpoint
- Sadece finished maclar → scheduled + finished + gelecek fikstur
- Hash bazli delta kontrol
- Adaptive rate limiter
- SofaScore seasonId kullanimi

```typescript
// src/bots/sofascore/SofaScoreBot.ts — TAMAMEN YENIDEN

import axios, { AxiosInstance } from 'axios';
import { BaseScraper } from '../BaseScraper';
import { BotRateConfig } from '../../config/botConfig';
import { LeagueConfig } from '../../types';
import { SEASON_START } from '../../config/seasons';
import { generateMatchKey } from '../../utils/dateMatcher';
import { normalizeTeamName } from '../../utils/teamMatcher';
import { retryWithBackoff } from '../../utils/retryWithBackoff';
import { FirestoreWriter } from '../../db/writer';
import { mapSofaScoreStatus } from '../../utils/matchStatusMapper';
import { SOFASCORE_SEASON_IDS } from '../../config/sofascoreSeasonIds';
import { sleep } from '../../utils/sleep';

const USER_AGENTS = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/131.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/130.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0',
  // ... 7+ daha UA
];

function randomUA(): string {
  return USER_AGENTS[Math.floor(Math.random() * USER_AGENTS.length)];
}

// Shared axios instance
const api: AxiosInstance = axios.create({
  baseURL: 'https://api.sofascore.com/api/v1',
  timeout: 30000,
});

export class SofaScoreBot extends BaseScraper {
  name = 'sofascore';
  private writer: FirestoreWriter | null = null;
  private consecutiveErrors = 0;
  private currentDelay: number;

  constructor(config: BotRateConfig) {
    super(config);
    this.status.name = 'SofaScore';
    this.currentDelay = config.delayMs;
    try { this.writer = new FirestoreWriter(); } catch { /**/ }
  }

  async start(leagues: LeagueConfig[]): Promise<void> {
    // ... BaseScraper baslatma kodu (mevcut pattern)
    // Her lig icin scrapeLeague cagir
    // 403'te bot durdur
  }

  private async scrapeLeague(league: LeagueConfig): Promise<void> {
    // Gun bazli event toplama (Agustos 2025 → bugun + 7 gun ileri)
    // Her event icin scrapeEvent cagir
  }

  /**
   * Tek bir mac icin 19 endpoint'i cek.
   * Bitirmis maclar: tum endpoint'ler
   * Gelecek maclar: sadece h2h, pregameForm, pregameOdds, missingPlayers
   * Canli maclar: live tracker'a birak
   */
  private async scrapeEvent(event: any, league: LeagueConfig): Promise<void> {
    const eventId = event.id;
    const statusCode = event.status?.code || 0;
    const status = mapSofaScoreStatus(statusCode);

    // 1. Temel mac bilgileri (event objesinden)
    // 2. /event/{id}/statistics
    // 3. /event/{id}/lineups
    // 4. /event/{id}/incidents
    // 5. /event/{id}/odds/1/all
    // 6. /event/{id}/shotmap
    // 7. /event/{id}/graph (momentum)
    // 8. /event/{id}/best-players
    // 9. /event/{id}/h2h/events
    // 10. /event/{id}/pregame-form
    // 11. /event/{id}/votes
    // 12. /event/{id}/highlights
    // 13. /event/{id}/managers
    // 14. /event/{id}/pregame-odds
    // 15. /event/{id}/missing-players
    // (comments, media, tweets → opsiyonel, oncelik dusuk)

    // Her endpoint icin: await this.fetchEndpoint(...)
    // Hata durumunda: null olarak kaydet, digerine gec
    // Sonunda: matchData olustur, hash uret, writer.writeMatch
  }

  private async fetchEndpoint(url: string): Promise<any> {
    await this.adaptiveWait();
    try {
      const resp = await retryWithBackoff(
        () => api.get(url, { headers: { 'User-Agent': randomUA() } }),
        { maxRetries: 2, baseDelayMs: this.currentDelay, backoffMultiplier: 2 },
        `SofaScore: ${url}`
      );
      this.consecutiveErrors = 0;
      this.currentDelay = Math.max(this.config.delayMs, this.currentDelay * 0.9);
      return resp.data;
    } catch (e: any) {
      this.consecutiveErrors++;
      if (e?.response?.status === 429) {
        this.currentDelay = Math.min(this.currentDelay * 3, 60000);
      } else if (e?.response?.status === 403) {
        this.currentDelay = 300000; // 5 dk bekle
        if (this.consecutiveErrors >= 3) throw e;
      }
      return null;
    }
  }

  private async adaptiveWait(): Promise<void> {
    const jitter = Math.random() * 1000;  // 0-1sn arasi rastgele ekleme
    await sleep(this.currentDelay + jitter);
  }
}
```

> **ONEMLI:** Bu taslaktir. Tam implementasyon sirasinda her endpoint'in response yapisini parse eden kod yazilmali. Ornegin `/event/{id}/shotmap` response'u `{ shotmap: [...] }` dondurur ve her item icin `{ player: { name }, isHome, xG, xGOT, bodyPart, situation, goalMouthLocation, coordinate: { x, y } }` alanlari map'lenmeli.

---

### 6.2 — `src/config/botConfig.ts` GUNCELLE

SofaScore delay'ini duşur (satir 22-28):

```
CIKAR:
  sofascore: {
    delayMs: 25000,

EKLE:
  sofascore: {
    delayMs: 3500,
```

Understat ve StatsBomb config'lerini SIL (satir 29-50):

```
CIKAR:
  understat: { ... },
  statsbomb: { ... },
```

---

## ADIM 7: SofaScore Turnuva + Takim + Oyuncu Scraper (~2 saat)

> **Amac:** Lig istatistikleri, gol kralligi, takim verileri, oyuncu verileri icin ayri scraper modulleri.
> **Bagimlilik:** Adim 6

---

### 7.1 — `src/bots/sofascore/SofaScoreTournamentScraper.ts` YENi DOSYA

Bu dosya 11 turnuva endpoint'ini isle:
- `standings/total`, `standings/home`, `standings/away` → leagues/ koleksiyonuna
- `top-players/goals`, `top-players/assists`, `top-players/rating`, `top-players/yellowCards` → seasonStats/ koleksiyonuna
- `statistics` → lig genel istatistikleri
- `rounds` → hafta bilgileri
- `seasons` → sezon ID dogrulama

### 7.2 — `src/bots/sofascore/SofaScoreTeamScraper.ts` YENi DOSYA

5 takim endpoint'ini isle:
- `near-events` → takimin yaklasan maclari
- `players` → takim kadrosu (SofaScore perspektifi)
- `transfers` → transfer hareketleri
- `manager-history` → TD gecmisi
- `statistics/season/{sid}` → takim sezon stat

### 7.3 — `src/bots/sofascore/SofaScorePlayerScraper.ts` YENi DOSYA

7 oyuncu endpoint'ini isle:
- `player/{id}` → profil
- `statistics/season/{sid}` → sezon stat
- `transfer-history` → transfer gecmisi
- `national-team-statistics` → milli takim
- `characteristics` → ozellikler
- `last-year-summary` → son yil ozet
- `heatmap/season/{sid}` → isi haritasi

> Her dosya icin pattern ayni: `fetchEndpoint` + response parse + `writer.writeXxx` + local cache

---

## ADIM 8: SofaScore Live Tracker (~2 saat)

> **Amac:** Canli mac takibi: pre/in/post-match 3 faz
> **Bagimlilik:** Adim 6

---

### 8.1 — `src/bots/sofascore/SofaScoreLiveTracker.ts` YENi DOSYA

```typescript
// src/bots/sofascore/SofaScoreLiveTracker.ts — YENi DOSYA

/**
 * Canli mac takip modulu.
 * Orchestrator tarafindan setInterval ile cagrilir.
 *
 * Calisma mantigi:
 * 1. /sport/football/live-events → canli mac listesi
 * 2. Her canli mac icin farkli polling intervali:
 *    - Pre-match (T-60dk): 5 dk'da bir (lineups, pregame-form, odds)
 *    - In-match (1./2. yari): 30 sn'de bir (skor, incidents, stats)
 *    - Halftime: 2 dk'da bir
 *    - Post-match (+2 saat): 5 dk'da bir (final stats, ratings, votes)
 * 3. Firestore live/{matchKey} koleksiyonuna yaz
 * 4. Gol/kart tespitinde FCM push bildirim gonder
 */

import axios from 'axios';
import { FirestoreWriter } from '../../db/writer';
import { LiveMatchData, LivePhase } from '../../types/live';
import { mapSofaScoreStatus, isLiveStatus, isFinishedStatus } from '../../utils/matchStatusMapper';
import { Logger } from '../../utils/logger';
// import { sendMatchNotification } from '../../utils/fcmNotifier';  // Adim 13'te eklenir

const logger = Logger.getInstance();
const API = 'https://api.sofascore.com/api/v1';

export class SofaScoreLiveTracker {
  private writer: FirestoreWriter;
  private trackedMatches = new Map<number, { phase: LivePhase; lastIncidentCount: number; finishedAt: number | null }>();
  private pollInterval: NodeJS.Timeout | null = null;

  constructor(writer: FirestoreWriter) {
    this.writer = writer;
  }

  /** Ana polling dongusunu baslat (30sn) */
  startPolling(): void {
    this.pollInterval = setInterval(() => this.poll(), 30000);
    logger.info('Live tracker baslatildi (30sn polling)', 'LiveTracker');
  }

  stopPolling(): void {
    if (this.pollInterval) clearInterval(this.pollInterval);
  }

  private async poll(): Promise<void> {
    // 1. Bugunun maclarini cek
    // 2. Izledigimiz liglere ait olanlari filtrele
    // 3. Her macin statusCode'una gore:
    //    - Canli → fetchLiveData + writeLive
    //    - Bitmis → fetchPostMatchData + writeMatch (final) + deleteLive (2 saat sonra)
    //    - Baslamak uzere (T-60dk) → fetchPreMatchData + writeLive
    // 4. Yeni gol/kart tespiti → FCM push
  }

  private async fetchLiveData(eventId: number): Promise<Partial<LiveMatchData>> {
    // /event/{id} → skor, dakika
    // /event/{id}/statistics → canli istatistik
    // /event/{id}/incidents → olaylar (gol, kart, degisiklik)
    // /event/{id}/odds/1/all → canli oranlar
    // /event/{id}/graph → momentum
    // /event/{id}/shotmap → canli sut haritasi
    return {} as any;
  }

  private async fetchPreMatchData(eventId: number): Promise<Partial<LiveMatchData>> {
    // /event/{id}/lineups → kadro
    // /event/{id}/pregame-form → form
    // /event/{id}/pregame-odds → oranlar
    // /event/{id}/missing-players → eksik oyuncular
    // /event/{id}/h2h/events → kafa kafaya
    return {} as any;
  }

  private async fetchPostMatchData(eventId: number): Promise<void> {
    // /event/{id}/statistics → final istatistik
    // /event/{id}/best-players → MOTM + en iyiler
    // /event/{id}/shotmap → final sut haritasi
    // /event/{id}/votes → oylama
    // /event/{id}/highlights → video ozet
    // → matches/{matchKey}'e final verisi yaz
    // → 2 saat sonra live/{matchKey} sil
  }

  /** Yeni incident tespit et (onceki sayiyla karsilastir) */
  private detectNewIncidents(eventId: number, incidents: any[]): any[] {
    const tracked = this.trackedMatches.get(eventId);
    const lastCount = tracked?.lastIncidentCount || 0;
    if (incidents.length > lastCount) {
      return incidents.slice(lastCount);
    }
    return [];
  }
}
```

---

## ADIM 9: FBref Bot Genisletme (~2 saat)

> **Amac:** 8 stat type → 12 stat type + oyuncu scouting + wages
> **Bagimlilik:** Adim 1

---

### 9.1 — `src/bots/fbref/urls.ts` GUNCELLE

**Mevcut:** 48 satir

**Yapilacaklar:**

#### A) STAT_TYPES dizisini genislet (satir 38-47)

```
CIKAR:
export const STAT_TYPES = [
  'stats', 'keepers', 'shooting', 'passing',
  'gca', 'defense', 'possession', 'misc',
] as const;

EKLE:
export const STAT_TYPES = [
  'stats', 'keepers', 'shooting', 'passing',
  'gca', 'defense', 'possession', 'misc',
  'passing_types', 'playingtime', 'keeper_adv', 'wages',
] as const;
```

#### B) Yeni URL generator fonksiyonlari ekle (dosyanin sonuna)

```typescript
/** Oyuncu profil sayfasi URL */
export function playerProfileUrl(playerId: string, playerSlug: string): string {
  return `${BASE}/players/${playerId}/${playerSlug}`;
}

/** Oyuncu scouting raporu URL */
export function playerScoutingUrl(playerId: string, playerSlug: string): string {
  return `${BASE}/players/${playerId}/scout/365_m1/${playerSlug}-Scouting-Report`;
}

/** Oyuncu mac kayitlari URL */
export function playerMatchLogsUrl(playerId: string, season: string, playerSlug: string): string {
  return `${BASE}/players/${playerId}/matchlogs/${season}/${playerSlug}`;
}
```

---

### 9.2 — `src/bots/fbref/FBrefBot.ts` GUNCELLE

**Mevcut:** 263 satir

**Yapilacaklar:**

#### A) `FBrefData` icerisindeki yeni alanlari doldurmak icin `scrapeMatch` metodunu guncelle (satir 205-261)

`matchData.fbref` objesine yeni alanlari ekle (satir 236-240 arasi):

```
CIKAR:
  passTypes: { home: { short: 0, medium: 0, long: 0, progressive: 0 }, away: { short: 0, medium: 0, long: 0, progressive: 0 } },

EKLE:
  passTypes: { home: { short: 0, medium: 0, long: 0, progressive: 0 }, away: { short: 0, medium: 0, long: 0, progressive: 0 } },
  passingTypes: null,
  playingTime: null,
  keeperAdv: null,
  wages: null,
```

#### B) `sources` dizisine `'fbref'` yerine `dataHash` da ekle (satir 242-244)

```
EKLE (matchData objesine):
  dataHash: '',  // writer yazarken hesaplanacak
```

---

### 9.3 — `src/bots/fbref/teamStatsScraper.ts` GUNCELLE

**Mevcut:** 50 satir

Degisiklik gerekmez — zaten `STAT_TYPES` dizisini import ediyor ve uzerine iterate ediyor. STAT_TYPES genisletilince otomatik olarak 12 stat tipi cekilecek.

Sadece `scrapeTeamSeasonStats` fonksiyonundaki JSDoc'u guncelle (satir 9-12):

```
CIKAR:  * Scrape all 8 stat types
EKLE:   * Scrape all 12 stat types
```

---

### 9.4 — `src/bots/fbref/playerScraper.ts` YENi DOSYA OLUSTUR

```typescript
// src/bots/fbref/playerScraper.ts — YENi DOSYA

import { playerProfileUrl, playerScoutingUrl } from './urls';
import { RateLimiter } from '../../utils/rateLimiter';
import { Logger } from '../../utils/logger';
import { fetchWithBrowser } from '../../utils/browser';
import * as cheerio from 'cheerio';
import { stripComments } from './parser';

const logger = Logger.getInstance();

export interface FBrefPlayerProfile {
  name: string;
  fbrefId: string;
  dateOfBirth: string | null;
  nationality: string | null;
  height: number | null;
  weight: number | null;
  position: string | null;
  preferredFoot: string | null;
}

export interface FBrefScoutingReport {
  percentiles: Record<string, number>;  // goalsP90: 95, vb.
  comparedTo: string;                    // "vs Forwards" vb.
}

/** Oyuncu profil sayfasini scrape et */
export async function scrapePlayerProfile(
  playerId: string,
  playerSlug: string,
  rateLimiter: RateLimiter,
): Promise<FBrefPlayerProfile> {
  const url = playerProfileUrl(playerId, playerSlug);
  await rateLimiter.wait();
  const html = await fetchWithBrowser(url, 5000);
  const $ = cheerio.load(stripComments(html));

  // #meta div'inden bilgileri cek
  // p etiketlerinden: Born, Position, Footed, Height/Weight
  // ... parse logic
  return {} as FBrefPlayerProfile;
}

/** Oyuncu scouting raporunu scrape et */
export async function scrapePlayerScouting(
  playerId: string,
  playerSlug: string,
  rateLimiter: RateLimiter,
): Promise<FBrefScoutingReport | null> {
  const url = playerScoutingUrl(playerId, playerSlug);
  await rateLimiter.wait();

  try {
    const html = await fetchWithBrowser(url, 5000);
    const $ = cheerio.load(stripComments(html));

    // Scouting raporu tablosundan percentile degerlerini cek
    // <div id="scout_summary"> altindaki tablo
    const percentiles: Record<string, number> = {};
    // ... parse logic

    return { percentiles, comparedTo: '' };
  } catch {
    return null;
  }
}
```

---

## ADIM 10: Transfermarkt Hibrit Scraper (~3 saat)

> **Amac:** Community API + Playwright fallback. 11 API + 12 Playwright endpoint.
> **Bagimlilik:** Adim 1, 2

---

### 10.1 — `src/bots/transfermarkt/TransfermarktBot.ts` TAMAMEN YENIDEN YAZ

**Mevcut:** 229 satir — sadece 3 API endpoint (injuries, players, profile)

**Yeni dosya:** Hibrit yaklasim. Mevcut dosyadaki tum kodu SIL ve yeniden yaz.

Temel degisiklikler:
- FBref cache bagimliligi yerine `TEAM_MAPPINGS` kullan
- 3 endpoint → 11 API + 12 Playwright
- Takim bazli → takim + oyuncu + haber bazli
- Delta hash kontrolu

```typescript
// src/bots/transfermarkt/TransfermarktBot.ts — TAMAMEN YENIDEN

import { BaseScraper } from '../BaseScraper';
import { BotRateConfig } from '../../config/botConfig';
import { LeagueConfig } from '../../types';
import { FirestoreWriter } from '../../db/writer';
import { getTeamsByLeague, TeamMapping } from '../../config/teamMappings';
import { TransfermarktApiClient } from './TransfermarktApiClient';
import { TransfermarktPlaywrightScraper } from './TransfermarktPlaywrightScraper';

export class TransfermarktBot extends BaseScraper {
  name = 'transfermarkt';
  private writer: FirestoreWriter | null = null;
  private apiClient: TransfermarktApiClient;
  private webScraper: TransfermarktPlaywrightScraper;

  constructor(config: BotRateConfig) {
    super(config);
    this.status.name = 'Transfermarkt';
    this.apiClient = new TransfermarktApiClient(config);
    this.webScraper = new TransfermarktPlaywrightScraper(config);
    try { this.writer = new FirestoreWriter(); } catch { /**/ }
  }

  async start(leagues: LeagueConfig[]): Promise<void> {
    // BaseScraper pattern ile baslat
    for (const league of leagues) {
      // Kupa turnuvalari icin takim listesi farkli
      // Lig takimlarini TEAM_MAPPINGS'den al (FBref cache'ye bagimsiz)
      const teams = getTeamsByLeague(league.key);
      for (const team of teams) {
        await this.scrapeTeam(team, league);
      }
    }
  }

  private async scrapeTeam(team: TeamMapping, league: LeagueConfig): Promise<void> {
    // === API ILE CEKILENLER ===
    const squad = await this.apiClient.getSquad(team.transfermarktId);
    const injuries = await this.apiClient.getInjuries(team.transfermarktId);
    const profile = await this.apiClient.getProfile(team.transfermarktId);
    const transfers = await this.apiClient.getTransfers(team.transfermarktId);

    // === PLAYWRIGHT ILE CEKILENLER (API'de olmayan) ===
    const rumors = await this.webScraper.getRumors(team.transfermarktId);
    const news = await this.webScraper.getNews(team.transfermarktId, team.slug);
    const suspended = await this.webScraper.getSuspended(team.transfermarktId, team.slug);
    const stadium = await this.webScraper.getStadium(team.transfermarktId, team.slug);
    const managerHistory = await this.webScraper.getManagerHistory(team.transfermarktId, team.slug);

    // TeamData olustur ve yaz
    // PlayerData olustur (her oyuncu icin) ve yaz
    // ManagerData olustur ve yaz
    // NewsArticle olustur (her haber icin) ve yaz
  }
}
```

---

### 10.2 — `src/bots/transfermarkt/TransfermarktApiClient.ts` YENi DOSYA

```typescript
// src/bots/transfermarkt/TransfermarktApiClient.ts — YENi DOSYA

import axios, { AxiosInstance } from 'axios';
import { BotRateConfig } from '../../config/botConfig';
import { retryWithBackoff } from '../../utils/retryWithBackoff';
import { RateLimiter } from '../../utils/rateLimiter';

const API_BASE = 'https://transfermarkt-api.fly.dev';

/**
 * Transfermarkt Community API client.
 * 11 endpoint'i sarar. API kapanirsa Playwright fallback devreye girer.
 */
export class TransfermarktApiClient {
  private api: AxiosInstance;
  private rateLimiter: RateLimiter;

  constructor(config: BotRateConfig) {
    this.rateLimiter = new RateLimiter(config.delayMs);
    this.api = axios.create({ baseURL: API_BASE, timeout: 30000 });
  }

  async getSquad(teamId: string): Promise<any[]> {
    return this.fetch(`/clubs/${teamId}/players`).then(d => d?.players || []);
  }

  async getInjuries(teamId: string): Promise<any[]> {
    return this.fetch(`/clubs/${teamId}/injuries`).then(d => d?.injuries || []);
  }

  async getProfile(teamId: string): Promise<any> {
    return this.fetch(`/clubs/${teamId}/profile`);
  }

  async getTransfers(teamId: string): Promise<any> {
    return this.fetch(`/clubs/${teamId}/transfers`);
  }

  async getPlayerProfile(playerId: string): Promise<any> {
    return this.fetch(`/players/${playerId}/profile`);
  }

  async getPlayerTransfers(playerId: string): Promise<any> {
    return this.fetch(`/players/${playerId}/transfers`);
  }

  async getPlayerStats(playerId: string): Promise<any> {
    return this.fetch(`/players/${playerId}/stats`);
  }

  async getPlayerMarketValue(playerId: string): Promise<any> {
    return this.fetch(`/players/${playerId}/market-value`);
  }

  async getLeagueClubs(competitionId: string): Promise<any[]> {
    return this.fetch(`/competitions/${competitionId}/clubs`).then(d => d?.clubs || []);
  }

  async getLeagueTable(competitionId: string): Promise<any> {
    return this.fetch(`/competitions/${competitionId}/table`);
  }

  async search(query: string): Promise<any> {
    return this.fetch(`/search?q=${encodeURIComponent(query)}`);
  }

  private async fetch(endpoint: string): Promise<any> {
    await this.rateLimiter.wait();
    try {
      const resp = await retryWithBackoff(
        () => this.api.get(endpoint),
        { maxRetries: 2, baseDelayMs: 3000, backoffMultiplier: 2 },
        `TM API: ${endpoint}`
      );
      return resp.data;
    } catch {
      return null;
    }
  }
}
```

---

### 10.3 — `src/bots/transfermarkt/TransfermarktPlaywrightScraper.ts` YENi DOSYA

```typescript
// src/bots/transfermarkt/TransfermarktPlaywrightScraper.ts — YENi DOSYA

import { BotRateConfig } from '../../config/botConfig';
import { RateLimiter } from '../../utils/rateLimiter';
import { fetchWithBrowser } from '../../utils/browser';
import * as cheerio from 'cheerio';
import { Logger } from '../../utils/logger';

const logger = Logger.getInstance();
const TM_BASE = 'https://www.transfermarkt.com.tr';

/**
 * Transfermarkt Playwright scraper — API'de olmayan veriler.
 * 12 kategori: soylenti, haber, cezali, hakem, stadyum, TD gecmisi,
 * kontrati bitenler, oyuncu detay, kadro yas, toplam deger, transfer, form
 */
export class TransfermarktPlaywrightScraper {
  private rateLimiter: RateLimiter;

  constructor(config: BotRateConfig) {
    this.rateLimiter = new RateLimiter(config.delayMs);
  }

  async getRumors(teamId: string): Promise<any[]> {
    // /ceapi/transferGeruechte/list/verein/{id} — JSON API
    // Cheerio ile parse et
    return [];
  }

  async getNews(teamId: string, teamSlug: string): Promise<any[]> {
    // /{teamSlug}/news/verein/{id}
    // HTML parse: baslik, tarih, ozet, link
    return [];
  }

  async getSuspended(teamId: string, teamSlug: string): Promise<any[]> {
    // /{teamSlug}/sperren/verein/{id}
    return [];
  }

  async getStadium(teamId: string, teamSlug: string): Promise<any> {
    // /{teamSlug}/stadion/verein/{id}
    // kapasite, sehir, yapim yili
    return null;
  }

  async getManagerHistory(teamId: string, teamSlug: string): Promise<any[]> {
    // /{teamSlug}/mitarbeiter/verein/{id}
    return [];
  }

  async getExpiringContracts(teamId: string, teamSlug: string): Promise<any[]> {
    // /{teamSlug}/vertragsende/verein/{id}
    return [];
  }

  async getPlayerDetailStats(playerId: string, playerSlug: string): Promise<any> {
    // /{playerSlug}/leistungsdatendetails/spieler/{id}
    return null;
  }

  async getTeamForm(teamId: string, teamSlug: string): Promise<string[]> {
    // /{teamSlug}/spielplan/verein/{id}
    return [];
  }

  async getRefereeAssignments(leagueId: string, leagueSlug: string): Promise<any[]> {
    // /{leagueSlug}/schiedsrichter/wettbewerb/{id}
    return [];
  }

  private async fetchPage(path: string): Promise<cheerio.CheerioAPI | null> {
    await this.rateLimiter.wait();
    try {
      const html = await fetchWithBrowser(`${TM_BASE}${path}`, 8000);
      if (!html || html.length < 2000) return null;
      return cheerio.load(html);
    } catch (e) {
      logger.warn(`TM Playwright fetch failed: ${path}: ${e}`, 'Transfermarkt');
      return null;
    }
  }
}
```

---

## ADIM 11: Data Merger v2 (~1.5 saat)

> **Amac:** 3 kaynak birlestirme, completeness skoru, dataHash uretimi.
> **Bagimlilik:** Adim 5, 6, 9, 10

---

### 11.1 — `src/db/matchMerger.ts` GUNCELLE

**Mevcut:** 102 satir

**Yapilacaklar:**

#### A) `understat` referanslarini SIL

Satir 43-45'i sil:
```
CIKAR:
  if (incoming.understat && !existing.understat) {
    merged.understat = incoming.understat;
  }
```

Yerine `transfermarkt` ekle:
```typescript
  if (incoming.transfermarkt && !existing.transfermarkt) {
    merged.transfermarkt = incoming.transfermarkt;
  }
```

#### B) `calculateCompleteness` fonksiyonunu guncelle (satir 61-101)

`understat` referanslarini SIL, yeni alanlari ekle:

```
CIKAR (satir 77-80):
  total += 3;
  if (match.fbref) filled++;
  if (match.sofascore) filled++;
  if (match.understat) filled++;

EKLE:
  total += 3;
  if (match.fbref) filled++;
  if (match.sofascore) filled++;
  if (match.transfermarkt) filled++;

  // v2 yeni alanlar
  total += 5;
  if (match.xG?.home != null) filled++;
  if (match.shotMap?.length) filled++;
  if (match.momentum?.length) filled++;
  if (match.bestPlayers) filled++;
  if (match.highlights?.length) filled++;
```

#### C) `mergeMatchData` fonksiyonuna `dataHash` uretimi ekle

Import ekle:
```typescript
import { dataHash } from '../utils/hashCompare';
```

Fonksiyonun sonuna (return'den once):
```typescript
  merged.dataHash = dataHash(merged as any);
```

---

## ADIM 12: Orchestrator v2 (~3 saat)

> **Amac:** 3 faz + Worker Manager + checkpoint/resume
> **Bagimlilik:** Adim 5-11

---

### 12.1 — `src/orchestrator.ts` TAMAMEN YENIDEN YAZ

**Mevcut:** 221 satir — 5 bot, 4 faz (FBref→Understat→StatsBomb→SofaScore→TM)

**Yeni dosya:** Tamamen silinip yeniden yazilacak. Understat + StatsBomb cikarilacak.

```typescript
// src/orchestrator.ts — TAMAMEN YENIDEN

import { LEAGUES } from './config/leagues';
import { BOT_CONFIGS } from './config/botConfig';
import { FBrefBot } from './bots/fbref/FBrefBot';
import { SofaScoreBot } from './bots/sofascore/SofaScoreBot';
import { TransfermarktBot } from './bots/transfermarkt/TransfermarktBot';
import { SofaScoreLiveTracker } from './bots/sofascore/SofaScoreLiveTracker';
import { SofaScoreTournamentScraper } from './bots/sofascore/SofaScoreTournamentScraper';
import { FirestoreWriter } from './db/writer';
import { Logger } from './utils/logger';
import { BaseScraper } from './bots/BaseScraper';
import { BotStatus, LeagueConfig, CheckpointState } from './types';
import { validateSeasonIds } from './config/sofascoreSeasonIds';
import { cleanLocalData, cleanFirestoreCollections } from './utils/dataCleaner';
import { getDb, isFirebaseInitialized } from './db/firebase';
// ... socket handler import'lari

const logger = Logger.getInstance();

const bots: Record<string, BaseScraper> = {};
let isRunning = false;
let writer: FirestoreWriter | null = null;
let liveTracker: SofaScoreLiveTracker | null = null;
let deltaInterval: NodeJS.Timeout | null = null;

/**
 * v2 Orchestrator — 3 calisma modu.
 */

// === MODE 1: FULL SCRAPE ===
export async function startFullScrape(): Promise<void> {
  if (isRunning) return;
  isRunning = true;
  logger.info('=== FULL SCRAPE BASLATILDI ===', 'Orchestrator');

  // 0. Season ID'leri dogrula
  const seasonIds = await validateSeasonIds(LEAGUES);
  // LEAGUES'e seasonId'leri yaz
  for (const league of LEAGUES) {
    league.sofascoreSeasonId = seasonIds[league.key] || null;
  }

  // 1. Eski veriyi temizle (sadece ilk calistirma icin)
  // cleanLocalData(...)
  // if (isFirebaseInitialized()) await cleanFirestoreCollections(getDb());

  // 2. Checkpoint kontrol — onceki yarim kalmis is var mi?
  // const checkpoint = await writer.readCheckpoint('full-scrape');
  // if (checkpoint?.resumable) { ... kaldigi yerden devam ... }

  // 3. Phase 1: SofaScore API + FBref (PARALEL)
  const sofascoreBot = new SofaScoreBot(BOT_CONFIGS.sofascore);
  const fbrefBot = new FBrefBot(BOT_CONFIGS.fbref);
  bots['sofascore'] = sofascoreBot;
  bots['fbref'] = fbrefBot;
  // wireBot(...) — mevcut pattern

  await Promise.allSettled([
    sofascoreBot.start(LEAGUES),
    fbrefBot.start(LEAGUES),
  ]);

  // 4. Phase 2: Transfermarkt (SIRA ILE — ban riski yuksek)
  const tmBot = new TransfermarktBot(BOT_CONFIGS.transfermarkt);
  bots['transfermarkt'] = tmBot;
  await tmBot.start(LEAGUES);

  // 5. Phase 3: Turnuva verileri (puan tablosu, gol kralligi)
  // const tournamentScraper = new SofaScoreTournamentScraper(writer, seasonIds);
  // await tournamentScraper.scrapeAll(LEAGUES);

  // 6. Scrape history yaz
  // 7. Delta + Live moduna gec
  startDeltaMode();
  startLiveMode();

  isRunning = false;
}

// === MODE 2: DELTA UPDATE ===
function startDeltaMode(): void {
  deltaInterval = setInterval(async () => {
    logger.info('Delta update baslatildi', 'Orchestrator');
    // 1. SofaScore: bugun + yarin maclarini kontrol et
    // 2. FBref: henuz cekilmemis mac raporlarini cek
    // 3. Transfermarkt: sakatlik + soylenti + haber kontrolu
    // 4. Puan tablosu + gol kralligi guncelle
    // 5. Hash bazli delta: sadece degisen veriyi yaz
  }, 30 * 60 * 1000); // 30 dk
}

// === MODE 3: LIVE TRACKER ===
function startLiveMode(): void {
  if (!writer) return;
  liveTracker = new SofaScoreLiveTracker(writer);
  liveTracker.startPolling();
}

// === KONTROL FONKSiYONLARI ===
export function stopAll(): void {
  for (const bot of Object.values(bots)) bot.stop();
  if (deltaInterval) clearInterval(deltaInterval);
  if (liveTracker) liveTracker.stopPolling();
  isRunning = false;
}

export function getOrchestratorStatus(): { isRunning: boolean; bots: Record<string, BotStatus> } {
  const statuses: Record<string, BotStatus> = {};
  for (const [name, bot] of Object.entries(bots)) {
    statuses[name] = { ...bot.status };
  }
  return { isRunning, bots: statuses };
}

// pauseBot, retryBot — mevcut pattern koru
```

---

### 12.2 — `src/index.ts` GUNCELLE

**Mevcut:** 62 satir

**Yapilacaklar:**

Surekli calisma modu ekle. `main()` fonksiyonunun sonuna:

```typescript
  // v2: Surekli calisma — process kapanmasin
  process.stdin.resume();
  logger.info('Sistem hazir — /api/start ile full scrape baslatilabilir', 'System');
```

---

## ADIM 13: FCM + Match Status Mapper (~1.5 saat)

> **Amac:** Push notification + status donusturme
> **Bagimlilik:** Adim 8

---

### 13.1 — `src/utils/fcmNotifier.ts` YENi DOSYA OLUSTUR

```typescript
// src/utils/fcmNotifier.ts — YENi DOSYA

import { getMessaging } from 'firebase-admin/messaging';
import { isFirebaseInitialized } from '../db/firebase';
import { Logger } from './logger';

const logger = Logger.getInstance();

export interface MatchNotification {
  title: string;
  body: string;
  matchKey: string;
  type: 'goal' | 'redCard' | 'matchStart' | 'matchEnd' | 'lineup' | 'var';
  teamSlug?: string;
}

export async function sendMatchNotification(payload: MatchNotification): Promise<void> {
  if (!isFirebaseInitialized()) return;

  try {
    const messaging = getMessaging();

    // Mac topic'ine gonder
    await messaging.sendToTopic(`match_${payload.matchKey}`, {
      notification: { title: payload.title, body: payload.body },
      data: {
        matchKey: payload.matchKey,
        type: payload.type,
        timestamp: new Date().toISOString(),
      },
      android: { priority: 'high' as const },
      apns: { payload: { aps: { sound: 'default' } } },
    });

    // Takim topic'ine de gonder (varsa)
    if (payload.teamSlug) {
      await messaging.sendToTopic(`team_${payload.teamSlug}`, {
        notification: { title: payload.title, body: payload.body },
        data: { matchKey: payload.matchKey, type: payload.type },
      });
    }

    logger.info(`FCM bildirim gonderildi: ${payload.type} — ${payload.title}`, 'FCM');
  } catch (e) {
    logger.warn(`FCM gonderilemedi: ${e}`, 'FCM');
  }
}
```

> **Not:** matchStatusMapper.ts zaten Adim 4.3'te olusturuldu.

---

## ADIM 14: Eski Botlari Sil + Test & Debug (~4.5 saat)

> **Amac:** Kullanilmayan botlari temizle, tum sistemi test et.
> **Bagimlilik:** Adim 1-13

---

### 14.1 — SiLiNECEK DOSYALAR

```
TAM SIL (dosyayi diskten kaldir):
  src/bots/understat/UnderstatBot.ts
  src/bots/statsbomb/StatsBombBot.ts
```

---

### 14.2 — SiLiNECEK KLASORLER

```
TAM SIL (tum icerikle birlikte):
  data/understat/
  data/statsbomb/
  data/fbref/          ← Sifirdan cekilecek
  data/sofascore/      ← Sifirdan cekilecek
  data/transfermarkt/  ← Sifirdan cekilecek
```

---

### 14.3 — GUNCELLENMESI GEREKEN REFERANSLAR

Understat ve StatsBomb import/referanslari olan tum dosyalar:

#### A) `src/orchestrator.ts` (zaten Adim 12'de yeniden yazildi)

Eski import'lar zaten kaldirildi:
```
CIKAR (eger hala varsa):
  import { UnderstatBot } from './bots/understat/UnderstatBot';
  import { StatsBombBot } from './bots/statsbomb/StatsBombBot';
```

createBot fonksiyonundan:
```
CIKAR:
  case 'understat': return new UnderstatBot(config);
  case 'statsbomb': return new StatsBombBot(config);
```

#### B) `src/config/botConfig.ts` (zaten Adim 6.2'de guncellendi)

```
CIKAR:
  understat: { ... },
  statsbomb: { ... },
```

#### C) `src/types/match.ts` (zaten Adim 1'de guncellendi)

```
CIKAR:
  export interface UnderstatData { ... }
```

`MatchData` interface'inden:
```
CIKAR:
  understat?: UnderstatData;
```

#### D) `src/db/matchMerger.ts` (zaten Adim 11'de guncellendi)

```
CIKAR:
  if (incoming.understat && !existing.understat) {
    merged.understat = incoming.understat;
  }
```

`calculateCompleteness`'den:
```
CIKAR:
  if (match.understat) filled++;
```

#### E) `src/config/leagues.ts` (zaten Adim 3.2'de guncellendi)

```
CIKAR:
  understatName: 'EPL',  // her lig'den bu alani sil
```

```
CIKAR:
  export const UNDERSTAT_NAME_MAP = ...
```

#### F) `src/config/seasons.ts` (zaten Adim 3.3'te guncellendi)

```
CIKAR:
  export const UNDERSTAT_SEASON = '2025';
```

#### G) `src/types/bot.ts` (zaten Adim 1.8'de guncellendi)

LeagueConfig'den:
```
CIKAR:
  understatName: string | null;
```

#### H) `src/types/team.ts` (zaten Adim 1.7'de guncellendi)

TeamIds'den:
```
CIKAR:
  understat: number | null;
```

---

### 14.4 — TEST KONTROL LiSTESi

```
[ ] 1. TypeScript derleme: `npm run build` — hata yok mu?
[ ] 2. Import grafigi temiz mi? Silinan modullere referans kaldi mi?
[ ] 3. Firestore baglantisi: `initFirebase()` basarili mi?
[ ] 4. SofaScore API testi: Tek bir mac icin 19 endpoint cekilebiliyor mu?
[ ] 5. FBref testi: Tek bir lig icin 12 stat tipi cekilebiliyor mu?
[ ] 6. Transfermarkt API testi: Community API canli mi? 3 endpoint testi
[ ] 7. Transfermarkt Playwright testi: transfermarkt.com.tr erisimi var mi? Cloudflare geciliyor mu?
[ ] 8. Hash testi: Ayni veri iki kez yazilinca ikincisi atlanıyor mu?
[ ] 9. Checkpoint testi: Scraper'i durdur, yeniden baslat — kaldigi yerden devam ediyor mu?
[ ] 10. Live tracker testi: Canli mac varken 30sn'de bir veri guncelliyor mu?
[ ] 11. Delta testi: 30dk sonra sadece degisen veriler mi yazildi?
[ ] 12. FCM testi: sendMatchNotification cagrilinca Firebase console'da gorunuyor mu?
[ ] 13. Writer testi: Tum 12 koleksiyona yazma calisiyor mu?
[ ] 14. Memory leak: 1 saat calistir — bellek artisi var mi?
[ ] 15. Error recovery: 403 ban sonrasi adaptive rate limiter calisıyor mu?
```

---

### 14.5 — INTEGRATION TEST SiRASI

```
1. Sadece SofaScore testi:
   → Tek lig (super-lig) icin full scrape
   → matches/ koleksiyonuna ~200 mac yazilmali
   → seasonStats/ koleksiyonuna gol/asist kralligi yazilmali

2. Sadece FBref testi:
   → Tek lig (super-lig) icin full scrape
   → matches/ koleksiyonuna fbref verileri merge edilmeli
   → 12 stat tipi cekilmeli

3. Sadece Transfermarkt testi:
   → Tek lig (super-lig) icin full scrape
   → teams/ koleksiyonuna 18 takim yazilmali
   → players/ koleksiyonuna ~450 oyuncu yazilmali
   → managers/ koleksiyonuna 18 TD yazilmali

4. 3 kaynak birlikte testi:
   → super-lig icin full scrape (3 bot paralel)
   → matches/ dokumanlarinda sources: ['sofascore','fbref','transfermarkt'] olmali
   → dataCompleteness > 0.7 olmali

5. Delta update testi:
   → Full scrape sonrasi 30dk bekle
   → Delta update calistir
   → Hash degismemis verilerin yazilMAMIS olmasi

6. Live tracker testi:
   → Canli mac varken calistir
   → live/ koleksiyonunda doc olusturulmus olmali
   → Mac bittikten 2 saat sonra live/ doc silinmis olmali
```

---

## DOSYA DEGISIKLIK OZET TABLOSU

| # | Dosya | Islem | Adim |
|---|-------|-------|:---:|
| 1 | `src/types/match.ts` | GUNCELLE (MatchStatus, SofaScoreData genislet, UnderstatData sil) | 1 |
| 2 | `src/types/player.ts` | YENi OLUSTUR | 1 |
| 3 | `src/types/manager.ts` | YENi OLUSTUR | 1 |
| 4 | `src/types/news.ts` | YENi OLUSTUR | 1 |
| 5 | `src/types/live.ts` | YENi OLUSTUR | 1 |
| 6 | `src/types/index.ts` | GUNCELLE (yeni export'lar) | 1 |
| 7 | `src/types/team.ts` | GUNCELLE (genislet, understat sil) | 1 |
| 8 | `src/types/bot.ts` | GUNCELLE (LeagueConfig, CheckpointState) | 1 |
| 9 | `src/db/schemas.ts` | GUNCELLE (6→12 koleksiyon) | 1 |
| 10 | `src/config/teamMappings.ts` | YENi OLUSTUR (170+ takim) | 2 |
| 11 | `src/utils/teamMatcher.ts` | GUNCELLE (TEAM_MAPPINGS'den alias yukle) | 2 |
| 12 | `src/config/sofascoreSeasonIds.ts` | YENi OLUSTUR | 3 |
| 13 | `src/config/leagues.ts` | GUNCELLE (understatName sil, transfermarktId ekle) | 3 |
| 14 | `src/config/seasons.ts` | GUNCELLE (UNDERSTAT_SEASON sil) | 3 |
| 15 | `src/utils/hashCompare.ts` | YENi OLUSTUR | 4 |
| 16 | `src/utils/dataCleaner.ts` | YENi OLUSTUR | 4 |
| 17 | `src/utils/matchStatusMapper.ts` | YENi OLUSTUR | 4 |
| 18 | `src/db/writer.ts` | GUNCELLE (7 yeni metod + delta hash) | 5 |
| 19 | `src/bots/sofascore/SofaScoreBot.ts` | TAMAMEN YENIDEN YAZ | 6 |
| 20 | `src/config/botConfig.ts` | GUNCELLE (SofaScore delay, understat/statsbomb sil) | 6 |
| 21 | `src/bots/sofascore/SofaScoreTournamentScraper.ts` | YENi OLUSTUR | 7 |
| 22 | `src/bots/sofascore/SofaScoreTeamScraper.ts` | YENi OLUSTUR | 7 |
| 23 | `src/bots/sofascore/SofaScorePlayerScraper.ts` | YENi OLUSTUR | 7 |
| 24 | `src/bots/sofascore/SofaScoreLiveTracker.ts` | YENi OLUSTUR | 8 |
| 25 | `src/bots/fbref/urls.ts` | GUNCELLE (STAT_TYPES 8→12, yeni URL fonksiyonlari) | 9 |
| 26 | `src/bots/fbref/FBrefBot.ts` | GUNCELLE (yeni FBrefData alanlari) | 9 |
| 27 | `src/bots/fbref/teamStatsScraper.ts` | GUNCELLE (JSDoc) | 9 |
| 28 | `src/bots/fbref/playerScraper.ts` | YENi OLUSTUR | 9 |
| 29 | `src/bots/transfermarkt/TransfermarktBot.ts` | TAMAMEN YENIDEN YAZ | 10 |
| 30 | `src/bots/transfermarkt/TransfermarktApiClient.ts` | YENi OLUSTUR | 10 |
| 31 | `src/bots/transfermarkt/TransfermarktPlaywrightScraper.ts` | YENi OLUSTUR | 10 |
| 32 | `src/db/matchMerger.ts` | GUNCELLE (understat→transfermarkt, yeni alanlar, hash) | 11 |
| 33 | `src/orchestrator.ts` | TAMAMEN YENIDEN YAZ | 12 |
| 34 | `src/index.ts` | GUNCELLE (surekli calisma modu) | 12 |
| 35 | `src/utils/fcmNotifier.ts` | YENi OLUSTUR | 13 |
| 36 | `src/bots/understat/UnderstatBot.ts` | SIL | 14 |
| 37 | `src/bots/statsbomb/StatsBombBot.ts` | SIL | 14 |
| 38 | `data/understat/` | KLASOR SIL | 14 |
| 39 | `data/statsbomb/` | KLASOR SIL | 14 |
| 40 | `data/fbref/*.json` | DOSYALARI SIL | 14 |
| 41 | `data/sofascore/*.json` | DOSYALARI SIL | 14 |
| 42 | `data/transfermarkt/*.json` | DOSYALARI SIL | 14 |

**Toplam:** 15 yeni dosya, 17 guncellenen dosya, 2 silinen dosya, 5 temizlenen klasor

---

**Son guncelleme:** 2026-03-01
**Yazar:** Claude (FutbolAI Scraper Plan v2 — Implementasyon Rehberi)
**Dosya:** `R:\YDev\futbol_ai\docs\scraper_plan_2026_03_01-v2.md`
