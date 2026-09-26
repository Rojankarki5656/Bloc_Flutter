// lib/features/watch/domain/entities/server.dart
import 'package:equatable/equatable.dart';

class StreamingServer extends Equatable {
  final String id;
  final String name;
  final String url;
  final String language; // 'sub' or 'dub'
  final String type; // 'iframe' or 'hls'
  final bool isDefault;

  const StreamingServer({
    required this.id,
    required this.name,
    required this.url,
    required this.language,
    this.type = 'iframe',
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, url, language, type, isDefault];
}