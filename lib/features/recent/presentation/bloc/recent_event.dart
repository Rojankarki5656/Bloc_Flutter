// lib/features/recent/presentation/bloc/recent_event.dart
import 'package:equatable/equatable.dart';

abstract class RecentEvent extends Equatable {
  const RecentEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecentlyAdded extends RecentEvent {
  final int page;
  final int perPage;

  const LoadRecentlyAdded({
    this.page = 1,
    this.perPage = 20,
  });

  @override
  List<Object?> get props => [page, perPage];
}

class LoadMoreRecentlyAdded extends RecentEvent {
  const LoadMoreRecentlyAdded();
}

class RefreshRecentlyAdded extends RecentEvent {
  const RefreshRecentlyAdded();
}