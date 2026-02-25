import 'package:cloud_functions/cloud_functions.dart';

/// Gemini API datasource — Cloud Functions çağrıları
class GeminiDatasource {
  final FirebaseFunctions _functions;

  GeminiDatasource({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1');

  /// Maç analizi iste
  Future<Map<String, dynamic>> requestAnalysis(String matchId) async {
    try {
      final callable = _functions.httpsCallable(
        'analyzeMatch',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 90)),
      );
      final result = await callable.call({'matchId': matchId});
      return Map<String, dynamic>.from(result.data as Map);
    } on FirebaseFunctionsException catch (e) {
      throw _mapError(e);
    }
  }

  /// AI chat mesajı gönder
  Future<String> sendChatMessage({
    required String matchId,
    required String message,
    List<Map<String, String>>? history,
  }) async {
    try {
      final callable = _functions.httpsCallable(
        'chatWithAI',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      final result = await callable.call({
        'matchId': matchId,
        'message': message,
        'history': history ?? [],
      });
      return (result.data as Map)['response'] as String? ?? 'Yanıt alınamadı.';
    } on FirebaseFunctionsException catch (e) {
      throw _mapError(e);
    }
  }

  Exception _mapError(FirebaseFunctionsException e) {
    return switch (e.code) {
      'unauthenticated' => Exception('Giriş yapmalısınız.'),
      'not-found' => Exception('Maç bulunamadı.'),
      'resource-exhausted' => RateLimitException(),
      'deadline-exceeded' => AnalysisTimeoutException(),
      _ => Exception(e.message ?? 'Bilinmeyen hata.'),
    };
  }
}

class RateLimitException implements Exception {
  @override
  String toString() => 'Günlük analiz limitinize ulaştınız.';
}

class AnalysisTimeoutException implements Exception {
  @override
  String toString() => 'Analiz zaman aşımına uğradı. Tekrar deneyin.';
}
