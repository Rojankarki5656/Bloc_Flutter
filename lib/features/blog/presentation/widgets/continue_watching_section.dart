// lib/features/home/presentation/widgets/continue_watching_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../core/di/injection.dart';

class ContinueWatchingSection extends StatefulWidget {
  const ContinueWatchingSection({super.key});

  @override
  State<ContinueWatchingSection> createState() =>
      _ContinueWatchingSectionState();
}

class _ContinueWatchingSectionState extends State<ContinueWatchingSection> {
  List<Map<String, dynamic>> _watchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadWatchHistory();
  }

  void _loadWatchHistory() {
    final prefs = getIt<SharedPreferencesService>();
    final history = prefs.getContinueWatching() ?? [];
    setState(() {
      _watchHistory = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_watchHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              '▶️ Continue Watching',
              style: AppTheme.headlineSmall,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _watchHistory.length,
              itemBuilder: (context, index) {
                final item = _watchHistory[index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: () {
                      final id = item['id']?.toString() ?? '';
                      final type = item['type'] ?? 'anime';
                      final episode = item['episode'] ?? 1;
                      context.go('/watch/$id/$type?ep=$episode');
                    },
                    child: Container(
                      width: 140.w,
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
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.r),
                            ),
                            child: Image.network(
                              item['poster'] ?? '',
                              height: 120.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 120.h,
                                  color: AppTheme.borderColor,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppTheme.textMuted,
                                    size: 32.sp,
                                  ),
                                );
                              },
                            ),
                          ),
                          // Title
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? 'Unknown',
                                  style: AppTheme.titleSmall.copyWith(
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Ep ${item['episode'] ?? 1}',
                                  style: AppTheme.labelMedium.copyWith(
                                    fontSize: 10.sp,
                                    color: AppTheme.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Progress bar
                          if (item['progress'] != null)
                            Container(
                              height: 3.h,
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: AppTheme.borderColor,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                              child: FractionallySizedBox(
                                widthFactor: (item['progress'] ?? 0) / 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGold,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
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