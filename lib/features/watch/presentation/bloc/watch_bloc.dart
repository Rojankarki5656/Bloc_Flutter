// lib/features/watch/presentation/bloc/watch_bloc.dart
import 'package:animeweebs/features/watch/domain/entities/server.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_series_data_usecase.dart';
import '../../domain/usecases/get_episode_stream_usecase.dart';
import '../../domain/usecases/save_watch_progress_usecase.dart';
import '../../domain/usecases/get_watch_progress_usecase.dart';
import 'watch_event.dart';
import 'watch_state.dart';

class WatchBloc extends Bloc<WatchEvent, WatchState> {
  final GetSeriesDataUseCase getSeriesData;
  final GetEpisodeStreamUseCase getEpisodeStream;
  final SaveWatchProgressUseCase saveWatchProgress;
  final GetWatchProgressUseCase getWatchProgress;

  String _currentAnimeId = '';
  String _currentType = 'anime';

  WatchBloc({
    required this.getSeriesData,
    required this.getEpisodeStream,
    required this.saveWatchProgress,
    required this.getWatchProgress,
  }) : super(WatchInitial()) {
    on<LoadSeriesData>(_onLoadSeriesData);
    on<RefreshSeriesData>(_onRefreshSeriesData);
    on<SelectEpisode>(_onSelectEpisode);
    on<ChangeServer>(_onChangeServer);
    on<ChangeLanguage>(_onChangeLanguage);
    on<NextEpisode>(_onNextEpisode);
    on<PreviousEpisode>(_onPreviousEpisode);
    on<ToggleTheaterMode>(_onToggleTheaterMode);
    on<ToggleFocusMode>(_onToggleFocusMode);
    on<SaveProgress>(_onSaveProgress);
    on<LoadResumeTime>(_onLoadResumeTime);
  }

  Future<void> _onLoadSeriesData(
    LoadSeriesData event,
    Emitter<WatchState> emit,
  ) async {
    _currentAnimeId = event.id;
    _currentType = event.type;

    emit(WatchLoading());

    try {
      AppLogger.info('📺 Loading series: ${event.id}');

      final series = await getSeriesData.call(event.id, event.type);

      if (series.episodes.isEmpty) {
        emit(const WatchError('No episodes available for this anime'));
        return;
      }

      final firstEpisode = series.episodes.first;

      // Load saved progress
      final progress = await getWatchProgress.call(event.id);
      final resumeTime = progress?.currentTime ?? 0;
      final startEpisode = progress != null
          ? series.episodes.firstWhere(
              (e) => e.number == progress.episode,
              orElse: () => firstEpisode,
            )
          : firstEpisode;

      // Get servers for the start episode
      final servers = await _getServersForEpisode(
        startEpisode.number,
        'megaplay',
        'sub',
      );

      emit(WatchLoaded(
        series: series,
        currentEpisode: startEpisode,
        servers: servers,
        resumeTime: resumeTime,
      ));

      AppLogger.success('✅ Series loaded: ${series.bestTitle}');
    } catch (e, stackTrace) {
      logError('Failed to load series', e, stackTrace);
      emit(WatchError(e.toString()));
    }
  }

  Future<void> _onRefreshSeriesData(
    RefreshSeriesData event,
    Emitter<WatchState> emit,
  ) async {
    if (state is WatchLoaded) {
      add(LoadSeriesData(id: event.id, type: event.type));
    }
  }

  Future<void> _onSelectEpisode(
    SelectEpisode event,
    Emitter<WatchState> emit,
  ) async {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;

    final episode = currentState.series.episodes.firstWhere(
      (e) => e.number == event.episodeNumber,
      orElse: () => currentState.currentEpisode!,
    );

    // Get servers for the new episode
    final servers = await _getServersForEpisode(
      episode.number,
      currentState.selectedServer,
      currentState.selectedLanguage,
    );

    emit(currentState.copyWith(
      currentEpisode: episode,
      servers: servers,
      resumeTime: 0,
    ));
  }

  Future<void> _onChangeServer(
    ChangeServer event,
    Emitter<WatchState> emit,
  ) async {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;

    emit(currentState.copyWith(
      selectedServer: event.server,
      isServerLoading: true,
    ));

    final servers = await _getServersForEpisode(
      currentState.currentEpisode?.number ?? 1,
      event.server,
      currentState.selectedLanguage,
    );

    emit(currentState.copyWith(
      selectedServer: event.server,
      servers: servers,
      isServerLoading: false,
    ));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<WatchState> emit,
  ) async {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;

    emit(currentState.copyWith(
      selectedLanguage: event.language,
    ));
  }

  Future<void> _onNextEpisode(
    NextEpisode event,
    Emitter<WatchState> emit,
  ) async {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;

    final next = currentState.nextEpisode;
    if (next == null) return;

    add(SelectEpisode(next.number));
  }

  Future<void> _onPreviousEpisode(
    PreviousEpisode event,
    Emitter<WatchState> emit,
  ) async {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;

    final prev = currentState.previousEpisode;
    if (prev == null) return;

    add(SelectEpisode(prev.number));
  }

  void _onToggleTheaterMode(
    ToggleTheaterMode event,
    Emitter<WatchState> emit,
  ) {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;
    emit(currentState.copyWith(theaterMode: !currentState.theaterMode));
  }

  void _onToggleFocusMode(
    ToggleFocusMode event,
    Emitter<WatchState> emit,
  ) {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;
    emit(currentState.copyWith(focusMode: !currentState.focusMode));
  }

  Future<void> _onSaveProgress(
    SaveProgress event,
    Emitter<WatchState> emit,
  ) async {
    if (state is! WatchLoaded) return;
    final currentState = state as WatchLoaded;

    await saveWatchProgress.call(
      animeId: _currentAnimeId,
      title: currentState.series.bestTitle,
      poster: currentState.series.poster ?? '',
      episode: currentState.currentEpisode?.number ?? 1,
      type: _currentType,
      progress: event.progress,
      currentTime: event.currentTime,
      duration: event.duration,
    );

    // Update state with current time
    emit(currentState.copyWith(
      currentTime: event.currentTime,
      duration: event.duration,
    ));
  }

  Future<void> _onLoadResumeTime(
    LoadResumeTime event,
    Emitter<WatchState> emit,
  ) async {
    final progress = await getWatchProgress.call(event.animeId);
    if (state is WatchLoaded && progress != null) {
      final currentState = state as WatchLoaded;
      emit(currentState.copyWith(resumeTime: progress.currentTime));
    }
  }

  /// Helper to get servers for an episode
  Future<List<StreamingServer>> _getServersForEpisode(
    int episodeNumber,
    String server,
    String language,
  ) async {
    try {
      return await getEpisodeStream.call(
        _currentAnimeId,
        episodeNumber,
        server: server,
      );
    } catch (e) {
      AppLogger.error('Failed to get servers', e);
      return [];
    }
  }
}