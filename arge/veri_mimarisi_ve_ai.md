# Futbol AI: Veri Mimarisi ve Yapay Zeka Entegrasyon Raporu

Bu belge, Futbol AI projesinin mevcut veri havuzunu, yapay zekaya veri aktarım formatını, sorgu (prompt) yapısını ve programın genel hedeflerini detaylandırmaktadır.

## 1. Programın Amacı ve Hedefi
Futbol AI, web scraping (veri kazıma) botları ile farklı kaynaklardan toplanan devasa futbol verilerini tek bir merkezde birleştiren ve bu verileri gelişmiş Yapay Zeka modellerine (şu anda Gemini 3.1 Pro) analiz ettirerek yüksek doğruluk oranına sahip, çok boyutlu maç tahminleri ve analiz raporları üreten akıllı bir analiz platformudur.

Amacı sadece "kim kazanır" tahmini yapmak değil; taktiksel, istatistiksel, psikolojik, hakem ve dış faktörler gibi 8 farklı kategoride (Ağırlıklı Puanlama Sistemi) maçı mikroskobik düzeyde incelemek ve kullanıcıya yapılandırılmış, okunabilir bir içgörü sunmaktır.

## 2. Veri Havuzu (Data Pool) Mimarisi
Projemizin veri havuzu Firestore üzerinde 12 ana koleksiyona ayrılmıştır. Veriler ağırlıklı olarak 3 ana bottan (FBref, SofaScore, Transfermarkt) toplanır ve `veri_butunlugu` (dataCompleteness) skoruyla harmanlanır.

### Kaydedilen Tüm Veriler (Kalem Kalem):
1. **matches (Maçlar - Ana Koleksiyon)**
   - **Genel:** Tarih, lig, stadyum, ev sahibi/deplasman takımı.
   - **Canlı Veriler:** Skor, dakika, anlık bahis oranları (SofaScore).
   - **İstatistikler (FBref/Understat):** xG (Beklenen gol), xGA, topla oynama, pas yüzdeleri, şut haritaları.
   - **Dış Faktörler:** Hava durumu (sıcaklık, nem, rüzgar).
2. **teams (Takımlar)**
   - Kadro bilgileri, sakatlıklar (Transfermarkt), menajer geçmişi, piyasa değerleri, son 5 maçlık form durumu, stadyum kapasitesi/zemin türü.
3. **players (Oyuncular)**
   - Kariyer geçmişi, performans yüzdelikleri (scouting percentiles), sakatlık geçmişi.
4. **managers (Teknik Direktörler)**
   - Tercih edilen diziliş, galibiyet yüzdeleri, kariyer geçmişi.
5. **referees (Hakemler)**
   - Maç başına faul ortalaması, gösterilen sarı/kırmızı kart ortalamaları, penaltı çalma yüzdesi.
6. **leagues & seasonStats (Ligler ve Sezon İstatistikleri)**
   - Lig puan durumları, gol krallığı, asist krallığı.
7. **news (Haberler)**
   - Sakatlık/transfer söylentileri, FBref/Transfermarkt maç önü raporları.
8. **live & scrapeHistory (Canlı Olaylar ve Sistem Logları)**
   - Anlık maç olayları (gol, kart vb.) ve kazıma botlarının çalışma performansı.

## 3. Yapay Zekaya Veri Gönderim Formatı
Maç analizi tetiklendiğinde (Cloud Function: `analyzeMatch.ts`), ham veriler birleştirilir ve **JSON string (metin)** formatına çevrilerek yapay zekaya (Gemini) tek bir devasa prompt içinde gönderilir.

- **Bağlantı Şekli:** REST API üzerinden doğrudan Google GenAI endpoint'ine `v1beta/models/gemini-3.1-pro-preview:generateContent` isteği atılır.
- **Parametreler:** 
  - `temperature: 0.7` (Kararında yaratıcılık)
  - `responseMimeType: 'application/json'` (Yapay zekanın *sadece ve sadece* JSON döndürmesini zorunlu kılarız)
- **Veri Tipi:** Toplanan tüm offline veriler (weather, fbref, sofascore, understat) `JSON.stringify` ile tek bir blok haline getirilip prompt metninin `ÇEVRİMDIŞI VERİ SETİ` bölümüne yerleştirilir.

## 4. Sorgu (Prompt) Yapısı ve Kuralları
Model'e gönderilen sistem promptu (`analysisPrompt.ts`) çok katı kurallara sahip bir "Ajan Pesonası" tanımlar.

- **Persona:** 15 yıllık profesyonel elit futbol analisti ve veri bilimcisi.
- **Kategori Ağırlıklandırması:** Yapay zekaya maçı 8 boyutta incelemesi emredilir:
  1. Güç Analizi (%20)
  2. Taktik Analizi (%20)
  3. Psikoloji Analizi (%18)
  4. Fiziksel ve Fikstür (%10)
  5. Dış Faktörler (%10)
  6. Hakem Analizi (%8)
  7. Duran Toplar (%7)
  8. Piyasa Analizi (%7)
- **Veto Kuralları:** Modele "Eğer x olursa, y puanını kır" gibi kesin talimatlar verilir (Örn: Yıldız oyuncu yoksa Güçten -1.5 kır. Avrupa yorgunluğu varsa Fizikselden -1.5 kır).
- **Format:** İşlem sonucunda model, Flutter uygulamamızın `AnalysisModel` mimarisiyle birebir eşleşen devasa bir JSON objesi üretir. Analiz Kategorileri, Beklenen Gol (xG) Raporu, Sakatlık Raporu, Hakem Etkisi vb. kısımlar ayrı property'ler olarak döner. Bu sayede üretilen analiz hiçbir parse (ayrıştırma) hatası olmadan doğrudan uygulamada UI'a aktarılır.

---

## 5. Çoklu Ajan (Ensemble Learning) Fikri İçin Mega Prompt
Sistemi tek bir yapay zekadan çıkarıp, 3 farklı yapay zekaya (İstatistikçi, Taktisyen, Psikolog/Haberci) bölüp, sonunda bir Mega AI'a (Karar Mercii) sentezletme fikrini diğer yapay zekalara (ChatGPT, Claude vb.) tartışmak ve mimariyi onlara tasarlatmak için aşağıdaki promptu kopyalayıp onlara yapıştırabilirsiniz:

***

**KOPYALANACAK PROMPT BAŞLANGICI**
```text
Selam. Firestore üzerinde 12 farklı koleksiyondan (matches, teams, players, injuries, weather, referees vs.) oluşan ve 3 farklı scraping botuyla (FBref, SofaScore, Transfermarkt) beslenen devasa bir "Futbol Veri Havuzum" (Futbol AI) var. Elimde xG, topla oynama, ısı haritaları, hakem kart ortalamaları, hava durumu, takımın yorgunluk durumu (fikstür), sakatlıklar gibi her türlü ince detay mevcut. 

Şu anda sadece Google Gemini 3.1 Pro'ya tüm veriyi tek bir dev JSON olarak atıp "Sen elit bir analistsin, bana 8 kategoride (Taktik, Psikoloji, Güç vb.) maçın analizini çıkar ve JSON dön" diyorum. 

Ancak ben sistemi "Ensemble Learning (Çoklu Ajan / Topluluk Öğrenimi)" mimarisine çevirmek istiyorum:
1. Ajan (Gemini): Sadece pür matematik, xG, xGA, H2H, ve sayısal verilere bakacak "Sayısal Veri Analisti".
2. Ajan (Claude 3.5 Sonnet): Sadece dizilişler, taktikler, oyun kurulumu ve pres (PPDA) verisine bakacak "Taktik ve Sistem Uzmanı".
3. Ajan (GPT-4o): Sadece sakatlıklar, hava durumu, derbi psikolojisi, fikstür yorgunluğu ve hakem istatistiklerine bakacak "Psikolog / Saha Dışı Uzmanı".
4. MEGA AJAN (Karar Mercii): Bu ilk 3 ajanın ürettiği JSON formatındaki "Alt Raporları" okuyacak, çelişkileri giderecek ve bana tek bir nihai tahmin, güven skoru ve özet analiz çıkaracak.

Bu mimariyi (Firebase Cloud Functions üzerinde, Typescript ile) en optimize şekilde nasıl kurarım? Promise.all() kullanarak API maliyetlerini ve bekleme süresini (latency) nasıl yönetmeliyim? LLM'lerin "halüsinasyon" görmemesi için her bir ajana veriyi filtreleyip (payload'u küçültüp) nasıl vermeliyim? Bana bu yeni çoklu-ajan sisteminin kod mimarisini ve sistem akışını tasarlar mısın?
```
**KOPYALANACAK PROMPT BİTİŞİ**
