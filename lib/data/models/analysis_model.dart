import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_model.freezed.dart';
part 'analysis_model.g.dart';

/// Analiz sonuç modeli — SPEC.md Bölüm 4.1 analyses/ şeması
@freezed
class AnalysisModel with _$AnalysisModel {
  const factory AnalysisModel({
    required String matchId,
    required String userId,
    @Default('pending') String status,
    PredictionModel? prediction,
    AnalysisCategories? categories,
    @Default([]) List<VetoRule> vetoRules,
    WeightedTotal? weightedTotal,
    DataIntelligence? dataIntelligence,
    @Default('') String xgAnalysis,
    @Default('') String fixtureAnalysis,
    @Default('') String injuryReport,
    @Default('') String setPieceBreakdown,
    @Default('') String refereeImpact,
    @Default('') String detailedNarrative,
    @Default('') String rawGeminiResponse,
    @Default('gemini-3.1-pro-preview') String modelUsed,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) = _AnalysisModel;

  factory AnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisModelFromJson(json);
}

@freezed
class PredictionModel with _$PredictionModel {
  const factory PredictionModel({
    @Default('') String result,
    @Default('') String resultLabel,
    @Default(0.0) double confidence,
    @Default(false) bool surpriseAlert,
    @Default('') String bankoLevel,
    @Default('') String mainReason,
  }) = _PredictionModel;

  factory PredictionModel.fromJson(Map<String, dynamic> json) =>
      _$PredictionModelFromJson(json);
}

@freezed
class CategoryScore with _$CategoryScore {
  const factory CategoryScore({
    @Default(0.0) double homeScore,
    @Default(0.0) double awayScore,
    @Default(0.0) double weight,
    @Default('') String detail,
  }) = _CategoryScore;

  factory CategoryScore.fromJson(Map<String, dynamic> json) =>
      _$CategoryScoreFromJson(json);
}

@freezed
class AnalysisCategories with _$AnalysisCategories {
  const factory AnalysisCategories({
    CategoryScore? power,
    CategoryScore? tactics,
    CategoryScore? psychology,
    CategoryScore? externalFactors,
    CategoryScore? market,
    CategoryScore? referee,
    CategoryScore? setPieces,
    CategoryScore? physical,
  }) = _AnalysisCategories;

  factory AnalysisCategories.fromJson(Map<String, dynamic> json) =>
      _$AnalysisCategoriesFromJson(json);
}

@freezed
class VetoRule with _$VetoRule {
  const factory VetoRule({
    @Default('') String rule,
    @Default('') String affectedTeam,
    @Default('') String penalty,
    @Default('') String affectedCategory,
    @Default('') String reason,
  }) = _VetoRule;

  factory VetoRule.fromJson(Map<String, dynamic> json) =>
      _$VetoRuleFromJson(json);
}

@freezed
class WeightedTotal with _$WeightedTotal {
  const factory WeightedTotal({
    @Default(0.0) double home,
    @Default(0.0) double away,
  }) = _WeightedTotal;

  factory WeightedTotal.fromJson(Map<String, dynamic> json) =>
      _$WeightedTotalFromJson(json);
}

@freezed
class DataIntelligence with _$DataIntelligence {
  const factory DataIntelligence({
    WeatherData? weather,
    InjuryData? injuries,
    RefereeData? referee,
    RestDaysData? restDays,
    XgData? xgData,
    HeadToHeadData? headToHead,
    StadiumData? stadiumInfo,
    FixtureContext? fixtureContext,
  }) = _DataIntelligence;

  factory DataIntelligence.fromJson(Map<String, dynamic> json) =>
      _$DataIntelligenceFromJson(json);
}

@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    @Default('') String temperature,
    @Default('') String humidity,
    @Default('') String rain,
    @Default('') String wind,
    @Default('') String impact,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}

@freezed
class InjuryData with _$InjuryData {
  const factory InjuryData({
    @Default([]) List<String> homeTeamOut,
    @Default([]) List<String> awayTeamOut,
    @Default([]) List<String> homeTeamDoubtful,
    @Default([]) List<String> awayTeamDoubtful,
  }) = _InjuryData;

  factory InjuryData.fromJson(Map<String, dynamic> json) =>
      _$InjuryDataFromJson(json);
}

@freezed
class RefereeData with _$RefereeData {
  const factory RefereeData({
    @Default('') String name,
    @Default(0.0) double avgFoulsPerMatch,
    @Default(0.0) double avgYellowCards,
    @Default(0.0) double avgPenalties,
    @Default('') String varReferee,
  }) = _RefereeData;

  factory RefereeData.fromJson(Map<String, dynamic> json) =>
      _$RefereeDataFromJson(json);
}

@freezed
class RestDaysData with _$RestDaysData {
  const factory RestDaysData({
    @Default(0) int home,
    @Default(0) int away,
    @Default('') String lastMatchHome,
    @Default('') String lastMatchAway,
  }) = _RestDaysData;

  factory RestDaysData.fromJson(Map<String, dynamic> json) =>
      _$RestDaysDataFromJson(json);
}

@freezed
class XgData with _$XgData {
  const factory XgData({
    @Default(0.0) double homeXg,
    @Default(0.0) double homeXga,
    @Default(0.0) double awayXg,
    @Default(0.0) double awayXga,
    @Default('') String source,
  }) = _XgData;

  factory XgData.fromJson(Map<String, dynamic> json) =>
      _$XgDataFromJson(json);
}

@freezed
class HeadToHeadData with _$HeadToHeadData {
  const factory HeadToHeadData({
    @Default('') String last5,
    @Default(0) int homeWins,
    @Default(0) int draws,
    @Default(0) int awayWins,
  }) = _HeadToHeadData;

  factory HeadToHeadData.fromJson(Map<String, dynamic> json) =>
      _$HeadToHeadDataFromJson(json);
}

@freezed
class StadiumData with _$StadiumData {
  const factory StadiumData({
    @Default('') String name,
    @Default(0) int capacity,
    @Default(0) int altitude,
    @Default('') String pitchType,
    @Default('') String pitchDimensions,
  }) = _StadiumData;

  factory StadiumData.fromJson(Map<String, dynamic> json) =>
      _$StadiumDataFromJson(json);
}

@freezed
class FixtureContext with _$FixtureContext {
  const factory FixtureContext({
    @Default('') String homeNextMatch,
    @Default('') String awayNextMatch,
    @Default('') String targetMatchSyndrome,
  }) = _FixtureContext;

  factory FixtureContext.fromJson(Map<String, dynamic> json) =>
      _$FixtureContextFromJson(json);
}
