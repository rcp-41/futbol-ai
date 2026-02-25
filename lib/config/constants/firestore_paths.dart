/// Firestore koleksiyon path sabitleri
class FirestorePaths {
  FirestorePaths._();

  static const String matches = 'matches';
  static const String analyses = 'analyses';
  static const String chats = 'chats';
  static const String users = 'users';
  static const String rateLimits = 'rateLimits';
  static const String appConfig = 'appConfig';

  static String matchChats(String userId, String matchId) =>
      '$chats/$userId/matchChats/$matchId/messages';

  static String userDoc(String userId) => '$users/$userId';
}
