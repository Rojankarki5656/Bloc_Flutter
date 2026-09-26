// lib/features/search/domain/repositories/i_search_repository.dart
import '../usecases/search_anime_usecase.dart';

abstract class ISearchRepository {
  Future<SearchResultSet> search({
    required String query,
    int page = 1,
    int perPage = 20,
    String? genre,
    String? format,
    String? status,
    String? sort,
  });
}