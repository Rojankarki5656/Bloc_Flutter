// lib/features/watch/domain/entities/episode.dart
import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final int number;
  final String? title;
  final String? thumbnail;
  final Map<String, String>? embedUrls;
  final int? duration;
  final String? airDate;
  final bool isFiller;
  final String? description;

  const Episode({
    required this.number,
    this.title,
    this.thumbnail,
    this.embedUrls,
    this.duration,
    this.airDate,
    this.isFiller = false,
    this.description,
  });

  /// Get sub URL if available
  String? get subUrl => embedUrls?['sub'];

  /// Get dub URL if available
  String? get dubUrl => embedUrls?['dub'];

  /// Check if episode has sub
  bool get hasSub => subUrl != null && subUrl!.isNotEmpty;

  /// Check if episode has dub
  bool get hasDub => dubUrl != null && dubUrl!.isNotEmpty;

  /// Get available languages
  List<String> get availableLanguages {
    final langs = <String>[];
    if (hasSub) langs.add('sub');
    if (hasDub) langs.add('dub');
    return langs;
  }

  @override
  List<Object?> get props => [
        number,
        title,
        thumbnail,
        embedUrls,
        duration,
        airDate,
        isFiller,
        description,
      ];
}