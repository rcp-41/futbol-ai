import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Kullanıcı modeli — SPEC.md Bölüm 4.1 users/ şeması
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    @Default('') String displayName,
    String? email,
    String? photoUrl,
    @Default('free') String tier,
    @Default(0) int dailyAnalysisCount,
    @Default('') String lastAnalysisDate,
    @Default([]) List<String> favoriteTeams,
    @Default(UserSettings()) UserSettings settings,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default('dark') String theme,
    @Default('tr') String language,
    @Default(true) bool notifications,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
