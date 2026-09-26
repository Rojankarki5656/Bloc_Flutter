// lib/features/search/presentation/bloc/search_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/usecases/search_anime_usecase.dart';

// ============================================================================
// Events
// ============================================================================

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;
  const SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreSearchResults extends SearchEvent {}

class ClearSearch extends SearchEvent {}

class ApplySearchFilters extends SearchEvent {
  final String? genre;
  final String? format;
  final String? status;
  final String? sort;

  const ApplySearchFilters({
    this.genre,
    this.format,
    this.status,
    this.sort,
  });

  @override
  List<Object?> get props => [genre, format, status, sort];
}

// ============================================================================
// States
// ============================================================================

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final bool hasMore;
  final int totalResults;
  final String? query;
  final Map<String, String?> filters;

  const SearchLoaded({
    required this.results,
    required this.hasMore,
    required this.totalResults,
    this.query,
    this.filters = const {},
  });

  @override
  List<Object?> get props => [results, hasMore, totalResults, query, filters];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================================================
// BLoC
// ============================================================================

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchAnimeUseCase searchAnime;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _currentQuery;
  Map<String, String?> _currentFilters = {};

  SearchBloc({required this.searchAnime}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<LoadMoreSearchResults>(_onLoadMore);
    on<ClearSearch>(_onClearSearch);
    on<ApplySearchFilters>(_onApplyFilters);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    // Debounce would be implemented in UI, but we can start search
    add(SearchSubmitted(event.query));
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    _currentPage = 1;
    _hasMore = true;
    _currentQuery = event.query;
    await _performSearch(emit, isNewSearch: true);
  }

  Future<void> _onLoadMore(
    LoadMoreSearchResults event,
    Emitter<SearchState> emit,
  ) async {
    if (!_hasMore || state is! SearchLoaded) return;
    _currentPage++;
    await _performSearch(emit, isNewSearch: false);
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    _currentQuery = null;
    _currentPage = 1;
    _hasMore = true;
    _currentFilters = {};
    emit(SearchInitial());
  }

  Future<void> _onApplyFilters(
    ApplySearchFilters event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilters = {
      'genre': event.genre,
      'format': event.format,
      'status': event.status,
      'sort': event.sort,
    };
    if (_currentQuery != null && _currentQuery!.isNotEmpty) {
      _currentPage = 1;
      _hasMore = true;
      await _performSearch(emit, isNewSearch: true);
    }
  }

  Future<void> _performSearch(
    Emitter<SearchState> emit, {
    required bool isNewSearch,
  }) async {
    if (_currentQuery == null || _currentQuery!.isEmpty) return;

    emit(SearchLoading());

    try {
      final result = await searchAnime.call(
        query: _currentQuery!,
        page: _currentPage,
        perPage: 20,
        genre: _currentFilters['genre'],
        format: _currentFilters['format'],
        status: _currentFilters['status'],
        sort: _currentFilters['sort'],
      );

      final newResults = result.results;
      _hasMore = result.hasMore;

      final combinedResults = isNewSearch
          ? newResults
          : [...(state as SearchLoaded).results, ...newResults];

      emit(SearchLoaded(
        results: combinedResults,
        hasMore: _hasMore,
        totalResults: result.total,
        query: _currentQuery,
        filters: _currentFilters,
      ));
    } catch (e, stackTrace) {
      logError('Search failed', e, stackTrace);
      emit(SearchError(e.toString()));
    }
  }
}