import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'league_model.freezed.dart';
part 'league_model.g.dart';

/// Lig modeli — scraper leagues/ koleksiyonu
@freezed
class LeagueModel with _$LeagueModel {
  const factory LeagueModel({
    required String key,
    required String name,
    @Default('') String country,
    @Default('') String season,
    @Default(0) int sofascoreId,
    @Default(0) int fbrefId,
    @Default(0) int sofascoreSeasonId,
    @Default('') String transfermarktId,
    LeagueStandings? standings,
    @Default([]) List<TopPlayerEntry> topScorers,
    @Default([]) List<TopPlayerEntry> topAssists,
    @Default([]) List<TopPlayerEntry> topRatings,
    @Default('') String dataHash,
    DateTime? lastUpdated,
  }) = _LeagueModel;

  factory LeagueModel.fromJson(Map<String, dynamic> json) =>
      _$LeagueModelFromJson(json);

  factory LeagueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data['lastUpdated'] is Timestamp) {
      data['lastUpdated'] =
          (data['lastUpdated'] as Timestamp).toDate().toIso8601String();
    }
    data['key'] = doc.id;
    return LeagueModel.fromJson(data);
  }
}

@freezed
class LeagueStandings with _$LeagueStandings {
  const factory LeagueStandings({
    @Default([]) List<StandingEntry> total,
    @Default([]) List<StandingEntry> home,
    @Default([]) List<StandingEntry> away,
  }) = _LeagueStandings;

  factory LeagueStandings.fromJson(Map<String, dynamic> json) =>
      _$LeagueStandingsFromJson(json);
}

@freezed
class StandingEntry with _$StandingEntry {
  const factory StandingEntry({
    @Default(0) int rank,
    @Default('') String team,
    @Default(0) int played,
    @Default(0) int won,
    @Default(0) int drawn,
    @Default(0) int lost,
    @Default(0) int goalsFor,
    @Default(0) int goalsAgainst,
    @Default(0) int goalDifference,
    @Default(0) int points,
    @Default([]) List<String> form,
  }) = _StandingEntry;

  factory StandingEntry.fromJson(Map<String, dynamic> json) =>
      _$StandingEntryFromJson(json);
}

@freezed
class TopPlayerEntry with _$TopPlayerEntry {
  const factory TopPlayerEntry({
    @Default('') String player,
    @Default('') String team,
    @Default('') String playerId,
    @Default(0) int goals,
    @Default(0) int assists,
    @Default(0.0) double rating,
  }) = _TopPlayerEntry;

  factory TopPlayerEntry.fromJson(Map<String, dynamic> json) =>
      _$TopPlayerEntryFromJson(json);
}
