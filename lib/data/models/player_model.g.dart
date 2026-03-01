// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerModelImpl _$$PlayerModelImplFromJson(Map<String, dynamic> json) =>
    _$PlayerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? '',
      ids: json['ids'] == null
          ? null
          : PlayerIds.fromJson(json['ids'] as Map<String, dynamic>),
      team: json['team'] as String? ?? '',
      league: json['league'] as String? ?? '',
      position: json['position'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      height: (json['height'] as num?)?.toInt() ?? 0,
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      preferredFoot: json['preferredFoot'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      contractUntil: json['contractUntil'] as String? ?? '',
      weeklyWage: (json['weeklyWage'] as num?)?.toDouble(),
      marketValue: (json['marketValue'] as num?)?.toInt() ?? 0,
      marketValueHistory:
          (json['marketValueHistory'] as List<dynamic>?)
              ?.map((e) => MarketValueEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seasonStats: json['seasonStats'] as Map<String, dynamic>? ?? const {},
      careerHistory:
          (json['careerHistory'] as List<dynamic>?)
              ?.map((e) => CareerEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      scouting: json['scouting'] == null
          ? null
          : ScoutingData.fromJson(json['scouting'] as Map<String, dynamic>),
      injuries:
          (json['injuries'] as List<dynamic>?)
              ?.map((e) => PlayerInjury.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nationalTeam: json['nationalTeam'] == null
          ? null
          : NationalTeamInfo.fromJson(
              json['nationalTeam'] as Map<String, dynamic>,
            ),
      dataHash: json['dataHash'] as String? ?? '',
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$PlayerModelImplToJson(_$PlayerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'ids': instance.ids,
      'team': instance.team,
      'league': instance.league,
      'position': instance.position,
      'nationality': instance.nationality,
      'dateOfBirth': instance.dateOfBirth,
      'height': instance.height,
      'weight': instance.weight,
      'preferredFoot': instance.preferredFoot,
      'number': instance.number,
      'contractUntil': instance.contractUntil,
      'weeklyWage': instance.weeklyWage,
      'marketValue': instance.marketValue,
      'marketValueHistory': instance.marketValueHistory,
      'seasonStats': instance.seasonStats,
      'careerHistory': instance.careerHistory,
      'scouting': instance.scouting,
      'injuries': instance.injuries,
      'nationalTeam': instance.nationalTeam,
      'dataHash': instance.dataHash,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_$PlayerIdsImpl _$$PlayerIdsImplFromJson(Map<String, dynamic> json) =>
    _$PlayerIdsImpl(
      sofascore: (json['sofascore'] as num?)?.toInt() ?? 0,
      transfermarkt: json['transfermarkt'] as String? ?? '',
      fbref: json['fbref'] as String? ?? '',
    );

Map<String, dynamic> _$$PlayerIdsImplToJson(_$PlayerIdsImpl instance) =>
    <String, dynamic>{
      'sofascore': instance.sofascore,
      'transfermarkt': instance.transfermarkt,
      'fbref': instance.fbref,
    };

_$MarketValueEntryImpl _$$MarketValueEntryImplFromJson(
  Map<String, dynamic> json,
) => _$MarketValueEntryImpl(
  date: json['date'] as String? ?? '',
  value: (json['value'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$MarketValueEntryImplToJson(
  _$MarketValueEntryImpl instance,
) => <String, dynamic>{'date': instance.date, 'value': instance.value};

_$CareerEntryImpl _$$CareerEntryImplFromJson(Map<String, dynamic> json) =>
    _$CareerEntryImpl(
      team: json['team'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String?,
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      goals: (json['goals'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CareerEntryImplToJson(_$CareerEntryImpl instance) =>
    <String, dynamic>{
      'team': instance.team,
      'from': instance.from,
      'to': instance.to,
      'matches': instance.matches,
      'goals': instance.goals,
    };

_$ScoutingDataImpl _$$ScoutingDataImplFromJson(Map<String, dynamic> json) =>
    _$ScoutingDataImpl(
      percentiles:
          (json['percentiles'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      source: json['source'] as String? ?? 'fbref',
    );

Map<String, dynamic> _$$ScoutingDataImplToJson(_$ScoutingDataImpl instance) =>
    <String, dynamic>{
      'percentiles': instance.percentiles,
      'source': instance.source,
    };

_$PlayerInjuryImpl _$$PlayerInjuryImplFromJson(Map<String, dynamic> json) =>
    _$PlayerInjuryImpl(
      type: json['type'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      days: (json['days'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlayerInjuryImplToJson(_$PlayerInjuryImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'from': instance.from,
      'to': instance.to,
      'days': instance.days,
    };

_$NationalTeamInfoImpl _$$NationalTeamInfoImplFromJson(
  Map<String, dynamic> json,
) => _$NationalTeamInfoImpl(
  team: json['team'] as String? ?? '',
  caps: (json['caps'] as num?)?.toInt() ?? 0,
  goals: (json['goals'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$NationalTeamInfoImplToJson(
  _$NationalTeamInfoImpl instance,
) => <String, dynamic>{
  'team': instance.team,
  'caps': instance.caps,
  'goals': instance.goals,
};
