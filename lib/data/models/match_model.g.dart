// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchModelImpl _$$MatchModelImplFromJson(Map<String, dynamic> json) =>
    _$MatchModelImpl(
      id: json['id'] as String,
      homeTeam: TeamInfo.fromJson(json['homeTeam'] as Map<String, dynamic>),
      awayTeam: TeamInfo.fromJson(json['awayTeam'] as Map<String, dynamic>),
      league: json['league'] as String,
      leagueCountry: json['leagueCountry'] as String? ?? '',
      week: (json['week'] as num?)?.toInt() ?? 0,
      matchDate: DateTime.parse(json['matchDate'] as String),
      stadium: json['stadium'] as String? ?? '',
      status: json['status'] as String? ?? 'upcoming',
      score: json['score'] == null
          ? null
          : MatchScore.fromJson(json['score'] as Map<String, dynamic>),
      odds: json['odds'] == null
          ? null
          : MatchOdds.fromJson(json['odds'] as Map<String, dynamic>),
      importance: json['importance'] as String? ?? 'normal',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MatchModelImplToJson(_$MatchModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'homeTeam': instance.homeTeam,
      'awayTeam': instance.awayTeam,
      'league': instance.league,
      'leagueCountry': instance.leagueCountry,
      'week': instance.week,
      'matchDate': instance.matchDate.toIso8601String(),
      'stadium': instance.stadium,
      'status': instance.status,
      'score': instance.score,
      'odds': instance.odds,
      'importance': instance.importance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$TeamInfoImpl _$$TeamInfoImplFromJson(Map<String, dynamic> json) =>
    _$TeamInfoImpl(
      name: json['name'] as String,
      shortName: json['shortName'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      formLast5: json['formLast5'] as String? ?? '',
    );

Map<String, dynamic> _$$TeamInfoImplToJson(_$TeamInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'shortName': instance.shortName,
      'logoUrl': instance.logoUrl,
      'formLast5': instance.formLast5,
    };

_$MatchScoreImpl _$$MatchScoreImplFromJson(Map<String, dynamic> json) =>
    _$MatchScoreImpl(
      home: (json['home'] as num?)?.toInt() ?? 0,
      away: (json['away'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MatchScoreImplToJson(_$MatchScoreImpl instance) =>
    <String, dynamic>{'home': instance.home, 'away': instance.away};

_$MatchOddsImpl _$$MatchOddsImplFromJson(Map<String, dynamic> json) =>
    _$MatchOddsImpl(
      home: (json['home'] as num?)?.toDouble() ?? 0.0,
      draw: (json['draw'] as num?)?.toDouble() ?? 0.0,
      away: (json['away'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? '',
    );

Map<String, dynamic> _$$MatchOddsImplToJson(_$MatchOddsImpl instance) =>
    <String, dynamic>{
      'home': instance.home,
      'draw': instance.draw,
      'away': instance.away,
      'source': instance.source,
    };
