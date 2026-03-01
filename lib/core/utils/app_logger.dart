import 'package:flutter/foundation.dart';

/// [K-04] Merkezi log yöneticisi
/// Debug modda konsola yazar, release'de sessiz kalır.
class AppLogger {
  AppLogger._();

  static void debug(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[$tag] $message');
    }
  }

  static void warn(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[WARN][$tag] $message');
    }
  }

  static void error(String tag, String message, [Object? error]) {
    if (kDebugMode) {
      debugPrint('[ERROR][$tag] $message${error != null ? ': $error' : ''}');
    }
    // TODO: Production'da Firebase Crashlytics'e gönder
    // if (!kDebugMode && error != null) {
    //   FirebaseCrashlytics.instance.recordError(error, null, reason: message);
    // }
  }
}
