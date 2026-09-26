// lib/features/watch/data/models/episode_model.dart
import '../../../../core/constants/api_endpoints.dart';
import '../../domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.number,
    super.title,
    super.thumbnail,
    super.embedUrls,
    super.duration,
    super.airDate,
    super.isFiller,
    super.description,
  });

  /// Create an EpisodeModel with MegaVid URLs
  /// 
  /// This is the PRIMARY way to create episodes since MegaVid works.
  factory EpisodeModel.fromMegaVid({
    required String animeId,
    required int episodeNumber,
    String? title,
    bool hasSub = true,
    bool hasDub = false,
  }) {
    final embedUrls = <String, String>{};
    
    if (hasSub) {
      embedUrls['sub'] = ApiEndpoints.buildMegaVidUrl(
        animeId,
        episodeNumber,
        language: 'sub',
      );
    }
    
    if (hasDub) {
      embedUrls['dub'] = ApiEndpoints.buildMegaVidUrl(
        animeId,
        episodeNumber,
        language: 'dub',
      );
    }

    return EpisodeModel(
      number: episodeNumber,
      title: title ?? 'Episode $episodeNumber',
      embedUrls: embedUrls,
    );
  }

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    // Extract embed URLs from the API response
    Map<String, String>? embedUrls;
    
    if (json['embed_url'] != null && json['embed_url'] is Map) {
      embedUrls = Map<String, String>.from(
        (json['embed_url'] as Map).map(
          (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
        ),
      );
    }

    return EpisodeModel(
      number: (json['number'] as num?)?.toInt() ??
              (json['episode'] as num?)?.toInt() ??
              1,
      title: json['title']?.toString(),
      thumbnail: json['thumbnail']?.toString(),
      embedUrls: embedUrls,
      duration: (json['duration'] as num?)?.toInt(),
      airDate: json['airDate']?.toString(),
      isFiller: json['isFiller'] == true || json['filler'] == true,
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'title': title,
        'thumbnail': thumbnail,
        'embed_url': embedUrls,
        'duration': duration,
        'airDate': airDate,
        'isFiller': isFiller,
        'description': description,
      };
}