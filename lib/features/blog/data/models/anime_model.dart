// lib/features/home/data/models/anime_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/anime.dart';

part 'anime_model.g.dart';

@JsonSerializable()
class AnimeModel extends Anime {
  const AnimeModel({
    required super.id,
    required super.title,
    super.englishTitle,
    super.nativeTitle,
    super.poster,
    super.bannerImage,
    super.description,
    super.format,
    super.status,
    super.episodes,
    super.duration,
    super.season,
    super.seasonYear,
    super.averageScore,
    super.popularity,
    super.favorites,
    super.genres,
    super.synonyms,
    super.source,
    super.isAdult,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeModelToJson(this);
}