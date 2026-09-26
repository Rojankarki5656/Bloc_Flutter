// lib/features/recent/domain/usecases/get_recently_added_usecase.dart
import '../entities/recent_anime.dart';
import '../repository/i_recent_repository.dart';

class GetRecentlyAddedUseCase {
  final IRecentRepository repository;

  GetRecentlyAddedUseCase(this.repository);

  Future<List<RecentAnime>> call({int page = 1, int perPage = 20}) async {
    return await repository.getRecentlyAdded(page: page, perPage: perPage);
  }
}