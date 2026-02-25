// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisModelImpl _$$AnalysisModelImplFromJson(
  Map<String, dynamic> json,
) => _$AnalysisModelImpl(
  matchId: json['matchId'] as String,
  userId: json['userId'] as String,
  status: json['status'] as String? ?? 'pending',
  prediction: json['prediction'] == null
      ? null
      : PredictionModel.fromJson(json['prediction'] as Map<String, dynamic>),
  categories: json['categories'] == null
      ? null
      : AnalysisCategories.fromJson(json['categories'] as Map<String, dynamic>),
  vetoRules:
      (json['vetoRules'] as List<dynamic>?)
          ?.map((e) => VetoRule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  weightedTotal: json['weightedTotal'] == null
      ? null
      : WeightedTotal.fromJson(json['weightedTotal'] as Map<String, dynamic>),
  dataIntelligence: json['dataIntelligence'] == null
      ? null
      : DataIntelligence.fromJson(
          json['dataIntelligence'] as Map<String, dynamic>,
        ),
  xgAnalysis: json['xgAnalysis'] as String? ?? '',
  fixtureAnalysis: json['fixtureAnalysis'] as String? ?? '',
  injuryReport: json['injuryReport'] as String? ?? '',
  setPieceBreakdown: json['setPieceBreakdown'] as String? ?? '',
  refereeImpact: json['refereeImpact'] as String? ?? '',
  detailedNarrative: json['detailedNarrative'] as String? ?? '',
  rawGeminiResponse: json['rawGeminiResponse'] as String? ?? '',
  modelUsed: json['modelUsed'] as String? ?? 'gemini-3.1-pro-preview',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$$AnalysisModelImplToJson(_$AnalysisModelImpl instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'userId': instance.userId,
      'status': instance.status,
      'prediction': instance.prediction,
      'categories': instance.categories,
      'vetoRules': instance.vetoRules,
      'weightedTotal': instance.weightedTotal,
      'dataIntelligence': instance.dataIntelligence,
      'xgAnalysis': instance.xgAnalysis,
      'fixtureAnalysis': instance.fixtureAnalysis,
      'injuryReport': instance.injuryReport,
      'setPieceBreakdown': instance.setPieceBreakdown,
      'refereeImpact': instance.refereeImpact,
      'detailedNarrative': instance.detailedNarrative,
      'rawGeminiResponse': instance.rawGeminiResponse,
      'modelUsed': instance.modelUsed,
      'createdAt': instance.createdAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

_$PredictionModelImpl _$$PredictionModelImplFromJson(
  Map<String, dynamic> json,
) => _$PredictionModelImpl(
  result: json['result'] as String? ?? '',
  resultLabel: json['resultLabel'] as String? ?? '',
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
  surpriseAlert: json['surpriseAlert'] as bool? ?? false,
  bankoLevel: json['bankoLevel'] as String? ?? '',
  mainReason: json['mainReason'] as String? ?? '',
);

Map<String, dynamic> _$$PredictionModelImplToJson(
  _$PredictionModelImpl instance,
) => <String, dynamic>{
  'result': instance.result,
  'resultLabel': instance.resultLabel,
  'confidence': instance.confidence,
  'surpriseAlert': instance.surpriseAlert,
  'bankoLevel': instance.bankoLevel,
  'mainReason': instance.mainReason,
};

_$CategoryScoreImpl _$$CategoryScoreImplFromJson(Map<String, dynamic> json) =>
    _$CategoryScoreImpl(
      homeScore: (json['homeScore'] as num?)?.toDouble() ?? 0.0,
      awayScore: (json['awayScore'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      detail: json['detail'] as String? ?? '',
    );

Map<String, dynamic> _$$CategoryScoreImplToJson(_$CategoryScoreImpl instance) =>
    <String, dynamic>{
      'homeScore': instance.homeScore,
      'awayScore': instance.awayScore,
      'weight': instance.weight,
      'detail': instance.detail,
    };

_$AnalysisCategoriesImpl _$$AnalysisCategoriesImplFromJson(
  Map<String, dynamic> json,
) => _$AnalysisCategoriesImpl(
  power: json['power'] == null
      ? null
      : CategoryScore.fromJson(json['power'] as Map<String, dynamic>),
  tactics: json['tactics'] == null
      ? null
      : CategoryScore.fromJson(json['tactics'] as Map<String, dynamic>),
  psychology: json['psychology'] == null
      ? null
      : CategoryScore.fromJson(json['psychology'] as Map<String, dynamic>),
  externalFactors: json['externalFactors'] == null
      ? null
      : CategoryScore.fromJson(json['externalFactors'] as Map<String, dynamic>),
  market: json['market'] == null
      ? null
      : CategoryScore.fromJson(json['market'] as Map<String, dynamic>),
  referee: json['referee'] == null
      ? null
      : CategoryScore.fromJson(json['referee'] as Map<String, dynamic>),
  setPieces: json['setPieces'] == null
      ? null
      : CategoryScore.fromJson(json['setPieces'] as Map<String, dynamic>),
  physical: json['physical'] == null
      ? null
      : CategoryScore.fromJson(json['physical'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AnalysisCategoriesImplToJson(
  _$AnalysisCategoriesImpl instance,
) => <String, dynamic>{
  'power': instance.power,
  'tactics': instance.tactics,
  'psychology': instance.psychology,
  'externalFactors': instance.externalFactors,
  'market': instance.market,
  'referee': instance.referee,
  'setPieces': instance.setPieces,
  'physical': instance.physical,
};

_$VetoRuleImpl _$$VetoRuleImplFromJson(Map<String, dynamic> json) =>
    _$VetoRuleImpl(
      rule: json['rule'] as String? ?? '',
      affectedTeam: json['affectedTeam'] as String? ?? '',
      penalty: json['penalty'] as String? ?? '',
      affectedCategory: json['affectedCategory'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );

Map<String, dynamic> _$$VetoRuleImplToJson(_$VetoRuleImpl instance) =>
    <String, dynamic>{
      'rule': instance.rule,
      'affectedTeam': instance.affectedTeam,
      'penalty': instance.penalty,
      'affectedCategory': instance.affectedCategory,
      'reason': instance.reason,
    };

_$WeightedTotalImpl _$$WeightedTotalImplFromJson(Map<String, dynamic> json) =>
    _$WeightedTotalImpl(
      home: (json['home'] as num?)?.toDouble() ?? 0.0,
      away: (json['away'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$WeightedTotalImplToJson(_$WeightedTotalImpl instance) =>
    <String, dynamic>{'home': instance.home, 'away': instance.away};

_$DataIntelligenceImpl _$$DataIntelligenceImplFromJson(
  Map<String, dynamic> json,
) => _$DataIntelligenceImpl(
  weather: json['weather'] == null
      ? null
      : WeatherData.fromJson(json['weather'] as Map<String, dynamic>),
  injuries: json['injuries'] == null
      ? null
      : InjuryData.fromJson(json['injuries'] as Map<String, dynamic>),
  referee: json['referee'] == null
      ? null
      : RefereeData.fromJson(json['referee'] as Map<String, dynamic>),
  restDays: json['restDays'] == null
      ? null
      : RestDaysData.fromJson(json['restDays'] as Map<String, dynamic>),
  xgData: json['xgData'] == null
      ? null
      : XgData.fromJson(json['xgData'] as Map<String, dynamic>),
  headToHead: json['headToHead'] == null
      ? null
      : HeadToHeadData.fromJson(json['headToHead'] as Map<String, dynamic>),
  stadiumInfo: json['stadiumInfo'] == null
      ? null
      : StadiumData.fromJson(json['stadiumInfo'] as Map<String, dynamic>),
  fixtureContext: json['fixtureContext'] == null
      ? null
      : FixtureContext.fromJson(json['fixtureContext'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DataIntelligenceImplToJson(
  _$DataIntelligenceImpl instance,
) => <String, dynamic>{
  'weather': instance.weather,
  'injuries': instance.injuries,
  'referee': instance.referee,
  'restDays': instance.restDays,
  'xgData': instance.xgData,
  'headToHead': instance.headToHead,
  'stadiumInfo': instance.stadiumInfo,
  'fixtureContext': instance.fixtureContext,
};

_$WeatherDataImpl _$$WeatherDataImplFromJson(Map<String, dynamic> json) =>
    _$WeatherDataImpl(
      temperature: json['temperature'] as String? ?? '',
      humidity: json['humidity'] as String? ?? '',
      rain: json['rain'] as String? ?? '',
      wind: json['wind'] as String? ?? '',
      impact: json['impact'] as String? ?? '',
    );

Map<String, dynamic> _$$WeatherDataImplToJson(_$WeatherDataImpl instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'rain': instance.rain,
      'wind': instance.wind,
      'impact': instance.impact,
    };

_$InjuryDataImpl _$$InjuryDataImplFromJson(Map<String, dynamic> json) =>
    _$InjuryDataImpl(
      homeTeamOut:
          (json['homeTeamOut'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      awayTeamOut:
          (json['awayTeamOut'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      homeTeamDoubtful:
          (json['homeTeamDoubtful'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      awayTeamDoubtful:
          (json['awayTeamDoubtful'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InjuryDataImplToJson(_$InjuryDataImpl instance) =>
    <String, dynamic>{
      'homeTeamOut': instance.homeTeamOut,
      'awayTeamOut': instance.awayTeamOut,
      'homeTeamDoubtful': instance.homeTeamDoubtful,
      'awayTeamDoubtful': instance.awayTeamDoubtful,
    };

_$RefereeDataImpl _$$RefereeDataImplFromJson(Map<String, dynamic> json) =>
    _$RefereeDataImpl(
      name: json['name'] as String? ?? '',
      avgFoulsPerMatch: (json['avgFoulsPerMatch'] as num?)?.toDouble() ?? 0.0,
      avgYellowCards: (json['avgYellowCards'] as num?)?.toDouble() ?? 0.0,
      avgPenalties: (json['avgPenalties'] as num?)?.toDouble() ?? 0.0,
      varReferee: json['varReferee'] as String? ?? '',
    );

Map<String, dynamic> _$$RefereeDataImplToJson(_$RefereeDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avgFoulsPerMatch': instance.avgFoulsPerMatch,
      'avgYellowCards': instance.avgYellowCards,
      'avgPenalties': instance.avgPenalties,
      'varReferee': instance.varReferee,
    };

_$RestDaysDataImpl _$$RestDaysDataImplFromJson(Map<String, dynamic> json) =>
    _$RestDaysDataImpl(
      home: (json['home'] as num?)?.toInt() ?? 0,
      away: (json['away'] as num?)?.toInt() ?? 0,
      lastMatchHome: json['lastMatchHome'] as String? ?? '',
      lastMatchAway: json['lastMatchAway'] as String? ?? '',
    );

Map<String, dynamic> _$$RestDaysDataImplToJson(_$RestDaysDataImpl instance) =>
    <String, dynamic>{
      'home': instance.home,
      'away': instance.away,
      'lastMatchHome': instance.lastMatchHome,
      'lastMatchAway': instance.lastMatchAway,
    };

_$XgDataImpl _$$XgDataImplFromJson(Map<String, dynamic> json) => _$XgDataImpl(
  homeXg: (json['homeXg'] as num?)?.toDouble() ?? 0.0,
  homeXga: (json['homeXga'] as num?)?.toDouble() ?? 0.0,
  awayXg: (json['awayXg'] as num?)?.toDouble() ?? 0.0,
  awayXga: (json['awayXga'] as num?)?.toDouble() ?? 0.0,
  source: json['source'] as String? ?? '',
);

Map<String, dynamic> _$$XgDataImplToJson(_$XgDataImpl instance) =>
    <String, dynamic>{
      'homeXg': instance.homeXg,
      'homeXga': instance.homeXga,
      'awayXg': instance.awayXg,
      'awayXga': instance.awayXga,
      'source': instance.source,
    };

_$HeadToHeadDataImpl _$$HeadToHeadDataImplFromJson(Map<String, dynamic> json) =>
    _$HeadToHeadDataImpl(
      last5: json['last5'] as String? ?? '',
      homeWins: (json['homeWins'] as num?)?.toInt() ?? 0,
      draws: (json['draws'] as num?)?.toInt() ?? 0,
      awayWins: (json['awayWins'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HeadToHeadDataImplToJson(
  _$HeadToHeadDataImpl instance,
) => <String, dynamic>{
  'last5': instance.last5,
  'homeWins': instance.homeWins,
  'draws': instance.draws,
  'awayWins': instance.awayWins,
};

_$StadiumDataImpl _$$StadiumDataImplFromJson(Map<String, dynamic> json) =>
    _$StadiumDataImpl(
      name: json['name'] as String? ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      altitude: (json['altitude'] as num?)?.toInt() ?? 0,
      pitchType: json['pitchType'] as String? ?? '',
      pitchDimensions: json['pitchDimensions'] as String? ?? '',
    );

Map<String, dynamic> _$$StadiumDataImplToJson(_$StadiumDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'capacity': instance.capacity,
      'altitude': instance.altitude,
      'pitchType': instance.pitchType,
      'pitchDimensions': instance.pitchDimensions,
    };

_$FixtureContextImpl _$$FixtureContextImplFromJson(Map<String, dynamic> json) =>
    _$FixtureContextImpl(
      homeNextMatch: json['homeNextMatch'] as String? ?? '',
      awayNextMatch: json['awayNextMatch'] as String? ?? '',
      targetMatchSyndrome: json['targetMatchSyndrome'] as String? ?? '',
    );

Map<String, dynamic> _$$FixtureContextImplToJson(
  _$FixtureContextImpl instance,
) => <String, dynamic>{
  'homeNextMatch': instance.homeNextMatch,
  'awayNextMatch': instance.awayNextMatch,
  'targetMatchSyndrome': instance.targetMatchSyndrome,
};
