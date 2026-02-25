import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/gemini_datasource.dart';
import '../models/chat_message_model.dart';

/// Chat Repository — mesaj gonder, Firestore'a kaydet, gecmis yukle, temizle
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

  /// Mesaj gecmisini stream et
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

  /// AI'a mesaj gonder ve yanit al — her iki mesaji da Firestore'a kaydet
  Future<String> sendMessage({
    required String matchId,
    required String message,
    List<ChatMessageModel>? history,
  }) async {
    final userId = _userId;
    if (userId == null) throw Exception('Oturum acilmamis.');

    // 1. Kullanici mesajini Firestore'a kaydet
    await _messagesRef(matchId).add({
      'role': 'user',
      'content': message,
      'timestamp': FieldValue.serverTimestamp(),
      'tokenCount': message.length ~/ 4, // yaklasik token tahmini
    });

    // 2. Mac verisini al (chat baglami icin)
    Map<String, dynamic>? matchData;
    try {
      final matchDoc =
          await _firestore.collection('matches').doc(matchId).get();
      if (matchDoc.exists) {
        matchData = matchDoc.data();
      } else {
        final sportotoDoc =
            await _firestore.collection('sportoto_matches').doc(matchId).get();
        if (sportotoDoc.exists) matchData = sportotoDoc.data();
      }
    } catch (_) {
      // Mac verisi alinamazsa devam et
    }

    // 3. History'yi Gemini formatina donustur
    final historyMaps = history
        ?.map((m) => {'role': m.role, 'content': m.content})
        .toList();

    // 4. Gemini'den yanit al
    final response = await _datasource.sendChatMessage(
      matchId: matchId,
      message: message,
      history: historyMaps,
      matchData: matchData,
    );

    // 5. AI yanitini Firestore'a kaydet
    await _messagesRef(matchId).add({
      'role': 'assistant',
      'content': response,
      'timestamp': FieldValue.serverTimestamp(),
      'tokenCount': response.length ~/ 4,
    });

    return response;
  }

  /// Bugun gonderilen mesaj sayisini getir
  Future<int> getTodayMessageCount(String matchId) async {
    if (_userId == null) return 0;

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final snap = await _messagesRef(matchId)
        .where('role', isEqualTo: 'user')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .count()
        .get();

    return snap.count ?? 0;
  }

  /// Sohbeti temizle
  Future<void> clearChat(String matchId) async {
    if (_userId == null) return;

    final snap = await _messagesRef(matchId).get();
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
