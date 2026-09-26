// lib/features/recent/presentation/widgets/recent_anime_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recent_anime.dart';

class RecentAnimeCard extends StatelessWidget {
  final RecentAnime anime;
  final bool showEpisodeBadge;

  const RecentAnimeCard({
    super.key,
    required this.anime,
    this.showEpisodeBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ✅ Navigate to watch page using the anime's ID (not ani_id)
        final id = anime.id;
        final episodeNum = anime.currentEpisode?.number ?? 1;
        context.go('/watch/$id/anime?ep=$episodeNum');
      },
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: anime.poster ?? '',
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.borderColor,
                      height: 180.h,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.borderColor,
                      height: 180.h,
                      child: Icon(
                        Icons.broken_image,
                        color: AppTheme.textMuted,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
                // Episode badge
                if (showEpisodeBadge && anime.currentEpisode != null)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Ep ${anime.currentEpisode!.number}',
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                // Status badge
                if (anime.isAiring)
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'AIRING',
                        style: AppTheme.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Title
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.bestTitle,
                    style: AppTheme.titleSmall.copyWith(fontSize: 12.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (anime.score != null) ...[
                        Icon(
                          Icons.star,
                          size: 12.sp,
                          color: AppTheme.primaryGold,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          anime.displayScore,
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.primaryGold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (anime.episodes != null)
                        Text(
                          '${anime.episodes} eps',
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.textMuted,
                            fontSize: 10.sp,
                          ),
                        ),
                    ],
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