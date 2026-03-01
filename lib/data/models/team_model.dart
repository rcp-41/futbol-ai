import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_model.freezed.dart';
part 'team_model.g.dart';

/// Takım modeli — scraper teams/ koleksiyonu
@freezed
class TeamModel with _$TeamModel {
  const factory TeamModel({
    required String slug,
    required String name,
    @Default('') String league,
    TeamIds? ids,
    ManagerInfo? manager,
    StadiumInfo? stadium,
    @Default([]) List<SquadPlayer> squad,
    @Default([]) List<InjuryInfo> injuries,
    @Default([]) List<SuspendedPlayer> suspended,
    @Default([]) List<TransferRumor> transferRumors,
    TeamTransfers? transfers,
    @Default([]) List<TeamNewsItem> news,
    @Default([]) List<String> recentForm,
    @Default(0) int totalSquadValue,
    @Default(0.0) double averageAge,
    @Default([]) List<ManagerHistoryEntry> managerHistory,
    @Default({}) Map<String, dynamic> seasonStats,
    @Default('') String dataHash,
    DateTime? lastUpdated,
  }) = _TeamModel;

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    if (data['lastUpdated'] is Timestamp) {
      data['lastUpdated'] =
          (data['lastUpdated'] as Timestamp).toDate().toIso8601String();
    }
    data['slug'] = data['slug'] ?? doc.id;
    return TeamModel.fromJson(data);
  }
}

@freezed
class TeamIds with _$TeamIds {
  const factory TeamIds({
    @Default(0) int sofascore,
    @Default('') String transfermarkt,
    @Default('') String fbref,
  }) = _TeamIds;

  factory TeamIds.fromJson(Map<String, dynamic> json) =>
      _$TeamIdsFromJson(json);
}

@freezed
class ManagerInfo with _$ManagerInfo {
  const factory ManagerInfo({
    @Default('') String name,
    @Default('') String since,
    @Default(0) int matches,
    @Default(0.0) double winRate,
    @Default('') String nationality,
    @Default([]) List<String> previousClubs,
  }) = _ManagerInfo;

  factory ManagerInfo.fromJson(Map<String, dynamic> json) =>
      _$ManagerInfoFromJson(json);
}

@freezed
class StadiumInfo with _$StadiumInfo {
  const factory StadiumInfo({
    @Default('') String name,
    @Default(0) int capacity,
    @Default('') String city,
    @Default(0) int builtYear,
  }) = _StadiumInfo;

  factory StadiumInfo.fromJson(Map<String, dynamic> json) =>
      _$StadiumInfoFromJson(json);
}

@freezed
class SquadPlayer with _$SquadPlayer {
  const factory SquadPlayer({
    required String name,
    @Default('') String position,
    @Default(0) int number,
    @Default(0) int age,
    @Default(0) int marketValue,
    @Default('') String contractUntil,
    @Default('fit') String status,
    @Default('') String nationality,
    @Default(0) int sofascoreId,
    @Default('') String transfermarktId,
    double? weeklyWage,
  }) = _SquadPlayer;

  factory SquadPlayer.fromJson(Map<String, dynamic> json) =>
      _$SquadPlayerFromJson(json);
}

@freezed
class InjuryInfo with _$InjuryInfo {
  const factory InjuryInfo({
    @Default('') String player,
    @Default('') String type,
    @Default('') String since,
    @Default('') String expectedReturn,
    @Default(0) int gamesMissed,
  }) = _InjuryInfo;

  factory InjuryInfo.fromJson(Map<String, dynamic> json) =>
      _$InjuryInfoFromJson(json);
}

@freezed
class SuspendedPlayer with _$SuspendedPlayer {
  const factory SuspendedPlayer({
    @Default('') String player,
    @Default('') String reason,
    @Default('') String returnDate,
  }) = _SuspendedPlayer;

  factory SuspendedPlayer.fromJson(Map<String, dynamic> json) =>
      _$SuspendedPlayerFromJson(json);
}

@freezed
class TransferRumor with _$TransferRumor {
  const factory TransferRumor({
    @Default('') String player,
    @Default('') String type,
    @Default('') String source,
    @Default('') String date,
    @Default('') String reliability,
  }) = _TransferRumor;

  factory TransferRumor.fromJson(Map<String, dynamic> json) =>
      _$TransferRumorFromJson(json);
}

@freezed
class TeamTransfers with _$TeamTransfers {
  const factory TeamTransfers({
    @Default([]) List<TransferEntry> transferIn,
    @Default([]) List<TransferEntry> transferOut,
  }) = _TeamTransfers;

  factory TeamTransfers.fromJson(Map<String, dynamic> json) =>
      _$TeamTransfersFromJson(json);
}

@freezed
class TransferEntry with _$TransferEntry {
  const factory TransferEntry({
    @Default('') String player,
    @Default('') String from,
    @Default('') String to,
    @Default(0) int fee,
    @Default('') String date,
  }) = _TransferEntry;

  factory TransferEntry.fromJson(Map<String, dynamic> json) =>
      _$TransferEntryFromJson(json);
}

@freezed
class TeamNewsItem with _$TeamNewsItem {
  const factory TeamNewsItem({
    @Default('') String title,
    @Default('') String date,
    @Default('') String summary,
    @Default('') String source,
    @Default('') String url,
  }) = _TeamNewsItem;

  factory TeamNewsItem.fromJson(Map<String, dynamic> json) =>
      _$TeamNewsItemFromJson(json);
}

@freezed
class ManagerHistoryEntry with _$ManagerHistoryEntry {
  const factory ManagerHistoryEntry({
    @Default('') String name,
    @Default('') String from,
    @Default('') String to,
    @Default(0) int matches,
    @Default(0.0) double winRate,
  }) = _ManagerHistoryEntry;

  factory ManagerHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ManagerHistoryEntryFromJson(json);
}
