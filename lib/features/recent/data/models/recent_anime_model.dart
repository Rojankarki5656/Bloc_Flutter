// lib/features/recent/data/models/recent_anime_model.dart
import '../../domain/entities/recent_anime.dart';

class RecentAnimeModel extends RecentAnime {
  const RecentAnimeModel({
    required super.id,
    required super.title,
    super.alternative,
    super.native,
    super.slug,
    super.rating,
    super.poster,
    super.description,
    super.aired,
    super.season,
    super.year,
    super.duration,
    super.status,
    super.score,
    super.malId,
    super.episodes,
    super.aniId,
    super.source,
    super.sId,
    super.backgroundImage,
    super.updatedAt,
    super.currentEpisode,
    super.genres,
    super.studios,
    super.producers,
  });

  factory RecentAnimeModel.fromJson(Map<String, dynamic> json) {
    // Parse current episode
    RecentEpisodes? currentEpisode;
    if (json['current_episode'] is Map) {
      final epData = json['current_episode'] as Map<String, dynamic>;
      Map<String, String>? embedUrl;
      if (epData['embed_url'] is Map) {
        embedUrl = Map<String, String>.from(
          (epData['embed_url'] as Map).map(
            (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
          ),
        );
      }
      currentEpisode = RecentEpisodes(
        title: epData['title']?.toString(),
        jpTitle: epData['jp_title']?.toString(),
        number: (epData['number'] as num?)?.toInt() ?? 1,
        episodeEmbedId: epData['episode_embed_id']?.toString(),
        embedUrl: embedUrl,
      );
    }

    // Parse terms_by_type
    List<String> genres = [];
    List<String> studios = [];
    List<String> producers = [];

    if (json['terms_by_type'] is Map) {
      final terms = json['terms_by_type'] as Map<String, dynamic>;

      if (terms['genre'] is List) {
        genres = (terms['genre'] as List).map((e) => e.toString()).toList();
      }
      if (terms['studios'] is List) {
        studios = (terms['studios'] as List).map((e) => e.toString()).toList();
      }
      if (terms['producers'] is List) {
        producers = (terms['producers'] as List).map((e) => e.toString()).toList();
      }
    }

    return RecentAnimeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? 'Unknown',
      alternative: json['alternative']?.toString(),
      native: json['native']?.toString(),
      slug: json['slug']?.toString(),
      rating: json['rating']?.toString(),
      poster: json['poster']?.toString(),
      description: json['description']?.toString(),
      aired: json['aired']?.toString(),
      season: json['season']?.toString(),
      year: (json['year'] as num?)?.toInt(),
      duration: json['duration']?.toString(),
      status: json['status']?.toString(),
      score: json['score']?.toString(),
      malId: json['mal_id']?.toString(),
      episodes: int.tryParse(json['episodes']?.toString() ?? ''),
      aniId: json['ani_id']?.toString(),
      source: json['source']?.toString(),
      sId: (json['s_id'] as num?)?.toInt(),
      backgroundImage: json['background_image']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      currentEpisode: currentEpisode,
      genres: genres,
      studios: studios,
      producers: producers,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'alternative': alternative,
        'native': native,
        'slug': slug,
        'rating': rating,
        'poster': poster,
        'description': description,
        'aired': aired,
        'season': season,
        'year': year,
        'duration': duration,
        'status': status,
        'score': score,
        'mal_id': malId,
        'episodes': episodes,
        'ani_id': aniId,
        'source': source,
        's_id': sId,
        'background_image': backgroundImage,
        'updated_at': updatedAt,
        'current_episode': currentEpisode == null
            ? null
            : {
                'title': currentEpisode!.title,
                'jp_title': currentEpisode!.jpTitle,
                'number': currentEpisode!.number,
                'episode_embed_id': currentEpisode!.episodeEmbedId,
                'embed_url': currentEpisode!.embedUrl,
              },
        'terms_by_type': {
          'genre': genres,
          'studios': studios,
          'producers': producers,
        },
      };
}