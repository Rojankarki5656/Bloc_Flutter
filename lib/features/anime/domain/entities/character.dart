// lib/features/anime/domain/entities/character.dart
import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String? image;
  final String? role;
  final VoiceActor? voiceActor;

  const Character({
    required this.id,
    required this.name,
    this.image,
    this.role,
    this.voiceActor,
  });

  @override
  List<Object?> get props => [id, name, image, role, voiceActor];
}

class VoiceActor extends Equatable {
  final int id;
  final String name;
  final String? image;

  const VoiceActor({
    required this.id,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}