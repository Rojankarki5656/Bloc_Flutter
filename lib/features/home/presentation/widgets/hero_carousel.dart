// lib/features/home/presentation/widgets/hero_carousel.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/anime.dart';

class HeroCarousel extends StatefulWidget {
  final List<Anime> slides;

  const HeroCarousel({
    super.key,
    required this.slides,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        // Carousel
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.slides.map((anime) {
            return _buildSlide(anime);
          }).toList(),
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  AppTheme.backgroundColor.withOpacity(0.8),
                  AppTheme.backgroundColor.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6],
              ),
            ),
          ),
        ),

        // Bottom gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100.h,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppTheme.backgroundColor,
                  AppTheme.backgroundColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        // Navigation Arrows
        Positioned(
          left: 16.w,
          top: MediaQuery.of(context).size.height / 2 - 28.h,
          child: _buildNavButton(
            icon: Icons.chevron_left,
            onTap: () => _controller.previousPage(),
          ),
        ),
        Positioned(
          right: 16.w,
          top: MediaQuery.of(context).size.height / 2 - 28.h,
          child: _buildNavButton(
            icon: Icons.chevron_right,
            onTap: () => _controller.nextPage(),
          ),
        ),

        // Pagination Dots
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.slides.asMap().entries.map((entry) {
              final index = entry.key;
              return Container(
                width: _currentIndex == index ? 32.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppTheme.primaryGold
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(Anime anime) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: anime.poster ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.borderColor,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.borderColor,
                child: Icon(
                  Icons.broken_image,
                  color: AppTheme.textMuted,
                  size: 60.sp,
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    anime.title,
                    style: AppTheme.displayMedium.copyWith(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),

                  // Tags
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildTag(
                        label: anime.format ?? 'ANIME',
                        bgColor: AppTheme.primaryGold.withOpacity(0.2),
                        textColor: AppTheme.primaryGold,
                      ),
                      if (anime.averageScore != null)
                        _buildTag(
                          label: '★ ${anime.averageScore}',
                          bgColor: Colors.transparent,
                          textColor: AppTheme.textPrimary,
                        ),
                      _buildTag(
                        label: anime.seasonYear?.toString() ?? 'Unknown',
                        bgColor: Colors.transparent,
                        textColor: AppTheme.textSecondary,
                      ),
                      _buildTag(
                        label: anime.duration != null ? '${anime.duration} min' : '??',
                        bgColor: Colors.transparent,
                        textColor: AppTheme.textSecondary,
                      ),
                      _buildTag(
                        label: 'FREE',
                        bgColor: AppTheme.purpleAccent.withOpacity(0.2),
                        textColor: AppTheme.purpleAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Synopsis
                  Text(
                    anime.description?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No description available.',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textBody,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),

                  // Buttons
                  Row(
                    children: [
                      _buildActionButton(
                        label: 'Watch Now',
                        icon: Icons.play_arrow,
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.backgroundColor,
                        onTap: () => context.go('/watch/${anime.id}/anime?ep=1'),
                      ),
                      SizedBox(width: 12.w),
                      _buildActionButton(
                        label: 'Add to List',
                        icon: Icons.add,
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppTheme.textPrimary,
                        borderColor: Colors.white.withOpacity(0.1),
                        onTap: () {
                          // TODO: Add to list functionality
                          AppLogger.info('Added ${anime.title} to list');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTheme.labelMedium.copyWith(
          color: textColor,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    Color? borderColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: foregroundColor,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTheme.labelLarge.copyWith(
                color: foregroundColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        child: Icon(
          icon,
          color: AppTheme.textPrimary,
          size: 28.sp,
        ),
      ),
    );
  }
}