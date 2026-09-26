// lib/features/watch/data/repositories/watch_repository_impl.dart
import '../../../../core/utils/logger.dart';
import '../../domain/entities/watch_series.dart';
import '../../domain/entities/server.dart';
import '../../domain/repository/i_watch_repository.dart';
import '../datasources/watch_remote_datasource.dart';
import '../datasources/watch_local_datasource.dart';

class WatchRepositoryImpl implements IWatchRepository {
  final WatchRemoteDataSource _remoteDataSource;
  final WatchLocalDataSource _localDataSource;

  WatchRepositoryImpl({
    required WatchRemoteDataSource remoteDataSource,
    required WatchLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<WatchSeries> getSeriesData(String id, String type) async {
    return await _remoteDataSource.getSeriesData(id, type);
  }

  @override
  Future<List<StreamingServer>> getEpisodeStream(
    String animeId,
    int episodeNumber, {
    String? server,
  }) async {
    try {
      // If FlixCloud server requested, fetch from FlixCloud
      if (server == 'flixcloud') {
        final flixServers = await _remoteDataSource.getFlixCloudServers(
          animeId,
          episodeNumber,
        );
        if (flixServers.isNotEmpty) {
          return flixServers;
        }
      }

      // Default: Get from series data
      final series = await _remoteDataSource.getSeriesData(animeId, 'anime');
      final episode = series.episodes.firstWhere(
        (e) => e.number == episodeNumber,
        orElse: () => series.episodes.first,
      );

      return _remoteDataSource.getMegaPlayServers(episode, animeId);
    } catch (e) {
      AppLogger.error('❌ Failed to get episode stream', e);
      return [];
    }
  }

  @override
  Future<List<StreamingServer>> getFlixCloudServers(
    String anilistId,
    int episodeNumber,
  ) async {
    return await _remoteDataSource.getFlixCloudServers(
      anilistId,
      episodeNumber,
    );
  }

  @override
  Future<void> saveWatchProgress({
    required String animeId,
    required String title,
    required String poster,
    required int episode,
    required String type,
    required int progress,
    required int currentTime,
    required int duration,
  }) async {
    final watchProgress = WatchProgress(
      animeId: animeId,
      title: title,
      poster: poster,
      episode: episode,
      type: type,
      progress: progress,
      currentTime: currentTime,
      duration: duration,
      updatedAt: DateTime.now(),
    );

    await _localDataSource.saveProgress(watchProgress);
  }

  @override
  Future<WatchProgress?> getWatchProgress(String animeId) async {
    return _localDataSource.getProgress(animeId);
  }

  @override
  Future<void> removeWatchProgress(String animeId) async {
    await _localDataSource.removeProgress(animeId);
  }
}
