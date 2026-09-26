// lib/features/watch/domain/usecases/get_watch_progress_usecase.dart
import '../repository/i_watch_repository.dart';

class GetWatchProgressUseCase {
  final IWatchRepository repository;

  GetWatchProgressUseCase(this.repository);

  Future<WatchProgress?> call(String animeId) async {
    if (animeId.isEmpty) return null;
    return await repository.getWatchProgress(animeId);
  }
}