import 'anime.dart';

class HomeData {
  final List<Anime> trending;
  final List<Anime> popularThisSeason;
  final List<Anime> upcomingNextSeason;
  final List<Anime> top100;
  final List<Anime> allTimePopular;

  const HomeData({
    required this.trending,
    required this.popularThisSeason,
    required this.upcomingNextSeason,
    required this.top100,
    required this.allTimePopular
  });
}