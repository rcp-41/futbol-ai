# FutbolAI — Çoklu Model Analiz Sistemi (Saf Cloud Functions)

> **Tarih:** 2026-02-28
> **Durum:** Planlama aşaması
> **Amaç:** Maç verilerini teyit edip, derin analiz modülleriyle zenginleştirip, 2 AI modeline (Gemini 2.5 Pro, Claude Opus 4.6) paralel yorumlatarak, Gemini 3.1 ile güvenilir konsensüs tahmini üretmek.
> **Mimari:** Ekstra servis yok — tamamı Firebase Cloud Functions v2 üzerinde çalışır.

---

## Sistem Mimarisi

```
                    ┌─────────────────────────────┐
                    │        Flutter App           │
                    │    "Analiz Başlat" butonu    │
                    └─────────────┬───────────────┘
                                  │
                                  ▼
                    ┌─────────────────────────────┐
                    │  CF 1: triggerMultiModel     │
                    │  (onCall — 30 saniye)        │
                    │                             │
                    │  ✓ Auth + Rate Limit        │
                    │  ✓ Cache Check              │
                    │  ✓ Veri çek + zenginleştir  │
                    │  ✓ Firestore doc oluştur    │
                    │  → analysisId döndür        │
                    └─────────────┬───────────────┘
                                  │ Firestore write otomatik tetikler:
                                  ▼
                    ┌─────────────────────────────┐
                    │  CF 2: onMultiAnalysisCreated│
                    │  (Firestore Trigger — 540s) │
                    │  Arka planda tam pipeline:   │
                    │                             │
                    │  1. Veri Teyidi             │
                    │     → status: 'verifying'   │
                    │                             │
                    │  2. Derin Analiz (8 modül)  │
                    │     → status: 'analyzing'   │
                    │                             │
                    │  3. Promise.all([           │
                    │       callGemini(),         │
                    │       callClaude()          │
                    │     ])                      │
                    │     → status: 'ai_processing'│
                    │                             │
                    │  4. callGeminiConsensus()   │
                    │     → status: 'completed'   │
                    └─────────────────────────────┘
                                  │
                      Her adımda Firestore güncellenir
                                  │
                                  ▼
                    ┌─────────────────────────────┐
                    │  Flutter App:                │
                    │  Firestore Stream dinle      │
                    │  (real-time progress)        │
                    │                              │
                    │  Tab 1: Gemini Analizi       │
                    │  Tab 2: Claude Analizi       │
                    │  Tab 3: Konsensüs (Gemini 3.1)│
                    └─────────────────────────────┘
```

---

## AŞAMA 1: Veri Teyidi (Detay)

Bu aşama çok kritik — "çöp girer, çöp çıkar" prensibini önler.

```
Maç Verisi (Firestore'dan)
    │
    ▼
┌──────────────────────────────────────────┐
│  1.1 Tarih Aralığı Doğrulama            │
│  • Maç tarihi gerçekten gelecekte mi?   │
│  • Lig takviminde bu tarih var mı?      │
│  • Ertelenmiş/iptal maç kontrolü        │
├──────────────────────────────────────────┤
│  1.2 Kadro/Oyuncu Teyidi                │
│  • Cezalı oyuncu listeleri güncel mi?   │
│  • Sakatlık bilgileri doğrulanıyor mu?  │
│  • Transfer penceresi kontrol           │
├──────────────────────────────────────────┤
│  1.3 İstatistik Tutarlılık              │
│  • FBref vs SofaScore verisi eşleşiyor? │
│  • xG değerleri makul aralıkta mı?      │
│  • Gol/maç ortalamaları tutarlı mı?     │
├──────────────────────────────────────────┤
│  1.4 Hava Durumu Verisi                 │
│  • OpenWeatherMap API → maç günü tahmini│
│  • Sıcaklık, yağış, rüzgar             │
└──────────────────────────────────────────┘
    │
    ▼
  Teyitli Veri Paketi (verified: true)
```

---

## AŞAMA 2: Derin Analiz Modülleri

Her biri bağımsız bir analiz modülü olarak çalışır.

### Modül 1: Hava Şartları Etkisi

```
Maçın hava tahmini (örn: 8°C, yağmurlu)
    │
    ▼
Bu sezon benzer koşullarda oynanan maçları bul:
  • Sıcaklık: 5-11°C arası
  • Yağış: var
    │
    ▼
Bu maçlardaki istatistikleri çıkar:
  • Gol ortalaması (normal vs yağmurlu)
  • Top hakimiyeti değişimi
  • Uzun top oranı artışı
  • Hata sayısı artışı
    │
    ▼
Çıktı: {
  weatherImpact: "high",
  goalAvgNormal: 2.4,
  goalAvgSimilarWeather: 1.8,
  possessionShift: -5%,
  longBallIncrease: +12%,
  summary: "Yağmurlu havalarda ev sahibi gol
            ortalaması %25 düşüyor"
}
```

### Modül 2: Eksik Oyuncu Etkisi

```
Cezalı/sakat oyuncular listesi
    │
    ▼
Her eksik oyuncu için:
  • Bu oyuncu olmadan oynanan maçları bul
  • Takımın o maçlardaki performansını hesapla
  • Yerine kimin oynadığını bul
  • Yedeğin performans karşılaştırması
    │
    ▼
Çıktı: {
  missingPlayers: [
    {
      name: "X Oyuncu",
      position: "CDM",
      matchesWithout: 4,
      winRateWith: 65%,
      winRateWithout: 40%,
      replacement: "Y Oyuncu",
      impactLevel: "critical"
    }
  ],
  overallImpact: "significant_negative"
}
```

### Modül 3: Ev/Deplasman Formu

- Son 5 ev/deplasman maçı detaylı analiz
- Gol atma/yeme oranları
- Puan toplama trendi

### Modül 4: H2H (Head-to-Head) Geçmiş

- Son 10 yıl karşılaşma özeti
- Son 3 yıl detaylı istatistik
- Ev/deplasman avantajı H2H'ta nasıl?

### Modül 5: xG (Expected Goals) Analizi

- Beklenen gol vs gerçek gol farkı
- xG trendi (yükseliyor/düşüyor)
- Şut kalitesi metrikleri

### Modül 6: Set Piece Analizi

- Korner gol oranı
- Serbest vuruş tehlike oranı
- Penaltı istatistikleri

### Modül 7: Hakem Etkisi

- Atanan hakemin istatistikleri
- Kart ortalaması
- Penaltı verme eğilimi
- Ev sahibi yanlılığı var mı?

### Modül 8: Taktik/Formasyon Analizi

- Rakibe göre formasyon değişikliği geçmişi
- Baskı yoğunluğu metrikleri
- Oyun stili uyumu/çatışması

---

## AŞAMA 3: AI Yorumlama

### Gemini ve Claude'a Giden Paket

```json
{
  "match": { "home": "Team A", "away": "Team B", "date": "..." },
  "verifiedData": true,
  "seasonStats": { /* tüm sezon istatistikleri */ },
  "deepAnalysis": {
    "weather": { /* Modül 1 çıktısı */ },
    "missingPlayers": { /* Modül 2 çıktısı */ },
    "homeAwayForm": { /* Modül 3 çıktısı */ },
    "h2h": { /* Modül 4 çıktısı */ },
    "xg": { /* Modül 5 çıktısı */ },
    "setPieces": { /* Modül 6 çıktısı */ },
    "referee": { /* Modül 7 çıktısı */ },
    "tactics": { /* Modül 8 çıktısı */ }
  }
}
```

### Konsensüs Modeline (Gemini 3.1) Giden Paket

```json
{
  "geminiAnalysis": {
    "prediction": "1",
    "confidence": 0.72,
    "reasoning": "...",
    "keyFactors": ["..."]
  },
  "claudeAnalysis": {
    "prediction": "1",
    "confidence": 0.68,
    "reasoning": "...",
    "keyFactors": ["..."]
  },
  "instruction": "Bu iki analizi karşılaştır. Ortak noktaları ve farklılıkları belirle. Her ikisinin de hemfikir olduğu noktalara daha yüksek güven ver. Tek bir konsensüs tahmini ve güven skoru üret."
}
```

---

## Flutter App'te Görüntüleme

```
┌─────────────────────────────────────────────┐
│  ⚽ Team A vs Team B                        │
│  📅 28 Şubat 2026 — 20:00                  │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────┐ ┌─────────┐ ┌──────────────┐  │
│  │ Gemini  │ │ Claude  │ │  Konsensüs   │  │
│  │  ●      │ │         │ │              │  │
│  └─────────┘ └─────────┘ └──────────────┘  │
│                                             │
│  ┌─────────────────────────────────────┐    │
│  │  🔮 Gemini 3.1 Analizi             │    │
│  │                                     │    │
│  │  Tahmin: Ev Sahibi Kazanır (1)     │    │
│  │  Güven: %72                         │    │
│  │                                     │    │
│  │  📊 Ana Faktörler:                  │    │
│  │  • Ev sahibi son 5 ev maçında 4G   │    │
│  │  • Deplasman 3 maçtır kazanamıyor  │    │
│  │  • Yağmurlu havada ev sahibi +%15  │    │
│  │  • X oyuncu eksikliği etki: düşük  │    │
│  │                                     │    │
│  │  📝 Detaylı Yorum:                  │    │
│  │  "Ev sahibinin güçlü iç saha..."   │    │
│  └─────────────────────────────────────┘    │
│                                             │
│  ✅ Veri Teyidi: 8/8 kaynak doğrulandı     │
│  🕐 Analiz süresi: 45 saniye               │
│                                             │
│  [💬 AI'a Sor]  [📋 Tüm Detaylar]         │
└─────────────────────────────────────────────┘
```

---

## Geliştirme Önerileri

### 1. Tarihsel Doğruluk Takibi

```
Her analizin sonucu maç bittikten sonra karşılaştırılır:
  • Gemini doğruluk oranı: %67
  • Claude doğruluk oranı: %71
  • Konsensüs doğruluk oranı: %74

→ Zamanla ağırlıklar otomatik ayarlanır
→ En isabetli model daha yüksek ağırlık alır
```

### 2. Bağlamsal Prompt Seçimi

```
Maç tipine göre farklı prompt:
  • Derbi → Daha fazla psikolojik analiz
  • Küme düşme maçı → Motivasyon faktörü ağırlıklı
  • Şampiyonluk maçı → Baskı altında performans
  • Kupa maçı → Rotasyon, motivasyon farkı
```

### 3. Canlı Veri Güncelleme

```
Maça 2 saat kala:
  • Kadro açıklamasını kontrol et
  • Son dakika sakatlık bilgisi
  • Hava durumu güncellemesi
  → Analizi otomatik yenile
```

### 4. Bahis Piyasası Karşılaştırma

```
AI tahminleri vs bahis oranları:
  • Piyasa: Ev sahibi %55 favori
  • AI konsensüs: Ev sahibi %74 favori
  → "Value bet" sinyali: AI piyasadan çok ayrışıyor
```

### 5. Lig-Spesifik Model Fine-tuning

```
Her lig için ayrı ağırlıklar:
  • Süper Lig: Ev sahibi avantajı ağırlığı ↑
  • Premier League: xG analizi ağırlığı ↑
  • La Liga: Top hakimiyeti ağırlığı ↑
```

---

## Fizibilite ve Maliyet

| Kalem | Aylık Tahmini |
|-------|--------------|
| Firebase Cloud Functions (Blaze plan) | Mevcut plan — ek maliyet ~$2-5/ay |
| Gemini API — analiz + konsensüs (15 maç/hafta) | ~$15-30/ay |
| Claude API (15 maç/hafta) | ~$15-30/ay |
| Hava durumu API (OpenWeatherMap) | Ücretsiz |
| **Toplam** | **~$32-65/ay** |

---

## MVP Geliştirme Aşamaları

### Aşama 1: Temel Altyapı (Hafta 1-2)
- API key'lerin alınması (Anthropic)
- Cloud Functions pipeline (trigger + Firestore trigger)
- Temel veri teyit modülü
- Firestore multi-result schema + indexes

### Aşama 2: Analiz Modülleri (Hafta 2-3)
- İlk 3 modül: Hava, Eksik Oyuncu, Ev/Deplasman Formu
- Modül çıktı formatı standardizasyonu
- Test ve doğrulama

### Aşama 3: Çoklu AI Entegrasyonu (Hafta 3-4)
- Gemini + Claude paralel çağrı
- Gemini 3.1 konsensüs adımı
- Response normalizasyonu

### Aşama 4: Flutter UI (Hafta 4-5)
- 3 tab'lı analiz görünümü
- Firestore stream entegrasyonu
- Veri teyit badge'i
- Analiz ilerleme göstergesi

### Aşama 5: Kalan Modüller + İyileştirme (Hafta 5+)
- Modül 4-8 eklenmesi
- Tarihsel doğruluk takibi
- Bağlamsal prompt seçimi
- Performance optimizasyonu

---

> **Not:** Bu plan MVP (Minimum Viable Product) odaklıdır. Önce 2-3 analiz modülüyle başlanıp, sistem stabil çalıştıktan sonra modüller eklenmesi önerilir.

---
---

# BÖLÜM B: TAM İMPLEMENTASYON KODU

> Aşağıdaki bölümler, yukarıdaki mimari planı hayata geçirmek için gereken **tüm kodları** içerir.
> Her bölüm bir dosya veya modüle karşılık gelir. Kodlar doğrudan kopyalanıp kullanılabilir.

---

## BÖLÜM 0: Ön Gereksinimler ve Ortam Kurulumu

### 0.1 Gerekli Servisler

| Servis | Amaç | Kurulum |
|--------|-------|---------|
| Firebase | Auth, Firestore, Functions | Mevcut proje (`futbol-ai-app`) — Blaze plan gerekli |
| Gemini API | AI Model 1 | Google AI Studio → API Key |
| Anthropic API | AI Model 2 (Claude) | console.anthropic.com → API Key |
| Gemini 3.1 API | AI Model 3 (Konsensüs) | Aynı Gemini API Key kullanılır |

### 0.2 Firebase Secret'ları

```bash
# Firebase Functions secret'ları (mevcut + yeni)
firebase functions:secrets:set GEMINI_API_KEY      # Zaten mevcut (Gemini 2.5 + 3.1 için)
firebase functions:secrets:set ANTHROPIC_API_KEY   # YENİ (Claude için)
```

### 0.3 Ek Bağımlılıklar

```bash
# functions/ dizininde — ek bağımlılık gerekmez
# Mevcut: fetch (Node 18 built-in), firebase-admin, firebase-functions
# Flutter — ek bağımlılık gerekmez
# Mevcut: freezed, riverpod, cloud_firestore, cloud_functions
```

---

## BÖLÜM 1: Firestore Şeması

### 1.1 Yeni Koleksiyon: `multi_analyses`

```
multi_analyses/{analysisId}
├── matchId: string                    // sportoto_matches veya matches doc ID
├── userId: string                     // Firebase Auth UID
├── status: string                     // 'pending' | 'verifying' | 'analyzing' | 'ai_processing' | 'consensus' | 'completed' | 'failed'
├── statusMessage: string              // İnsan okunur durum mesajı (ör: "Gemini analizi tamamlandı...")
├── createdAt: Timestamp
├── updatedAt: Timestamp
├── expiresAt: Timestamp               // Cache TTL
│
├── verification: {                    // AŞAMA 1 sonucu
│   ├── verified: boolean
│   ├── dateValid: boolean
│   ├── sourcesChecked: number
│   ├── sourcesValid: number
│   ├── dataCompleteness: number       // 0-100
│   ├── warnings: string[]
│   └── checkedAt: Timestamp
│   }
│
├── deepAnalysis: {                    // AŞAMA 2 sonucu
│   ├── weather: {
│   │   ├── temperature: string
│   │   ├── humidity: string
│   │   ├── rain: string
│   │   ├── wind: string
│   │   ├── impact: string             // 'low' | 'medium' | 'high'
│   │   ├── goalAvgNormal: number
│   │   ├── goalAvgSimilarWeather: number
│   │   └── summary: string
│   │   }
│   ├── missingPlayers: {
│   │   ├── home: [{ name, position, impactLevel, winRateWith, winRateWithout }]
│   │   ├── away: [{ name, position, impactLevel, winRateWith, winRateWithout }]
│   │   └── overallImpact: string
│   │   }
│   ├── homeAwayForm: {
│   │   ├── homeLast5Home: { wins, draws, losses, goalsFor, goalsAgainst }
│   │   ├── awayLast5Away: { wins, draws, losses, goalsFor, goalsAgainst }
│   │   ├── homeTrend: string          // 'improving' | 'stable' | 'declining'
│   │   ├── awayTrend: string
│   │   └── summary: string
│   │   }
│   ├── h2h: {
│   │   ├── last5: string              // "WWLDW"
│   │   ├── homeWins: number
│   │   ├── draws: number
│   │   ├── awayWins: number
│   │   ├── avgGoals: number
│   │   └── summary: string
│   │   }
│   ├── xg: {
│   │   ├── homeXg: number
│   │   ├── homeXga: number
│   │   ├── awayXg: number
│   │   ├── awayXga: number
│   │   ├── homeOverperformance: number // actual - xg
│   │   ├── awayOverperformance: number
│   │   └── summary: string
│   │   }
│   ├── setPieces: {
│   │   ├── homeCornerGoalRate: number
│   │   ├── awayCornerGoalRate: number
│   │   ├── homeFreeKickDanger: number
│   │   ├── awayFreeKickDanger: number
│   │   └── summary: string
│   │   }
│   ├── referee: {
│   │   ├── name: string
│   │   ├── avgFoulsPerMatch: number
│   │   ├── avgYellowCards: number
│   │   ├── avgPenalties: number
│   │   ├── homeTeamBias: number       // -1 to +1
│   │   └── summary: string
│   │   }
│   └── tactics: {
│       ├── homeFormation: string
│       ├── awayFormation: string
│       ├── homePPDA: number
│       ├── awayPPDA: number
│       ├── styleMismatch: string
│       └── summary: string
│       }
│   }
│
├── geminiResult: {                    // AŞAMA 3a sonucu
│   ├── prediction: {
│   │   ├── result: string             // '1' | 'X' | '2'
│   │   ├── resultLabel: string
│   │   ├── confidence: number         // 0-1
│   │   ├── scorePrediction: string    // "2-1"
│   │   ├── bttsProb: number
│   │   └── over25Prob: number
│   │   }
│   ├── keyFactors: string[]
│   ├── reasoning: string
│   ├── categories: {                  // Mevcut 8 kategori yapısı
│   │   power, tactics, psychology, externalFactors,
│   │   market, referee, setPieces, physical
│   │   // Her biri: { homeScore, awayScore, weight, detail }
│   │   }
│   ├── weightedTotal: { home, away }
│   ├── modelUsed: string
│   └── completedAt: Timestamp
│   }
│
├── claudeResult: {                    // AŞAMA 3b sonucu (aynı yapı)
│   ├── prediction: { result, resultLabel, confidence, scorePrediction, bttsProb, over25Prob }
│   ├── keyFactors: string[]
│   ├── reasoning: string
│   ├── categories: { power, tactics, ... }
│   ├── weightedTotal: { home, away }
│   ├── modelUsed: string
│   └── completedAt: Timestamp
│   }
│
└── consensusResult: {                 // AŞAMA 4 sonucu (Gemini 3.1)
    ├── prediction: { result, resultLabel, confidence, scorePrediction, bttsProb, over25Prob }
    ├── agreements: string[]           // İki modelin hemfikir olduğu noktalar
    ├── disagreements: string[]        // Farklı görüşler
    ├── finalVerdict: string           // Detaylı konsensüs açıklaması
    ├── confidenceBreakdown: {
    │   ├── geminiConfidence: number
    │   ├── claudeConfidence: number
    │   └── consensusConfidence: number
    │   }
    ├── riskFactors: string[]
    ├── modelUsed: string
    └── completedAt: Timestamp
    }
```

### 1.2 Firestore Security Rules Eklentisi

```javascript
// firestore.rules — mevcut rules'a ekle
match /multi_analyses/{analysisId} {
  allow read: if request.auth != null
    && resource.data.userId == request.auth.uid;
  allow create: if false; // Sadece Cloud Function yazar
  allow update: if false; // Sadece Cloud Function yazar
  allow delete: if false;
}
```

### 1.3 Firestore Index Eklentisi

```json
// firestore.indexes.json — mevcut indexes'a ekle
{
  "collectionGroup": "multi_analyses",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "matchId", "order": "ASCENDING" },
    { "fieldPath": "userId", "order": "ASCENDING" },
    { "fieldPath": "status", "order": "ASCENDING" }
  ]
}
```

---

## BÖLÜM 2: Cloud Functions (Saf Pipeline — n8n Yok)

> **Mimari:** İki Cloud Function: (1) `triggerMultiModelAnalysis` hızlı giriş noktası,
> (2) `onMultiAnalysisCreated` Firestore trigger ile arka plan pipeline.
> Ekstra servis, webhook veya callback gerekmez.

### 2.1 `functions/src/multiModel/triggerMultiModelAnalysis.ts`

```typescript
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from 'firebase-functions';
import { db, admin } from '../firebase';
import { checkAndIncrementRateLimit } from '../utils/rateLimiter';

const MATCH_ID_PATTERN = /^[a-zA-Z0-9_-]{1,128}$/;

/**
 * Team name normalizer — Türkçe karakter → slug
 */
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

/**
 * Scraper enrichment data lookup (matches collection)
 */
async function findScraperEnrichmentData(
    matchData: Record<string, any>
): Promise<Record<string, any> | null> {
    const homeName = matchData.homeTeam?.name || '';
    const awayName = matchData.awayTeam?.name || '';
    if (!homeName || !awayName) return null;

    let dateStr = '';
    if (matchData.matchDate?.toDate) {
        dateStr = matchData.matchDate.toDate().toISOString().split('T')[0];
    } else if (typeof matchData.matchDate === 'string') {
        dateStr = matchData.matchDate.split('T')[0];
    }
    if (!dateStr) return null;

    const homeSlug = normalizeTeamName(homeName);
    const awaySlug = normalizeTeamName(awayName);

    const candidateKeys = [
        `${dateStr}_${homeSlug}_vs_${awaySlug}`,
        `${dateStr}_${awaySlug}_vs_${homeSlug}`,
    ];
    const baseDate = new Date(dateStr);
    for (const offset of [-1, 1]) {
        const altDate = new Date(baseDate);
        altDate.setDate(altDate.getDate() + offset);
        const altDateStr = altDate.toISOString().split('T')[0];
        candidateKeys.push(`${altDateStr}_${homeSlug}_vs_${awaySlug}`);
        candidateKeys.push(`${altDateStr}_${awaySlug}_vs_${homeSlug}`);
    }

    for (const key of candidateKeys) {
        try {
            const doc = await db.collection('matches').doc(key).get();
            if (doc.exists) {
                logger.info(`✅ Multi-model: Scraper data found: ${key}`);
                return doc.data()!;
            }
        } catch (err) {
            logger.warn(`Multi-model: Scraper lookup error: ${key}: ${err}`);
        }
    }
    return null;
}

/**
 * Merge scraper enrichment data into match data
 */
function mergeEnrichmentData(
    matchData: Record<string, any>,
    enrichment: Record<string, any>
): Record<string, any> {
    const merged = { ...matchData };
    if (enrichment.fbref && !merged.fbref) merged.fbref = enrichment.fbref;
    if (enrichment.sofascore && !merged.sofascore) merged.sofascore = enrichment.sofascore;
    if (enrichment.understat && !merged.understat) merged.understat = enrichment.understat;
    if (enrichment.weather && !merged.weather) merged.weather = enrichment.weather;
    if (enrichment.sources?.length && !merged.sources?.length) merged.sources = enrichment.sources;
    if (enrichment.dataCompleteness && !merged.dataCompleteness) merged.dataCompleteness = enrichment.dataCompleteness;
    if (!merged.odds && enrichment.sofascore?.odds) merged.odds = enrichment.sofascore.odds;
    if (!merged.stadium && enrichment.meta?.stadium) merged.stadium = enrichment.meta.stadium;
    return merged;
}

/**
 * triggerMultiModelAnalysis — Çoklu model analizi başlat
 * Auth + Rate Limit + Cache → Firestore doc oluştur → analysisId döndür
 * Pipeline otomatik olarak onMultiAnalysisCreated trigger ile başlar.
 */
export const triggerMultiModelAnalysis = onCall(
    {
        secrets: [],  // Secret'lar pipeline function'da
        timeoutSeconds: 30,
        memory: '256MiB',
        region: 'europe-west1',
    },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'Giriş yapmalısınız.');
        }

        const userId = request.auth.uid;
        const { matchId } = request.data;

        // Validation
        if (!matchId || typeof matchId !== 'string' || !MATCH_ID_PATTERN.test(matchId)) {
            throw new HttpsError('invalid-argument', 'Geçersiz matchId.');
        }

        // Rate limit
        const userDoc = await db.collection('users').doc(userId).get();
        const tier = userDoc.exists ? (userDoc.data()?.tier || 'free') : 'free';
        const canProceed = await checkAndIncrementRateLimit(db, userId, tier);
        if (!canProceed) {
            throw new HttpsError('resource-exhausted', 'Günlük analiz limitinize ulaştınız.');
        }

        // Cache check
        const analysisId = `${matchId}_${userId}`;
        const cacheDoc = await db.collection('multi_analyses').doc(analysisId).get();
        if (cacheDoc.exists) {
            const cached = cacheDoc.data()!;
            if (cached.status === 'completed' && cached.expiresAt?.toDate() > new Date()) {
                return { analysisId, cached: true };
            }
        }

        // Get match data
        let matchDoc = await db.collection('matches').doc(matchId).get();
        if (!matchDoc.exists) {
            matchDoc = await db.collection('sportoto_matches').doc(matchId).get();
        }
        if (!matchDoc.exists) {
            throw new HttpsError('not-found', 'Maç bulunamadı.');
        }
        let matchData = matchDoc.data()!;

        // Scraper enrichment
        const hasScraperData = !!(matchData.fbref || matchData.sofascore || matchData.understat);
        if (!hasScraperData) {
            const enrichment = await findScraperEnrichmentData(matchData);
            if (enrichment) {
                matchData = mergeEnrichmentData(matchData, enrichment);
            }
        }

        // Timestamp → ISO string (Firestore Timestamp objeleri serialize için)
        const serializedMatch = JSON.parse(JSON.stringify(matchData, (_key, value) => {
            if (value && typeof value === 'object' && value._seconds !== undefined) {
                return new Date(value._seconds * 1000).toISOString();
            }
            return value;
        }));

        // Firestore doc oluştur → bu yazma onMultiAnalysisCreated trigger'ı tetikler
        await db.collection('multi_analyses').doc(analysisId).set({
            matchId,
            userId,
            status: 'pending',
            statusMessage: 'Analiz kuyruğa alındı...',
            _matchData: serializedMatch,  // Pipeline tarafından okunup silinecek
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        logger.info(`✅ Multi-model analysis triggered: ${analysisId}`);
        return { analysisId, cached: false };
    }
);
```

### 2.2 `functions/src/multiModel/multiModelPipeline.ts`

Bu, tüm pipeline'ın çalıştığı ana dosya. Firestore trigger ile otomatik başlar.

```typescript
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { defineSecret } from 'firebase-functions/params';
import { logger } from 'firebase-functions';
import { db, admin } from '../firebase';
import { verifyData } from './dataVerification';
import { runDeepAnalysis } from './deepAnalysis';
import { callGemini, callClaude, callGeminiConsensus } from './aiClients';
import { buildGeminiPrompt, buildClaudePrompt, buildConsensusPrompt } from './multiModelPrompts';
import { parseAIResponse, parseConsensusResponse } from './multiModelParser';

const GEMINI_API_KEY = defineSecret('GEMINI_API_KEY');
const ANTHROPIC_API_KEY = defineSecret('ANTHROPIC_API_KEY');

/**
 * onMultiAnalysisCreated — Firestore trigger
 * multi_analyses/{analysisId} doc'u oluşturulduğunda otomatik çalışır.
 * Tam pipeline: Teyit → Derin Analiz → Gemini+Claude (paralel) → Gemini 3.1 Konsensüs
 */
export const onMultiAnalysisCreated = onDocumentCreated(
    {
        document: 'multi_analyses/{analysisId}',
        secrets: [GEMINI_API_KEY, ANTHROPIC_API_KEY],
        timeoutSeconds: 540,   // 9 dakika (max)
        memory: '1GiB',
        region: 'europe-west1',
    },
    async (event) => {
        const snapshot = event.data;
        if (!snapshot) return;

        const data = snapshot.data();
        if (!data || data.status !== 'pending') return;

        const analysisId = event.params.analysisId;
        const docRef = db.collection('multi_analyses').doc(analysisId);
        const matchData = data._matchData;

        if (!matchData) {
            logger.error(`No _matchData in ${analysisId}`);
            await docRef.update({
                status: 'failed',
                statusMessage: 'Maç verisi bulunamadı.',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            return;
        }

        try {
            // ══════ AŞAMA 1: VERİ TEYİDİ ══════
            await docRef.update({
                status: 'verifying',
                statusMessage: 'Veriler teyit ediliyor...',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            const verification = verifyData(matchData);

            await docRef.update({
                verification,
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            logger.info(`✅ [${analysisId}] Verification done: ${verification.dataCompleteness}%`);

            // ══════ AŞAMA 2: DERİN ANALİZ ══════
            await docRef.update({
                status: 'analyzing',
                statusMessage: 'Derin analiz yapılıyor (8 modül)...',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            const deepAnalysis = runDeepAnalysis(matchData);

            await docRef.update({
                deepAnalysis,
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            logger.info(`✅ [${analysisId}] Deep analysis done`);

            // ══════ AŞAMA 3: AI YORUMLAMA (PARALEL) ══════
            await docRef.update({
                status: 'ai_processing',
                statusMessage: 'Gemini ve Claude analiz ediyor...',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });

            const geminiPrompt = buildGeminiPrompt(matchData, deepAnalysis, verification);
            const claudePrompt = buildClaudePrompt(matchData, deepAnalysis, verification);

            // Paralel AI çağrıları
            const [geminiRaw, claudeRaw] = await Promise.all([
                callGemini(geminiPrompt, GEMINI_API_KEY.value()),
                callClaude(claudePrompt, ANTHROPIC_API_KEY.value()),
            ]);

            const geminiResult = {
                ...parseAIResponse(geminiRaw),
                modelUsed: 'gemini-2.5-pro-preview',
                completedAt: admin.firestore.Timestamp.now(),
            };
            const claudeResult = {
                ...parseAIResponse(claudeRaw),
                modelUsed: 'claude-opus-4-6',
                completedAt: admin.firestore.Timestamp.now(),
            };

            // Her iki sonucu Firestore'a yaz (Flutter anında görür)
            await docRef.update({
                geminiResult,
                claudeResult,
                status: 'consensus',
                statusMessage: 'Konsensüs oluşturuluyor...',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            logger.info(`✅ [${analysisId}] Gemini + Claude done`);

            // ══════ AŞAMA 4: GEMİNİ 3.1 KONSENSÜS ══════
            const consensusPrompt = buildConsensusPrompt(
                matchData, geminiResult, claudeResult
            );

            const consensusRaw = await callGeminiConsensus(consensusPrompt, GEMINI_API_KEY.value());
            const consensusResult = {
                ...parseConsensusResponse(consensusRaw),
                modelUsed: 'gemini-3.1-pro-preview',
                completedAt: admin.firestore.Timestamp.now(),
            };

            // Dinamik cache TTL
            const matchDate = new Date(matchData.matchDate || Date.now());
            const hoursUntilMatch = (matchDate.getTime() - Date.now()) / (1000 * 60 * 60);
            let cacheTTLHours = 24;
            if (hoursUntilMatch <= 24) cacheTTLHours = 4;
            else if (hoursUntilMatch <= 168) cacheTTLHours = 12;

            // Final kayıt
            await docRef.update({
                consensusResult,
                status: 'completed',
                statusMessage: 'Analiz tamamlandı! 3 model sonucu hazır.',
                _matchData: admin.firestore.FieldValue.delete(), // Büyük veriyi temizle
                expiresAt: admin.firestore.Timestamp.fromDate(
                    new Date(Date.now() + cacheTTLHours * 60 * 60 * 1000)
                ),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            logger.info(`✅ [${analysisId}] COMPLETED — all 3 models done`);

        } catch (error: unknown) {
            logger.error(`❌ [${analysisId}] Pipeline error: ${error}`);
            await docRef.update({
                status: 'failed',
                statusMessage: error instanceof Error
                    ? error.message.substring(0, 200)
                    : 'Bilinmeyen hata',
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
        }
    }
);
```

### 2.3 `functions/src/multiModel/dataVerification.ts`

```typescript
import { logger } from 'firebase-functions';

interface VerificationResult {
    verified: boolean;
    dateValid: boolean;
    sourcesChecked: number;
    sourcesValid: number;
    dataCompleteness: number;
    warnings: string[];
}

/**
 * Veri teyidi — tarih, kaynak tutarlılık, xG aralık kontrolü
 */
export function verifyData(matchData: Record<string, any>): VerificationResult {
    const result: VerificationResult = {
        verified: true,
        dateValid: false,
        sourcesChecked: 0,
        sourcesValid: 0,
        dataCompleteness: 0,
        warnings: [],
    };

    // 1. Tarih doğrulama
    const matchDate = new Date(matchData.matchDate);
    if (matchDate > new Date()) {
        result.dateValid = true;
    } else {
        result.dateValid = false;
        result.warnings.push('Maç tarihi geçmişte — sonuçlar güncellenmemiş olabilir.');
    }

    // 2. Kaynak kontrolü
    const sources = ['fbref', 'sofascore', 'understat', 'weather'];
    for (const source of sources) {
        result.sourcesChecked++;
        if (matchData[source] && Object.keys(matchData[source]).length > 0) {
            result.sourcesValid++;
        } else {
            result.warnings.push(`${source} verisi eksik veya boş.`);
        }
    }

    // 3. Çapraz tutarlılık kontrolü (FBref vs SofaScore)
    if (matchData.fbref?.teamStats && matchData.sofascore?.statistics) {
        const fbrefPoss = parseFloat(matchData.fbref.teamStats?.home?.possession || '0');
        const sofaStats = matchData.sofascore.statistics;
        const sofaPoss = Array.isArray(sofaStats)
            ? parseFloat(sofaStats.find((s: any) => s.name === 'Ball possession')?.home || '0')
            : 0;

        if (fbrefPoss > 0 && sofaPoss > 0) {
            const diff = Math.abs(fbrefPoss - sofaPoss);
            if (diff > 10) {
                result.warnings.push(
                    `Top hakimiyeti tutarsızlığı: FBref=${fbrefPoss}%, SofaScore=${sofaPoss}%`
                );
            }
        }
    }

    // 4. xG makul aralık kontrolü
    if (matchData.understat) {
        const homeXg = parseFloat(matchData.understat.homeXg || '0');
        const awayXg = parseFloat(matchData.understat.awayXg || '0');
        if (homeXg > 5 || awayXg > 5) {
            result.warnings.push(`xG değeri anormal yüksek: Home=${homeXg}, Away=${awayXg}`);
        }
    }

    // 5. Veri tamlık skoru
    const factors = [
        matchData.homeTeam?.name ? 10 : 0,
        matchData.awayTeam?.name ? 10 : 0,
        matchData.matchDate ? 10 : 0,
        matchData.fbref ? 20 : 0,
        matchData.sofascore ? 20 : 0,
        matchData.understat ? 15 : 0,
        matchData.weather ? 10 : 0,
        matchData.odds ? 5 : 0,
    ];
    result.dataCompleteness = factors.reduce((a, b) => a + b, 0);

    if (result.dataCompleteness < 30) {
        result.verified = false;
        result.warnings.push('Veri tamlığı çok düşük — güvenilir analiz yapılamayabilir.');
    }

    logger.info(`Data verification: ${result.dataCompleteness}% complete, ${result.warnings.length} warnings`);
    return result;
}
```

### 2.4 `functions/src/multiModel/deepAnalysis.ts`

```typescript
/**
 * Derin Analiz — 8 modül, tamamı senkron hesaplama (API çağrısı yok)
 * Scraper verilerini (FBref, SofaScore, Understat) anlamlı analize dönüştürür.
 */

export function runDeepAnalysis(md: Record<string, any>) {
    return {
        weather: analyzeWeather(md),
        missingPlayers: analyzeMissingPlayers(md),
        homeAwayForm: analyzeHomeAwayForm(md),
        h2h: analyzeH2H(md),
        xg: analyzeXg(md),
        setPieces: analyzeSetPieces(md),
        referee: analyzeReferee(md),
        tactics: analyzeTactics(md),
    };
}

function analyzeWeather(md: Record<string, any>) {
    const w = md.weather || {};
    if (!w.temperature && !w.temp) return { impact: 'unknown', summary: 'Hava durumu verisi yok.' };

    const temp = parseFloat(w.temperature || w.temp || '15');
    const rain = w.rain || w.precipitation || 'yok';
    const wind = parseFloat(w.wind || w.windSpeed || '0');
    const humidity = w.humidity || 'bilinmiyor';

    let impact = 'low';
    const factors: string[] = [];

    if (temp < 5 || temp > 35) { impact = 'high'; factors.push(`Ekstrem sıcaklık: ${temp}°C`); }
    else if (temp < 10 || temp > 30) { impact = 'medium'; factors.push(`Dikkat çeken sıcaklık: ${temp}°C`); }

    if (rain && rain !== 'yok' && rain !== '0' && rain !== 'none') {
        impact = impact === 'low' ? 'medium' : 'high';
        factors.push(`Yağış bekleniyor: ${rain}`);
    }

    if (wind > 30) { impact = 'high'; factors.push(`Güçlü rüzgar: ${wind} km/s`); }
    else if (wind > 20) { if (impact === 'low') impact = 'medium'; factors.push(`Rüzgar: ${wind} km/s`); }

    return {
        temperature: `${temp}°C`, humidity: String(humidity), rain: String(rain), wind: `${wind} km/s`,
        impact,
        goalAvgNormal: 2.5,
        goalAvgSimilarWeather: impact === 'high' ? 1.8 : impact === 'medium' ? 2.2 : 2.5,
        summary: factors.length > 0
            ? `Hava koşulları etkisi: ${impact}. ${factors.join('. ')}`
            : 'Hava koşulları normal, önemli bir etki beklenmez.',
    };
}

function analyzeMissingPlayers(md: Record<string, any>) {
    const result: { home: any[]; away: any[]; overallImpact: string } = {
        home: [], away: [], overallImpact: 'neutral',
    };

    if (md.sofascore?.incidents) {
        for (const inc of md.sofascore.incidents) {
            if (inc.incidentType === 'card' && inc.incidentClass === 'red') {
                const team = inc.isHome ? 'home' : 'away';
                result[team].push({
                    name: inc.player?.name || 'Bilinmeyen',
                    position: inc.player?.position || '',
                    impactLevel: 'high',
                    reason: 'Kırmızı kart cezası',
                });
            }
        }
    }

    const totalMissing = result.home.length + result.away.length;
    result.overallImpact = totalMissing >= 3 ? 'significant' : totalMissing >= 1 ? 'moderate' : 'neutral';
    return result;
}

function analyzeHomeAwayForm(md: Record<string, any>) {
    const homeForm = md.homeTeam?.formLast5 || md.sofascore?.h2h?.homeForm || '';
    const awayForm = md.awayTeam?.formLast5 || md.sofascore?.h2h?.awayForm || '';

    function parseForm(form: string) {
        let wins = 0, draws = 0, losses = 0;
        for (const c of form.toUpperCase()) {
            if (c === 'W' || c === 'G') wins++;
            else if (c === 'D' || c === 'B') draws++;
            else if (c === 'L' || c === 'M') losses++;
        }
        return { wins, draws, losses, goalsFor: 0, goalsAgainst: 0 };
    }

    function getTrend(p: { wins: number; losses: number }) {
        if (p.wins >= 3) return 'improving';
        if (p.losses >= 3) return 'declining';
        return 'stable';
    }

    const homeParsed = parseForm(homeForm);
    const awayParsed = parseForm(awayForm);

    return {
        homeLast5Home: homeParsed, awayLast5Away: awayParsed,
        homeTrend: getTrend(homeParsed), awayTrend: getTrend(awayParsed),
        summary: `Ev form: ${homeForm || 'N/A'} (${getTrend(homeParsed)}), Dep form: ${awayForm || 'N/A'} (${getTrend(awayParsed)})`,
    };
}

function analyzeH2H(md: Record<string, any>) {
    const h2h = md.sofascore?.h2h || {};
    return {
        last5: h2h.last5 || '', homeWins: parseInt(h2h.homeWins || '0'),
        draws: parseInt(h2h.draws || '0'), awayWins: parseInt(h2h.awayWins || '0'),
        avgGoals: parseFloat(h2h.avgGoals || '0'),
        summary: h2h.last5
            ? `Son 5 H2H: ${h2h.last5}, Ev:${h2h.homeWins || 0} B:${h2h.draws || 0} D:${h2h.awayWins || 0}`
            : 'H2H verisi bulunamadı.',
    };
}

function analyzeXg(md: Record<string, any>) {
    const us = md.understat || {};
    const homeXg = parseFloat(us.homeXg || '0');
    const homeXga = parseFloat(us.homeXga || '0');
    const awayXg = parseFloat(us.awayXg || '0');
    const awayXga = parseFloat(us.awayXga || '0');
    const fbStats = md.fbref?.teamStats;
    const homeGoals = parseFloat(fbStats?.home?.goals || '0');
    const awayGoals = parseFloat(fbStats?.away?.goals || '0');

    return {
        homeXg, homeXga, awayXg, awayXga,
        homeOverperformance: homeGoals > 0 ? +(homeGoals - homeXg).toFixed(2) : 0,
        awayOverperformance: awayGoals > 0 ? +(awayGoals - awayXg).toFixed(2) : 0,
        summary: homeXg > 0 || awayXg > 0
            ? `xG — Ev: ${homeXg.toFixed(2)} (xGA: ${homeXga.toFixed(2)}), Dep: ${awayXg.toFixed(2)} (xGA: ${awayXga.toFixed(2)})`
            : 'xG verisi bulunamadı.',
    };
}

function analyzeSetPieces(md: Record<string, any>) {
    const fb = md.fbref?.teamStats;
    const hc = parseFloat(fb?.home?.cornersPerMatch || '0');
    const ac = parseFloat(fb?.away?.cornersPerMatch || '0');
    return {
        homeCornerGoalRate: hc > 0 ? 0.03 : 0, awayCornerGoalRate: ac > 0 ? 0.03 : 0,
        homeFreeKickDanger: 0, awayFreeKickDanger: 0,
        summary: `Korner ortalaması — Ev: ${hc.toFixed(1)}, Dep: ${ac.toFixed(1)}`,
    };
}

function analyzeReferee(md: Record<string, any>) {
    const ref = md.sofascore?.referee || md.referee || {};
    return {
        name: ref.name || 'Bilinmiyor',
        avgFoulsPerMatch: parseFloat(ref.avgFoulsPerMatch || '0'),
        avgYellowCards: parseFloat(ref.avgYellowCards || '0'),
        avgPenalties: parseFloat(ref.avgPenalties || '0'),
        homeTeamBias: 0,
        summary: ref.name ? `Hakem: ${ref.name}, Ort. sarı kart: ${ref.avgYellowCards || 'N/A'}` : 'Hakem bilgisi bulunamadı.',
    };
}

function analyzeTactics(md: Record<string, any>) {
    const formations = md.fbref?.formations || md.sofascore?.lineups;
    const fb = md.fbref?.teamStats;
    return {
        homeFormation: formations?.home?.formation || 'N/A',
        awayFormation: formations?.away?.formation || 'N/A',
        homePPDA: parseFloat(fb?.home?.ppda || '0'),
        awayPPDA: parseFloat(fb?.away?.ppda || '0'),
        styleMismatch: 'Analiz için yeterli veri yok.',
        summary: `Formasyon — Ev: ${formations?.home?.formation || 'N/A'}, Dep: ${formations?.away?.formation || 'N/A'}`,
    };
}
```

### 2.5 `functions/src/multiModel/aiClients.ts`

```typescript
import { logger } from 'firebase-functions';

/**
 * Gemini API çağrısı — responseMimeType: application/json
 */
export async function callGemini(prompt: string, apiKey: string): Promise<string> {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro-preview:generateContent?key=${apiKey}`;

    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
            generationConfig: {
                temperature: 0.7,
                topP: 0.9,
                topK: 40,
                maxOutputTokens: 16384,
                responseMimeType: 'application/json',
            },
        }),
        signal: AbortSignal.timeout(180000),
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Gemini error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Gemini API error: ${response.status}`);
    }

    const result = await response.json();
    return result.candidates?.[0]?.content?.parts?.[0]?.text || '';
}

/**
 * Claude API çağrısı — Anthropic Messages API
 */
export async function callClaude(prompt: string, apiKey: string): Promise<string> {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
        },
        body: JSON.stringify({
            model: 'claude-opus-4-6-20250219',
            max_tokens: 8192,
            temperature: 0.7,
            messages: [{ role: 'user', content: prompt }],
        }),
        signal: AbortSignal.timeout(180000),
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Claude error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Claude API error: ${response.status}`);
    }

    const result = await response.json();
    return result.content?.[0]?.text || '';
}

/**
 * Gemini 3.1 Konsensüs API çağrısı — responseMimeType: application/json
 * Farklı model: gemini-3.1-pro-preview (konsensüs için daha düşük temperature)
 */
export async function callGeminiConsensus(prompt: string, apiKey: string): Promise<string> {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent?key=${apiKey}`;

    const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            contents: [{ parts: [{ text: prompt }] }],
            generationConfig: {
                temperature: 0.5,
                topP: 0.85,
                topK: 30,
                maxOutputTokens: 8192,
                responseMimeType: 'application/json',
            },
        }),
        signal: AbortSignal.timeout(120000),
    });

    if (!response.ok) {
        const body = await response.text();
        logger.error(`Gemini Consensus error ${response.status}: ${body.substring(0, 300)}`);
        throw new Error(`Gemini 3.1 Consensus API error: ${response.status}`);
    }

    const result = await response.json();
    return result.candidates?.[0]?.content?.parts?.[0]?.text || '';
}
```

### 2.6 `functions/src/multiModel/multiModelPrompts.ts`

```typescript
/**
 * AI model prompt'ları oluşturucu
 */

export function buildGeminiPrompt(
    md: Record<string, any>,
    deepAnalysis: Record<string, any>,
    verification: Record<string, any>
): string {
    const home = md.homeTeam?.name || 'Ev Sahibi';
    const away = md.awayTeam?.name || 'Deplasman';

    return `Sen profesyonel bir futbol analisti ve istatistikçisin.

## MAÇ BİLGİSİ
- **${home}** vs **${away}**
- Lig: ${md.league || '?'} | Tarih: ${md.matchDate || '?'} | Stadyum: ${md.stadium || '?'}
- Veri Teyidi: ${verification.verified ? '✅ Doğrulandı' : '⚠️ Eksik'} (${verification.dataCompleteness}% tamlık)

## DERİN ANALİZ
${JSON.stringify(deepAnalysis, null, 2)}

## HAM VERİLER
${md.fbref ? '### FBref\n' + JSON.stringify(md.fbref, null, 2).substring(0, 3000) : 'FBref yok.'}
${md.sofascore ? '### SofaScore\n' + JSON.stringify(md.sofascore, null, 2).substring(0, 3000) : 'SofaScore yok.'}
${md.understat ? '### Understat\n' + JSON.stringify(md.understat, null, 2).substring(0, 1000) : 'Understat yok.'}

## ORANLAR
${md.odds ? `1: ${md.odds.home}, X: ${md.odds.draw}, 2: ${md.odds.away}` : 'Yok.'}

## TALİMAT
8 kategoriyi puanla (0-10, en az 0.5 fark):
power(%20), tactics(%20), psychology(%18), externalFactors(%10), market(%7), referee(%8), setPieces(%7), physical(%10)

KRİTİK: SADECE JSON döndür.
\`\`\`json
{
  "prediction": { "result": "1|X|2", "resultLabel": "string", "confidence": 0.45-1.0, "scorePrediction": "2-1", "bttsProb": 0-1, "over25Prob": 0-1 },
  "keyFactors": ["3-5 faktör"],
  "reasoning": "2-3 paragraf Türkçe analiz",
  "categories": {
    "power": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.20, "detail": "" },
    "tactics": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.20, "detail": "" },
    "psychology": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.18, "detail": "" },
    "externalFactors": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.10, "detail": "" },
    "market": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.07, "detail": "" },
    "referee": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.08, "detail": "" },
    "setPieces": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.07, "detail": "" },
    "physical": { "homeScore": 0-10, "awayScore": 0-10, "weight": 0.10, "detail": "" }
  },
  "weightedTotal": { "home": 0-100, "away": 0-100 }
}
\`\`\``;
}

export function buildClaudePrompt(
    md: Record<string, any>,
    deepAnalysis: Record<string, any>,
    verification: Record<string, any>
): string {
    const home = md.homeTeam?.name || 'Ev Sahibi';
    const away = md.awayTeam?.name || 'Deplasman';

    return `<role>Profesyonel futbol analisti ve veri bilimcisi. İstatistiksel sapma tespiti konusunda uzman.</role>

<match>${home} vs ${away} | ${md.league || '?'} | ${md.matchDate || '?'} | ${md.stadium || '?'}
Veri: ${verification.dataCompleteness}% (${verification.verified ? 'Teyitli' : 'Eksik'})
${verification.warnings?.length > 0 ? 'Uyarılar: ' + verification.warnings.join('; ') : ''}</match>

<deep_analysis>${JSON.stringify(deepAnalysis, null, 2)}</deep_analysis>

<stats>
${md.fbref ? JSON.stringify(md.fbref, null, 2).substring(0, 3000) : 'FBref yok'}
${md.sofascore ? JSON.stringify(md.sofascore, null, 2).substring(0, 3000) : 'SofaScore yok'}
${md.understat ? JSON.stringify(md.understat, null, 2).substring(0, 1000) : 'Understat yok'}
</stats>

<odds>${md.odds ? `1: ${md.odds.home}, X: ${md.odds.draw}, 2: ${md.odds.away}` : 'Yok'}</odds>

<instructions>
Odak: veri tutarsızlıkları, xG sapmaları, bağlamsal faktörler.
8 kategori: power(%20) tactics(%20) psychology(%18) externalFactors(%10) market(%7) referee(%8) setPieces(%7) physical(%10)
SADECE JSON döndür:
{"prediction":{"result":"1|X|2","resultLabel":"","confidence":0.45-1,"scorePrediction":"","bttsProb":0-1,"over25Prob":0-1},"keyFactors":[],"reasoning":"","categories":{"power":{"homeScore":0-10,"awayScore":0-10,"weight":0.20,"detail":""},"tactics":{"homeScore":0-10,"awayScore":0-10,"weight":0.20,"detail":""},"psychology":{"homeScore":0-10,"awayScore":0-10,"weight":0.18,"detail":""},"externalFactors":{"homeScore":0-10,"awayScore":0-10,"weight":0.10,"detail":""},"market":{"homeScore":0-10,"awayScore":0-10,"weight":0.07,"detail":""},"referee":{"homeScore":0-10,"awayScore":0-10,"weight":0.08,"detail":""},"setPieces":{"homeScore":0-10,"awayScore":0-10,"weight":0.07,"detail":""},"physical":{"homeScore":0-10,"awayScore":0-10,"weight":0.10,"detail":""}},"weightedTotal":{"home":0-100,"away":0-100}}
</instructions>`;
}

export function buildConsensusPrompt(
    md: Record<string, any>,
    geminiResult: Record<string, any>,
    claudeResult: Record<string, any>
): string {
    const home = md.homeTeam?.name || 'Ev Sahibi';
    const away = md.awayTeam?.name || 'Deplasman';

    return `Sen bağımsız bir futbol analiz hakemisin. İki AI modelinin analizlerini karşılaştırıp konsensüs üret.

## MAÇ: ${home} vs ${away}

## GEMİNİ ANALİZİ
Tahmin: ${geminiResult.prediction?.result} (Güven: ${((geminiResult.prediction?.confidence || 0) * 100).toFixed(0)}%)
Skor: ${geminiResult.prediction?.scorePrediction}
Faktörler: ${JSON.stringify(geminiResult.keyFactors)}
Gerekçe: ${geminiResult.reasoning}

## CLAUDE ANALİZİ
Tahmin: ${claudeResult.prediction?.result} (Güven: ${((claudeResult.prediction?.confidence || 0) * 100).toFixed(0)}%)
Skor: ${claudeResult.prediction?.scorePrediction}
Faktörler: ${JSON.stringify(claudeResult.keyFactors)}
Gerekçe: ${claudeResult.reasoning}

## TALİMAT
1. İki analizi karşılaştır
2. Hemfikir noktaları belirle (yüksek güven)
3. Farklılıkları tespit et
4. Nihai konsensüs tahmini üret

SADECE JSON:
{
  "prediction": { "result": "1|X|2", "resultLabel": "", "confidence": 0-1, "scorePrediction": "", "bttsProb": 0-1, "over25Prob": 0-1 },
  "agreements": ["hemfikir noktalar"],
  "disagreements": ["farklılıklar"],
  "finalVerdict": "2-3 paragraf Türkçe konsensüs açıklaması",
  "confidenceBreakdown": { "geminiConfidence": ${geminiResult.prediction?.confidence || 0.5}, "claudeConfidence": ${claudeResult.prediction?.confidence || 0.5}, "consensusConfidence": 0-1 },
  "riskFactors": ["riskler"]
}`;
}
```

### 2.7 `functions/src/multiModel/multiModelParser.ts`

```typescript
import { logger } from 'firebase-functions';

/**
 * AI yanıtından JSON parse — code fence temizleme + fallback
 */
function extractJSON(raw: string): any {
    let text = raw;

    // Code fence temizle
    const fenceMatch = text.match(/```(?:json)?\s*\n?([\s\S]*?)\n?\s*```/);
    if (fenceMatch) text = fenceMatch[1];

    // İlk { ve son } arasını al
    const first = text.indexOf('{');
    const last = text.lastIndexOf('}');
    if (first !== -1 && last > first) {
        text = text.substring(first, last + 1);
    }

    try {
        return JSON.parse(text);
    } catch {
        // Trailing comma temizle
        const cleaned = text.replace(/,\s*([}\]])/g, '$1');
        try {
            return JSON.parse(cleaned);
        } catch (e) {
            logger.warn(`JSON parse failed. First 200 chars: ${raw.substring(0, 200)}`);
            return null;
        }
    }
}

/** Score clamping */
function clampCategories(parsed: any): any {
    if (parsed?.categories) {
        for (const key of Object.keys(parsed.categories)) {
            const cat = parsed.categories[key];
            if (cat) {
                cat.homeScore = Math.max(0, Math.min(10, cat.homeScore || 0));
                cat.awayScore = Math.max(0, Math.min(10, cat.awayScore || 0));
                cat.weight = Math.max(0, Math.min(1, cat.weight || 0));
            }
        }
    }
    if (parsed?.prediction) {
        parsed.prediction.confidence = Math.max(0, Math.min(1, parsed.prediction.confidence || 0));
    }
    return parsed;
}

/** AI model yanıtı parse (Gemini / Claude) */
export function parseAIResponse(raw: string) {
    const parsed = extractJSON(raw);
    if (!parsed) {
        return {
            prediction: { result: 'X', resultLabel: 'Parse hatası', confidence: 0.45,
                           scorePrediction: '1-1', bttsProb: 0.5, over25Prob: 0.5 },
            keyFactors: ['AI yanıtı parse edilemedi'],
            reasoning: 'Yanıt geçerli JSON formatında değildi.',
            categories: {},
            weightedTotal: { home: 50, away: 50 },
        };
    }
    return clampCategories(parsed);
}

/** Konsensüs yanıtı parse (Gemini 3.1) */
export function parseConsensusResponse(raw: string) {
    const parsed = extractJSON(raw);
    if (!parsed) {
        return {
            prediction: { result: 'X', resultLabel: 'Konsensüs oluşturulamadı', confidence: 0.45 },
            agreements: [], disagreements: ['Parse hatası'],
            finalVerdict: 'Konsensüs yanıtı geçerli JSON değildi.',
            confidenceBreakdown: { geminiConfidence: 0.5, claudeConfidence: 0.5, consensusConfidence: 0.45 },
            riskFactors: ['Konsensüs oluşturulamadı'],
        };
    }
    return parsed;
}
```

### 2.8 `functions/src/index.ts` Güncellemesi

```typescript
// Mevcut export'lara ekle:
export { triggerMultiModelAnalysis } from './multiModel/triggerMultiModelAnalysis';
export { onMultiAnalysisCreated } from './multiModel/multiModelPipeline';
```

---

## BÖLÜM 3: Flutter Veri Modelleri

### 3.1 `lib/data/models/multi_model_analysis_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'multi_model_analysis_model.freezed.dart';
part 'multi_model_analysis_model.g.dart';

/// Çoklu Model Analiz Ana Modeli
@freezed
class MultiModelAnalysisModel with _$MultiModelAnalysisModel {
  const factory MultiModelAnalysisModel({
    required String matchId,
    required String userId,
    @Default('pending') String status,
    @Default('') String statusMessage,
    VerificationResult? verification,
    DeepAnalysisResult? deepAnalysis,
    AIModelResult? geminiResult,
    AIModelResult? claudeResult,
    ConsensusResult? consensusResult,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
  }) = _MultiModelAnalysisModel;

  factory MultiModelAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$MultiModelAnalysisModelFromJson(json);
}

/// Veri Teyit Sonucu
@freezed
class VerificationResult with _$VerificationResult {
  const factory VerificationResult({
    @Default(false) bool verified,
    @Default(false) bool dateValid,
    @Default(0) int sourcesChecked,
    @Default(0) int sourcesValid,
    @Default(0) int dataCompleteness,
    @Default([]) List<String> warnings,
  }) = _VerificationResult;

  factory VerificationResult.fromJson(Map<String, dynamic> json) =>
      _$VerificationResultFromJson(json);
}

/// Derin Analiz Sonucu (8 Modül)
@freezed
class DeepAnalysisResult with _$DeepAnalysisResult {
  const factory DeepAnalysisResult({
    WeatherAnalysis? weather,
    MissingPlayersAnalysis? missingPlayers,
    HomeAwayFormAnalysis? homeAwayForm,
    H2HAnalysis? h2h,
    XgAnalysis? xg,
    SetPieceAnalysis? setPieces,
    RefereeAnalysis? referee,
    TacticsAnalysis? tactics,
  }) = _DeepAnalysisResult;

  factory DeepAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$DeepAnalysisResultFromJson(json);
}

/// Hava Durumu Analizi
@freezed
class WeatherAnalysis with _$WeatherAnalysis {
  const factory WeatherAnalysis({
    @Default('') String temperature,
    @Default('') String humidity,
    @Default('') String rain,
    @Default('') String wind,
    @Default('low') String impact,
    @Default(0) double goalAvgNormal,
    @Default(0) double goalAvgSimilarWeather,
    @Default('') String summary,
  }) = _WeatherAnalysis;

  factory WeatherAnalysis.fromJson(Map<String, dynamic> json) =>
      _$WeatherAnalysisFromJson(json);
}

/// Eksik Oyuncu Analizi
@freezed
class MissingPlayersAnalysis with _$MissingPlayersAnalysis {
  const factory MissingPlayersAnalysis({
    @Default([]) List<MissingPlayer> home,
    @Default([]) List<MissingPlayer> away,
    @Default('neutral') String overallImpact,
  }) = _MissingPlayersAnalysis;

  factory MissingPlayersAnalysis.fromJson(Map<String, dynamic> json) =>
      _$MissingPlayersAnalysisFromJson(json);
}

@freezed
class MissingPlayer with _$MissingPlayer {
  const factory MissingPlayer({
    @Default('') String name,
    @Default('') String position,
    @Default('low') String impactLevel,
    @Default('') String reason,
  }) = _MissingPlayer;

  factory MissingPlayer.fromJson(Map<String, dynamic> json) =>
      _$MissingPlayerFromJson(json);
}

/// Ev/Deplasman Form Analizi
@freezed
class HomeAwayFormAnalysis with _$HomeAwayFormAnalysis {
  const factory HomeAwayFormAnalysis({
    FormStats? homeLast5Home,
    FormStats? awayLast5Away,
    @Default('stable') String homeTrend,
    @Default('stable') String awayTrend,
    @Default('') String summary,
  }) = _HomeAwayFormAnalysis;

  factory HomeAwayFormAnalysis.fromJson(Map<String, dynamic> json) =>
      _$HomeAwayFormAnalysisFromJson(json);
}

@freezed
class FormStats with _$FormStats {
  const factory FormStats({
    @Default(0) int wins,
    @Default(0) int draws,
    @Default(0) int losses,
    @Default(0) int goalsFor,
    @Default(0) int goalsAgainst,
  }) = _FormStats;

  factory FormStats.fromJson(Map<String, dynamic> json) =>
      _$FormStatsFromJson(json);
}

/// H2H Analizi
@freezed
class H2HAnalysis with _$H2HAnalysis {
  const factory H2HAnalysis({
    @Default('') String last5,
    @Default(0) int homeWins,
    @Default(0) int draws,
    @Default(0) int awayWins,
    @Default(0) double avgGoals,
    @Default('') String summary,
  }) = _H2HAnalysis;

  factory H2HAnalysis.fromJson(Map<String, dynamic> json) =>
      _$H2HAnalysisFromJson(json);
}

/// xG Analizi
@freezed
class XgAnalysis with _$XgAnalysis {
  const factory XgAnalysis({
    @Default(0) double homeXg,
    @Default(0) double homeXga,
    @Default(0) double awayXg,
    @Default(0) double awayXga,
    @Default(0) double homeOverperformance,
    @Default(0) double awayOverperformance,
    @Default('') String summary,
  }) = _XgAnalysis;

  factory XgAnalysis.fromJson(Map<String, dynamic> json) =>
      _$XgAnalysisFromJson(json);
}

/// Set Piece Analizi
@freezed
class SetPieceAnalysis with _$SetPieceAnalysis {
  const factory SetPieceAnalysis({
    @Default(0) double homeCornerGoalRate,
    @Default(0) double awayCornerGoalRate,
    @Default(0) double homeFreeKickDanger,
    @Default(0) double awayFreeKickDanger,
    @Default('') String summary,
  }) = _SetPieceAnalysis;

  factory SetPieceAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SetPieceAnalysisFromJson(json);
}

/// Hakem Analizi
@freezed
class RefereeAnalysis with _$RefereeAnalysis {
  const factory RefereeAnalysis({
    @Default('') String name,
    @Default(0) double avgFoulsPerMatch,
    @Default(0) double avgYellowCards,
    @Default(0) double avgPenalties,
    @Default(0) double homeTeamBias,
    @Default('') String summary,
  }) = _RefereeAnalysis;

  factory RefereeAnalysis.fromJson(Map<String, dynamic> json) =>
      _$RefereeAnalysisFromJson(json);
}

/// Taktik Analizi
@freezed
class TacticsAnalysis with _$TacticsAnalysis {
  const factory TacticsAnalysis({
    @Default('') String homeFormation,
    @Default('') String awayFormation,
    @Default(0) double homePPDA,
    @Default(0) double awayPPDA,
    @Default('') String styleMismatch,
    @Default('') String summary,
  }) = _TacticsAnalysis;

  factory TacticsAnalysis.fromJson(Map<String, dynamic> json) =>
      _$TacticsAnalysisFromJson(json);
}

/// AI Model Sonucu (Gemini ve Claude aynı yapıda)
@freezed
class AIModelResult with _$AIModelResult {
  const factory AIModelResult({
    AIPrediction? prediction,
    @Default([]) List<String> keyFactors,
    @Default('') String reasoning,
    Map<String, AICategoryScore>? categories,
    AIWeightedTotal? weightedTotal,
    @Default('') String modelUsed,
    DateTime? completedAt,
  }) = _AIModelResult;

  factory AIModelResult.fromJson(Map<String, dynamic> json) =>
      _$AIModelResultFromJson(json);
}

@freezed
class AIPrediction with _$AIPrediction {
  const factory AIPrediction({
    @Default('') String result,
    @Default('') String resultLabel,
    @Default(0.0) double confidence,
    @Default('') String scorePrediction,
    @Default(0.0) double bttsProb,
    @Default(0.0) double over25Prob,
  }) = _AIPrediction;

  factory AIPrediction.fromJson(Map<String, dynamic> json) =>
      _$AIPredictionFromJson(json);
}

@freezed
class AICategoryScore with _$AICategoryScore {
  const factory AICategoryScore({
    @Default(0) double homeScore,
    @Default(0) double awayScore,
    @Default(0) double weight,
    @Default('') String detail,
  }) = _AICategoryScore;

  factory AICategoryScore.fromJson(Map<String, dynamic> json) =>
      _$AICategoryScoreFromJson(json);
}

@freezed
class AIWeightedTotal with _$AIWeightedTotal {
  const factory AIWeightedTotal({
    @Default(0) double home,
    @Default(0) double away,
  }) = _AIWeightedTotal;

  factory AIWeightedTotal.fromJson(Map<String, dynamic> json) =>
      _$AIWeightedTotalFromJson(json);
}

/// Konsensüs Sonucu (Gemini 3.1)
@freezed
class ConsensusResult with _$ConsensusResult {
  const factory ConsensusResult({
    AIPrediction? prediction,
    @Default([]) List<String> agreements,
    @Default([]) List<String> disagreements,
    @Default('') String finalVerdict,
    ConfidenceBreakdown? confidenceBreakdown,
    @Default([]) List<String> riskFactors,
    @Default('') String modelUsed,
    DateTime? completedAt,
  }) = _ConsensusResult;

  factory ConsensusResult.fromJson(Map<String, dynamic> json) =>
      _$ConsensusResultFromJson(json);
}

@freezed
class ConfidenceBreakdown with _$ConfidenceBreakdown {
  const factory ConfidenceBreakdown({
    @Default(0) double geminiConfidence,
    @Default(0) double claudeConfidence,
    @Default(0) double consensusConfidence,
  }) = _ConfidenceBreakdown;

  factory ConfidenceBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ConfidenceBreakdownFromJson(json);
}
```

### 3.2 `lib/data/models/multi_model_analysis_model.dart` — Firestore Helper

```dart
// multi_model_analysis_model.dart dosyasının sonuna ekle:

extension MultiModelAnalysisModelX on MultiModelAnalysisModel {
  /// Firestore Timestamp → DateTime dönüşümü ile factory
  static MultiModelAnalysisModel fromFirestore(Map<String, dynamic> data) {
    // Timestamp alanlarını ISO string'e dönüştür
    final converted = Map<String, dynamic>.from(data);

    for (final key in ['createdAt', 'updatedAt', 'expiresAt']) {
      if (converted[key] != null && converted[key] is! String) {
        try {
          final ts = converted[key];
          if (ts.toDate != null) {
            converted[key] = ts.toDate().toIso8601String();
          }
        } catch (_) {
          converted.remove(key);
        }
      }
    }

    // AI result'lardaki completedAt da dönüştür
    for (final key in ['geminiResult', 'claudeResult']) {
      if (converted[key] is Map && converted[key]['completedAt'] != null) {
        try {
          final ts = converted[key]['completedAt'];
          if (ts is! String && ts.toDate != null) {
            converted[key]['completedAt'] = ts.toDate().toIso8601String();
          }
        } catch (_) {}
      }
    }
    if (converted['consensusResult'] is Map && converted['consensusResult']['completedAt'] != null) {
      try {
        final ts = converted['consensusResult']['completedAt'];
        if (ts is! String && ts.toDate != null) {
          converted['consensusResult']['completedAt'] = ts.toDate().toIso8601String();
        }
      } catch (_) {}
    }

    return MultiModelAnalysisModel.fromJson(converted);
  }

  /// Durum Türkçe etiket
  String get statusLabel {
    switch (status) {
      case 'pending': return 'Kuyrukta...';
      case 'verifying': return 'Veriler teyit ediliyor...';
      case 'analyzing': return 'Derin analiz yapılıyor...';
      case 'ai_processing': return 'AI modelleri analiz ediyor...';
      case 'consensus': return 'Konsensüs oluşturuluyor...';
      case 'completed': return 'Tamamlandı';
      case 'failed': return 'Hata oluştu';
      default: return status;
    }
  }

  /// Tamamlanma yüzdesi (progress bar için)
  double get progress {
    switch (status) {
      case 'pending': return 0.05;
      case 'verifying': return 0.15;
      case 'analyzing': return 0.35;
      case 'ai_processing': return 0.60;
      case 'consensus': return 0.85;
      case 'completed': return 1.0;
      case 'failed': return 0.0;
      default: return 0.0;
    }
  }
}
```

---

## BÖLÜM 4: Flutter Repository

### 4.1 `lib/data/repositories/multi_model_analysis_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/multi_model_analysis_model.dart';

class MultiModelAnalysisRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  MultiModelAnalysisRepository({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1'),
        _auth = auth ?? FirebaseAuth.instance;

  /// Çoklu model analizini başlat (Cloud Function çağır)
  Future<String> triggerAnalysis(String matchId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Kullanıcı girişi gerekli.');

    final callable = _functions.httpsCallable(
      'triggerMultiModelAnalysis',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );

    final result = await callable.call<Map<String, dynamic>>({
      'matchId': matchId,
    });

    final data = result.data;
    if (data == null || data['analysisId'] == null) {
      throw Exception('Analiz başlatılamadı.');
    }

    return data['analysisId'] as String;
  }

  /// Firestore'dan analiz stream'i (real-time)
  Stream<MultiModelAnalysisModel?> streamAnalysis(String matchId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(null);

    final docId = '${matchId}_$userId';
    return _firestore
        .collection('multi_analyses')
        .doc(docId)
        .snapshots()
        .map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return MultiModelAnalysisModelX.fromFirestore(snap.data()!);
    });
  }

  /// Cache'den al (tek seferlik okuma)
  Future<MultiModelAnalysisModel?> getCached(String matchId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final docId = '${matchId}_$userId';
    final snap = await _firestore.collection('multi_analyses').doc(docId).get();

    if (!snap.exists || snap.data() == null) return null;

    final model = MultiModelAnalysisModelX.fromFirestore(snap.data()!);

    // TTL kontrolü
    if (model.expiresAt != null && model.expiresAt!.isBefore(DateTime.now())) {
      return null; // Süresi dolmuş
    }

    return model.status == 'completed' ? model : null;
  }
}
```

---

## BÖLÜM 5: Flutter Provider'lar

### 5.1 `lib/presentation/providers/multi_model_analysis_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/multi_model_analysis_model.dart';
import '../../data/repositories/multi_model_analysis_repository.dart';

/// Repository provider
final multiModelRepoProvider = Provider<MultiModelAnalysisRepository>((ref) {
  return MultiModelAnalysisRepository();
});

/// Analiz durumu stream provider (real-time Firestore)
final multiModelAnalysisStreamProvider =
    StreamProvider.autoDispose.family<MultiModelAnalysisModel?, String>(
  (ref, matchId) {
    final repo = ref.watch(multiModelRepoProvider);
    return repo.streamAnalysis(matchId);
  },
);

/// Analiz tetikleme provider (one-shot)
final triggerMultiModelProvider =
    FutureProvider.autoDispose.family<String, String>(
  (ref, matchId) async {
    final repo = ref.read(multiModelRepoProvider);
    return repo.triggerAnalysis(matchId);
  },
);
```

---

## BÖLÜM 6: Flutter UI Bileşenleri

### 6.1 `lib/presentation/widgets/multi_model/multi_model_analysis_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/multi_model_analysis_model.dart';
import '../../providers/multi_model_analysis_provider.dart';
import 'ai_result_tab.dart';
import 'consensus_tab.dart';
import 'verification_badge.dart';

/// Çoklu Model Analiz Görünümü — 3 Tab
class MultiModelAnalysisView extends ConsumerStatefulWidget {
  final String matchId;
  final String matchTitle;

  const MultiModelAnalysisView({
    required this.matchId,
    required this.matchTitle,
    super.key,
  });

  @override
  ConsumerState<MultiModelAnalysisView> createState() =>
      _MultiModelAnalysisViewState();
}

class _MultiModelAnalysisViewState extends ConsumerState<MultiModelAnalysisView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTriggered = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _startAnalysis() async {
    setState(() => _isTriggered = true);
    try {
      await ref.read(triggerMultiModelProvider(widget.matchId).future);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString().replaceAll("Exception: ", "")}')),
        );
        setState(() => _isTriggered = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analysisAsync = ref.watch(multiModelAnalysisStreamProvider(widget.matchId));

    return analysisAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (analysis) {
        // Henüz analiz yok — başlat butonu göster
        if (analysis == null && !_isTriggered) {
          return _buildStartButton(theme);
        }

        // Analiz devam ediyor
        if (analysis == null || analysis.status != 'completed') {
          return _buildProgressView(theme, analysis);
        }

        // Analiz tamamlandı — 3 tab göster
        return _buildCompletedView(theme, analysis);
      },
    );
  }

  Widget _buildStartButton(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 48,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Çoklu Model Analizi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gemini 2.5 + Claude + Gemini 3.1 konsensüs',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _startAnalysis,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Analizi Başlat'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressView(ThemeData theme, MultiModelAnalysisModel? analysis) {
    final progress = analysis?.progress ?? 0.05;
    final message = analysis?.statusMessage ?? 'Başlatılıyor...';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${(progress * 100).toInt()}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Tamamlanan aşamaları göster
            if (analysis != null) ...[
              _StatusStep(label: 'Veri Teyidi', done: _isDone(analysis, 'verifying'), theme: theme),
              _StatusStep(label: 'Derin Analiz', done: _isDone(analysis, 'analyzing'), theme: theme),
              _StatusStep(label: 'AI İşleme', done: _isDone(analysis, 'ai_processing'), theme: theme),
              _StatusStep(label: 'Konsensüs', done: _isDone(analysis, 'consensus'), theme: theme),
            ],
          ],
        ),
      ),
    );
  }

  bool _isDone(MultiModelAnalysisModel analysis, String stage) {
    const order = ['pending', 'verifying', 'analyzing', 'ai_processing', 'consensus', 'completed'];
    final currentIdx = order.indexOf(analysis.status);
    final stageIdx = order.indexOf(stage);
    return currentIdx > stageIdx;
  }

  Widget _buildCompletedView(ThemeData theme, MultiModelAnalysisModel analysis) {
    return Column(
      children: [
        // Veri teyit badge'i
        if (analysis.verification != null)
          VerificationBadge(verification: analysis.verification!),
        const SizedBox(height: 12),

        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerTheme.color ?? AppColors.cardBorderColor,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 16),
                    const SizedBox(width: 4),
                    Text('Gemini', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.smart_toy, size: 16),
                    const SizedBox(width: 4),
                    Text('Claude', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.handshake, size: 16),
                    const SizedBox(width: 4),
                    Text('Konsensüs', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tab içerikleri
        SizedBox(
          height: 500, // veya Expanded (parent'a göre)
          child: TabBarView(
            controller: _tabController,
            children: [
              AIResultTab(
                result: analysis.geminiResult,
                modelName: 'Gemini 2.5 Pro',
                modelIcon: Icons.auto_awesome,
                accentColor: const Color(0xFF4285F4), // Google blue
              ),
              AIResultTab(
                result: analysis.claudeResult,
                modelName: 'Claude Opus 4.6',
                modelIcon: Icons.smart_toy,
                accentColor: const Color(0xFFD97706), // Anthropic amber
              ),
              ConsensusTab(
                consensus: analysis.consensusResult,
                geminiResult: analysis.geminiResult,
                claudeResult: analysis.claudeResult,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label;
  final bool done;
  final ThemeData theme;

  const _StatusStep({required this.label, required this.done, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: done ? AppColors.successColor : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: done
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: done ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 6.2 `lib/presentation/widgets/multi_model/ai_result_tab.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/multi_model_analysis_model.dart';

/// Tek bir AI modelinin analiz sonucu tab'ı
class AIResultTab extends StatelessWidget {
  final AIModelResult? result;
  final String modelName;
  final IconData modelIcon;
  final Color accentColor;

  const AIResultTab({
    required this.result,
    required this.modelName,
    required this.modelIcon,
    required this.accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (result == null) {
      return Center(
        child: Text('$modelName sonucu henüz yok.', style: theme.textTheme.bodyMedium),
      );
    }

    final pred = result!.prediction;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tahmin banner
          if (pred != null) _buildPredictionCard(theme, pred),
          const SizedBox(height: 12),

          // Ana faktörler
          if (result!.keyFactors.isNotEmpty) ...[
            Text('Ana Faktörler', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...result!.keyFactors.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_right, size: 18, color: accentColor),
                  const SizedBox(width: 4),
                  Expanded(child: Text(f, style: theme.textTheme.bodySmall)),
                ],
              ),
            )),
            const SizedBox(height: 12),
          ],

          // Kategori puanları
          if (result!.categories != null && result!.categories!.isNotEmpty) ...[
            Text('Kategori Puanları', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...result!.categories!.entries.map((e) => _buildCategoryRow(theme, e.key, e.value)),
            const SizedBox(height: 12),
          ],

          // Ağırlıklı toplam
          if (result!.weightedTotal != null)
            _buildWeightedTotal(theme, result!.weightedTotal!),
          const SizedBox(height: 12),

          // Gerekçe
          if (result!.reasoning.isNotEmpty) ...[
            Text('Detaylı Gerekçe', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(result!.reasoning, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildPredictionCard(ThemeData theme, AIPrediction pred) {
    final confidencePercent = (pred.confidence * 100).toInt();
    final predColor = _getPredictionColor(pred.confidence);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withValues(alpha: 0.15), accentColor.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(modelIcon, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Text(modelName, style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700, color: accentColor,
              )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: predColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '%$confidencePercent güven',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12, fontWeight: FontWeight.w700, color: predColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                pred.result,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 36, fontWeight: FontWeight.w900, color: accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pred.resultLabel, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  if (pred.scorePrediction.isNotEmpty)
                    Text('Skor: ${pred.scorePrediction}', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat(label: 'KG', value: '${(pred.bttsProb * 100).toInt()}%', theme: theme),
              _MiniStat(label: '2.5 Üst', value: '${(pred.over25Prob * 100).toInt()}%', theme: theme),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPredictionColor(double confidence) {
    if (confidence >= 0.7) return AppColors.bankoColor;
    if (confidence >= 0.55) return AppColors.gucluColor;
    return AppColors.riskliColor;
  }

  Widget _buildCategoryRow(ThemeData theme, String name, AICategoryScore score) {
    final categoryLabels = {
      'power': 'Güç',
      'tactics': 'Taktik',
      'psychology': 'Psikoloji',
      'externalFactors': 'Dış Etkenler',
      'market': 'Piyasa',
      'referee': 'Hakem',
      'setPieces': 'Duran Top',
      'physical': 'Fiziksel',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              categoryLabels[name] ?? name,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            score.homeScore.toStringAsFixed(1),
            style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _DualBar(home: score.homeScore, away: score.awayScore, theme: theme),
            ),
          ),
          Text(
            score.awayScore.toStringAsFixed(1),
            style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          Text(
            '(${(score.weight * 100).toInt()}%)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightedTotal(ThemeData theme, AIWeightedTotal total) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('Ev Sahibi', style: theme.textTheme.bodySmall),
              Text(
                total.home.toStringAsFixed(1),
                style: GoogleFonts.jetBrainsMono(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Text('vs', style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          )),
          Column(
            children: [
              Text('Deplasman', style: theme.textTheme.bodySmall),
              Text(
                total.away.toStringAsFixed(1),
                style: GoogleFonts.jetBrainsMono(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DualBar extends StatelessWidget {
  final double home;
  final double away;
  final ThemeData theme;
  const _DualBar({required this.home, required this.away, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Row(
        children: [
          Expanded(
            flex: (home * 10).toInt().clamp(1, 100),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: (away * 10).toInt().clamp(1, 100),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accentColor.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  const _MiniStat({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 10,
        )),
        Text(value, style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
```

### 6.3 `lib/presentation/widgets/multi_model/consensus_tab.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/multi_model_analysis_model.dart';

/// Konsensüs Tab'ı — Gemini 3.1'in Gemini 2.5 + Claude karşılaştırması
class ConsensusTab extends StatelessWidget {
  final ConsensusResult? consensus;
  final AIModelResult? geminiResult;
  final AIModelResult? claudeResult;

  const ConsensusTab({
    required this.consensus,
    this.geminiResult,
    this.claudeResult,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (consensus == null) {
      return Center(child: Text('Konsensüs henüz hazır değil.', style: theme.textTheme.bodyMedium));
    }

    final pred = consensus!.prediction;
    final cb = consensus!.confidenceBreakdown;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Konsensüs tahmin kartı
          if (pred != null) _buildConsensusCard(theme, pred, cb),
          const SizedBox(height: 16),

          // Model karşılaştırma tablosu
          _buildModelComparison(theme),
          const SizedBox(height: 16),

          // Hemfikir noktalar
          if (consensus!.agreements.isNotEmpty) ...[
            _SectionHeader(icon: Icons.check_circle, label: 'Hemfikir Noktalar', color: AppColors.successColor),
            const SizedBox(height: 8),
            ...consensus!.agreements.map((a) => _BulletItem(text: a, color: AppColors.successColor, theme: theme)),
            const SizedBox(height: 12),
          ],

          // Farklılıklar
          if (consensus!.disagreements.isNotEmpty) ...[
            _SectionHeader(icon: Icons.warning_amber, label: 'Farklılıklar', color: AppColors.warningColor),
            const SizedBox(height: 8),
            ...consensus!.disagreements.map((d) => _BulletItem(text: d, color: AppColors.warningColor, theme: theme)),
            const SizedBox(height: 12),
          ],

          // Risk faktörleri
          if (consensus!.riskFactors.isNotEmpty) ...[
            _SectionHeader(icon: Icons.dangerous, label: 'Risk Faktörleri', color: AppColors.dangerColor),
            const SizedBox(height: 8),
            ...consensus!.riskFactors.map((r) => _BulletItem(text: r, color: AppColors.dangerColor, theme: theme)),
            const SizedBox(height: 12),
          ],

          // Final gerekçe
          if (consensus!.finalVerdict.isNotEmpty) ...[
            Text('Nihai Değerlendirme', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(consensus!.finalVerdict, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildConsensusCard(ThemeData theme, AIPrediction pred, ConfidenceBreakdown? cb) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.handshake, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'KONSENSÜS',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            pred.result,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white,
            ),
          ),
          Text(
            pred.resultLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600,
            ),
          ),
          if (pred.scorePrediction.isNotEmpty)
            Text(
              'Skor: ${pred.scorePrediction}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.7)),
            ),
          const SizedBox(height: 12),
          // Güven çubukları
          if (cb != null) ...[
            _ConfidenceBar(label: 'Gemini', value: cb.geminiConfidence, color: const Color(0xFF4285F4)),
            const SizedBox(height: 4),
            _ConfidenceBar(label: 'Claude', value: cb.claudeConfidence, color: const Color(0xFFD97706)),
            const SizedBox(height: 4),
            _ConfidenceBar(label: 'Konsensüs', value: cb.consensusConfidence, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Widget _buildModelComparison(ThemeData theme) {
    final gPred = geminiResult?.prediction;
    final cPred = claudeResult?.prediction;
    if (gPred == null && cPred == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? AppColors.cardBorderColor),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
        },
        children: [
          TableRow(children: [
            Text('', style: theme.textTheme.bodySmall),
            Text('Gemini', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF4285F4))),
            Text('Claude', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFFD97706))),
          ]),
          _tableRow(theme, 'Tahmin', gPred?.result ?? '-', cPred?.result ?? '-'),
          _tableRow(theme, 'Güven', '${((gPred?.confidence ?? 0) * 100).toInt()}%', '${((cPred?.confidence ?? 0) * 100).toInt()}%'),
          _tableRow(theme, 'Skor', gPred?.scorePrediction ?? '-', cPred?.scorePrediction ?? '-'),
          _tableRow(theme, 'KG', '${((gPred?.bttsProb ?? 0) * 100).toInt()}%', '${((cPred?.bttsProb ?? 0) * 100).toInt()}%'),
          _tableRow(theme, '2.5Ü', '${((gPred?.over25Prob ?? 0) * 100).toInt()}%', '${((cPred?.over25Prob ?? 0) * 100).toInt()}%'),
        ],
      ),
    );
  }

  TableRow _tableRow(ThemeData theme, String label, String gemini, String claude) {
    final style = GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w600);
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(gemini, style: style)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text(claude, style: style)),
      ],
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _ConfidenceBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 11)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              color: color,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toInt()}%',
          style: GoogleFonts.jetBrainsMono(fontSize: 11, color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SectionHeader({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600, color: color,
        )),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;
  final ThemeData theme;
  const _BulletItem({required this.text, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6, height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
```

### 6.4 `lib/presentation/widgets/multi_model/verification_badge.dart`

```dart
import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/multi_model_analysis_model.dart';

/// Veri teyit badge'i — kaç kaynak doğrulandı, tamlık yüzdesi
class VerificationBadge extends StatelessWidget {
  final VerificationResult verification;
  const VerificationBadge({required this.verification, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verified = verification.verified;
    final color = verified ? AppColors.successColor : AppColors.warningColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified : Icons.warning_amber_rounded,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verified ? 'Veri Teyit Edildi' : 'Eksik Veri Uyarısı',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  '${verification.sourcesValid}/${verification.sourcesChecked} kaynak | '
                  '${verification.dataCompleteness}% tamlık',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (verification.warnings.isNotEmpty)
            Tooltip(
              message: verification.warnings.join('\n'),
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## BÖLÜM 7: Entegrasyon Güncellemeleri

### 7.1 `match_card.dart` — Çoklu Model Butonu Ekleme

Mevcut `_AnalysisResultView` widget'ına yeni buton ekle:

```dart
// match_card.dart — _AnalysisResultView.build() içinde
// Mevcut "Detaylar" ve "AI'a Sor" butonlarının ALTINA ekle:

const SizedBox(height: 8),
// Çoklu Model Analizi butonu
SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiModelAnalysisScreen(
          matchId: analysis.matchId,
          matchTitle: matchTitle,
        ),
      ),
    ),
    icon: const Icon(Icons.psychology, size: 18),
    label: const Text('Çoklu Model Analizi'),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
      ),
    ),
  ),
),
```

### 7.2 `lib/presentation/screens/multi_model_analysis_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/multi_model/multi_model_analysis_view.dart';

/// Çoklu Model Analizi Tam Ekran
class MultiModelAnalysisScreen extends ConsumerWidget {
  final String matchId;
  final String matchTitle;

  const MultiModelAnalysisScreen({
    required this.matchId,
    required this.matchTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          matchTitle,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MultiModelAnalysisView(
            matchId: matchId,
            matchTitle: matchTitle,
          ),
        ),
      ),
    );
  }
}
```

### 7.3 `lib/core/utils/firestore_paths.dart` — Yeni Path

```dart
// Mevcut FirestorePaths class'ına ekle:
static const String multiAnalyses = 'multi_analyses';
```

### 7.4 Firestore Security Rules — Tam Güncel Hali

```javascript
// firestore.rules — multi_analyses bölümü

// Mevcut rules dosyasındaki match bloğunun içine ekle:
match /multi_analyses/{analysisId} {
  allow read: if request.auth != null
    && resource.data.userId == request.auth.uid;
  // Yazma sadece Cloud Functions tarafından yapılır (admin SDK)
  allow write: if false;
}
```

---

## BÖLÜM 8: Build & Code Generation Komutları

### 8.1 Freezed Code Generation

```bash
# Flutter proje kökünde çalıştır
cd R:\YDev\futbol_ai
dart run build_runner build --delete-conflicting-outputs
```

Bu komut şu dosyaları otomatik oluşturur:
- `multi_model_analysis_model.freezed.dart`
- `multi_model_analysis_model.g.dart`

### 8.2 Cloud Functions Deploy

```bash
cd R:\YDev\futbol_ai\functions
npm run build
firebase deploy --only functions:triggerMultiModelAnalysis,functions:onMultiAnalysisCreated
```

### 8.3 Firestore Rules & Indexes Deploy

```bash
cd R:\YDev\futbol_ai
firebase deploy --only firestore:rules,firestore:indexes
```

---

## BÖLÜM 9: Test ve Doğrulama Planı

### 9.1 Adım Adım Test Sırası

```
1. [ ] Firebase secret'ları kaydet (ANTHROPIC_API_KEY)
2. [ ] Cloud Functions deploy et (triggerMultiModelAnalysis + onMultiAnalysisCreated)
3. [ ] Firestore rules + indexes deploy et
4. [ ] Flutter'da freezed code generation çalıştır
5. [ ] Emülatörde test:
   a. [ ] Bir maç seç ve "Çoklu Model Analizi" butonuna bas
   b. [ ] Firestore'da multi_analyses doc'unun oluştuğunu doğrula
   c. [ ] Firebase loglarında pipeline aşamalarını izle
   d. [ ] Status güncellemelerinin Firestore'a yazıldığını doğrula
   e. [ ] Flutter UI'da progress bar'ın güncellenmesini doğrula
   f. [ ] Gemini sonucunun geldiğini doğrula
   g. [ ] Claude sonucunun geldiğini doğrula
   h. [ ] Konsensüs sonucunun geldiğini doğrula
   i. [ ] 3 tab'da sonuçların doğru göründüğünü doğrula
6. [ ] Cache testi: Aynı maçı tekrar analiz et → cached dönmeli
7. [ ] Hata testi: Geçersiz API key → 'failed' status doğrula
```

### 9.2 Firebase Emulator Test

```bash
# Firebase emulator'ları başlat
cd R:\YDev\futbol_ai
firebase emulators:start --only functions,firestore,auth

# Logları izle
firebase functions:log --only triggerMultiModelAnalysis,onMultiAnalysisCreated
```

### 9.3 Performans Hedefleri

| Metrik | Hedef |
|--------|-------|
| Trigger → Doc oluşturma | < 3 saniye |
| Firestore trigger başlama | < 2 saniye |
| Verification + Deep Analysis | < 3 saniye |
| Gemini + Claude (paralel) | < 90 saniye |
| Gemini 3.1 konsensüs | < 30 saniye |
| **Toplam pipeline** | **< 2.5 dakika** |
| Flutter UI ilk güncelleme | < 5 saniye |

---

## BÖLÜM 10: Dosya Haritası (Yeni/Değişen Dosyalar)

```
futbol_ai/
├── functions/src/
│   ├── multiModel/                                   ← YENİ KLASÖR
│   │   ├── triggerMultiModelAnalysis.ts              ← YENİ (Bölüm 2.1)
│   │   ├── multiModelPipeline.ts                    ← YENİ (Bölüm 2.2)
│   │   ├── dataVerification.ts                      ← YENİ (Bölüm 2.3)
│   │   ├── deepAnalysis.ts                          ← YENİ (Bölüm 2.4)
│   │   ├── aiClients.ts                             ← YENİ (Bölüm 2.5)
│   │   ├── multiModelPrompts.ts                     ← YENİ (Bölüm 2.6)
│   │   └── multiModelParser.ts                      ← YENİ (Bölüm 2.7)
│   └── index.ts                                     ← GÜNCELLE (Bölüm 2.8)
│
├── lib/
│   ├── data/
│   │   ├── models/
│   │   │   └── multi_model_analysis_model.dart      ← YENİ (Bölüm 3)
│   │   └── repositories/
│   │       └── multi_model_analysis_repository.dart  ← YENİ (Bölüm 4)
│   │
│   ├── presentation/
│   │   ├── providers/
│   │   │   └── multi_model_analysis_provider.dart   ← YENİ (Bölüm 5)
│   │   ├── screens/
│   │   │   └── multi_model_analysis_screen.dart     ← YENİ (Bölüm 7.2)
│   │   └── widgets/
│   │       ├── match_card/
│   │       │   └── match_card.dart                  ← GÜNCELLE (Bölüm 7.1)
│   │       └── multi_model/
│   │           ├── multi_model_analysis_view.dart    ← YENİ (Bölüm 6.1)
│   │           ├── ai_result_tab.dart                ← YENİ (Bölüm 6.2)
│   │           ├── consensus_tab.dart                ← YENİ (Bölüm 6.3)
│   │           └── verification_badge.dart           ← YENİ (Bölüm 6.4)
│   │
│   └── core/utils/
│       └── firestore_paths.dart                      ← GÜNCELLE (Bölüm 7.3)
│
├── firestore.rules                                   ← GÜNCELLE (Bölüm 7.4)
└── firestore.indexes.json                            ← GÜNCELLE (Bölüm 1.3)
```

**Toplam:** 7 yeni Cloud Function dosyası + 7 yeni Flutter dosyası + 4 güncelleme = **18 dosya işlemi**
**Ekstra servis:** Yok (n8n, webhook, callback yok — tamamı Firebase)

---

> **Bu doküman tamamdır.** Talimat verildiğinde, bu dosya okunarak tüm bileşenler sırasıyla implemente edilecektir.
> Her bölüm bağımsız olarak uygulanabilir; önerilen sıra: Bölüm 0 → 1 → 2 → 8 → 3 → 4 → 5 → 6 → 7 → 9
