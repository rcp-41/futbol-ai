import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

/// Sohbet mesaj modeli — SPEC.md Bölüm 4.1 chats/ şeması
@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    String? id,
    required String role,
    required String content,
    required DateTime timestamp,
    @Default(0) int tokenCount,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data['timestamp'] is Timestamp) {
      data['timestamp'] =
          (data['timestamp'] as Timestamp).toDate().toIso8601String();
    }
    data['id'] = doc.id;
    return ChatMessageModel.fromJson(data);
  }
}
