import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/utils/app_logger.dart';

import '../../config/constants/firestore_paths.dart';
import '../datasources/gemini_datasource.dart';
import '../models/chat_message_model.dart';

/// Chat Repository — Cloud Function üzerinden mesaj gönder, Firestore'dan geçmiş yükle
class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GeminiDatasource _datasource;

  ChatRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    GeminiDatasource? datasource,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _datasource = datasource ?? GeminiDatasource();

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _messagesRef(String matchId) {
    final userId = _userId;
    if (userId == null) throw Exception('Oturum açılmamış.');
    return _firestore
        .collection(FirestorePaths.chats)
        .doc(userId)
        .collection(FirestorePaths.matchChatsSubcollection)
        .doc(matchId)
        .collection(FirestorePaths.messagesSubcollection);
  }

  /// Mesaj geçmişini stream et
  Stream<List<ChatMessageModel>> streamMessages(String matchId) {
    if (_userId == null) return Stream.value([]);

    return _messagesRef(matchId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data();
              return ChatMessageModel(
                id: doc.id,
                role: data['role'] as String? ?? 'user',
                content: data['content'] as String? ?? '',
                timestamp: (data['timestamp'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
              );
            }).toList());
  }

  /// AI'a mesaj gönder — Cloud Function üzerinden
  /// Cloud Function hem mesajı hem yanıtı Firestore'a kaydeder.
  /// Client tarafında ek yazma yapılmaz (duplikasyon önlenir).
  Future<String> sendMessage({
    required String matchId,
    required String message,
    List<ChatMessageModel>? history,
  }) async {
    if (_userId == null) throw Exception('Oturum açılmamış.');

    // History'yi Cloud Function formatına dönüştür
    final historyMaps = history
        ?.map((m) => {'role': m.role, 'content': m.content})
        .toList();

    // Cloud Function üzerinden mesaj gönder
    // Server hem user mesajını hem AI yanıtını Firestore'a yazar
    final response = await _datasource.sendChatMessage(
      matchId: matchId,
      message: message,
      history: historyMaps,
    );

    return response;
  }

  /// [B-11] FIX: Bugün gönderilen mesaj sayısını global olarak getir
  /// rateLimits koleksiyonundan okur (Cloud Function ile senkron)
  Future<int> getTodayMessageCount(String matchId) async {
    if (_userId == null) return 0;

    final today = DateTime.now().toUtc().toIso8601String().split('T')[0];
    final docId = '${_userId}_$today';

    try {
      final doc = await _firestore
          .collection(FirestorePaths.rateLimits)
          .doc(docId)
          .get();

      if (!doc.exists) return 0;
      return (doc.data()?['count'] as num?)?.toInt() ?? 0;
    } catch (e) {
      AppLogger.error('Chat', 'Message count hatası', e);
      return 0;
    }
  }

  /// Sohbeti temizle
  Future<void> clearChat(String matchId) async {
    if (_userId == null) return;

    final snap = await _messagesRef(matchId).get();
    if (snap.docs.isEmpty) return;

    // Batch limitine dikkat
    const batchLimit = 400;
    var batch = _firestore.batch();
    var count = 0;

    for (final doc in snap.docs) {
      batch.delete(doc.reference);
      count++;
      if (count >= batchLimit) {
        await batch.commit();
        batch = _firestore.batch();
        count = 0;
      }
    }
    if (count > 0) {
      await batch.commit();
    }
  }
}
