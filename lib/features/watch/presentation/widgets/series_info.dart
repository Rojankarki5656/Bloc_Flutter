// lib/features/watch/presentation/widgets/series_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/watch_series.dart';
import '../../domain/entities/episode.dart';

class SeriesInfo extends StatelessWidget {
  final WatchSeries series;
  final Episode? currentEpisode;

  const SeriesInfo({
    super.key,
    required this.series,
    this.currentEpisode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            series.bestTitle,
            style: AppTheme.headlineSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),

          // Info row
          Row(
            children: [
              if (currentEpisode != null) ...[
                Icon(
                  Icons.play_circle_outline,
                  size: 16.sp,
                  color: AppTheme.primaryGold,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Episode ${currentEpisode!.number}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
              if (series.duration != null) ...[
                SizedBox(width: 12.w),
                Icon(
                  Icons.access_time,
                  size: 16.sp,
                  color: AppTheme.primaryGold,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${series.duration} min',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
              if (currentEpisode?.hasDub == true) ...[
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.purpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Dub Available',
                    style: AppTheme.labelSmall.copyWith(
                      color: AppTheme.purpleAccent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}