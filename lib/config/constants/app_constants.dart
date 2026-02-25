/// Genel uygulama sabitleri
class AppConstants {
  AppConstants._();

  static const String appName = 'FutbolAI';
  static const String appTagline = 'Elit Futbol Analiz & Tahmin';

  // Rate limits
  static const int freeAnalysisLimit = 5;
  static const int proAnalysisLimit = 50;
  static const int chatMessageLimit = 20;
  static const int globalDailyLimit = 1000;

  // UI
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

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
