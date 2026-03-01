import 'package:cloud_functions/cloud_functions.dart';
import '../../core/utils/app_logger.dart';

/// Cloud Function proxy datasource — tüm AI işlemleri sunucu tarafında yapılır.
/// API key'ler Cloud Functions defineSecret() ile güvenli şekilde yönetilir.
/// @deprecated Use [CloudFunctionDatasource] instead.
typedef GeminiDatasource = CloudFunctionDatasource;

class CloudFunctionDatasource {
  static const _tag = 'CloudFunctionDatasource';
  late final FirebaseFunctions _functions;

  CloudFunctionDatasource() {
    _functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
  }

  /// Maç analizi iste - Firebase Cloud Function üzerinden
  Future<Map<String, dynamic>> requestAnalysis(String matchId) async {
    AppLogger.debug(_tag, 'analyzeMatch çağrılıyor: $matchId');

    try {
      final callable = _functions.httpsCallable(
        'analyzeMatch',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 120)),
      );

      final response = await callable.call({'matchId': matchId});

      if (response.data == null) {
        throw Exception('Cloud Function boş yanıt döndü.');
      }
      if (response.data is! Map) {
        throw Exception('Beklenmeyen yanıt formatı: ${response.data.runtimeType}');
      }

      final data = response.data as Map;
      return Map<String, dynamic>.from(data);
    } on FirebaseFunctionsException catch (e) {
      AppLogger.error(_tag, 'Cloud Function Hatası: ${e.code}', e);

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
      AppLogger.error(_tag, 'Beklenmeyen Hata', e);
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

  /// AI chat mesajı gönder — Cloud Function üzerinden
  Future<String> sendChatMessage({
    required String matchId,
    required String message,
    List<Map<String, String>>? history,
    Map<String, dynamic>? matchData,
  }) async {
    AppLogger.debug(_tag, 'chatWithAI çağrılıyor: $matchId');

    try {
      final callable = _functions.httpsCallable(
        'chatWithAI',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );

      final historyForServer = history
          ?.map((m) => {'role': m['role'] ?? 'user', 'content': m['content'] ?? ''})
          .toList();

      final response = await callable.call({
        'matchId': matchId,
        'message': message,
        'history': historyForServer,
      });

      if (response.data == null || response.data is! Map) {
        return 'Yanıt alınamadı.';
      }

      final data = response.data as Map;
      return data['response']?.toString() ?? 'Yanıt alınamadı.';
    } on FirebaseFunctionsException catch (e) {
      AppLogger.error(_tag, 'Chat Hatası: ${e.code}', e);
      if (e.code == 'resource-exhausted') {
        return 'Günlük mesaj limitinize ulaştınız.';
      }
      if (e.code == 'deadline-exceeded') {
        return 'Yanıt zaman aşımına uğradı. Tekrar deneyin.';
      }
      return 'Sohbet sırasında hata oluştu: ${e.message}';
    } catch (e) {
      AppLogger.error(_tag, 'Chat Beklenmeyen Hata', e);
      return 'Bağlantı hatası oluştu. Tekrar deneyin.';
    }
  }
}
