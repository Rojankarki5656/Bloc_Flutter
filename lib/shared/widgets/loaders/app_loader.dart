// lib/shared/widgets/loaders/app_loader.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoader({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size.w,
        height: size.h,
        child: CircularProgressIndicator(
          strokeWidth: 3.w,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppTheme.primaryGold,
          ),
        ),
      ),
    );
  }
}