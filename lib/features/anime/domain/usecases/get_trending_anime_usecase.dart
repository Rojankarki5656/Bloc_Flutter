// lib/features/home/domain/usecases/get_trending_anime_usecase.dart
import '../entities/anime.dart';
import '../repository/i_anime_repository.dart';

class GetTrendingAnimeUseCase {
  final IAnimeRepository repository;

  GetTrendingAnimeUseCase(this.repository);

  Future<List<Anime>> call({int page = 1, int perPage = 12}) async {
    return await repository.getTrendingAnime(page: page, perPage: perPage);
  }
}