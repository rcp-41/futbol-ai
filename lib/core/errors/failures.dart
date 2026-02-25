/// Hata sınıfları — SPEC.md Bölüm 11 Hata Yönetimi Matrisi
sealed class Failure {
  final String message;
  final String? code;
  const Failure(this.message, {this.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('📡 İnternet bağlantınızı kontrol edin');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = '🔧 AI motoru şu an meşgul, birazdan deneyin']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure()
      : super('⏱️ Analiz uzun sürdü, tekrar deneyin');
}

class RateLimitFailure extends Failure {
  final int remaining;
  const RateLimitFailure({this.remaining = 0})
      : super('📊 Günlük analiz hakkınız doldu. Pro\'ya geçin!');
}

class CacheFailure extends Failure {
  const CacheFailure() : super('💾 Veri yüklenemedi');
}

class AuthFailure extends Failure {
  const AuthFailure() : super('🔐 Oturumunuz sonlandı');
}

class ParseFailure extends Failure {
  const ParseFailure() : super('Veri işlenemedi, tekrar deneyin');
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure() : super('⚠️ Maç verisi eksik');
}
