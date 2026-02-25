// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      tier: json['tier'] as String? ?? 'free',
      dailyAnalysisCount: (json['dailyAnalysisCount'] as num?)?.toInt() ?? 0,
      lastAnalysisDate: json['lastAnalysisDate'] as String? ?? '',
      favoriteTeams:
          (json['favoriteTeams'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      settings: json['settings'] == null
          ? const UserSettings()
          : UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'tier': instance.tier,
      'dailyAnalysisCount': instance.dailyAnalysisCount,
      'lastAnalysisDate': instance.lastAnalysisDate,
      'favoriteTeams': instance.favoriteTeams,
      'settings': instance.settings,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
    };

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'tr',
      notifications: json['notifications'] as bool? ?? true,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'language': instance.language,
      'notifications': instance.notifications,
    };
