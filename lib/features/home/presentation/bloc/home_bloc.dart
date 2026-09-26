// lib/features/home/presentation/bloc/home_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/anime.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

part 'home_state.dart';
part 'home_event.dart';

// ============================================================================
// BLoC
// ============================================================================

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeData;

  HomeBloc({
    required this.getHomeData,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _fetchHomeData(emit);
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _fetchHomeData(emit);
  }

  Future<void> _fetchHomeData(Emitter<HomeState> emit) async {
    try {
      final data = await getHomeData.call();

      emit(HomeLoaded(
        trending: data.trending,
        popularThisSeason: data.popularThisSeason,
        upcomingNextSeason: data.upcomingNextSeason,
        top100: data.top100,
        allTimePopular: data.allTimePopular
      ));
    } catch (e, stackTrace) {
      logError('Failed to load home data', e, stackTrace);
      emit(HomeError(e.toString()));
    }
  }
}