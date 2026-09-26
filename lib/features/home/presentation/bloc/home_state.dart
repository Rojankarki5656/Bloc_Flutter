// lib/features/home/presentation/bloc/home_state.dart
part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Anime> trending;
  final List<Anime> popularThisSeason;
  final List<Anime> upcomingNextSeason;
  final List<Anime> top100;
  final List<Anime> allTimePopular;

  const HomeLoaded({
    required this.trending,
    required this.popularThisSeason,
    required this.upcomingNextSeason,
    required this.top100,
    required this.allTimePopular,
  });

  @override
  List<Object?> get props => [
        trending,
        popularThisSeason,   // ✅ was duplicated
        upcomingNextSeason,
        top100,
        allTimePopular,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}