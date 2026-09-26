// lib/features/home/presentation/widgets/trending_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/anime.dart';
import 'anime_card.dart';

class TrendingSection extends StatelessWidget {
  final String title;
  final List<Anime> animeList;
  final VoidCallback onSeeAll;

  const TrendingSection({
    super.key,
    required this.title,
    required this.animeList,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTheme.headlineSmall,
                ),
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
          SizedBox(
            height: 280.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: AnimeCard(
                    anime: anime,
                    showRank: true,
                    rank: index + 1,
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