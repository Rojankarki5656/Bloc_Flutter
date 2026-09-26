// lib/features/recent/domain/entities/recent_anime.dart
import 'package:equatable/equatable.dart';

class RecentAnime extends Equatable {
  final int id;
  final String title;
  final String? alternative;
  final String? native;
  final String? slug;
  final String? rating;
  final String? poster;
  final String? description;
  final String? aired;
  final String? season;
  final int? year;
  final String? duration;
  final String? status;
  final String? score;
  final String? malId;
  final int? episodes;
  final String? aniId;
  final String? source;
  final int? sId;
  final String? backgroundImage;
  final String? updatedAt;
  final RecentEpisodes? currentEpisode;
  final List<String> genres;
  final List<String> studios;
  final List<String> producers;

  const RecentAnime({
    required this.id,
    required this.title,
    this.alternative,
    this.native,
    this.slug,
    this.rating,
    this.poster,
    this.description,
    this.aired,
    this.season,
    this.year,
    this.duration,
    this.status,
    this.score,
    this.malId,
    this.episodes,
    this.aniId,
    this.source,
    this.sId,
    this.backgroundImage,
    this.updatedAt,
    this.currentEpisode,
    this.genres = const [],
    this.studios = const [],
    this.producers = const [],
  });

  /// Get best display title
  String get bestTitle => alternative ?? title;

  /// Get formatted score
  String get displayScore => score ?? 'N/A';

  /// Get episode info
  String get episodeInfo {
    if (currentEpisode != null) {
      return 'Ep ${currentEpisode!.number}';
    }
    if (episodes != null) {
      return '$episodes eps';
    }
    return '?';
  }

  /// Check if currently airing
  bool get isAiring => status?.toLowerCase().contains('airing') ?? false;

  @override
  List<Object?> get props => [
        id,
        title,
        alternative,
        native,
        slug,
        rating,
        poster,
        description,
        aired,
        season,
        year,
        duration,
        status,
        score,
        malId,
        episodes,
        aniId,
        source,
        sId,
        backgroundImage,
        updatedAt,
        currentEpisode,
        genres,
        studios,
        producers,
      ];
}

class RecentEpisodes extends Equatable {
  final String? title;
  final String? jpTitle;
  final int number;
  final String? episodeEmbedId;
  final Map<String, String>? embedUrl;

  const RecentEpisodes({
    this.title,
    this.jpTitle,
    required this.number,
    this.episodeEmbedId,
    this.embedUrl,
  });

  String? get subUrl => embedUrl?['sub'];
  String? get dubUrl => embedUrl?['dub'];
  bool get hasSub => subUrl != null && subUrl!.isNotEmpty;
  bool get hasDub => dubUrl != null && dubUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
        title,
        jpTitle,
        number,
        episodeEmbedId,
        embedUrl,
      ];
}