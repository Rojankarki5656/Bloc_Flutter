// lib/features/search/data/datasources/search_remote_datasource.dart
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/search_result_model.dart';

class SearchRemoteDataSource {
  final ApiService _apiService;

  SearchRemoteDataSource(this._apiService);

  Future<List<SearchResultModel>> search({
    required String query,
    int page = 1,
    int perPage = 20,
    String? genre,
    String? format,
    String? status,
    String? sort,
  }) async {
    final searchQuery = '''
      query (\$search: String, \$page: Int, \$perPage: Int, \$genre: String, \$format: MediaFormat, \$status: MediaStatus, \$sort: [MediaSort]) {
        Page(page: \$page, perPage: \$perPage) {
          pageInfo { hasNextPage total }
          media(search: \$search, type: ANIME, genre: \$genre, format: \$format, status: \$status, sort: \$sort) {
            id
            title { romaji english native }
            coverImage { large medium }
            format
            episodes
            averageScore
            status
            startDate { year }
          }
        }
      }
    ''';

    final variables = {
      'search': query,
      'page': page,
      'perPage': perPage,
      'genre': genre,
      'format': format,
      'status': status,
      'sort': [sort ?? 'POPULARITY_DESC'],
    };

    final response = await _apiService.graphQL(searchQuery, variables: variables);
    final pageData = response['data']['Page'];
    final media = pageData['media'] as List<dynamic>? ?? [];
    return media.map((json) => SearchResultModel.fromJson(json)).toList();
  }
}