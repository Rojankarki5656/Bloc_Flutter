// lib/app/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../shared/widgets/navigation/bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = AppBottomNavBar.indexFromPath(location);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
      ),
    );
  }
}