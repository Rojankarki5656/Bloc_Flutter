// lib/features/home/domain/usecases/get_recommendations_usecase.dart
import '../entities/anime.dart';
import '../repository/i_anime_repository.dart';

class GetRecommendationsUseCase {
  final IAnimeRepository repository;

  GetRecommendationsUseCase(this.repository);

  Future<List<Anime>> call({int page = 1, int perPage = 12}) async {
    return await repository.getPopularAnime(page: page, perPage: perPage);
  }
}