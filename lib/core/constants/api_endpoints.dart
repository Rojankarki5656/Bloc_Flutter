// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl =
      'https://untranslatable-glidingly-gwyn.ngrok-free.dev/api';
  static const String homeData =
      'https://untranslatable-glidingly-gwyn.ngrok-free.dev/api/home';
  static const String anilist = 'https://graphql.anilist.co';
  static const String flixApi = 'https://reanime.to/api/flix';
  static const String anikoto = 'https://anikotoapi.site';
  static const String megaplayBase = 'https://megaplay.buzz/stream/ani';
  static const String megaVidBase = 'https://megavid.buzz/ani';

  // API Endpoints
  static const String recentAnime = '$anikoto/recent-anime';
  static const String animeInfo = '$anikoto/series';
  static const String watch = '$anikoto/series';
  static const String flix = '$flixApi';

  // AniList Queries
  static const String trendingAnime = '''
    query (\$page: Int, \$perPage: Int) {
      Page(page: \$page, perPage: \$perPage) {
        media(sort: TRENDING_DESC, type: ANIME) {
          id
          title { romaji english native }
          coverImage { large medium }
          format
          averageScore
        }
      }
    }
  ''';

  static const String searchAnime = '''
    query (\$search: String, \$page: Int, \$perPage: Int) {
      Page(page: \$page, perPage: \$perPage) {
        media(search: \$search, type: ANIME, sort: POPULARITY_DESC) {
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

  static String buildMegaVidUrl(
    String animeId,
    int episode, {
    String language = 'sub',
  }) {
    return '$megaVidBase/$animeId/$episode/$language';
  }

  // API Endpoints
  static const String home = '/api/home';
  static const String trending = '/api/trending';
  static const String popular = '/api/popular';
  static const String upcoming = '/api/upcoming';
  static const String top100 = '/api/top100';
  static const String search = '/api/search';
}
