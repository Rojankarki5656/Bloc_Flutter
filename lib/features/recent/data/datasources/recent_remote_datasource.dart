// lib/features/recent/data/datasources/recent_remote_datasource.dart
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../models/recent_anime_model.dart';

class RecentRemoteDataSource {
  final ApiService _apiService;

  RecentRemoteDataSource(this._apiService);

  /// Get recently added anime
  Future<List<RecentAnimeModel>> getRecentlyAdded({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      AppLogger.debug('🆕 Fetching recently added: page=$page, perPage=$perPage');

      final response = await _apiService.get(
        '${ApiEndpoints.baseUrl}/recent-anime',
        queryParams: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (response is! Map) {
        AppLogger.warning('⚠️ Invalid recent response: expected an object');
        return [];
      }

      AppLogger.debug('📦 Recent response keys: ${response.keys}');

      // Handle nested response structure
      final rawData = response['data'] ?? response;
      final data = rawData is Map ? rawData : null;
      final results = data == null
          ? rawData
          : data['results'] ?? data['data'] ?? data;

      if (results is! List) {
        AppLogger.warning('⚠️ Invalid response structure');
        return [];
      }

      return results
          .whereType<Map>()
          .map((item) => RecentAnimeModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      AppLogger.error('❌ Failed to fetch recently added', e);
      rethrow;
    }
  }

  /// Get recently updated anime (same endpoint but sorted by updated_at)
  Future<List<RecentAnimeModel>> getRecentlyUpdated({
    int page = 1,
    int perPage = 20,
  }) async {
    return getRecentlyAdded(page: page, perPage: perPage);
  }
}