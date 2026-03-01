/// Firestore koleksiyon path sabitleri
class FirestorePaths {
  FirestorePaths._();

  static const String matches = 'matches';
  static const String analyses = 'analyses';
  static const String multiAnalyses = 'multi_analyses';
  static const String chats = 'chats';
  static const String users = 'users';
  static const String rateLimits = 'rateLimits';
  static const String appConfig = 'appConfig';
  static const String sportotoMatches = 'sportoto_matches';

  // [K-08] Alt-koleksiyon path'leri
  static const String matchChatsSubcollection = 'matchChats';
  static const String messagesSubcollection = 'messages';

  static String matchChats(String userId, String matchId) =>
      '$chats/$userId/$matchChatsSubcollection/$matchId/$messagesSubcollection';

  static String userDoc(String userId) => '$users/$userId';
}
