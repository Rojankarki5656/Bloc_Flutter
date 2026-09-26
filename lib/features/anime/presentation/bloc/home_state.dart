// ============================================================================
// States
// ============================================================================
part of 'anime_detail_bloc.dart';


abstract class AnimeDetailState extends Equatable {
  const AnimeDetailState();

  @override
  List<Object?> get props => [];
}

class AnimeDetailInitial extends AnimeDetailState {}

class AnimeDetailLoading extends AnimeDetailState {}

class AnimeDetailLoaded extends AnimeDetailState {
  final Anime anime;
  final List<Character> characters;
  final List<Relation> relations;

  const AnimeDetailLoaded({
    required this.anime,
    this.characters = const [],
    this.relations = const [],
  });

  @override
  List<Object?> get props => [anime, characters, relations];
}

class AnimeDetailError extends AnimeDetailState {
  final String message;
  const AnimeDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
