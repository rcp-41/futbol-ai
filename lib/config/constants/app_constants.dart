/// Genel uygulama sabitleri
class AppConstants {
  AppConstants._();

  static const String appName = 'FutbolAI';
  static const String appTagline = 'Elit Futbol Analiz & Tahmin';

  // Rate limits
  static const int freeAnalysisLimit = 5;
  static const int proAnalysisLimit = 50;
  static const int chatMessageLimit = 20;
  static const int maxDailyMessages = chatMessageLimit;
  static const int globalDailyLimit = 1000;

  // Timeouts
  static const int analysisTimeoutSeconds = 120;
  static const int chatTimeoutSeconds = 30;

  // UI
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  // Chat Bottom Sheet
  static const double sheetInitialSize = 0.65;
  static const double sheetMinSize = 0.4;
  static const double sheetMaxSize = 0.92;

  // Version
  static const int versionParts = 3;

  // Ligler
  static const List<String> defaultLeagues = [
    'Tümü',
    'Süper Lig',
    'Premier League',
    'La Liga',
    'Serie A',
    'Bundesliga',
    'Şampiyonlar Ligi',
  ];

  static const Map<String, String> leagueFlags = {
    'Tümü': '⚽',
    'Süper Lig': '🇹🇷',
    'Premier League': '🏴',
    'La Liga': '🇪🇸',
    'Serie A': '🇮🇹',
    'Bundesliga': '🇩🇪',
    'Şampiyonlar Ligi': '🇪🇺',
  };

  // Loading mesajları
  static const List<String> loadingMessages = [
    '🔍 Sakatlık verileri taranıyor...',
    '🌡️ Hava durumu kontrol ediliyor...',
    '⚖️ Hakem istatistikleri çekiliyor...',
    '📊 xG ve taktik verileri analiz ediliyor...',
    '🧠 Psikolojik faktörler değerlendiriliyor...',
    '📅 Fikstür yorgunluğu hesaplanıyor...',
    '⚽ Duran top verileri kontrol ediliyor...',
    '💰 Piyasa hareketleri taranıyor...',
    '🎯 Veto kuralları uygulanıyor...',
    '📝 Final raporu hazırlanıyor...',
  ];
}
