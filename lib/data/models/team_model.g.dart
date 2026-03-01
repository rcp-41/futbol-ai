// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamModelImpl _$$TeamModelImplFromJson(Map<String, dynamic> json) =>
    _$TeamModelImpl(
      slug: json['slug'] as String,
      name: json['name'] as String,
      league: json['league'] as String? ?? '',
      ids: json['ids'] == null
          ? null
          : TeamIds.fromJson(json['ids'] as Map<String, dynamic>),
      manager: json['manager'] == null
          ? null
          : ManagerInfo.fromJson(json['manager'] as Map<String, dynamic>),
      stadium: json['stadium'] == null
          ? null
          : StadiumInfo.fromJson(json['stadium'] as Map<String, dynamic>),
      squad:
          (json['squad'] as List<dynamic>?)
              ?.map((e) => SquadPlayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      injuries:
          (json['injuries'] as List<dynamic>?)
              ?.map((e) => InjuryInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suspended:
          (json['suspended'] as List<dynamic>?)
              ?.map((e) => SuspendedPlayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transferRumors:
          (json['transferRumors'] as List<dynamic>?)
              ?.map((e) => TransferRumor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transfers: json['transfers'] == null
          ? null
          : TeamTransfers.fromJson(json['transfers'] as Map<String, dynamic>),
      news:
          (json['news'] as List<dynamic>?)
              ?.map((e) => TeamNewsItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentForm:
          (json['recentForm'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalSquadValue: (json['totalSquadValue'] as num?)?.toInt() ?? 0,
      averageAge: (json['averageAge'] as num?)?.toDouble() ?? 0.0,
      managerHistory:
          (json['managerHistory'] as List<dynamic>?)
              ?.map(
                (e) => ManagerHistoryEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      seasonStats: json['seasonStats'] as Map<String, dynamic>? ?? const {},
      dataHash: json['dataHash'] as String? ?? '',
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$TeamModelImplToJson(_$TeamModelImpl instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'league': instance.league,
      'ids': instance.ids,
      'manager': instance.manager,
      'stadium': instance.stadium,
      'squad': instance.squad,
      'injuries': instance.injuries,
      'suspended': instance.suspended,
      'transferRumors': instance.transferRumors,
      'transfers': instance.transfers,
      'news': instance.news,
      'recentForm': instance.recentForm,
      'totalSquadValue': instance.totalSquadValue,
      'averageAge': instance.averageAge,
      'managerHistory': instance.managerHistory,
      'seasonStats': instance.seasonStats,
      'dataHash': instance.dataHash,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_$TeamIdsImpl _$$TeamIdsImplFromJson(Map<String, dynamic> json) =>
    _$TeamIdsImpl(
      sofascore: (json['sofascore'] as num?)?.toInt() ?? 0,
      transfermarkt: json['transfermarkt'] as String? ?? '',
      fbref: json['fbref'] as String? ?? '',
    );

Map<String, dynamic> _$$TeamIdsImplToJson(_$TeamIdsImpl instance) =>
    <String, dynamic>{
      'sofascore': instance.sofascore,
      'transfermarkt': instance.transfermarkt,
      'fbref': instance.fbref,
    };

_$ManagerInfoImpl _$$ManagerInfoImplFromJson(Map<String, dynamic> json) =>
    _$ManagerInfoImpl(
      name: json['name'] as String? ?? '',
      since: json['since'] as String? ?? '',
      matches: (json['matches'] as num?)?.toInt() ?? 0,
      winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
      nationality: json['nationality'] as String? ?? '',
      previousClubs:
          (json['previousClubs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ManagerInfoImplToJson(_$ManagerInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'since': instance.since,
      'matches': instance.matches,
      'winRate': instance.winRate,
      'nationality': instance.nationality,
      'previousClubs': instance.previousClubs,
    };

_$StadiumInfoImpl _$$StadiumInfoImplFromJson(Map<String, dynamic> json) =>
    _$StadiumInfoImpl(
      name: json['name'] as String? ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      city: json['city'] as String? ?? '',
      builtYear: (json['builtYear'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$StadiumInfoImplToJson(_$StadiumInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'capacity': instance.capacity,
      'city': instance.city,
      'builtYear': instance.builtYear,
    };

_$SquadPlayerImpl _$$SquadPlayerImplFromJson(Map<String, dynamic> json) =>
    _$SquadPlayerImpl(
      name: json['name'] as String,
      position: json['position'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      age: (json['age'] as num?)?.toInt() ?? 0,
      marketValue: (json['marketValue'] as num?)?.toInt() ?? 0,
      contractUntil: json['contractUntil'] as String? ?? '',
      status: json['status'] as String? ?? 'fit',
      nationality: json['nationality'] as String? ?? '',
      sofascoreId: (json['sofascoreId'] as num?)?.toInt() ?? 0,
      transfermarktId: json['transfermarktId'] as String? ?? '',
      weeklyWage: (json['weeklyWage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$SquadPlayerImplToJson(_$SquadPlayerImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'number': instance.number,
      'age': instance.age,
      'marketValue': instance.marketValue,
      'contractUntil': instance.contractUntil,
      'status': instance.status,
      'nationality': instance.nationality,
      'sofascoreId': instance.sofascoreId,
      'transfermarktId': instance.transfermarktId,
      'weeklyWage': instance.weeklyWage,
    };

_$InjuryInfoImpl _$$InjuryInfoImplFromJson(Map<String, dynamic> json) =>
    _$InjuryInfoImpl(
      player: json['player'] as String? ?? '',
      type: json['type'] as String? ?? '',
      since: json['since'] as String? ?? '',
      expectedReturn: json['expectedReturn'] as String? ?? '',
      gamesMissed: (json['gamesMissed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$InjuryInfoImplToJson(_$InjuryInfoImpl instance) =>
    <String, dynamic>{
      'player': instance.player,
      'type': instance.type,
      'since': instance.since,
      'expectedReturn': instance.expectedReturn,
      'gamesMissed': instance.gamesMissed,
    };

_$SuspendedPlayerImpl _$$SuspendedPlayerImplFromJson(
  Map<String, dynamic> json,
) => _$SuspendedPlayerImpl(
  player: json['player'] as String? ?? '',
  reason: json['reason'] as String? ?? '',
  returnDate: json['returnDate'] as String? ?? '',
);

Map<String, dynamic> _$$SuspendedPlayerImplToJson(
  _$SuspendedPlayerImpl instance,
) => <String, dynamic>{
  'player': instance.player,
  'reason': instance.reason,
  'returnDate': instance.returnDate,
};

_$TransferRumorImpl _$$TransferRumorImplFromJson(Map<String, dynamic> json) =>
    _$TransferRumorImpl(
      player: json['player'] as String? ?? '',
      type: json['type'] as String? ?? '',
      source: json['source'] as String? ?? '',
      date: json['date'] as String? ?? '',
      reliability: json['reliability'] as String? ?? '',
    );

Map<String, dynamic> _$$TransferRumorImplToJson(_$TransferRumorImpl instance) =>
    <String, dynamic>{
      'player': instance.player,
      'type': instance.type,
      'source': instance.source,
      'date': instance.date,
      'reliability': instance.reliability,
    };

_$TeamTransfersImpl _$$TeamTransfersImplFromJson(Map<String, dynamic> json) =>
    _$TeamTransfersImpl(
      transferIn:
          (json['transferIn'] as List<dynamic>?)
              ?.map((e) => TransferEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transferOut:
          (json['transferOut'] as List<dynamic>?)
              ?.map((e) => TransferEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TeamTransfersImplToJson(_$TeamTransfersImpl instance) =>
    <String, dynamic>{
      'transferIn': instance.transferIn,
      'transferOut': instance.transferOut,
    };

_$TransferEntryImpl _$$TransferEntryImplFromJson(Map<String, dynamic> json) =>
    _$TransferEntryImpl(
      player: json['player'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      fee: (json['fee'] as num?)?.toInt() ?? 0,
      date: json['date'] as String? ?? '',
    );

Map<String, dynamic> _$$TransferEntryImplToJson(_$TransferEntryImpl instance) =>
    <String, dynamic>{
      'player': instance.player,
      'from': instance.from,
      'to': instance.to,
      'fee': instance.fee,
      'date': instance.date,
    };

_$TeamNewsItemImpl _$$TeamNewsItemImplFromJson(Map<String, dynamic> json) =>
    _$TeamNewsItemImpl(
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      source: json['source'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$$TeamNewsItemImplToJson(_$TeamNewsItemImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date,
      'summary': instance.summary,
      'source': instance.source,
      'url': instance.url,
    };

_$ManagerHistoryEntryImpl _$$ManagerHistoryEntryImplFromJson(
  Map<String, dynamic> json,
) => _$ManagerHistoryEntryImpl(
  name: json['name'] as String? ?? '',
  from: json['from'] as String? ?? '',
  to: json['to'] as String? ?? '',
  matches: (json['matches'] as num?)?.toInt() ?? 0,
  winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$ManagerHistoryEntryImplToJson(
  _$ManagerHistoryEntryImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'from': instance.from,
  'to': instance.to,
  'matches': instance.matches,
  'winRate': instance.winRate,
};
