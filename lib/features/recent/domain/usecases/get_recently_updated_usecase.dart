// lib/features/recent/domain/usecases/get_recently_updated_usecase.dart
import '../entities/recent_anime.dart';
import '../repository/i_recent_repository.dart';

class GetRecentlyUpdatedUseCase {
  final IRecentRepository repository;

  GetRecentlyUpdatedUseCase(this.repository);

  Future<List<RecentAnime>> call({int page = 1, int perPage = 20}) async {
    return await repository.getRecentlyUpdated(page: page, perPage: perPage);
  }
}