/// [A-04] Merkezi hata yönetimi
/// [K-02] Firebase auth hata kodlarını Türkçe mesaja çeviren utility

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

/// Firebase Auth hata kodlarını kullanıcı dostu Türkçe mesajlara dönüştür
String mapFirebaseAuthError(String code) {
  return switch (code) {
    'user-not-found' => 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
    'wrong-password' => 'Yanlış şifre girdiniz.',
    'invalid-email' => 'Geçersiz e-posta adresi.',
    'user-disabled' => 'Bu hesap devre dışı bırakılmış.',
    'email-already-in-use' => 'Bu e-posta adresi zaten kullanılıyor.',
    'weak-password' => 'Şifre en az 6 karakter olmalıdır.',
    'too-many-requests' => 'Çok fazla deneme yaptınız. Lütfen bir süre bekleyin.',
    'operation-not-allowed' => 'Bu giriş yöntemi etkin değil.',
    'network-request-failed' => 'İnternet bağlantınızı kontrol edin.',
    'invalid-credential' => 'E-posta veya şifre hatalı.',
    _ => 'Bir hata oluştu. Lütfen tekrar deneyin.',
  };
}

/// Cloud Functions hata kodlarını kullanıcı dostu mesajlara dönüştür
String mapCloudFunctionError(String code) {
  return switch (code) {
    'unauthenticated' => 'Oturum açmanız gerekiyor.',
    'permission-denied' => 'Bu işlem için yetkiniz yok.',
    'resource-exhausted' => 'Günlük kullanım limitinize ulaştınız.',
    'deadline-exceeded' => 'İşlem zaman aşımına uğradı. Tekrar deneyin.',
    'not-found' => 'İstenen kaynak bulunamadı.',
    'unavailable' => 'Sunucu geçici olarak kullanılamıyor. Tekrar deneyin.',
    'internal' => 'Sunucu hatası oluştu. Tekrar deneyin.',
    _ => 'Bir hata oluştu. Lütfen tekrar deneyin.',
  };
}
