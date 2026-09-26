// lib/features/home/data/repositories/anime_repository_impl.dart
import '../../domain/entities/anime.dart';
import '../../domain/repository/i_anime_repository.dart';
import '../datasources/remote/anime_remote_datasource.dart';
import '../models/anime_model.dart';

class AnimeRepositoryImpl implements IAnimeRepository {
  final AnimeRemoteDataSource _remoteDataSource;

  AnimeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Anime>> getTrendingAnime({int page = 1, int perPage = 12}) async {
    final models = await _remoteDataSource.getTrendingAnime(page: page, perPage: perPage);
    return models;
  }

  @override
  Future<List<Anime>> getPopularAnime({int page = 1, int perPage = 12}) async {
    final models = await _remoteDataSource.getPopularAnime(page: page, perPage: perPage);
    return models;
  }

  @override
  Future<List<Anime>> getUpcomingAnime({int page = 1, int perPage = 12}) async {
    final models = await _remoteDataSource.getUpcomingAnime(page: page, perPage: perPage);
    return models;
  }

  @override
  Future<List<Anime>> getTop100Anime({int page = 1, int perPage = 20}) async {
    // Use popular anime as top 100
    final models = await _remoteDataSource.getPopularAnime(page: page, perPage: perPage);
    return models;
  }

  @override
  Future<Anime> getAnimeDetail(int id) async {
    return await _remoteDataSource.getAnimeDetail(id);
  }

  @override
  Future<List<Anime>> searchAnime(String query, {int page = 1, int perPage = 20}) async {
    // Implement search using the search data source
    // This would be in the search feature
    return [];
  }
}