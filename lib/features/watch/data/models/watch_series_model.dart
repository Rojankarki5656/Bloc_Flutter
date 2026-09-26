// lib/features/watch/data/models/watch_series_model.dart
import '../../domain/entities/watch_series.dart';
import '../../domain/entities/episode.dart';
import 'episode_model.dart';

class WatchSeriesModel extends WatchSeries {
  const WatchSeriesModel({
    required super.id,
    super.aniId,
    required super.title,
    super.englishTitle,
    super.nativeTitle,
    super.poster,
    super.bannerImage,
    super.description,
    super.duration,
    super.status,
    super.format,
    super.totalEpisodes,
    super.episodes,
    super.type,
  });

  factory WatchSeriesModel.fromJson(Map<String, dynamic> json) {
    // Extract episodes
    List<Episode> episodes = [];
    if (json['episodes'] is List) {
      episodes = (json['episodes'] as List)
          .whereType<Map>()
          .map((e) => EpisodeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      // Sort by episode number
      episodes.sort((a, b) => a.number.compareTo(b.number));
    }

    // Extract title
    String title = 'Unknown';
    String? englishTitle;
    String? nativeTitle;

    if (json['title'] is String) {
      title = json['title'];
    } else if (json['title'] is Map) {
      final titleMap = json['title'] as Map;
      title = (titleMap['romaji'] ??
              titleMap['english'] ??
              titleMap['native'] ??
              'Unknown')
          .toString();
      englishTitle = titleMap['english']?.toString();
      nativeTitle = titleMap['native']?.toString();
    }

    // Extract poster
    String? poster;
    if (json['poster'] is String) {
      poster = json['poster'];
    } else if (json['coverImage'] is Map) {
      final cover = json['coverImage'] as Map;
      poster = (cover['large'] ?? cover['extraLarge'] ?? cover['medium'])
          ?.toString();
    }

    return WatchSeriesModel(
      id: json['id']?.toString() ?? '',
      aniId: json['ani_id']?.toString() ?? json['aniId']?.toString(),
      title: title,
      englishTitle: englishTitle ?? json['english']?.toString(),
      nativeTitle: nativeTitle ?? json['native']?.toString(),
      poster: poster,
      bannerImage: json['bannerImage']?.toString(),
      description: json['description']?.toString(),
      duration: (json['duration'] as num?)?.toInt() ??
          (json['episodeDuration'] as num?)?.toInt(),
      status: json['status']?.toString(),
      format: json['format']?.toString(),
      totalEpisodes:
          (json['totalEpisodes'] as num?)?.toInt() ?? episodes.length,
      episodes: episodes,
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ani_id': aniId,
        'title': title,
        'english': englishTitle,
        'native': nativeTitle,
        'poster': poster,
        'bannerImage': bannerImage,
        'description': description,
        'duration': duration,
        'status': status,
        'format': format,
        'totalEpisodes': totalEpisodes,
        'episodes': episodes.map((e) => (e as EpisodeModel).toJson()).toList(),
        'type': type,
      };
}
