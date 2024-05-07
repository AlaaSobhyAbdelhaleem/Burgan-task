// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: (json['id'] as num).toInt(),
      publishedDate: json['published_date'] as String?,
      title: json['title'] as String,
      content: json['abstract'] as String,
      byline: json['byline'] as String,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      section: json['section'] as String,
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'published_date': instance.publishedDate,
      'title': instance.title,
      'abstract': instance.content,
      'byline': instance.byline,
      'media': instance.media,
      'section': instance.section,
    };
