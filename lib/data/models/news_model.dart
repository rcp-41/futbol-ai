import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

/// Haber modeli — scraper news/ koleksiyonu
@freezed
class NewsModel with _$NewsModel {
  const factory NewsModel({
    required String id,
    @Default('') String title,
    @Default('') String date,
    @Default('') String summary,
    @Default('') String content,
    @Default('') String source,
    @Default('') String sourceUrl,
    @Default('') String author,
    @Default('') String relatedTeam,
    @Default([]) List<String> relatedPlayers,
    @Default([]) List<String> tags,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return NewsModel.fromJson(data);
  }
}
