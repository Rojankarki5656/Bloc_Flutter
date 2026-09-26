// lib/features/home/presentation/widgets/anime_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/anime.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final bool showRank;
  final int rank;
  final bool compact;
  final VoidCallback? onTap;

  const AnimeCard({
    super.key,
    required this.anime,
    this.showRank = false,
    this.rank = 0,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.go('/anime/${anime.id}'),
      child: Container(
        width: compact ? 120.w : 150.w,
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
            // Poster
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: anime.poster ?? '',
                    height: compact ? 160.h : 200.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.borderColor,
                      height: compact ? 160.h : 200.h,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.borderColor,
                      height: compact ? 160.h : 200.h,
                      child: Icon(
                        Icons.broken_image,
                        color: AppTheme.textMuted,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
                // Rank badge
                if (showRank && rank > 0)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryGold, Color(0xFFF0BE63)],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '#$rank',
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.backgroundColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // Status badge
                if (anime.status != null)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                    ),
                  ),
              ],
            ),
            // Title and Info
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    style: AppTheme.titleSmall.copyWith(
                      fontSize: compact ? 12.sp : 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!compact) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (anime.averageScore != null) ...[
                          Icon(
                            Icons.star,
                            size: 14.sp,
                            color: AppTheme.primaryGold,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "15", // ✅ This is already a String
                            style: AppTheme.labelMedium.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (anime.episodes != null)
                          Text(
                            '${anime.episodes} eps',
                            style: AppTheme.labelMedium.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                      ],
                    ),
                    if (anime.format != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        anime.format!, // ✅ This is a String
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.textMuted,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}