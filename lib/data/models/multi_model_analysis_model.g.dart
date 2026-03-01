// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_model_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultiModelAnalysisModelImpl _$$MultiModelAnalysisModelImplFromJson(
  Map<String, dynamic> json,
) => _$MultiModelAnalysisModelImpl(
  matchId: json['matchId'] as String,
  userId: json['userId'] as String,
  status: json['status'] as String,
  statusMessage: json['statusMessage'] as String?,
  error: json['error'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  verification: json['verification'] == null
      ? null
      : VerificationResult.fromJson(
          json['verification'] as Map<String, dynamic>,
        ),
  deepAnalysis: json['deepAnalysis'] == null
      ? null
      : DeepAnalysisResult.fromJson(
          json['deepAnalysis'] as Map<String, dynamic>,
        ),
  geminiResult: json['geminiResult'] == null
      ? null
      : AIModelResult.fromJson(json['geminiResult'] as Map<String, dynamic>),
  claudeResult: json['claudeResult'] == null
      ? null
      : AIModelResult.fromJson(json['claudeResult'] as Map<String, dynamic>),
  consensusResult: json['consensusResult'] == null
      ? null
      : ConsensusResult.fromJson(
          json['consensusResult'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$MultiModelAnalysisModelImplToJson(
  _$MultiModelAnalysisModelImpl instance,
) => <String, dynamic>{
  'matchId': instance.matchId,
  'userId': instance.userId,
  'status': instance.status,
  'statusMessage': instance.statusMessage,
  'error': instance.error,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'verification': instance.verification,
  'deepAnalysis': instance.deepAnalysis,
  'geminiResult': instance.geminiResult,
  'claudeResult': instance.claudeResult,
  'consensusResult': instance.consensusResult,
};

_$VerificationResultImpl _$$VerificationResultImplFromJson(
  Map<String, dynamic> json,
) => _$VerificationResultImpl(
  verified: json['verified'] as bool,
  dateValid: json['dateValid'] as bool,
  sourcesChecked: (json['sourcesChecked'] as num).toInt(),
  sourcesValid: (json['sourcesValid'] as num).toInt(),
  dataCompleteness: (json['dataCompleteness'] as num).toInt(),
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$VerificationResultImplToJson(
  _$VerificationResultImpl instance,
) => <String, dynamic>{
  'verified': instance.verified,
  'dateValid': instance.dateValid,
  'sourcesChecked': instance.sourcesChecked,
  'sourcesValid': instance.sourcesValid,
  'dataCompleteness': instance.dataCompleteness,
  'warnings': instance.warnings,
};

_$DeepAnalysisResultImpl _$$DeepAnalysisResultImplFromJson(
  Map<String, dynamic> json,
) => _$DeepAnalysisResultImpl(
  weather: json['weather'] as Map<String, dynamic>,
  missingPlayers: json['missingPlayers'] as Map<String, dynamic>,
  homeAwayForm: json['homeAwayForm'] as Map<String, dynamic>,
  h2h: json['h2h'] as Map<String, dynamic>,
  xg: json['xg'] as Map<String, dynamic>,
  setPieces: json['setPieces'] as Map<String, dynamic>,
  referee: json['referee'] as Map<String, dynamic>,
  tactics: json['tactics'] as Map<String, dynamic>,
);

Map<String, dynamic> _$$DeepAnalysisResultImplToJson(
  _$DeepAnalysisResultImpl instance,
) => <String, dynamic>{
  'weather': instance.weather,
  'missingPlayers': instance.missingPlayers,
  'homeAwayForm': instance.homeAwayForm,
  'h2h': instance.h2h,
  'xg': instance.xg,
  'setPieces': instance.setPieces,
  'referee': instance.referee,
  'tactics': instance.tactics,
};

_$AIModelResultImpl _$$AIModelResultImplFromJson(Map<String, dynamic> json) =>
    _$AIModelResultImpl(
      modelName: json['modelName'] as String,
      homeWinProbability: (json['homeWinProbability'] as num).toDouble(),
      drawProbability: (json['drawProbability'] as num).toDouble(),
      awayWinProbability: (json['awayWinProbability'] as num).toDouble(),
      over25Probability: (json['over25Probability'] as num).toDouble(),
      under25Probability: (json['under25Probability'] as num).toDouble(),
      bttsProbability: (json['bttsProbability'] as num).toDouble(),
      predictedScore: json['predictedScore'] as String,
      topPredictions: (json['topPredictions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      keyFactors: (json['keyFactors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gameNarrative: json['gameNarrative'] as String,
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
    );

Map<String, dynamic> _$$AIModelResultImplToJson(_$AIModelResultImpl instance) =>
    <String, dynamic>{
      'modelName': instance.modelName,
      'homeWinProbability': instance.homeWinProbability,
      'drawProbability': instance.drawProbability,
      'awayWinProbability': instance.awayWinProbability,
      'over25Probability': instance.over25Probability,
      'under25Probability': instance.under25Probability,
      'bttsProbability': instance.bttsProbability,
      'predictedScore': instance.predictedScore,
      'topPredictions': instance.topPredictions,
      'keyFactors': instance.keyFactors,
      'gameNarrative': instance.gameNarrative,
      'confidenceScore': instance.confidenceScore,
    };

_$ConsensusResultImpl _$$ConsensusResultImplFromJson(
  Map<String, dynamic> json,
) => _$ConsensusResultImpl(
  homeWinProbability: (json['homeWinProbability'] as num).toDouble(),
  drawProbability: (json['drawProbability'] as num).toDouble(),
  awayWinProbability: (json['awayWinProbability'] as num).toDouble(),
  over25Probability: (json['over25Probability'] as num).toDouble(),
  under25Probability: (json['under25Probability'] as num).toDouble(),
  bttsProbability: (json['bttsProbability'] as num).toDouble(),
  predictedScore: json['predictedScore'] as String,
  topPredictions: (json['topPredictions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  consensusReasoning: json['consensusReasoning'] as String,
  confidenceScore: (json['confidenceScore'] as num).toDouble(),
  fallback: json['fallback'] as bool? ?? false,
  modelName: json['modelName'] as String?,
);

Map<String, dynamic> _$$ConsensusResultImplToJson(
  _$ConsensusResultImpl instance,
) => <String, dynamic>{
  'homeWinProbability': instance.homeWinProbability,
  'drawProbability': instance.drawProbability,
  'awayWinProbability': instance.awayWinProbability,
  'over25Probability': instance.over25Probability,
  'under25Probability': instance.under25Probability,
  'bttsProbability': instance.bttsProbability,
  'predictedScore': instance.predictedScore,
  'topPredictions': instance.topPredictions,
  'consensusReasoning': instance.consensusReasoning,
  'confidenceScore': instance.confidenceScore,
  'fallback': instance.fallback,
  'modelName': instance.modelName,
};
