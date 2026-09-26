// lib/features/recent/presentation/bloc/recent_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/recent_anime.dart';

abstract class RecentState extends Equatable {
  const RecentState();

  @override
  List<Object?> get props => [];
}

class RecentInitial extends RecentState {}

class RecentLoading extends RecentState {}

class RecentLoaded extends RecentState {
  final List<RecentAnime> animeList;
  final bool hasMore;
  final int currentPage;

  const RecentLoaded({
    required this.animeList,
    this.hasMore = false,
    this.currentPage = 1,
  });

  RecentLoaded copyWith({
    List<RecentAnime>? animeList,
    bool? hasMore,
    int? currentPage,
  }) {
    return RecentLoaded(
      animeList: animeList ?? this.animeList,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [animeList, hasMore, currentPage];
}

class RecentError extends RecentState {
  final String message;

  const RecentError(this.message);

  @override
  List<Object?> get props => [message];
}