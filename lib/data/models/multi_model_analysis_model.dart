import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/firebase_helpers.dart'; // Assuming Timestamp converter exists

part 'multi_model_analysis_model.freezed.dart';
part 'multi_model_analysis_model.g.dart';

@freezed
class MultiModelAnalysisModel with _$MultiModelAnalysisModel {
  const factory MultiModelAnalysisModel({
    required String matchId,
    required String userId,
    required String status, // 'pending', 'verifying', 'analyzing', 'ai_processing', 'consensus', 'completed', 'failed'
    String? statusMessage,
    String? error,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    VerificationResult? verification,
    DeepAnalysisResult? deepAnalysis,
    AIModelResult? geminiResult,
    AIModelResult? claudeResult,
    ConsensusResult? consensusResult,
  }) = _MultiModelAnalysisModel;

  factory MultiModelAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$MultiModelAnalysisModelFromJson(json);
}

@freezed
class VerificationResult with _$VerificationResult {
  const factory VerificationResult({
    required bool verified,
    required bool dateValid,
    required int sourcesChecked,
    required int sourcesValid,
    required int dataCompleteness,
    required List<String> warnings,
  }) = _VerificationResult;

  factory VerificationResult.fromJson(Map<String, dynamic> json) =>
      _$VerificationResultFromJson(json);
}

@freezed
class DeepAnalysisResult with _$DeepAnalysisResult {
  const factory DeepAnalysisResult({
    required Map<String, dynamic> weather,
    required Map<String, dynamic> missingPlayers,
    required Map<String, dynamic> homeAwayForm,
    required Map<String, dynamic> h2h,
    required Map<String, dynamic> xg,
    required Map<String, dynamic> setPieces,
    required Map<String, dynamic> referee,
    required Map<String, dynamic> tactics,
  }) = _DeepAnalysisResult;

  factory DeepAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$DeepAnalysisResultFromJson(json);
}

@freezed
class AIModelResult with _$AIModelResult {
  const factory AIModelResult({
    required String modelName,
    required double homeWinProbability,
    required double drawProbability,
    required double awayWinProbability,
    required double over25Probability,
    required double under25Probability,
    required double bttsProbability,
    required String predictedScore,
    required List<String> topPredictions,
    required List<String> keyFactors,
    required String gameNarrative,
    required double confidenceScore,
  }) = _AIModelResult;

  factory AIModelResult.fromJson(Map<String, dynamic> json) =>
      _$AIModelResultFromJson(json);
}

@freezed
class ConsensusResult with _$ConsensusResult {
  const factory ConsensusResult({
    required double homeWinProbability,
    required double drawProbability,
    required double awayWinProbability,
    required double over25Probability,
    required double under25Probability,
    required double bttsProbability,
    required String predictedScore,
    required List<String> topPredictions,
    required String consensusReasoning,
    required double confidenceScore,
    @Default(false) bool fallback,
    String? modelName,
  }) = _ConsensusResult;

  factory ConsensusResult.fromJson(Map<String, dynamic> json) =>
      _$ConsensusResultFromJson(json);
}
