// lib/features/watch/domain/entities/watch_series.dart
import 'package:equatable/equatable.dart';
import 'episode.dart';

class WatchSeries extends Equatable {
  final String id;
  final String? aniId;
  final String title;
  final String? englishTitle;
  final String? nativeTitle;
  final String? poster;
  final String? bannerImage;
  final String? description;
  final int? duration;
  final String? status;
  final String? format;
  final int? totalEpisodes;
  final List<Episode> episodes;
  final String? type;

  const WatchSeries({
    required this.id,
    this.aniId,
    required this.title,
    this.englishTitle,
    this.nativeTitle,
    this.poster,
    this.bannerImage,
    this.description,
    this.duration,
    this.status,
    this.format,
    this.totalEpisodes,
    this.episodes = const [],
    this.type,
  });

  String get bestTitle => englishTitle ?? title;

  bool get isReleasing => status?.toLowerCase() == 'releasing';
  bool get isFinished => status?.toLowerCase() == 'finished';

  @override
  List<Object?> get props => [
        id,
        aniId,
        title,
        englishTitle,
        nativeTitle,
        poster,
        bannerImage,
        description,
        duration,
        status,
        format,
        totalEpisodes,
        episodes,
        type,
      ];
}