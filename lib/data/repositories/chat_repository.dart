import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/gemini_datasource.dart';
import '../models/chat_message_model.dart';

/// Chat Repository — mesaj gönder, geçmiş yükle, temizle
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
    return _firestore
        .collection('chats')
        .doc(_userId)
        .collection('matchChats')
        .doc(matchId)
        .collection('messages');
  }

  /// Mesaj geçmişini stream et
  Stream<List<ChatMessageModel>> streamMessages(String matchId) {
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

  /// AI'a mesaj gönder ve yanıt al
  Future<String> sendMessage({
    required String matchId,
    required String message,
    List<ChatMessageModel>? history,
  }) async {
    // History'yi Gemini formatına dönüştür
    final historyMaps = history
        ?.map((m) => {'role': m.role, 'content': m.content})
        .toList();

    // Cloud Function çağır — mesajları Firestore'a kaydeder
    final response = await _datasource.sendChatMessage(
      matchId: matchId,
      message: message,
      history: historyMaps,
    );

    return response;
  }

  /// Bugün gönderilen mesaj sayısını getir
  Future<int> getTodayMessageCount(String matchId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final snap = await _messagesRef(matchId)
        .where('role', isEqualTo: 'user')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .count()
        .get();

    return snap.count ?? 0;
  }

  /// Sohbeti temizle
  Future<void> clearChat(String matchId) async {
    final snap = await _messagesRef(matchId).get();
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
