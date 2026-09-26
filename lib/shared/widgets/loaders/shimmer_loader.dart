// lib/shared/widgets/loaders/shimmer_loader.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_theme.dart';

class ShimmerLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.borderColor,
      highlightColor: AppTheme.surfaceColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.borderColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }
}