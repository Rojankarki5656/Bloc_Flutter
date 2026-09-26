// lib/features/watch/domain/usecases/get_series_data_usecase.dart
import '../entities/watch_series.dart';
import '../repository/i_watch_repository.dart';

class GetSeriesDataUseCase {
  final IWatchRepository repository;

  GetSeriesDataUseCase(this.repository);

  Future<WatchSeries> call(String id, String type) async {
    if (id.isEmpty) {
      throw Exception('Anime ID cannot be empty');
    }
    return await repository.getSeriesData(id, type);
  }
}