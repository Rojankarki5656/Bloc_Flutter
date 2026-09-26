// lib/features/recent/data/repositories/recent_repository_impl.dart
import '../../domain/entities/recent_anime.dart';
import '../../domain/repository/i_recent_repository.dart';
import '../datasources/recent_remote_datasource.dart';

class RecentRepositoryImpl implements IRecentRepository {
  final RecentRemoteDataSource _remoteDataSource;

  RecentRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<RecentAnime>> getRecentlyAdded({
    int page = 1,
    int perPage = 20,
  }) async {
    return await _remoteDataSource.getRecentlyAdded(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<List<RecentAnime>> getRecentlyUpdated({
    int page = 1,
    int perPage = 20,
  }) async {
    return await _remoteDataSource.getRecentlyUpdated(
      page: page,
      perPage: perPage,
    );
  }
}