// lib/shared/widgets/navigation/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  /// Navigation items
  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    _NavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
      route: '/search',
    ),
    _NavItem(
      icon: Icons.new_releases_outlined,
      activeIcon: Icons.new_releases,
      label: 'Recent',
      route: '/recent',
    ),
    _NavItem(
      icon: Icons.article_outlined,
      activeIcon: Icons.article,
      label: 'Blog',
      route: '/blog',
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
  ];

  /// Get current index from route path
  static int indexFromPath(String path) {
    for (int i = 0; i < _navItems.length; i++) {
      if (path == _navItems[i].route || path.startsWith('${_navItems[i].route}/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = currentIndex == index;

              return Expanded(
                child: _NavBarItem(
                  item: item,
                  isActive: isActive,
                  onTap: () {
                    if (onTap != null) {
                      onTap!(index);
                    } else {
                      // Default navigation behavior
                      if (!isActive) {
                        context.go(item.route);
                      }
                    }
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Internal Widgets
// ============================================================================

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppTheme.primaryGold.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? 16.w : 8.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryGold.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isActive ? item.activeIcon : item.icon,
              color: isActive ? AppTheme.primaryGold : AppTheme.textMuted,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 2.h),

          // Label
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: (isActive
                    ? AppTheme.labelSmall.copyWith(
                        color: AppTheme.primaryGold,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      )
                    : AppTheme.labelSmall.copyWith(
                        color: AppTheme.textMuted,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      )),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}