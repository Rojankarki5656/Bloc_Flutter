// lib/features/watch/domain/usecases/save_watch_progress_usecase.dart
import '../repository/i_watch_repository.dart';

class SaveWatchProgressUseCase {
  final IWatchRepository repository;

  SaveWatchProgressUseCase(this.repository);

  Future<void> call({
    required String animeId,
    required String title,
    required String poster,
    required int episode,
    required String type,
    required int progress,
    required int currentTime,
    required int duration,
  }) async {
    if (animeId.isEmpty) return;
    await repository.saveWatchProgress(
      animeId: animeId,
      title: title,
      poster: poster,
      episode: episode,
      type: type,
      progress: progress,
      currentTime: currentTime,
      duration: duration,
    );
  }
}