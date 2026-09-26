// lib/features/watch/presentation/bloc/watch_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/watch_series.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/server.dart';
import '../../domain/repository/i_watch_repository.dart';

abstract class WatchState extends Equatable {
  const WatchState();

  @override
  List<Object?> get props => [];
}

class WatchInitial extends WatchState {}

class WatchLoading extends WatchState {}

class WatchLoaded extends WatchState {
  final WatchSeries series;
  final Episode? currentEpisode;
  final List<StreamingServer> servers;
  final String selectedServer;
  final String selectedLanguage;
  final bool isServerLoading;
  final bool theaterMode;
  final bool focusMode;
  final int resumeTime;
  final int currentTime;
  final int duration;

  const WatchLoaded({
    required this.series,
    this.currentEpisode,
    this.servers = const [],
    this.selectedServer = 'megaplay',
    this.selectedLanguage = 'sub',
    this.isServerLoading = false,
    this.theaterMode = false,
    this.focusMode = false,
    this.resumeTime = 0,
    this.currentTime = 0,
    this.duration = 0,
  });

  /// Check if there's a next episode
  bool get hasNextEpisode {
    if (currentEpisode == null) return false;
    final currentIndex = series.episodes.indexWhere(
      (e) => e.number == currentEpisode!.number,
    );
    return currentIndex < series.episodes.length - 1;
  }

  /// Check if there's a previous episode
  bool get hasPreviousEpisode {
    if (currentEpisode == null) return false;
    final currentIndex = series.episodes.indexWhere(
      (e) => e.number == currentEpisode!.number,
    );
    return currentIndex > 0;
  }

  /// Get next episode
  Episode? get nextEpisode {
    if (!hasNextEpisode) return null;
    final currentIndex = series.episodes.indexWhere(
      (e) => e.number == currentEpisode!.number,
    );
    return series.episodes[currentIndex + 1];
  }

  /// Get previous episode
  Episode? get previousEpisode {
    if (!hasPreviousEpisode) return null;
    final currentIndex = series.episodes.indexWhere(
      (e) => e.number == currentEpisode!.number,
    );
    return series.episodes[currentIndex - 1];
  }

  WatchLoaded copyWith({
    WatchSeries? series,
    Episode? currentEpisode,
    List<StreamingServer>? servers,
    String? selectedServer,
    String? selectedLanguage,
    bool? isServerLoading,
    bool? theaterMode,
    bool? focusMode,
    int? resumeTime,
    int? currentTime,
    int? duration,
  }) {
    return WatchLoaded(
      series: series ?? this.series,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      servers: servers ?? this.servers,
      selectedServer: selectedServer ?? this.selectedServer,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isServerLoading: isServerLoading ?? this.isServerLoading,
      theaterMode: theaterMode ?? this.theaterMode,
      focusMode: focusMode ?? this.focusMode,
      resumeTime: resumeTime ?? this.resumeTime,
      currentTime: currentTime ?? this.currentTime,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
        series,
        currentEpisode,
        servers,
        selectedServer,
        selectedLanguage,
        isServerLoading,
        theaterMode,
        focusMode,
        resumeTime,
        currentTime,
        duration,
      ];
}

class WatchError extends WatchState {
  final String message;

  const WatchError(this.message);

  @override
  List<Object?> get props => [message];
}