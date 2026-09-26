// lib/features/watch/presentation/pages/watch_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';
import '../bloc/watch_state.dart';
import '../widgets/video_player.dart';
import '../widgets/episode_selector.dart';
import '../widgets/series_info.dart';

class WatchPage extends StatefulWidget {
  final String animeId;
  final String type;
  final String episode;

  const WatchPage({
    super.key,
    required this.animeId,
    this.type = 'anime',
    this.episode = '1',
  });

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  late final WatchBloc _watchBloc;
  bool _showEpisodes = true;

  @override
  void initState() {
    super.initState();
    _watchBloc = getIt<WatchBloc>();
    _watchBloc.add(LoadSeriesData(id: widget.animeId, type: widget.type));

    // Auto-select episode after load
    Future.delayed(const Duration(milliseconds: 500), () {
      final episodeNum = int.tryParse(widget.episode) ?? 1;
      _watchBloc.add(SelectEpisode(episodeNum));
    });
  }

  @override
  void dispose() {
    _watchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocProvider.value(
        value: _watchBloc,
        child: BlocConsumer<WatchBloc, WatchState>(
          listener: (context, state) {
            if (state is WatchLoaded && state.currentEpisode != null) {
              // Update URL
              context.go(
                '/watch/${widget.animeId}/${widget.type}?ep=${state.currentEpisode!.number}',
              );
            }
          },
          builder: (context, state) {
            if (state is WatchLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryGold,
                ),
              );
            }

            if (state is WatchError) {
              return _buildError(state.message);
            }

            if (state is WatchLoaded) {
              return _buildWatchContent(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

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
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: AppTheme.primaryButtonStyle,
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchContent(WatchLoaded state) {
    return SafeArea(
      child: Column(
        children: [
          // App bar
          _buildAppBar(state),

          // Video player
          Expanded(
            child: Column(
              children: [
                VideoPlayer(
                  servers: state.servers,
                  isLoading: state.isServerLoading,
                  isError: state.servers.isEmpty,
                  theaterMode: state.theaterMode,
                ),
                if (!state.theaterMode)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Series info
                          SeriesInfo(
                            series: state.series,
                            currentEpisode: state.currentEpisode,
                          ),

                          // Controls
                          _buildControls(state),

                          // Episode selector
                          if (_showEpisodes)
                            SizedBox(
                              height: 300.h,
                              child: EpisodeSelector(
                                episodes: state.series.episodes,
                                currentEpisode: state.currentEpisode,
                                onEpisodeSelected: (episode) {
                                  _watchBloc.add(SelectEpisode(episode.number));
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(WatchLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back,
              color: AppTheme.textPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.series.bestTitle,
                  style: AppTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (state.currentEpisode != null)
                  Text(
                    'Episode ${state.currentEpisode!.number}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),

          // Server selector
          _buildServerDropdown(state),

          SizedBox(width: 8.w),

          // Theater mode toggle
          _buildIconButton(
            icon: state.theaterMode
                ? Icons.fullscreen_exit
                : Icons.fullscreen,
            onTap: () => _watchBloc.add(const ToggleTheaterMode()),
          ),

          SizedBox(width: 8.w),

          // Focus mode toggle
          _buildIconButton(
            icon: state.focusMode ? Icons.visibility : Icons.visibility_off,
            onTap: () => _watchBloc.add(const ToggleFocusMode()),
          ),
        ],
      ),
    );
  }

  Widget _buildServerDropdown(WatchLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedServer,
          dropdownColor: AppTheme.surfaceColor,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppTheme.primaryGold,
            size: 20.sp,
          ),
          style: AppTheme.bodySmall,
          items: const [
            DropdownMenuItem(value: 'megaplay', child: Text('MegaPlay')),
            DropdownMenuItem(value: 'flixcloud', child: Text('FlixCloud')),
          ],
          onChanged: (value) {
            if (value != null) {
              _watchBloc.add(ChangeServer(value));
            }
          },
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Icon(
          icon,
          color: AppTheme.textPrimary,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildControls(WatchLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Previous episode
          if (state.hasPreviousEpisode)
            Expanded(
              child: _buildNavButton(
                icon: Icons.skip_previous,
                label: 'Previous',
                subtitle: 'Ep ${state.previousEpisode?.number}',
                onTap: () => _watchBloc.add(const PreviousEpisode()),
              ),
            ),

          if (state.hasPreviousEpisode && state.hasNextEpisode)
            SizedBox(width: 12.w),

          // Next episode
          if (state.hasNextEpisode)
            Expanded(
              child: _buildNavButton(
                icon: Icons.skip_next,
                label: 'Next',
                subtitle: 'Ep ${state.nextEpisode?.number}',
                onTap: () => _watchBloc.add(const NextEpisode()),
                isPrimary: true,
              ),
            ),

          // Episode list toggle
          SizedBox(width: 12.w),
          _buildIconButton(
            icon: _showEpisodes ? Icons.list : Icons.grid_view,
            onTap: () {
              setState(() {
                _showEpisodes = !_showEpisodes;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryGold : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isPrimary ? AppTheme.primaryGold : AppTheme.borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? AppTheme.backgroundColor : AppTheme.textPrimary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.labelMedium.copyWith(
                    color: isPrimary
                        ? AppTheme.backgroundColor
                        : AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.labelSmall.copyWith(
                    color: isPrimary
                        ? AppTheme.backgroundColor.withOpacity(0.7)
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}