// lib/features/watch/data/repositories/watch_repository_impl.dart
import '../../../../core/utils/logger.dart';
import '../../domain/entities/watch_series.dart';
import '../../domain/entities/server.dart';
import '../../domain/repository/i_watch_repository.dart';
import '../datasources/watch_remote_datasource.dart';
import '../datasources/watch_local_datasource.dart';
import '../models/episode_model.dart';

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
      // 1. Get series data (this will use Anikoto or fallback)
      final series = await _remoteDataSource.getSeriesData(animeId, 'anime');

      // 2. Find the episode
      EpisodeModel? episode;
      for (final ep in series.episodes) {
        if (ep.number == episodeNumber) {
          episode = ep as EpisodeModel;
          break;
        }
      }

      if (episode == null) {
        AppLogger.warning('⚠️ Episode $episodeNumber not found');
        return [];
      }

      // 3. ✅ Get MegaVid servers (this works!)
      final megaVidServers = _remoteDataSource.getMegaVidServers(
        animeId: animeId,
        episode: episode,
      );

      if (megaVidServers.isNotEmpty) {
        AppLogger.success('✅ Found ${megaVidServers.length} MegaVid servers');
        return megaVidServers;
      }

      // 4. Fallback to FlixCloud
      AppLogger.info('⚠️ No MegaVid servers, trying FlixCloud...');
      final flixServers = await _remoteDataSource.getFlixCloudServers(
        animeId,
        episodeNumber,
      );

      return flixServers;
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to get episode stream', e, stackTrace);
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