// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueModelImpl _$$LeagueModelImplFromJson(Map<String, dynamic> json) =>
    _$LeagueModelImpl(
      key: json['key'] as String,
      name: json['name'] as String,
      country: json['country'] as String? ?? '',
      season: json['season'] as String? ?? '',
      sofascoreId: (json['sofascoreId'] as num?)?.toInt() ?? 0,
      fbrefId: (json['fbrefId'] as num?)?.toInt() ?? 0,
      sofascoreSeasonId: (json['sofascoreSeasonId'] as num?)?.toInt() ?? 0,
      transfermarktId: json['transfermarktId'] as String? ?? '',
      standings: json['standings'] == null
          ? null
          : LeagueStandings.fromJson(json['standings'] as Map<String, dynamic>),
      topScorers:
          (json['topScorers'] as List<dynamic>?)
              ?.map((e) => TopPlayerEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topAssists:
          (json['topAssists'] as List<dynamic>?)
              ?.map((e) => TopPlayerEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topRatings:
          (json['topRatings'] as List<dynamic>?)
              ?.map((e) => TopPlayerEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      dataHash: json['dataHash'] as String? ?? '',
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$LeagueModelImplToJson(_$LeagueModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'country': instance.country,
      'season': instance.season,
      'sofascoreId': instance.sofascoreId,
      'fbrefId': instance.fbrefId,
      'sofascoreSeasonId': instance.sofascoreSeasonId,
      'transfermarktId': instance.transfermarktId,
      'standings': instance.standings,
      'topScorers': instance.topScorers,
      'topAssists': instance.topAssists,
      'topRatings': instance.topRatings,
      'dataHash': instance.dataHash,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_$LeagueStandingsImpl _$$LeagueStandingsImplFromJson(
  Map<String, dynamic> json,
) => _$LeagueStandingsImpl(
  total:
      (json['total'] as List<dynamic>?)
          ?.map((e) => StandingEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  home:
      (json['home'] as List<dynamic>?)
          ?.map((e) => StandingEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  away:
      (json['away'] as List<dynamic>?)
          ?.map((e) => StandingEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LeagueStandingsImplToJson(
  _$LeagueStandingsImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'home': instance.home,
  'away': instance.away,
};

_$StandingEntryImpl _$$StandingEntryImplFromJson(Map<String, dynamic> json) =>
    _$StandingEntryImpl(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      team: json['team'] as String? ?? '',
      played: (json['played'] as num?)?.toInt() ?? 0,
      won: (json['won'] as num?)?.toInt() ?? 0,
      drawn: (json['drawn'] as num?)?.toInt() ?? 0,
      lost: (json['lost'] as num?)?.toInt() ?? 0,
      goalsFor: (json['goalsFor'] as num?)?.toInt() ?? 0,
      goalsAgainst: (json['goalsAgainst'] as num?)?.toInt() ?? 0,
      goalDifference: (json['goalDifference'] as num?)?.toInt() ?? 0,
      points: (json['points'] as num?)?.toInt() ?? 0,
      form:
          (json['form'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$$StandingEntryImplToJson(_$StandingEntryImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'team': instance.team,
      'played': instance.played,
      'won': instance.won,
      'drawn': instance.drawn,
      'lost': instance.lost,
      'goalsFor': instance.goalsFor,
      'goalsAgainst': instance.goalsAgainst,
      'goalDifference': instance.goalDifference,
      'points': instance.points,
      'form': instance.form,
    };

_$TopPlayerEntryImpl _$$TopPlayerEntryImplFromJson(Map<String, dynamic> json) =>
    _$TopPlayerEntryImpl(
      player: json['player'] as String? ?? '',
      team: json['team'] as String? ?? '',
      playerId: json['playerId'] as String? ?? '',
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      assists: (json['assists'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TopPlayerEntryImplToJson(
  _$TopPlayerEntryImpl instance,
) => <String, dynamic>{
  'player': instance.player,
  'team': instance.team,
  'playerId': instance.playerId,
  'goals': instance.goals,
  'assists': instance.assists,
  'rating': instance.rating,
};
