// lib/features/search/data/repositories/search_repository_impl.dart
import '../../domain/repository/i_search_repository.dart';
import '../../domain/usecases/search_anime_usecase.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/search_result_model.dart';

class SearchRepositoryImpl implements ISearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<SearchResultSet> search({
    required String query,
    int page = 1,
    int perPage = 20,
    String? genre,
    String? format,
    String? status,
    String? sort,
  }) async {
    final models = await _remoteDataSource.search(
      query: query,
      page: page,
      perPage: perPage,
      genre: genre,
      format: format,
      status: status,
      sort: sort,
    );

    final results = models.map((model) => model as SearchResultModel).toList();
    // Determine hasMore based on response size (could also be from pageInfo)
    final hasMore = results.length == perPage;
    return SearchResultSet(
      results: results,
      hasMore: hasMore,
      total: results.length,
    );
  }
}