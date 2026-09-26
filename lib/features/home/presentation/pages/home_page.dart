// lib/features/home/presentation/pages/home_page.dart
import 'package:animeweebs/features/recent/presentation/widgets/recent_anime_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../bloc/home_bloc.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>();
    _homeBloc.add(LoadHomeData());
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocProvider.value(
        value: _homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial || state is HomeLoading) {
              return const HomeShimmer();
            }

            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60.sp,
                      color: AppTheme.errorColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load content',
                      style: AppTheme.headlineSmall,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.message,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        _homeBloc.add(RefreshHomeData());
                      },
                      style: AppTheme.primaryButtonStyle,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is HomeLoaded) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Carousel
                    if (state.trending.isNotEmpty)
                      HeroCarousel(slides: state.trending),

                    SizedBox(height: 16.h),

                    // Continue Watching
                    const ContinueWatchingSection(),

                    // Trending Now
                    if (state.trending.isNotEmpty)
                      AnimeListSection(
                        title: '🔥 Trending Now',
                        animeList: state.trending.take(12).toList(),
                        onSeeAll: () => context.go('/list/trending'),
                        showRank: true,
                      ),

                    // Popular This Season
                    if (state.popularThisSeason.isNotEmpty)
                      AnimeListSection(
                        title: '🏆 Popular This Season',
                        animeList: state.popularThisSeason.take(12).toList(),
                        onSeeAll: () => context.go('/list/popular'),
                      ),

                    // All Time Popular
                    if (state.allTimePopular.isNotEmpty)
                      AnimeListSection(
                        title: '🏅 All Time Popular',
                        animeList: state.allTimePopular.take(12).toList(),
                        onSeeAll: () => context.go('/list/alltime'),
                        showRank: true,
                      ),

                    // Upcoming Next Season
                    if (state.upcomingNextSeason.isNotEmpty)
                      AnimeListSection(
                        title: '📅 Upcoming Next Season',
                        animeList: state.upcomingNextSeason.take(12).toList(),
                        onSeeAll: () => context.go('/list/upcoming'),
                      ),

                    // Top 100 Anime
                    if (state.top100.isNotEmpty)
                      AnimeListSection(
                        title: '🌟 Top 100 Anime',
                        animeList: state.top100.take(12).toList(),
                        onSeeAll: () => context.go('/list/top100'),
                        showRank: true,
                      ),

                    // Quick Pick + Community Section
                    _buildCommunitySection(),

                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shuffle,
                  color: AppTheme.purpleAccent,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Not sure what to watch?',
                  style: AppTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Random pick logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purpleAccent.withOpacity(0.15),
                  foregroundColor: AppTheme.purpleAccent,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Pick something random'),
              ),
            ),
            SizedBox(height: 16.h),
            Divider(
              color: AppTheme.borderColor,
              thickness: 1,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(
                  Icons.discord,
                  color: AppTheme.purpleAccent,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Talk anime on Discord',
                  style: AppTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '500+ people trading recommendations and fan art daily.',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                // TODO: Open Discord link
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Join the server',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.purpleAccent,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppTheme.purpleAccent,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Shimmer Loading
// ============================================================================

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Carousel Shimmer
          ShimmerLoader(
            height: 300.h,
            borderRadius: 0,
          ),
          SizedBox(height: 16.h),

          // Sections Shimmer
          ...List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoader(
                    height: 24.h,
                    width: 150.w,
                    borderRadius: 8.r,
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 180.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: ShimmerLoader(
                            width: 140.w,
                            height: 180.h,
                            borderRadius: 16.r,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
