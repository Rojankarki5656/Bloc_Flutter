// lib/features/search/domain/entities/search_result.dart
import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final int id;
  final String title;
  final String? englishTitle;
  final String? poster;
  final String? format;
  final int? episodes;
  final double? averageScore;
  final String? status;
  final int? year;

  const SearchResult({
    required this.id,
    required this.title,
    this.englishTitle,
    this.poster,
    this.format,
    this.episodes,
    this.averageScore,
    this.status,
    this.year,
  });

  @override
  List<Object?> get props => [
    id, title, englishTitle, poster, format, episodes, averageScore, status, year,
  ];
}