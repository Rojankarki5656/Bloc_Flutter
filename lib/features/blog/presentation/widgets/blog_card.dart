// lib/features/blog/presentation/widgets/blog_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/blog_post.dart';

class BlogCard extends StatelessWidget {
  final BlogPost post;
  final bool featured;

  const BlogCard({super.key, required this.post, this.featured = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/blog/${post.slug}'),
      child: Container(
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
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              child: CachedNetworkImage(
                imageUrl: post.image ?? '',
                height: featured ? 200.h : 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: featured ? 200.h : 160.h,
                  color: AppTheme.borderColor,
                ),
                errorWidget: (context, url, error) => Container(
                  height: featured ? 200.h : 160.h,
                  color: AppTheme.borderColor,
                  child: Icon(
                    Icons.broken_image,
                    color: AppTheme.textMuted,
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (featured) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8B04B), Color(0xFFF0BE63)],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Featured',
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  // Date & Author
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12.sp,
                        color: AppTheme.textMuted,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        post.formattedDate,
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.person,
                        size: 12.sp,
                        color: AppTheme.textMuted,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        post.author,
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Title
                  Text(
                    post.title,
                    style: featured ? AppTheme.headlineSmall : AppTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Excerpt
                  Text(
                    post.excerpt,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: featured ? 4 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Tags
                  if (post.tags.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: post.tags.take(3).map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: AppTheme.labelSmall.copyWith(
                              fontSize: 10.sp,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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