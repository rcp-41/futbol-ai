import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// Maç veri modeli — SPEC.md Bölüm 4.1 matches/ şeması
@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required TeamInfo homeTeam,
    required TeamInfo awayTeam,
    required String league,
    @Default('') String leagueCountry,
    @Default(0) int week,
    required DateTime matchDate,
    @Default('') String stadium,
    @Default('upcoming') String status,
    MatchScore? score,
    MatchOdds? odds,
    @Default('normal') String importance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Timestamp → DateTime conversion
    if (data['matchDate'] is Timestamp) {
      data['matchDate'] =
          (data['matchDate'] as Timestamp).toDate().toIso8601String();
    }
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] =
          (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    data['id'] = doc.id;
    return MatchModel.fromJson(data);
  }
}

@freezed
class TeamInfo with _$TeamInfo {
  const factory TeamInfo({
    required String name,
    @Default('') String shortName,
    @Default('') String logoUrl,
    @Default('') String formLast5,
  }) = _TeamInfo;

  factory TeamInfo.fromJson(Map<String, dynamic> json) =>
      _$TeamInfoFromJson(json);
}

@freezed
class MatchScore with _$MatchScore {
  const factory MatchScore({
    @Default(0) int home,
    @Default(0) int away,
  }) = _MatchScore;

  factory MatchScore.fromJson(Map<String, dynamic> json) =>
      _$MatchScoreFromJson(json);
}

@freezed
class MatchOdds with _$MatchOdds {
  const factory MatchOdds({
    @Default(0.0) double home,
    @Default(0.0) double draw,
    @Default(0.0) double away,
    @Default('') String source,
  }) = _MatchOdds;

  factory MatchOdds.fromJson(Map<String, dynamic> json) =>
      _$MatchOddsFromJson(json);
}
