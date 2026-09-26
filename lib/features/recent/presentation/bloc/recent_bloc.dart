// lib/features/recent/presentation/bloc/recent_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_recently_added_usecase.dart';
import 'recent_event.dart';
import 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  final GetRecentlyAddedUseCase getRecentlyAdded;
  int _currentPage = 1;
  bool _hasMore = true;
  final List<dynamic> _allAnime = [];

  RecentBloc({required this.getRecentlyAdded}) : super(RecentInitial()) {
    on<LoadRecentlyAdded>(_onLoadRecentlyAdded);
    on<LoadMoreRecentlyAdded>(_onLoadMore);
    on<RefreshRecentlyAdded>(_onRefresh);
  }

  Future<void> _onLoadRecentlyAdded(
    LoadRecentlyAdded event,
    Emitter<RecentState> emit,
  ) async {
    emit(RecentLoading());
    _currentPage = 1;
    _hasMore = true;
    _allAnime.clear();

    try {
      final anime = await getRecentlyAdded.call(
        page: _currentPage,
        perPage: event.perPage,
      );

      _allAnime.addAll(anime);
      _hasMore = anime.length >= event.perPage;

      emit(RecentLoaded(
        animeList: _allAnime.cast(),
        hasMore: _hasMore,
        currentPage: _currentPage,
      ));

      AppLogger.success('✅ Loaded ${anime.length} recent anime');
    } catch (e, stackTrace) {
      logError('Failed to load recent anime', e, stackTrace);
      emit(RecentError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreRecentlyAdded event,
    Emitter<RecentState> emit,
  ) async {
    if (!_hasMore || state is! RecentLoaded) return;

    final currentState = state as RecentLoaded;
    _currentPage++;

    try {
      final anime = await getRecentlyAdded.call(
        page: _currentPage,
        perPage: 20,
      );

      _allAnime.addAll(anime);
      _hasMore = anime.length >= 20;

      emit(currentState.copyWith(
        animeList: _allAnime.cast(),
        hasMore: _hasMore,
        currentPage: _currentPage,
      ));
    } catch (e) {
      AppLogger.error('Failed to load more', e);
    }
  }

  Future<void> _onRefresh(
    RefreshRecentlyAdded event,
    Emitter<RecentState> emit,
  ) async {
    add(const LoadRecentlyAdded(page: 1, perPage: 20));
  }
}