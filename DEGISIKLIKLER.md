# FutbolAI - Kapsamli Analiz ve Duzeltme Raporu

> Tarih: 2026-02-25
> Analiz Eden: Claude Opus 4.6

---

## OZET

Uygulamanin tum kaynak kodlari, Android konfigurasyonu, API baglantilari, Gemini prompt'lari ve SPEC.md uyumlulugu detayli olarak analiz edildi. Asagida bulunan sorunlar ve yapilan duzeltmeler listelenmistir.

---

## KRITIK SORUNLAR VE DUZELTMELER

### 1. Android: INTERNET Permission Eksik (AndroidManifest.xml)
**Dosya:** `android/app/src/main/AndroidManifest.xml`
**Sorun:** Main manifest'te `INTERNET` ve `ACCESS_NETWORK_STATE` izinleri tanimli degildi. Debug/profile manifest'lerde vardi ama release build'de internet erisimi olmadan uygulama calismaz.
**Duzeltme:**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 2. Android: minSdk Cok Dusuk (build.gradle.kts)
**Dosya:** `android/app/build.gradle.kts`
**Sorun:** `minSdk = flutter.minSdkVersion` (varsayilan 21) kullaniliyordu. Firebase Auth ve Firestore **minSdk 23** gerektiriyor.
**Duzeltme:**
```kotlin
minSdk = 23
multiDexEnabled = true
```

### 3. Android: Uygulama Adi Yanlis (AndroidManifest.xml)
**Dosya:** `android/app/src/main/AndroidManifest.xml`
**Sorun:** `android:label="futbol_ai"` — kullaniciya gorunen ad teknik isimdi.
**Duzeltme:** `android:label="FutbolAI"`

---

## API BAGLANTI VE PROMPT DUZELTMELERI

### 4. Gemini Model Adi Guncellendi (gemini_datasource.dart)
**Dosya:** `lib/data/datasources/gemini_datasource.dart`
**Sorun:** `gemini-2.5-pro-preview-05-06` modeli kullaniliyordu — bu model agir, yavas ve pahaliydi.
**Duzeltme:** `gemini-2.5-flash-preview-04-17` — daha hizli, mobil uygulamalar icin daha uygun.

### 5. Gemini Prompt SPEC.md ile Uyumsuzdu (gemini_datasource.dart)
**Dosya:** `lib/data/datasources/gemini_datasource.dart`
**Sorun:** Mevcut prompt SPEC.md Bolum 6.1'deki tam prompt'a kiyasla cok kisaydı. Eksikler:
- `dataIntelligence` JSON cikti yapisi istenmiyordu (UI bos kaliyordu)
- Veri toplama talimatlari yoktu (72 veri noktasi)
- Veto kurallari detaysizdi
- Agirlikli puan hesaplama formulu yoktu
- Ek analiz alanlari (xgAnalysis, fixtureAnalysis, injuryReport vb.) JSON'da yoktu

**Duzeltme:** Prompt tamamen yeniden yazildi:
- 22 zorunlu + 6 istatistiksel veri noktasi talimatı eklendi
- 8 kategori detayli aciklamalariyla eklendi
- 9 veto kurali tam listesi eklendi
- `dataIntelligence` tam JSON sema ciktisi eklendi (weather, injuries, referee, restDays, xgData, headToHead, stadiumInfo, fixtureContext)
- `xgAnalysis`, `fixtureAnalysis`, `injuryReport`, `setPieceBreakdown`, `refereeImpact` alanlari eklendi
- Agirlikli puan formulu ve guvenilirlik siniflandirmasi eklendi

### 6. Chat System Context Eksikti (gemini_datasource.dart)
**Dosya:** `lib/data/datasources/gemini_datasource.dart`
**Sorun:** `sendChatMessage()` metodu hicbir sistem baglami gondermiyordu — AI hangi mac hakkinda soru soruldugunu bilmiyordu.
**Duzeltme:**
- `matchData` parametresi eklendi
- `_buildChatSystemContext()` metodu eklendi — mac bilgisini, rolleri ve kurallari tanimlayan sistem mesaji olusturuyor
- Chat baslangicinda sistem mesaji + model yaniti ekleniyor

---

## VERI KALICILIGI DUZELTMELERI

### 7. Chat Mesajlari Firestore'a Kaydedilmiyordu (chat_repository.dart)
**Dosya:** `lib/data/repositories/chat_repository.dart`
**Sorun:** `sendMessage()` sadece Gemini API'ye istek gonderiyordu ama kullanici mesajini ve AI yanitini Firestore'a **HIC KAYDETMIYORDU**.
- `streamMessages()` Firestore'u dinliyordu ama yazma olmadigi icin UI hep bostu
- Mesaj gecmisi oturumlar arasi kayboluyordu
- Rate limiting calismamiyor du (count hep 0 donuyordu)

**Duzeltme:**
- Kullanici mesaji Firestore'a `_messagesRef(matchId).add({...})` ile kaydediliyor
- Mac verisi Firestore'dan cekilerek chat baglamina ekleniyor
- AI yaniti da Firestore'a kaydediliyor
- Token count tahmini eklendi
- Null userId kontrolu eklendi

### 8. Analiz Sonuclari Firestore'a Cache'lenmiyordu (analysis_repository.dart)
**Dosya:** `lib/data/repositories/analysis_repository.dart`
**Sorun:** `getOrRequestAnalysis()` cache kontrolu yapiyordu ama **sonucu asla Firestore'a yazmiyordu** — cache her zaman miss veriyordu, her seferinde yeni API cagrisi yapiliyordu.

**Duzeltme:**
- `_saveAnalysisToFirestore()` metodu eklendi — analiz sonucunu tam sema ile Firestore'a kaydediyor
- Doc ID: `{matchId}_{userId}` formatiyla hizli erisim
- 24 saatlik expire suresi eklendi
- Cache okumada once docId ile direkt erisim, sonra query ile fallback
- Expire kontrolu eklendi

---

## HATA YAKALAMA VE STABILITE

### 9. Firebase Crashlytics ve Analytics Baslatilmamisti (main.dart)
**Dosya:** `lib/main.dart`
**Sorun:** Crashlytics paketiistenmis ama `main()` icinde baslatilmamisti — hicbir crash raporlanmiyordu.
**Duzeltme:**
```dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};
```
- `runZonedGuarded` ile tum asenkron hatalar da yakalaniyor
- `dart:ui` import eklendi

### 10. RateLimitException Cift Tanim (gemini_datasource.dart + exceptions.dart)
**Dosya:** `lib/data/datasources/gemini_datasource.dart` ve `lib/core/errors/exceptions.dart`
**Sorun:** `RateLimitException` sinifi iki yerde tanimliydi — compile hatasi verebilirdi.
**Duzeltme:**
- `gemini_datasource.dart`'taki tanim kaldirildi
- `exceptions.dart`'a `AnalysisTimeoutException` sinifi eklendi
- Tek kaynak (single source of truth) saglandi

---

## NAVIGASYON DUZELTMELERI

### 11. Settings Navigasyonu Yanlis (home_screen.dart)
**Dosya:** `lib/presentation/screens/home_screen.dart`
**Sorun:** `context.push('/settings')` kullaniliyordu — bu settings'i bottom nav'in ustuune tam sayfa olarak aciyordu.
**Duzeltme:** `context.go('/settings')` — bottom nav icinde dogru tab'a geciyor.

---

## PERFORMANS DUZELTMELERI

### 12. Duplicate GeminiDatasource Instance'lari (chat_provider.dart)
**Dosya:** `lib/presentation/providers/chat_provider.dart`
**Sorun:** `_datasourceProvider` olarak ayri bir `GeminiDatasource()` instance'i olusturuluyordu — `analysis_provider.dart`'taki ile ayni seyi yapan ikinci bir instance.
**Duzeltme:** Gereksiz `_datasourceProvider` kaldirildi, `analysis_provider.dart`'taki `geminiDatasourceProvider` yeniden kullaniliyor.

### 13. Gereksiz `http` Paketi Kaldirildi (pubspec.yaml)
**Dosya:** `pubspec.yaml`
**Sorun:** `http: ^1.3.0` paketi tanimli ama hicbir yerde kullanilmiyordu.
**Duzeltme:** Kaldirildi — gereksiz dependency azaltildi.

---

## GUVENLIK NOTU

### 14. API Key Client-Side (gemini_datasource.dart)
**Dosya:** `lib/data/datasources/gemini_datasource.dart`
**Durum:** Gemini API key hala Dart kodunda hardcoded.
**SPEC.md Bolum 3.1** diyor ki: "API key ASLA client'ta olmayacak — Firebase Cloud Function proxy"
**Onerilen Aksiyon:** Firebase Cloud Functions `defineSecret()` ile tasiniilmasi gerekiyor. Bu degisiklik sunucu tarafi deploy gerektirdigi icin client-side duzeltme olarak yapilamadi. TODO yorumu eklendi.

---

## DUZELTILMIS DOSYALAR LISTESI

| # | Dosya | Degisiklik Turu |
|---|-------|----------------|
| 1 | `android/app/src/main/AndroidManifest.xml` | Internet izinleri + uygulama adi |
| 2 | `android/app/build.gradle.kts` | minSdk 23 + multidex |
| 3 | `lib/main.dart` | Crashlytics init + zone guarded |
| 4 | `lib/data/datasources/gemini_datasource.dart` | Model adi + prompt + chat context + duplicate class fix |
| 5 | `lib/data/repositories/analysis_repository.dart` | Firestore cache write-back + expire + direkt doc erisim |
| 6 | `lib/data/repositories/chat_repository.dart` | Firestore mesaj kaydi + mac baglami + null kontrol |
| 7 | `lib/presentation/providers/chat_provider.dart` | Tek datasource instance kullanimi |
| 8 | `lib/presentation/screens/home_screen.dart` | push → go navigasyon duzeltmesi |
| 9 | `lib/core/errors/exceptions.dart` | AnalysisTimeoutException eklendi |
| 10 | `pubspec.yaml` | Gereksiz http paketi kaldirildi |

---

## MEVCUT YAPISAL SORUNLAR (DUZELTME GEREKTIRMEYEN)

1. **`google-services.json` yok** — firebase_options.dart manual yaklasimi ile sorun degil
2. **ScreenUtil kullanilmiyor** — pubspec'te var ama kodda kullanilmiyor, zararsiz
3. **`lottie` paketi kullanilmiyor** — ileride animasyon eklenmesi icin hazir
4. **Shorebird** — sadece release build'lerde aktif, development'ta sorun yok
5. **Freezed generated files** — mevcut .freezed.dart ve .g.dart dosyalari guncel gorunuyor

---

## SONRAKI ADIMLAR (ONERILER)

1. **Firebase Cloud Functions deploy** — Gemini API key'i sunucu tarafina tasimak icin
2. **Firestore Security Rules deploy** — SPEC.md Bolum 3.2'deki kurallarin Firebase'e yuklenmesi
3. **Firestore Indexes deploy** — SPEC.md Bolum 4.2'deki index tanimlarinin yuklenmesi
4. **`flutter pub get`** ardindan **`dart run build_runner build`** — freezed/json_serializable kodlarinin guncellenmesi
5. **`flutter analyze`** — linting kontrolu
6. **Android test build** — `flutter build apk --debug` ile test
