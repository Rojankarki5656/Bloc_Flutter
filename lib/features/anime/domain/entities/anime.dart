// lib/features/anime/domain/entities/anime.dart
import 'package:equatable/equatable.dart';

class Anime extends Equatable {
  final int id;
  final String title;
  final String? englishTitle;
  final String? nativeTitle;
  final String? poster;
  final String? bannerImage;
  final String? description;
  final String? format;
  final String? status;
  final int? episodes;
  final int? duration;
  final String? season;
  final int? seasonYear;
  final double? averageScore;
  final int? popularity;
  final int? favorites;
  final List<String>? genres;
  final List<String>? synonyms;
  final String? source;
  final bool isAdult;

  const Anime({
    required this.id,
    required this.title,
    this.englishTitle,
    this.nativeTitle,
    this.poster,
    this.bannerImage,
    this.description,
    this.format,
    this.status,
    this.episodes,
    this.duration,
    this.season,
    this.seasonYear,
    this.averageScore,
    this.popularity,
    this.favorites,
    this.genres,
    this.synonyms,
    this.source,
    this.isAdult = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        englishTitle,
        nativeTitle,
        poster,
        bannerImage,
        description,
        format,
        status,
        episodes,
        duration,
        season,
        seasonYear,
        averageScore,
        popularity,
        favorites,
        genres,
        synonyms,
        source,
        isAdult,
      ];
}
