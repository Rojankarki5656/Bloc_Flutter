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
        '${ApiEndpoints.anikoto}/api/recent-anime',
        queryParams: {
          'page': page,
          'per_page': perPage,
        },
      );

      AppLogger.debug('📦 Recent response keys: ${response.keys}');

      // Handle nested response structure
      final data = response['data'] ?? response;
      final results = data['results'] ?? data['data'] ?? data;

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