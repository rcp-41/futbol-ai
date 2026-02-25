import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Gemini API datasource — google_generative_ai paket kullanımı
/// NOT: Produksiyonda API key Firebase Cloud Function proxy arkasina alinmalidir (SPEC.md Bolum 3.1)
class GeminiDatasource {
  // TODO: Produksiyonda bu key Firebase Cloud Functions defineSecret() ile tasinmali
  static const _apiKey = 'AIzaSyAzs3FaIZNIPiRF1tCKJhLpCoHzzG74_Os';
  static const _modelName = 'gemini-2.0-flash';

  late final GenerativeModel _model;
  late final GenerativeModel _chatModel;

  GeminiDatasource() {
    _model = GenerativeModel(
      model: _modelName,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topP: 0.9,
        topK: 40,
        maxOutputTokens: 8192,
        responseMimeType: 'application/json',
      ),
    );
    _chatModel = GenerativeModel(
      model: _modelName,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.8,
        maxOutputTokens: 2048,
      ),
    );
  }

  /// Mac analizi iste
  Future<Map<String, dynamic>> requestAnalysis(String matchId) async {
    // Firestore'dan mac verisini al (matches veya sportoto_matches)
    final db = FirebaseFirestore.instance;
    DocumentSnapshot? doc;

    final matchDoc = await db.collection('matches').doc(matchId).get();
    if (matchDoc.exists) {
      doc = matchDoc;
    } else {
      final sportotoDoc =
          await db.collection('sportoto_matches').doc(matchId).get();
      if (sportotoDoc.exists) doc = sportotoDoc;
    }

    if (doc == null || !doc.exists) {
      throw Exception('Mac bulunamadi.');
    }

    final matchData = doc.data() as Map<String, dynamic>;
    final prompt = _buildAnalysisPrompt(matchData);

    // Gemini API cagrisi — 90 saniye timeout
    final response = await _model
        .generateContent([Content.text(prompt)])
        .timeout(
          const Duration(seconds: 90),
          onTimeout: () => throw Exception('Analiz zaman asimina ugradi (90s). Tekrar deneyin.'),
        );
    final rawText = response.text ?? '';

    if (rawText.isEmpty) {
      throw Exception('Gemini bos yanit dondu.');
    }

    debugPrint('Gemini yanit uzunlugu: ${rawText.length} karakter');

    // JSON parse
    try {
      final cleaned =
          rawText.replaceAll('```json', '').replaceAll('```', '').trim();
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('JSON parse hatasi: $e');
      return {
        'prediction': {
          'result': '?',
          'resultLabel': 'Analiz tamamlandi',
          'confidence': 0.5,
          'surpriseAlert': false,
          'bankoLevel': 'RISKLI',
          'mainReason': 'JSON ayristirma hatasi — ham analiz mevcut',
        },
        'detailedNarrative': rawText,
        'rawGeminiResponse': rawText,
      };
    }
  }

  /// AI chat mesaji gonder — mac baglami ile
  Future<String> sendChatMessage({
    required String matchId,
    required String message,
    List<Map<String, String>>? history,
    Map<String, dynamic>? matchData,
  }) async {
    // Sistem konteksti olustur
    final systemContext = matchData != null
        ? _buildChatSystemContext(matchData)
        : 'Sen bir futbol analiz asistanisin. Turkce yanit ver.';

    final chatHistory = <Content>[];

    // Sistem mesajini ilk user mesaji olarak ekle
    chatHistory.add(Content('user', [TextPart(systemContext)]));
    chatHistory.add(Content('model', [
      TextPart(
          'Anlasildim. Bu mac hakkinda sorularinizi yanitmaya hazirim. Turkce yanit verecegim.')
    ]));

    // Onceki mesajlari ekle
    if (history != null) {
      for (final msg in history) {
        final role = msg['role'] == 'user' ? 'user' : 'model';
        chatHistory.add(Content(role, [TextPart(msg['content'] ?? '')]));
      }
    }

    final chat = _chatModel.startChat(history: chatHistory);
    final response = await chat.sendMessage(Content.text(message));
    return response.text ?? 'Yanit alinamadi.';
  }

  /// Chat icin mac baglami
  String _buildChatSystemContext(Map<String, dynamic> matchData) {
    final homeTeam = matchData['homeTeam']?['name'] ?? 'Ev Sahibi';
    final awayTeam = matchData['awayTeam']?['name'] ?? 'Deplasman';
    final league = matchData['league'] ?? '';

    return '''Sen elit bir futbol analiz asistanisin. Kullanici asagidaki mac hakkinda soru soruyor:

Mac: $homeTeam vs $awayTeam ($league)

Kurallar:
- Turkce yanit ver
- Kisa ve oz yanit ver (2-3 paragraf maksimum)
- Istatistik ve veri odakli ol
- Bilmedigin bir seyi UYDURMA, "bu veri elimde yok" de
- Futbol disinda bir soru gelirse kibar bir sekilde reddet''';
  }

  /// SPEC.md Bolum 6.1 tam system prompt — 72 veri noktali analiz
  String _buildAnalysisPrompt(Map<String, dynamic> matchData) {
    final homeTeam = matchData['homeTeam']?['name'] ?? 'Ev Sahibi';
    final awayTeam = matchData['awayTeam']?['name'] ?? 'Deplasman';
    final league = matchData['league'] ?? 'Bilinmiyor';
    final leagueCountry = matchData['leagueCountry'] ?? '';
    final week = matchData['week'] ?? '';
    final stadium = matchData['stadium'] ?? 'Bilinmiyor';
    final homeOdds = matchData['odds']?['home'] ?? '-';
    final drawOdds = matchData['odds']?['draw'] ?? '-';
    final awayOdds = matchData['odds']?['away'] ?? '-';
    final importance = matchData['importance'] ?? 'normal';
    final homeForm = matchData['homeTeam']?['formLast5'] ?? '';
    final awayForm = matchData['awayTeam']?['formLast5'] ?? '';

    String matchDate = '';
    final md = matchData['matchDate'];
    if (md is Timestamp) {
      matchDate = md.toDate().toIso8601String();
    } else if (md is String) {
      matchDate = md;
    }

    return '''SEN: Elit seviyede bir futbol analisti ve veri bilimcisisin. 15 yillik profesyonel futbol analiz deneyimine sahipsin. Hem istatistiksel hem taktiksel derinlige hakimsin.

GOREV: Asagidaki futbol macini 8 ana kategoride, toplamda 72 veri noktasini degerlendirerek analiz et ve bir tahmin uret.

═══════════════════════════════════════
MAC BILGISI:
═══════════════════════════════════════
- Ev Sahibi: $homeTeam
- Deplasman: $awayTeam
- Lig: $league ($leagueCountry)
- Tarih/Saat: $matchDate
- Hafta: $week
- Stadyum: $stadium
- Bahis Oranlari: 1=$homeOdds / X=$drawOdds / 2=$awayOdds
- Onem: $importance (normal/derbi/sampiyonluk/kume dusme)
- Ev Sahibi Son 5: $homeForm
- Deplasman Son 5: $awayForm

═══════════════════════════════════════
VERI TOPLAMA TALIMATLARI:
═══════════════════════════════════════

Bildigin guncel verileri kullanarak asagidaki veri noktalarini degerlendir. Bilmedigin verileri UYDURMA — "veri bulunamadi" yaz.

ZORUNLU VERILER:
1. Her iki takimin guncel sakatlık listesi
2. Cezali oyuncular
3. Kilit eksikler kombinasyon analizi
4. Teknik direktorlerin gorev suresi
5. Hakem ve VAR hakemi + sezon istatistikleri
6. Mac gunu hava durumu tahmini
7. Stadyum zemin tipi, rakimi, saha olculeri
8. Son mactan bu yana gecen dinlenme suresi
9. Avrupa kupasi donusu mu?
10. Hedef Mac Sendromu (sonraki 7 gunde kritik mac var mi?)
11. xG ve xGA verileri
12. PPDA degerleri
13. Son maclardaki dizilisler
14. Intikam Maci (eski takimina karsi oynayan var mi?)
15. Transfer soylentilerindeki oyuncular
16. Kaptanin sahada olup olmadigi

ISTATISTIKSEL VERILER:
17. Kaleci PSxG kurtaris verimi
18. Kose vurusu ve duran top gol yuzdeleri
19. Comeback skoru (maglup durumda gol atma yüzdesi)
20. Mac kapatma basarisi
21. Hava topu kazanma oranlari
22. Progresif pas ve top tasima istatistikleri

═══════════════════════════════════════
ANALIZ KATEGORILERI VE AGIRLIKLARI (8 KATEGORI):
═══════════════════════════════════════

A) GUC ANALIZI (Agirlik: %20) — Kadro kalitesi, sakatlıklar, kaleci, hava topu, rotasyon
B) TAKTIK ANALIZ (Agirlik: %20) — Hoca profili, dizilis, PPDA, topla oynama, stil uyumu
C) PSIKOLOJI ANALIZI (Agirlik: %18) — Form, moral, derbi, baskı, comeback, hedef mac sendromu
D) DIS FAKTORLER (Agirlik: %10) — Ev sahibi avantaji, hava, stadyum, seyahat, zemin
E) PIYASA ANALIZI (Agirlik: %7) — Bahis oran degisimleri, para akisi
F) HAKEM ANALIZI (Agirlik: %8) — Faul esigi, kart, penalti, VAR egilimi
G) DURAN TOP ANALIZI (Agirlik: %7) — Kose, serbest vurus, penalti egilimi
H) FIZIKSEL & FIKSTUR (Agirlik: %10) — Dinlenme, Avrupa yorgunlugu, sezon evresi

Her kategori icin her iki takima 1-10 arasi puan ver.

═══════════════════════════════════════
VETO KURALLARI:
═══════════════════════════════════════
1. YILDIZ EKSIKLIGI: Kritik oyuncu eksikse → GUC -1.5
2. KRITIK IKILI EKSIKLIGI: Uyumlu ikili birlikte eksikse → GUC -2.0
3. AVRUPA YORGUNLUGU: Son 72 saatte Avrupa maci → FIZIKSEL -1.5
4. KOTU SERI: Son 4+ macta galibiyetsiz → PSIKOLOJI -1.0
5. YENI HOCA: Son 6 macta goreve geldiyse → PSIKOLOJI +1.0
6. KOVULMA BASKISI: Guclu kovulma soylentileri → PSIKOLOJI -1.0
7. DERBI FAKTORU: Derbi ise → favori guven %10 azalt
8. HEDEF MAC TUZAGI: 3-4 gun sonra kritik mac → PSIKOLOJI -1.0
9. SURPRIZ ALARMI: Favori PSİKOLOJİ<5.0 VEYA FİZİKSEL<5.0 VEYA 2+ Veto → surpriseAlert: true

═══════════════════════════════════════
CIKTI FORMATI: SADECE asagidaki JSON yapisinda yanit ver:
═══════════════════════════════════════

{
  "prediction": {
    "result": "1 | X | 2",
    "resultLabel": "Ev Sahibi Kazanir | Beraberlik | Deplasman Kazanir",
    "confidence": 0.00,
    "surpriseAlert": false,
    "bankoLevel": "BANKO | GUCLU | RISKLI | KAPAT",
    "mainReason": "Tek cumlelik ana sebep"
  },
  "categories": {
    "power": {"homeScore":0.0,"awayScore":0.0,"weight":0.20,"detail":"3-4 cumle"},
    "tactics": {"homeScore":0.0,"awayScore":0.0,"weight":0.20,"detail":"3-4 cumle"},
    "psychology": {"homeScore":0.0,"awayScore":0.0,"weight":0.18,"detail":"3-4 cumle"},
    "externalFactors": {"homeScore":0.0,"awayScore":0.0,"weight":0.10,"detail":"2-3 cumle"},
    "market": {"homeScore":0.0,"awayScore":0.0,"weight":0.07,"detail":"2-3 cumle"},
    "referee": {"homeScore":0.0,"awayScore":0.0,"weight":0.08,"detail":"2-3 cumle"},
    "setPieces": {"homeScore":0.0,"awayScore":0.0,"weight":0.07,"detail":"2-3 cumle"},
    "physical": {"homeScore":0.0,"awayScore":0.0,"weight":0.10,"detail":"2-3 cumle"}
  },
  "vetoRules": [
    {"rule":"...","affectedTeam":"...","penalty":"-1.5","affectedCategory":"power","reason":"..."}
  ],
  "weightedTotal": {"home":0.0,"away":0.0},
  "dataIntelligence": {
    "weather": {"temperature":"°C","humidity":"%","rain":"yok/hafif/siddetli","wind":"km/s","impact":"etki aciklamasi"},
    "injuries": {"homeTeamOut":["Oyuncu — sakatlık"],"awayTeamOut":["Oyuncu — sakatlık"],"homeTeamDoubtful":["Oyuncu"],"awayTeamDoubtful":["Oyuncu"]},
    "referee": {"name":"Hakem adi","avgFoulsPerMatch":0.0,"avgYellowCards":0.0,"avgPenalties":0.0,"varReferee":"VAR hakemi"},
    "restDays": {"home":0,"away":0,"lastMatchHome":"Tarih — Rakip (Sonuc)","lastMatchAway":"Tarih — Rakip (Sonuc)"},
    "xgData": {"homeXg":0.0,"homeXga":0.0,"awayXg":0.0,"awayXga":0.0,"source":"FBref/Understat"},
    "headToHead": {"last5":"Son 5 karsilasma ozeti","homeWins":0,"draws":0,"awayWins":0},
    "stadiumInfo": {"name":"Stadyum","capacity":0,"altitude":0,"pitchType":"dogal/hibrit/suni","pitchDimensions":"105x68m"},
    "fixtureContext": {"homeNextMatch":"Tarih — Rakip","awayNextMatch":"Tarih — Rakip","targetMatchSyndrome":"Var/Yok — aciklama"}
  },
  "xgAnalysis": "xG verilerine dayali detayli analiz (2-3 cumle)",
  "fixtureAnalysis": "Fikstur yorgunluk analizi (2-3 cumle)",
  "injuryReport": "Kritik eksikler ve kombinasyon etkileri (3-4 cumle)",
  "setPieceBreakdown": "Duran top analizi (2-3 cumle)",
  "refereeImpact": "Hakem etkisi (2-3 cumle)",
  "detailedNarrative": "5-8 paragraf detayli analiz metni. Elit spor gazetecisi gibi yaz."
}

AGIRLIKLI PUAN FORMULU:
Toplam = (Guc x 0.20) + (Taktik x 0.20) + (Psikoloji x 0.18) + (Dis x 0.10) + (Piyasa x 0.07) + (Hakem x 0.08) + (Duran Top x 0.07) + (Fiziksel x 0.10)

GUVENILIRLIK:
confidence >= 0.80 → BANKO
confidence >= 0.65 → GUCLU
confidence >= 0.50 → RISKLI
confidence < 0.50 → KAPAT

Turkce yanit ver. Sadece JSON formatinda yanit ver, baska hicbir metin ekleme.''';
  }
}

// RateLimitException ve AnalysisTimeoutException
// core/errors/exceptions.dart dosyasinda tanimlidir.
