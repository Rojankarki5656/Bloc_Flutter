// lib/core/di/injection.dart
import 'package:animeweebs/features/recent/data/datasources/recent_remote_datasource.dart';
import 'package:animeweebs/features/recent/data/repositories/recent_repository_impl.dart';
import 'package:animeweebs/features/recent/domain/repository/i_recent_repository.dart';
import 'package:animeweebs/features/recent/domain/usecases/get_recently_added_usecase.dart';
import 'package:animeweebs/features/recent/domain/usecases/get_recently_updated_usecase.dart';
import 'package:animeweebs/features/recent/presentation/bloc/recent_bloc.dart';
import 'package:animeweebs/features/watch/data/datasources/watch_local_datasource.dart';
import 'package:animeweebs/features/watch/data/datasources/watch_remote_datasource.dart';
import 'package:animeweebs/features/watch/data/repositories/watch_repository_impl.dart';
import 'package:animeweebs/features/watch/domain/usecases/get_watch_progress_usecase.dart';
import 'package:animeweebs/features/watch/domain/usecases/save_watch_progress_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/navigation_service.dart';
import '../services/api_service.dart';
import '../services/shared_preferences_service.dart';
import '../network/dio_client.dart';
import '../../features/blog/domain/usecases/get_blog_posts_usecase.dart';
import '../../features/blog/presentation/bloc/blog_bloc.dart';
import '../../features/home/data/datasources/remote/anime_remote_datasource.dart';
import '../../features/home/data/repositories/anime_repository_impl.dart';
import '../../features/home/domain/repository/i_anime_repository.dart';
import '../../features/anime/data/datasources/remote/anime_remote_datasource.dart'
    as anime_remote;
import '../../features/anime/data/repositories/anime_repository_impl.dart'
    as anime_data;
import '../../features/anime/domain/repository/i_anime_repository.dart'
    as anime_domain;

import '../../features/watch/domain/repository/i_watch_repository.dart';
import '../../features/home/domain/usecases/get_recommendations_usecase.dart';
import '../../features/home/domain/usecases/get_trending_anime_usecase.dart';
import '../../features/home/domain/usecases/get_home_data_usecase.dart';
import '../../features/anime/domain/usecases/get_anime_detail_usecase.dart';
import '../../features/watch/domain/usecases/get_episode_stream_usecase.dart';
import '../../features/watch/domain/usecases/get_series_data_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/anime/presentation/bloc/anime_detail_bloc.dart';
import '../../features/watch/presentation/bloc/watch_bloc.dart';

/// Global GetIt instance
final GetIt getIt = GetIt.instance; // ✅ Keep this

/// Initialize dependency injection
Future<void> initDependencies() async {
  // Core Services
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  // Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // API Service
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<DioClient>()));

  // Shared Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  getIt.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<GetBlogPostsUseCase>(
    () => GetBlogPostsUseCase(),
  );
  getIt.registerFactory<BlogBloc>(
    () => BlogBloc(getBlogPosts: getIt<GetBlogPostsUseCase>()),
  );

  getIt.registerLazySingleton<AnimeRemoteDataSource>(
    () => AnimeRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<WatchRemoteDataSource>(
    () => WatchRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<WatchLocalDataSource>(
    () => WatchLocalDataSource(Hive.box('watch_history')),
  );
  getIt.registerLazySingleton<anime_remote.AnimeRemoteDataSource>(
    () => anime_remote.AnimeRemoteDataSource(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<RecentRemoteDataSource>(
    () => RecentRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<IAnimeRepository>(
    () => AnimeRepositoryImpl(getIt<AnimeRemoteDataSource>()),
  );
  getIt.registerLazySingleton<anime_domain.IAnimeRepository>(
    () => anime_data.AnimeRepositoryImpl(
      getIt<anime_remote.AnimeRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<IWatchRepository>(
    () => WatchRepositoryImpl(
      remoteDataSource: getIt<WatchRemoteDataSource>(),
      localDataSource: getIt<WatchLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetTrendingAnimeUseCase>(
    () => GetTrendingAnimeUseCase(getIt<IAnimeRepository>()),
  );
  getIt.registerLazySingleton<GetRecommendationsUseCase>(
    () => GetRecommendationsUseCase(getIt<IAnimeRepository>()),
  );
  getIt.registerLazySingleton<GetHomeDataUseCase>(
    () => GetHomeDataUseCase(getIt<IAnimeRepository>()),
  );
  getIt.registerLazySingleton<GetAnimeDetailUseCase>(
    () => GetAnimeDetailUseCase(getIt<anime_domain.IAnimeRepository>()),
  );

  getIt.registerLazySingleton<GetSeriesDataUseCase>(
    () => GetSeriesDataUseCase(getIt<IWatchRepository>()),
  );

  getIt.registerLazySingleton<GetEpisodeStreamUseCase>(
    () => GetEpisodeStreamUseCase(getIt<IWatchRepository>()),
  );

  getIt.registerLazySingleton<SaveWatchProgressUseCase>(
    () => SaveWatchProgressUseCase(getIt<IWatchRepository>()),
  );

  getIt.registerLazySingleton<GetWatchProgressUseCase>(
    () => GetWatchProgressUseCase(getIt<IWatchRepository>()),
  );

  getIt.registerLazySingleton<IRecentRepository>(
    () => RecentRepositoryImpl(getIt<RecentRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetRecentlyAddedUseCase>(
    () => GetRecentlyAddedUseCase(getIt<IRecentRepository>()),
  );

  getIt.registerLazySingleton<GetRecentlyUpdatedUseCase>(
    () => GetRecentlyUpdatedUseCase(getIt<IRecentRepository>()),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getHomeData: getIt<GetHomeDataUseCase>(),
    ),
  );
  getIt.registerFactory<AnimeDetailBloc>(
    () => AnimeDetailBloc(
      getAnimeDetail: getIt<GetAnimeDetailUseCase>(),
    ),
  );
  getIt.registerFactory<WatchBloc>(
    () => WatchBloc(
      getSeriesData: getIt<GetSeriesDataUseCase>(),
      getEpisodeStream: getIt<GetEpisodeStreamUseCase>(),
      saveWatchProgress: getIt<SaveWatchProgressUseCase>(),
      getWatchProgress: getIt<GetWatchProgressUseCase>(),
    ),
  );
  getIt.registerFactory<RecentBloc>(
    () => RecentBloc(
      getRecentlyAdded: getIt<GetRecentlyAddedUseCase>(),
    ),
  );
}

/// Get a registered dependency - ✅ Renamed function to avoid conflict
T getItService<T extends Object>() => getIt.get<T>();
