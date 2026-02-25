/// Exception sınıfları — repository → failure mapping için
class ServerException implements Exception {
  final String? message;
  final int? statusCode;
  const ServerException({this.message, this.statusCode});
}

class CacheException implements Exception {
  final String? message;
  const CacheException({this.message});
}

class NetworkException implements Exception {
  const NetworkException();
}

class RateLimitException implements Exception {
  final int remaining;
  const RateLimitException({this.remaining = 0});
}
