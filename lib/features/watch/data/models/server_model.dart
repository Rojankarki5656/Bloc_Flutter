// lib/features/watch/data/models/server_model.dart
import '../../domain/entities/server.dart';

class ServerModel extends StreamingServer {
  const ServerModel({
    required super.id,
    required super.name,
    required super.url,
    required super.language,
    super.type,
    super.isDefault,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['\$id']?.toString() ?? 
          json['id']?.toString() ?? 
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['serverName']?.toString() ?? 
            json['name']?.toString() ?? 
            'Server',
      url: json['dataLink']?.toString() ?? 
           json['file']?.toString() ?? 
           json['url']?.toString() ?? 
           '',
      language: json['dataType']?.toString() ?? 
                json['language']?.toString() ?? 
                'sub',
      type: json['type']?.toString() ?? 'iframe',
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        '\$id': id,
        'serverName': name,
        'dataLink': url,
        'dataType': language,
        'type': type,
        'isDefault': isDefault,
      };

  /// Convert from MegaPlay/Anikoto format
  factory ServerModel.fromEmbedUrl({
    required String url,
    required String language,
    required int episodeNumber,
  }) {
    return ServerModel(
      id: 'megaplay-$language-$episodeNumber',
      name: language == 'sub' ? 'SUB' : 'DUB',
      url: url,
      language: language,
      type: 'iframe',
    );
  }
}