// lib/features/watch/data/datasources/watch_remote_datasource.dart
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../models/episode_model.dart';
import '../models/server_model.dart';
import '../models/watch_series_model.dart';

class WatchRemoteDataSource {
  final ApiService _apiService;

  WatchRemoteDataSource(this._apiService);

  /// Get series data with episodes
  Future<WatchSeriesModel> getSeriesData(String id, String type) async {
    try {
      AppLogger.debug('📺 Fetching series data: id=$id, type=$type');

      // 1. Try primary API (Anikoto)
      try {
        final response = await _apiService.get(
          '${ApiEndpoints.baseUrl}/api/watch',
          queryParams: {'id': id},
        );

        final outerData = response['data'];
        final innerData = outerData is Map && outerData['data'] is Map
            ? outerData['data']
            : outerData;

        if (innerData is Map && innerData['episodes'] is List) {
          final episodes = innerData['episodes'] as List;
          
          // ✅ If episodes have valid embed_url, use them
          if (episodes.isNotEmpty) {
            final firstEp = episodes.first;
            if (firstEp is Map && firstEp['embed_url'] is Map) {
              AppLogger.success('✅ Using Anikoto data with embed URLs');
              return WatchSeriesModel.fromJson(
                Map<String, dynamic>.from(innerData),
              );
            }
          }
        }
      } catch (primaryError) {
        AppLogger.warning('⚠️ Primary API failed: $primaryError');
      }

      // 2. Fallback: Use AniList + MegaVid
      AppLogger.info('📺 Using AniList + MegaVid fallback');
      return await _getFallbackSeriesData(id);
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to fetch series data', e, stackTrace);
      rethrow;
    }
  }

  /// Fallback using AniList for metadata + MegaVid for streaming
  Future<WatchSeriesModel> _getFallbackSeriesData(String id) async {
    final response = await _apiService.get(
      '${ApiEndpoints.baseUrl}/api/anime/$id',
    );

    final rawData = response['data'] ?? response;
    if (rawData is! Map) throw Exception('Anime not found');
    final data = Map<String, dynamic>.from(rawData);

    final totalEpisodes = (data['episodes'] as num?)?.toInt() ?? 12;

    // ✅ Create episodes with WORKING MegaVid URLs
    final episodes = List.generate(
      totalEpisodes,
      (index) => EpisodeModel.fromMegaVid(
        animeId: id,
        episodeNumber: index + 1,
        title: 'Episode ${index + 1}',
        hasSub: true,
        hasDub: false, // Set to true if you want dub option
      ),
    );

    return WatchSeriesModel(
      id: id,
      aniId: data['ani_id']?.toString() ?? id,
      title: data['title']?.toString() ?? 'Unknown',
      englishTitle: data['english']?.toString(),
      poster: data['poster']?.toString(),
      bannerImage: data['bannerImage']?.toString(),
      description: data['description']?.toString(),
      duration: (data['episodeDuration'] as num?)?.toInt(),
      status: data['status']?.toString(),
      format: data['format']?.toString(),
      totalEpisodes: totalEpisodes,
      episodes: episodes,
      type: 'anime',
    );
  }

  /// Get FlixCloud servers (secondary fallback)
  Future<List<ServerModel>> getFlixCloudServers(
    String anilistId,
    int episodeNumber,
  ) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.baseUrl}/api/flix/$anilistId/$episodeNumber',
      );

      final rawData = response['data'] ?? response;
      if (rawData is! Map) return [];
      final data = Map<String, dynamic>.from(rawData);
      final servers = data['servers'] as List<dynamic>? ?? [];

      if (servers.isEmpty) return [];

      return servers
          .whereType<Map>()
          .map((s) => ServerModel.fromJson(Map<String, dynamic>.from(s)))
          .toList();
    } catch (e) {
      AppLogger.error('❌ Failed to fetch FlixCloud servers', e);
      return [];
    }
  }

  /// Get MegaVid servers (PRIMARY)
  List<ServerModel> getMegaVidServers({
    required String animeId,
    required EpisodeModel episode,
  }) {
    final servers = <ServerModel>[];

    // Add SUB server
    if (episode.hasSub) {
      servers.add(ServerModel(
        id: 'megavid-sub-${episode.number}',
        name: 'SUB',
        url: episode.subUrl!,
        language: 'sub',
        type: 'iframe',
      ));
    }

    // Add DUB server
    if (episode.hasDub) {
      servers.add(ServerModel(
        id: 'megavid-dub-${episode.number}',
        name: 'DUB',
        url: episode.dubUrl!,
        language: 'dub',
        type: 'iframe',
      ));
    }

    // If no servers from embed URLs, create from scratch
    if (servers.isEmpty) {
      servers.add(ServerModel(
        id: 'megavid-sub-${episode.number}',
        name: 'SUB',
        url: ApiEndpoints.buildMegaVidUrl(
          animeId,
          episode.number,
          language: 'sub',
        ),
        language: 'sub',
        type: 'iframe',
      ));
    }

    return servers;
  }
}