// lib/features/recent/presentation/widgets/recent_anime_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/recent_anime.dart';
import 'recent_anime_card.dart';

class RecentAnimeSection extends StatelessWidget {
  final String title;
  final List<RecentAnime> animeList;
  final VoidCallback onSeeAll;

  const RecentAnimeSection({
    super.key,
    required this.title,
    required this.animeList,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (animeList.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTheme.headlineSmall),
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'See All',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Horizontal list
          SizedBox(
            height: 260.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: RecentAnimeCard(anime: animeList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}