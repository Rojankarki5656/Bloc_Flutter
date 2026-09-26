// lib/features/watch/presentation/widgets/episode_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/episode.dart';

class EpisodeSelector extends StatelessWidget {
  final List<Episode> episodes;
  final Episode? currentEpisode;
  final Function(Episode) onEpisodeSelected;

  const EpisodeSelector({
    super.key,
    required this.episodes,
    required this.currentEpisode,
    required this.onEpisodeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return Center(
        child: Text(
          'No episodes available',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textMuted,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Episodes',
                style: AppTheme.headlineSmall,
              ),
              Text(
                '${episodes.length} total',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Episodes grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
              ),
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];
                final isCurrent = episode.number == currentEpisode?.number;

                return GestureDetector(
                  onTap: () => onEpisodeSelected(episode),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppTheme.primaryGold
                          : AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isCurrent
                            ? AppTheme.primaryGold
                            : AppTheme.borderColor,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${episode.number}',
                            style: AppTheme.titleMedium.copyWith(
                              color: isCurrent
                                  ? AppTheme.backgroundColor
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (episode.isFiller && !isCurrent)
                            Icon(
                              Icons.warning_amber,
                              size: 10.sp,
                              color: AppTheme.warningColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}