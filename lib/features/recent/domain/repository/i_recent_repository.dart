// lib/features/recent/domain/repository/i_recent_repository.dart
import '../entities/recent_anime.dart';

abstract class IRecentRepository {
  Future<List<RecentAnime>> getRecentlyAdded({
    int page = 1,
    int perPage = 20,
  });

  Future<List<RecentAnime>> getRecentlyUpdated({
    int page = 1,
    int perPage = 20,
  });
}