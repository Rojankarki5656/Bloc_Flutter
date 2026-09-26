// lib/shared/widgets/not_found_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80.sp,
                color: AppTheme.errorColor,
              ),
              SizedBox(height: 24.h),
              Text(
                '404',
                style: AppTheme.displayLarge.copyWith(
                  color: AppTheme.errorColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Page Not Found',
                style: AppTheme.headlineMedium,
              ),
              SizedBox(height: 12.h),
              Text(
                'The page you are looking for does not exist.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: AppTheme.primaryButtonStyle,
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}