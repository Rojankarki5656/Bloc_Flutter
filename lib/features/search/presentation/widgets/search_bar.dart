// lib/features/search/presentation/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onCleared;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: AppTheme.textMuted,
              size: 20.sp,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search anime...',
                hintStyle: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                controller.clear();
                onCleared();
              },
              icon: Icon(
                Icons.clear,
                color: AppTheme.textMuted,
                size: 20.sp,
              ),
            ),
        ],
      ),
    );
  }
}