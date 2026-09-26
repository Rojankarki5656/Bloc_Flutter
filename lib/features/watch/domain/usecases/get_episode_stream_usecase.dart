// lib/features/watch/domain/usecases/get_episode_stream_usecase.dart
import '../entities/server.dart';
import '../repository/i_watch_repository.dart';

class GetEpisodeStreamUseCase {
  final IWatchRepository repository;

  GetEpisodeStreamUseCase(this.repository);

  Future<List<StreamingServer>> call(
    String animeId,
    int episodeNumber, {
    String? server,
  }) async {
    if (animeId.isEmpty) {
      throw Exception('Anime ID cannot be empty');
    }
    if (episodeNumber < 1) {
      throw Exception('Episode number must be greater than 0');
    }
    return await repository.getEpisodeStream(
      animeId,
      episodeNumber,
      server: server,
    );
  }
}