// lib/features/home/data/models/anime_model.dart
import '../../domain/entities/anime.dart';

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

  /// Parse JSON manually
  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    // Handle title object
    final titleObj = json['title'] as Map<String, dynamic>? ?? {};
    final title = titleObj['english'] as String? ?? 
                   titleObj['romaji'] as String? ?? 
                   titleObj['native'] as String? ?? 
                   'Unknown';

    // Handle cover image
    final coverImage = json['coverImage'] as Map<String, dynamic>? ?? {};
    final poster = coverImage['large'] as String? ?? 
                   coverImage['medium'] as String?;

    return AnimeModel(
      id: json['id'] as int? ?? 0,
      title: title,
      englishTitle: titleObj['english'] as String?,
      nativeTitle: titleObj['native'] as String?,
      poster: poster,
      bannerImage: json['bannerImage'] as String?,
      description: json['description'] as String?,
      format: json['format'] as String?,
      status: json['status'] as String?,
      episodes: json['episodes'] as int?,
      duration: json['duration'] as int?,
      season: json['season'] as String?,
      seasonYear: json['seasonYear'] as int?,
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      popularity: json['popularity'] as int?,
      favorites: json['favourites'] as int?,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>(),
      synonyms: (json['synonyms'] as List<dynamic>?)?.cast<String>(),
      source: json['source'] as String?,
      isAdult: json['isAdult'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'englishTitle': englishTitle,
    'nativeTitle': nativeTitle,
    'poster': poster,
    'bannerImage': bannerImage,
    'description': description,
    'format': format,
    'status': status,
    'episodes': episodes,
    'duration': duration,
    'season': season,
    'seasonYear': seasonYear,
    'averageScore': averageScore,
    'popularity': popularity,
    'favourites': favorites,
    'genres': genres,
    'synonyms': synonyms,
    'source': source,
    'isAdult': isAdult,
  };
}