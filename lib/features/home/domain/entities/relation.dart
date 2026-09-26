// lib/features/anime/domain/entities/relation.dart
import 'package:equatable/equatable.dart';

class Relation extends Equatable {
  final String type;
  final int id;
  final String title;
  final String? poster;
  final String? mediaType;

  const Relation({
    required this.type,
    required this.id,
    required this.title,
    this.poster,
    this.mediaType,
  });

  @override
  List<Object?> get props => [type, id, title, poster, mediaType];
}