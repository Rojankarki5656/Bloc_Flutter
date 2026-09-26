// lib/features/search/domain/usecases/search_anime_usecase.dart
import '../repository/i_search_repository.dart';
import '../../data/models/search_result_model.dart';

class SearchAnimeUseCase {
  final ISearchRepository repository;

  SearchAnimeUseCase(this.repository);

  Future<SearchResultSet> call({
    required String query,
    int page = 1,
    int perPage = 20,
    String? genre,
    String? format,
    String? status,
    String? sort,
  }) async {
    return await repository.search(
      query: query,
      page: page,
      perPage: perPage,
      genre: genre,
      format: format,
      status: status,
      sort: sort,
    );
  }
}

class SearchResultSet {
  final List<SearchResultModel> results;
  final bool hasMore;
  final int total;

  SearchResultSet({
    required this.results,
    required this.hasMore,
    required this.total,
  });
}