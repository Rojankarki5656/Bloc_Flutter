// lib/features/anime/data/mock/mock_anime_data.dart
import '../../domain/entities/anime.dart';

abstract class MockAnimeData {
  static final List<Anime> trendingAnime = [
    const Anime(
      id: 1,
      title: 'Attack on Titan',
      englishTitle: 'Attack on Titan',
      nativeTitle: '進撃の巨人',
      poster: 'https://cdn.myanimelist.net/images/anime/10/47347.jpg',
      bannerImage: 'https://image.tmdb.org/t/p/original/m8AakI1oV6R6dO4xR6A7qO3oG1I.jpg',
      description: 'Humanity lives inside cities surrounded by enormous walls due to the Titans.',
      format: 'TV',
      status: 'FINISHED',
      episodes: 25,
      duration: 24,
      season: 'SPRING',
      seasonYear: 2013,
      averageScore: 85.0,
      popularity: 1500000,
      favorites: 160000,
      genres: ['Action', 'Drama', 'Fantasy'],
      isAdult: false,
    ),
    const Anime(
      id: 2,
      title: 'Demon Slayer: Kimetsu no Yaiba',
      englishTitle: 'Demon Slayer',
      nativeTitle: '鬼滅の刃',
      poster: 'https://cdn.myanimelist.net/images/anime/1286/99889.jpg',
      bannerImage: 'https://image.tmdb.org/t/p/original/nTvM42138L382103810238120381.jpg',
      description: 'A young man strives to turn his sister back into a human after her transformation into a demon.',
      format: 'TV',
      status: 'FINISHED',
      episodes: 26,
      duration: 23,
      season: 'SPRING',
      seasonYear: 2019,
      averageScore: 84.0,
      popularity: 1200000,
      favorites: 100000,
      genres: ['Action', 'Supernatural'],
      isAdult: false,
    ),
  ];

  static List<Anime> generateRecommendations() {
    return List.generate(
      30,
      (index) => Anime(
        id: index + 10,
        title: 'Anime Title ${index + 1}',
        englishTitle: 'Anime English Title ${index + 1}',
        poster: 'https://via.placeholder.com/300x450.png?text=Anime+${index + 1}',
        bannerImage: 'https://via.placeholder.com/1200x450.png?text=Banner+${index + 1}',
        description: 'This is a mock description for generated recommendation anime #${index + 1}.',
        format: 'TV',
        status: index % 2 == 0 ? 'RELEASING' : 'FINISHED',
        episodes: 12,
        duration: 24,
        seasonYear: 2024,
        averageScore: 7.5 + (index % 25) / 10,
        genres: const ['Action', 'Adventure', 'Comedy'],
        isAdult: false,
      ),
    );
  }
}