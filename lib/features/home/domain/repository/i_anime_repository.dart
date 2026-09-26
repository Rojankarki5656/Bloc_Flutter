// lib/features/home/domain/repositories/i_anime_repository.dart
import '../entities/anime.dart';
import '../entities/home_data.dart';

abstract class IAnimeRepository {
  Future<HomeData> getHomeData();
  Future<List<Anime>> getTrendingAnime({int page = 1, int perPage = 12});
  Future<List<Anime>> getPopularAnime({int page = 1, int perPage = 12});
  Future<List<Anime>> getUpcomingAnime({int page = 1, int perPage = 12});
  Future<List<Anime>> getTop100Anime({int page = 1, int perPage = 20});
  Future<Anime> getAnimeDetail(int id);
  Future<List<Anime>> searchAnime(String query, {int page = 1, int perPage = 20});
}