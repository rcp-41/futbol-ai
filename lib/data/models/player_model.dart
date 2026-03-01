import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

/// Oyuncu modeli — scraper players/ koleksiyonu
@freezed
class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    required String id,
    required String name,
    @Default('') String slug,
    PlayerIds? ids,
    @Default('') String team,
    @Default('') String league,
    @Default('') String position,
    @Default('') String nationality,
    @Default('') String dateOfBirth,
    @Default(0) int height,
    @Default(0) int weight,
    @Default('') String preferredFoot,
    @Default(0) int number,
    @Default('') String contractUntil,
    double? weeklyWage,
    @Default(0) int marketValue,
    @Default([]) List<MarketValueEntry> marketValueHistory,
    @Default({}) Map<String, dynamic> seasonStats,
    @Default([]) List<CareerEntry> careerHistory,
    ScoutingData? scouting,
    @Default([]) List<PlayerInjury> injuries,
    NationalTeamInfo? nationalTeam,
    @Default('') String dataHash,
    DateTime? lastUpdated,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  factory PlayerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data['lastUpdated'] is Timestamp) {
      data['lastUpdated'] =
          (data['lastUpdated'] as Timestamp).toDate().toIso8601String();
    }
    data['id'] = doc.id;
    return PlayerModel.fromJson(data);
  }
}

@freezed
class PlayerIds with _$PlayerIds {
  const factory PlayerIds({
    @Default(0) int sofascore,
    @Default('') String transfermarkt,
    @Default('') String fbref,
  }) = _PlayerIds;

  factory PlayerIds.fromJson(Map<String, dynamic> json) =>
      _$PlayerIdsFromJson(json);
}

@freezed
class MarketValueEntry with _$MarketValueEntry {
  const factory MarketValueEntry({
    @Default('') String date,
    @Default(0) int value,
  }) = _MarketValueEntry;

  factory MarketValueEntry.fromJson(Map<String, dynamic> json) =>
      _$MarketValueEntryFromJson(json);
}

@freezed
class CareerEntry with _$CareerEntry {
  const factory CareerEntry({
    @Default('') String team,
    @Default('') String from,
    String? to,
    @Default(0) int matches,
    @Default(0) int goals,
  }) = _CareerEntry;

  factory CareerEntry.fromJson(Map<String, dynamic> json) =>
      _$CareerEntryFromJson(json);
}

@freezed
class ScoutingData with _$ScoutingData {
  const factory ScoutingData({
    @Default({}) Map<String, int> percentiles,
    @Default('fbref') String source,
  }) = _ScoutingData;

  factory ScoutingData.fromJson(Map<String, dynamic> json) =>
      _$ScoutingDataFromJson(json);
}

@freezed
class PlayerInjury with _$PlayerInjury {
  const factory PlayerInjury({
    @Default('') String type,
    @Default('') String from,
    @Default('') String to,
    @Default(0) int days,
  }) = _PlayerInjury;

  factory PlayerInjury.fromJson(Map<String, dynamic> json) =>
      _$PlayerInjuryFromJson(json);
}

@freezed
class NationalTeamInfo with _$NationalTeamInfo {
  const factory NationalTeamInfo({
    @Default('') String team,
    @Default(0) int caps,
    @Default(0) int goals,
  }) = _NationalTeamInfo;

  factory NationalTeamInfo.fromJson(Map<String, dynamic> json) =>
      _$NationalTeamInfoFromJson(json);
}
