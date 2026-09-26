// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) =>
    SearchResultModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      englishTitle: json['englishTitle'] as String?,
      poster: json['poster'] as String?,
      format: json['format'] as String?,
      episodes: (json['episodes'] as num?)?.toInt(),
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      status: json['status'] as String?,
      year: (json['year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'englishTitle': instance.englishTitle,
      'poster': instance.poster,
      'format': instance.format,
      'episodes': instance.episodes,
      'averageScore': instance.averageScore,
      'status': instance.status,
      'year': instance.year,
    };
