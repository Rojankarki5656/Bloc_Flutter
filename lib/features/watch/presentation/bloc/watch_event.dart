// lib/features/watch/presentation/bloc/watch_event.dart
import 'package:equatable/equatable.dart';

abstract class WatchEvent extends Equatable {
  const WatchEvent();

  @override
  List<Object?> get props => [];
}

/// Load series data and episodes
class LoadSeriesData extends WatchEvent {
  final String id;
  final String type;

  const LoadSeriesData({
    required this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}

/// Refresh series data
class RefreshSeriesData extends WatchEvent {
  final String id;
  final String type;

  const RefreshSeriesData({
    required this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}

/// Select an episode
class SelectEpisode extends WatchEvent {
  final int episodeNumber;

  const SelectEpisode(this.episodeNumber);

  @override
  List<Object?> get props => [episodeNumber];
}

/// Change server (megaplay / flixcloud)
class ChangeServer extends WatchEvent {
  final String server;

  const ChangeServer(this.server);

  @override
  List<Object?> get props => [server];
}

/// Change language (sub / dub)
class ChangeLanguage extends WatchEvent {
  final String language;

  const ChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

/// Go to next episode
class NextEpisode extends WatchEvent {
  const NextEpisode();
}

/// Go to previous episode
class PreviousEpisode extends WatchEvent {
  const PreviousEpisode();
}

/// Toggle theater mode
class ToggleTheaterMode extends WatchEvent {
  const ToggleTheaterMode();
}

/// Toggle focus mode
class ToggleFocusMode extends WatchEvent {
  const ToggleFocusMode();
}

/// Save watch progress
class SaveProgress extends WatchEvent {
  final int currentTime;
  final int duration;
  final int progress;

  const SaveProgress({
    required this.currentTime,
    required this.duration,
    required this.progress,
  });

  @override
  List<Object?> get props => [currentTime, duration, progress];
}

/// Load resume time from storage
class LoadResumeTime extends WatchEvent {
  final String animeId;

  const LoadResumeTime(this.animeId);

  @override
  List<Object?> get props => [animeId];
}