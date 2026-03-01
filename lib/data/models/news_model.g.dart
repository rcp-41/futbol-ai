// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsModelImpl _$$NewsModelImplFromJson(Map<String, dynamic> json) =>
    _$NewsModelImpl(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      content: json['content'] as String? ?? '',
      source: json['source'] as String? ?? '',
      sourceUrl: json['sourceUrl'] as String? ?? '',
      author: json['author'] as String? ?? '',
      relatedTeam: json['relatedTeam'] as String? ?? '',
      relatedPlayers:
          (json['relatedPlayers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$$NewsModelImplToJson(_$NewsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'summary': instance.summary,
      'content': instance.content,
      'source': instance.source,
      'sourceUrl': instance.sourceUrl,
      'author': instance.author,
      'relatedTeam': instance.relatedTeam,
      'relatedPlayers': instance.relatedPlayers,
      'tags': instance.tags,
    };
