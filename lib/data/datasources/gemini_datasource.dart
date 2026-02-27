import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  /// Mac analizi iste - Firebase Cloud Function üzerinden
  Future<Map<String, dynamic>> requestAnalysis(String matchId) async {
    debugPrint('[GeminiDatasource] Bulut fonksiyonu (analyzeMatch) çağrılıyor: $matchId');
    
    try {
      final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
      final callable = functions.httpsCallable(
        'analyzeMatch',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 120)),
      );

      final response = await callable.call({'matchId': matchId});
      
      // Cloud Function zaten bir JSON objesi (Map) dönüyor
      if (response.data == null) {
        throw Exception('Cloud Function boş yanıt döndü.');
      }

      final data = response.data as Map;
      // Anahtarları String'e zorlamak garantisi
      return Map<String, dynamic>.from(data);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('[GeminiDatasource] Cloud Function Hatası: ${e.code} - ${e.message}');
      
      return {
        'prediction': {
          'result': '?',
          'resultLabel': 'Hata Oluştu',
          'confidence': 0.5,
          'surpriseAlert': false,
          'bankoLevel': 'KAPAT',
          'mainReason': 'Analiz yapılamadı: ${e.message}',
        },
        'detailedNarrative': 'Sunucu ile iletişimde hata oluştu: ${e.message}',
        'rawGeminiResponse': '{}',
      };
    } catch (e) {
      debugPrint('[GeminiDatasource] Beklenmeyen Hata: $e');
      return {
        'prediction': {
          'result': '?',
          'resultLabel': 'Bağlantı Hatası',
          'confidence': 0.5,
          'surpriseAlert': false,
          'bankoLevel': 'KAPAT',
          'mainReason': 'Beklenmeyen bir hata oluştu veya bağlantı kurulamadı.',
        },
        'detailedNarrative': 'Beklenmeyen hata: $e',
        'rawGeminiResponse': '{}',
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
}

// RateLimitException ve AnalysisTimeoutException
// core/errors/exceptions.dart dosyasinda tanimlidir.
