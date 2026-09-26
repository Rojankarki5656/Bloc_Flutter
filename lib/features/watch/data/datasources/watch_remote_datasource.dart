// lib/features/watch/data/datasources/watch_remote_datasource.dart
import 'package:animeweebs/features/anime/data/models/anime_model.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/episode.dart';
import '../models/episode_model.dart';
import '../models/server_model.dart';
import '../models/watch_series_model.dart';

class WatchRemoteDataSource {
  final ApiService _apiService;

  WatchRemoteDataSource(this._apiService);

  //Get Episodes only

  Future<AnimeModel> getAnimeDetail(String id) async {
    const query = '''
      query (\$id: Int) {
        Media(id: \$id, type: ANIME) {
          id
          title { romaji english native }
          coverImage { large medium extraLarge }
          bannerImage
          format
          status
          episodes
          duration
          season
          seasonYear
          averageScore
          popularity
          favourites
          genres
          synonyms
          source
          isAdult
          description(asHtml: false)
          nextAiringEpisode { episode timeUntilAiring }
          studios(isMain: false) { nodes { id name } }
          tags { id name rank }
        }
      }
    ''';

    final variables = {
      'id': int.parse(id),
    };
    final response = await _apiService.graphQL(query, variables: variables);

    if (response is! Map) {
      throw Exception('Invalid anime response format');
    }

    final responseData = response['data'];
    if (responseData is! Map || responseData['Media'] is! Map) {
      throw Exception('Anime not found');
    }

    final media = Map<String, dynamic>.from(responseData['Media']);

    return AnimeModel.fromJson(media);
  }

  /// Get series data with episodes
  Future<WatchSeriesModel> getSeriesData(String id, String type) async {
    try {
      AppLogger.debug('📺 Fetching series data: id=$id, type=$type');

      // Try primary API first
      try {
        const endpoint = '${ApiEndpoints.baseUrl}/watch';
        AppLogger.debug('🌐 Fetching watch API: $endpoint?id=$id');
        final response = await _apiService.get(
          endpoint,
          queryParams: {'id': id},
        );

        if (response is! Map) {
          throw Exception('Invalid watch response format');
        }
        final responseMap = Map<String, dynamic>.from(response);

        AppLogger.debug('📦 Watch response keys: ${responseMap.keys}');

        // Handle nested response
        final outerData = responseMap['data'];
        final innerData = outerData is Map && outerData['data'] is Map
            ? outerData['data']
            : outerData;

        if (innerData is! Map) {
          throw Exception('Invalid response structure');
        }

        final innerDataMap = Map<String, dynamic>.from(innerData);
        final seriesData =
            innerDataMap['anime'] ?? innerDataMap['series'] ?? innerDataMap;

        if (seriesData is! Map) {
          throw Exception('Invalid series response structure');
        }

        return WatchSeriesModel.fromJson(
          Map<String, dynamic>.from(seriesData),
        );
      } catch (primaryError) {
        AppLogger.warning(
            '⚠️ Primary API failed, trying fallback: $primaryError');

        // Fallback to AniList
        return await _getFallbackSeriesData(id);
      }
    } catch (e) {
      AppLogger.error('❌ Failed to fetch series data', e);
      rethrow;
    }
  }

  /// Fallback series data from AniList
  Future<WatchSeriesModel> _getFallbackSeriesData(String id) async {
    final animeData = await getAnimeDetail(id);

    // Create fallback episodes
    final totalEpisodes = animeData.episodes ?? 12;
    final episodes = List.generate(
      totalEpisodes,
      (index) => EpisodeModel(
        number: index + 1,
        title: 'Episode ${index + 1}',
        embedUrls: {
          'sub': '${ApiEndpoints.megaVid}/ani/$id/${index + 1}/sub',
          'dub': '${ApiEndpoints.megaVid}/ani/$id/${index + 1}/dub',
        },
      ),
    );

    return WatchSeriesModel(
      id: id,
      aniId: id,
      title: animeData.title,
      englishTitle: animeData.englishTitle,
      poster: animeData.poster,
      bannerImage: animeData.bannerImage,
      description: animeData.description,
      duration: animeData.duration,
      status: animeData.status,
      format: animeData.format,
      totalEpisodes: totalEpisodes,
      episodes: episodes,
      type: 'anime',
    );
  }

  /// Get FlixCloud servers
  Future<List<ServerModel>> getFlixCloudServers(
    String anilistId,
    int episodeNumber,
  ) async {
    try {
      AppLogger.debug(
          '🎬 Fetching FlixCloud servers: $anilistId/$episodeNumber');

      final endpoint = '${ApiEndpoints.flixApi}/$anilistId/$episodeNumber';
      AppLogger.debug('🌐 Fetching FlixCloud API: $endpoint');
      final response = await _apiService.get(
        endpoint,
      );

      if (response is! Map) {
        AppLogger.warning('⚠️ Invalid FlixCloud response format');
        return [];
      }

      // Handle nested response
      final data = response['data'] ?? response;
      if (data is! Map) {
        AppLogger.warning('⚠️ Invalid FlixCloud data format');
        return [];
      }
      final servers = data['servers'] as List<dynamic>? ?? [];

      if (servers.isEmpty) {
        AppLogger.warning('⚠️ No FlixCloud servers found');
        return [];
      }

      return servers
          .whereType<Map>()
          .map((s) => ServerModel.fromJson(Map<String, dynamic>.from(s)))
          .toList();
    } catch (e) {
      AppLogger.error('❌ Failed to fetch FlixCloud servers', e);
      return [];
    }
  }

  /// Build MegaPlay embed URLs from the anime and episode identifiers.
  List<ServerModel> getMegaPlayServers(Episode episode, String animeId) {
    final servers = <ServerModel>[];
    final languages = <String>[];

    if (episode.hasSub) languages.add('sub');
    if (episode.hasDub) languages.add('dub');
    if (languages.isEmpty) languages.add('sub');

    for (final language in languages) {
      final url =
          '${ApiEndpoints.megaVid}/ani/$animeId/${episode.number}/$language';
      servers.add(ServerModel.fromEmbedUrl(
        url: url,
        language: language,
        episodeNumber: episode.number,
      ));
    }

    return servers;
  }
}
