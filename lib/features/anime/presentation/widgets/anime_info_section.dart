// lib/features/anime/presentation/widgets/anime_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/anime.dart';

class AnimeInfoSection extends StatefulWidget {
  final Anime anime;
  const AnimeInfoSection({super.key, required this.anime});

  @override
  State<AnimeInfoSection> createState() => _AnimeInfoSectionState();
}

class _AnimeInfoSectionState extends State<AnimeInfoSection> {
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final anime = widget.anime;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Synopsis',
            style: AppTheme.headlineSmall,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anime.description ?? 'No description available.',
                  style: AppTheme.bodyMedium,
                  maxLines: _showFullDescription ? null : 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (anime.description != null && anime.description!.length > 200)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showFullDescription = !_showFullDescription;
                      });
                    },
                    child: Text(
                      _showFullDescription ? 'Show Less' : 'Read More',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Genres
          if (anime.genres != null && anime.genres!.isNotEmpty) ...[
            Text(
              'Genres',
              style: AppTheme.headlineSmall,
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: anime.genres!.map((genre) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    genre,
                    style: AppTheme.labelMedium,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
          ],

          // Studios
          if (anime.genres != null && anime.genres!.isNotEmpty) ...[
            Text(
              'Studio',
              style: AppTheme.headlineSmall,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: anime.genres!.map((studio) {
                return Text(
                  "Studio",
                  style: AppTheme.bodyMedium,
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
          ],

          // Info Grid
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 2,
              children: [
                _buildInfoItem('Score', anime.averageScore.toString()),
                _buildInfoItem('Popularity', anime.popularity?.toString() ?? 'N/A'),
                _buildInfoItem('Favorites', anime.favorites?.toString() ?? 'N/A'),
                _buildInfoItem('Season', anime.season ?? 'N/A'),
                _buildInfoItem('Duration', anime.duration != null ? '${anime.duration} min' : 'N/A'),
                _buildInfoItem('Source', anime.source ?? 'N/A'),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Watch Button
          if (anime.status?.toLowerCase() != 'not_yet_released')
            PrimaryButton(
              text: 'Watch Now',
              onPressed: () {
                context.go('/watch/${anime.id}/anime?ep=1');
              },
              isFullWidth: true,
              icon: Icons.play_arrow,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTheme.labelSmall.copyWith(
            color: AppTheme.textMuted,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTheme.labelLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}