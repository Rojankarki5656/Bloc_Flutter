// lib/features/home/data/datasources/anime_remote_datasource.dart
import '../../../../../core/services/api_service.dart';
import '../../../../../core/constants/api_endpoints.dart';
import '../../models/anime_model.dart';

class AnimeRemoteDataSource {
  final ApiService _apiService;

  AnimeRemoteDataSource(this._apiService);

  Future<List<AnimeModel>> getTrendingAnime({int page = 1, int perPage = 12}) async {
    final query = '''
      query (\$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media(sort: TRENDING_DESC, type: ANIME) {
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
          }
        }
      }
    ''';

    final variables = {
      'page': page,
      'perPage': perPage,
    };

    final response = await _apiService.graphQL(query, variables: variables);

    final media = response['data']['Page']['media'] as List<dynamic>? ?? [];
    return media.map((json) => AnimeModel.fromJson(json)).toList();
  }

  Future<List<AnimeModel>> getPopularAnime({int page = 1, int perPage = 12}) async {
    final query = '''
      query (\$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media(sort: POPULARITY_DESC, type: ANIME) {
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
          }
        }
      }
    ''';

    final variables = {
      'page': page,
      'perPage': perPage,
    };

    final response = await _apiService.graphQL(query, variables: variables);

    final media = response['data']['Page']['media'] as List<dynamic>? ?? [];
    return media.map((json) => AnimeModel.fromJson(json)).toList();
  }

  Future<List<AnimeModel>> getUpcomingAnime({int page = 1, int perPage = 12}) async {
    final query = '''
      query (\$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media(sort: POPULARITY_DESC, type: ANIME, status: NOT_YET_RELEASED) {
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
          }
        }
      }
    ''';

    final variables = {
      'page': page,
      'perPage': perPage,
    };

    final response = await _apiService.graphQL(query, variables: variables);

    final media = response['data']['Page']['media'] as List<dynamic>? ?? [];
    return media.map((json) => AnimeModel.fromJson(json)).toList();
  }

  Future<AnimeModel> getAnimeDetail(int id) async {
    final query = '''
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

    final variables = {'id': id};

    final response = await _apiService.graphQL(query, variables: variables);

    final media = response['data']['Media'];
    if (media == null) throw Exception('Anime not found');

    return AnimeModel.fromJson(media);
  }
}