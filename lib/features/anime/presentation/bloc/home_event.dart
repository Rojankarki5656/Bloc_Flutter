// ============================================================================
// Events
// ============================================================================

part of 'anime_detail_bloc.dart';


abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnimeDetail extends AnimeDetailEvent {
  final String id;
  const LoadAnimeDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshAnimeDetail extends AnimeDetailEvent {
  final String id;
  const RefreshAnimeDetail(this.id);

  @override
  List<Object?> get props => [id];
}