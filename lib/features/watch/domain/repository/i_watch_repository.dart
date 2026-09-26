// lib/features/watch/domain/repository/i_watch_repository.dart
import '../entities/watch_series.dart';
import '../entities/episode.dart';
import '../entities/server.dart';

abstract class IWatchRepository {
  /// Get series data with episodes
  Future<WatchSeries> getSeriesData(String id, String type);

  /// Get episode stream servers
  Future<List<StreamingServer>> getEpisodeStream(
    String animeId,
    int episodeNumber, {
    String? server,
  });

  /// Get FlixCloud servers
  Future<List<StreamingServer>> getFlixCloudServers(
    String anilistId,
    int episodeNumber,
  );

  /// Save watch progress
  Future<void> saveWatchProgress({
    required String animeId,
    required String title,
    required String poster,
    required int episode,
    required String type,
    required int progress,
    required int currentTime,
    required int duration,
  });

  /// Get watch progress for an anime
  Future<WatchProgress?> getWatchProgress(String animeId);

  /// Remove watch progress
  Future<void> removeWatchProgress(String animeId);
}

class WatchProgress {
  final String animeId;
  final String title;
  final String poster;
  final int episode;
  final String type;
  final int progress;
  final int currentTime;
  final int duration;
  final DateTime updatedAt;

  const WatchProgress({
    required this.animeId,
    required this.title,
    required this.poster,
    required this.episode,
    required this.type,
    required this.progress,
    required this.currentTime,
    required this.duration,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': animeId,
        'title': title,
        'poster': poster,
        'episode': episode,
        'type': type,
        'progress': progress,
        'currentTime': currentTime,
        'duration': duration,
        'timestamp': updatedAt.millisecondsSinceEpoch,
      };

  factory WatchProgress.fromJson(Map<String, dynamic> json) {
    return WatchProgress(
      animeId: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown',
      poster: json['poster']?.toString() ?? '',
      episode: (json['episode'] as num?)?.toInt() ?? 1,
      type: json['type']?.toString() ?? 'anime',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      currentTime: (json['currentTime'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] as num?)?.toInt() ?? 0,
      ),
    );
  }
}