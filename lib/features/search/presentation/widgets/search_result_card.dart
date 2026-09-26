// lib/features/search/presentation/widgets/search_result_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/search_result.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const SearchResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: AppTheme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.go('/anime/${result.id}'),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: result.poster ?? '',
                  width: 80.w,
                  height: 110.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80.w,
                    height: 110.h,
                    color: AppTheme.borderColor,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80.w,
                    height: 110.h,
                    color: AppTheme.borderColor,
                    child: Icon(
                      Icons.broken_image,
                      color: AppTheme.textMuted,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title,
                      style: AppTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (result.englishTitle != null &&
                        result.englishTitle != result.title) ...[
                      SizedBox(height: 4.h),
                      Text(
                        result.englishTitle!,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (result.format != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.borderColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              result.format!,
                              style: AppTheme.labelSmall.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        if (result.averageScore != null) ...[
                          SizedBox(width: 8.w),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 14.sp,
                                color: AppTheme.primaryGold,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                result.averageScore!.toStringAsFixed(1),
                                style: AppTheme.labelSmall.copyWith(
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (result.episodes != null) ...[
                          SizedBox(width: 8.w),
                          Text(
                            '${result.episodes} eps',
                            style: AppTheme.labelSmall.copyWith(
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (result.year != null)
                      Text(
                        result.year.toString(),
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}