// lib/features/anime/data/models/anime_model.dart
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
    @JsonKey(name: 'coverImage', fromJson: _posterFromJson) super.poster,
    @JsonKey(name: 'bannerImage') super.bannerImage,
    @JsonKey(name: 'description') super.description,
    @JsonKey(name: 'format') super.format,
    @JsonKey(name: 'status') super.status,
    @JsonKey(name: 'episodes') super.episodes,
    @JsonKey(name: 'duration') super.duration,
    @JsonKey(name: 'season') super.season,
    @JsonKey(name: 'seasonYear') super.seasonYear,
    @JsonKey(name: 'averageScore') super.averageScore,
    @JsonKey(name: 'popularity') super.popularity,
    @JsonKey(name: 'favourites') super.favorites,
    @JsonKey(name: 'genres') super.genres,
    @JsonKey(name: 'synonyms') super.synonyms,
    @JsonKey(name: 'source') super.source,
    @JsonKey(name: 'isAdult') super.isAdult,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeModelFromJson(_normalizeJson(json));

  Map<String, dynamic> toJson() => _$AnimeModelToJson(this);

  // Helper to extract poster from coverImage object
  static String? _posterFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return value['large'] ??
          value['medium'] ??
          value['extraLarge'] as String?;
    }
    return null;
  }

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    final title = json['title'];

    if (title is Map<String, dynamic>) {
      normalized['title'] =
          title['english'] ?? title['romaji'] ?? title['native'] ?? '';
      normalized['englishTitle'] = title['english'];
      normalized['nativeTitle'] = title['native'];
    }

    if (json['coverImage'] is Map<String, dynamic>) {
      normalized['poster'] = _posterFromJson(json['coverImage']);
    }

    return normalized;
  }
}
