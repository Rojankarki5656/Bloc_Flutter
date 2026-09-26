// lib/features/anime/presentation/widgets/related_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/relation.dart';

class RelatedSection extends StatelessWidget {
  final List<Relation> relations;

  const RelatedSection({super.key, required this.relations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Related Series',
                style: AppTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relations.take(12).length,
              itemBuilder: (context, index) {
                final relation = relations[index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: GestureDetector(
                    onTap: () => context.go('/anime/${relation.id}'),
                    child: SizedBox(
                      width: 120.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: relation.poster ?? '',
                              height: 160.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 160.h,
                                width: 120.w,
                                color: AppTheme.borderColor,
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 160.h,
                                width: 120.w,
                                color: AppTheme.borderColor,
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppTheme.textMuted,
                                  size: 32.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Title
                          Text(
                            relation.title,
                            style: AppTheme.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Relation Type
                          Text(
                            relation.type,
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.textMuted,
                              fontSize: 10.sp,
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