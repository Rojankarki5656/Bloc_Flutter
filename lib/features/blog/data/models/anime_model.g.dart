// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeModel _$AnimeModelFromJson(Map<String, dynamic> json) => AnimeModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      englishTitle: json['englishTitle'] as String?,
      nativeTitle: json['nativeTitle'] as String?,
      poster: json['poster'] as String?,
      bannerImage: json['bannerImage'] as String?,
      description: json['description'] as String?,
      format: json['format'] as String?,
      status: json['status'] as String?,
      episodes: (json['episodes'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      season: json['season'] as String?,
      seasonYear: (json['seasonYear'] as num?)?.toInt(),
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      popularity: (json['popularity'] as num?)?.toInt(),
      favorites: (json['favorites'] as num?)?.toInt(),
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      synonyms: (json['synonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      source: json['source'] as String?,
      isAdult: json['isAdult'] as bool? ?? false,
    );

Map<String, dynamic> _$AnimeModelToJson(AnimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'englishTitle': instance.englishTitle,
      'nativeTitle': instance.nativeTitle,
      'poster': instance.poster,
      'bannerImage': instance.bannerImage,
      'description': instance.description,
      'format': instance.format,
      'status': instance.status,
      'episodes': instance.episodes,
      'duration': instance.duration,
      'season': instance.season,
      'seasonYear': instance.seasonYear,
      'averageScore': instance.averageScore,
      'popularity': instance.popularity,
      'favorites': instance.favorites,
      'genres': instance.genres,
      'synonyms': instance.synonyms,
      'source': instance.source,
      'isAdult': instance.isAdult,
    };
