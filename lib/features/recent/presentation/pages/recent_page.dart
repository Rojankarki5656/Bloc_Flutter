// lib/features/recent/presentation/pages/recent_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loaders/shimmer_loader.dart';
import '../bloc/recent_bloc.dart';
import '../bloc/recent_event.dart';
import '../bloc/recent_state.dart';
import '../widgets/recent_anime_card.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  late final RecentBloc _bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<RecentBloc>();
    _bloc.add(const LoadRecentlyAdded());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  /// Load more when near the bottom
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = 300.h;

    if (currentScroll >= (maxScroll - threshold)) {
      final state = _bloc.state;
      if (state is RecentLoaded && state.hasMore) {
        _bloc.add(const LoadMoreRecentlyAdded());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text(
          '🆕 Recently Added',
          style: AppTheme.headlineSmall,
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppTheme.textPrimary,
              size: 22.sp,
            ),
            onPressed: () {
              _bloc.add(const RefreshRecentlyAdded());
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<RecentBloc, RecentState>(
          builder: (context, state) {
            // Loading state (first load)
            if (state is RecentInitial || state is RecentLoading) {
              return const _RecentShimmer();
            }

            // Error state
            if (state is RecentError) {
              return _buildError(state.message);
            }

            // Loaded state
            if (state is RecentLoaded) {
              // Empty state
              if (state.animeList.isEmpty) {
                return _buildEmpty();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _bloc.add(const RefreshRecentlyAdded());
                },
                color: AppTheme.primaryGold,
                backgroundColor: AppTheme.surfaceColor,
                child: GridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16.w),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: state.animeList.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Load more indicator at the end
                    if (index == state.animeList.length) {
                      return _buildLoadingMoreIndicator();
                    }

                    final anime = state.animeList[index];
                    return RecentAnimeCard(
                      anime: anime,
                      showEpisodeBadge: true,
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ============================================================================
  // Error State
  // ============================================================================
  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
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
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                _bloc.add(const RefreshRecentlyAdded());
              },
              style: AppTheme.primaryButtonStyle,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Empty State
  // ============================================================================
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80.sp,
            color: AppTheme.textMuted,
          ),
          SizedBox(height: 16.h),
          Text(
            'No recent anime',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new episodes',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              _bloc.add(const RefreshRecentlyAdded());
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Loading More Indicator
  // ============================================================================
  Widget _buildLoadingMoreIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryGold,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

// ============================================================================
// Shimmer Loading
// ============================================================================
class _RecentShimmer extends StatelessWidget {
  const _RecentShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title shimmer
          ShimmerLoader(
            height: 24.h,
            width: 200.w,
            borderRadius: 8.r,
          ),
          SizedBox(height: 16.h),

          // Grid shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoader(
                    height: 180.h,
                    borderRadius: 12.r,
                  ),
                  SizedBox(height: 8.h),
                  ShimmerLoader(
                    height: 12.h,
                    width: 100.w,
                    borderRadius: 6.r,
                  ),
                  SizedBox(height: 4.h),
                  ShimmerLoader(
                    height: 10.h,
                    width: 60.w,
                    borderRadius: 6.r,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}