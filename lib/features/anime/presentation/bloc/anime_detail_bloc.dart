// lib/features/anime/presentation/bloc/anime_detail_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/relation.dart';
import '../../domain/usecases/get_anime_detail_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

// ============================================================================
// BLoC
// ============================================================================

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final GetAnimeDetailUseCase getAnimeDetail;

  AnimeDetailBloc({required this.getAnimeDetail}) : super(AnimeDetailInitial()) {
    on<LoadAnimeDetail>(_onLoadAnimeDetail);
    on<RefreshAnimeDetail>(_onRefreshAnimeDetail);
  }

  Future<void> _onLoadAnimeDetail(
    LoadAnimeDetail event,
    Emitter<AnimeDetailState> emit,
  ) async {
    emit(AnimeDetailLoading());
    await _fetchAnimeDetail(event.id, emit);
  }

  Future<void> _onRefreshAnimeDetail(
    RefreshAnimeDetail event,
    Emitter<AnimeDetailState> emit,
  ) async {
    await _fetchAnimeDetail(event.id, emit);
  }

  Future<void> _fetchAnimeDetail(
    String id,
    Emitter<AnimeDetailState> emit,
  ) async {
    try {
      final result = await getAnimeDetail.call(id);
      emit(AnimeDetailLoaded(
        anime: result.anime,
        characters: result.characters,
        relations: result.relations,
      ));
    } catch (e, stackTrace) {
      logError('Failed to load anime detail', e, stackTrace);
      emit(AnimeDetailError(e.toString()));
    }
  }
}