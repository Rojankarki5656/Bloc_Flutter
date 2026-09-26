// lib/core/services/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation service for managing navigation without context
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigate to a route
  void navigateTo(String route, {Object? extra}) {
    navigatorKey.currentState?.pushNamed(route, arguments: extra);
  }

  /// Navigate to a route with GoRouter
  void goTo(String route, {Object? extra}) {
    navigatorKey.currentContext?.go(route, extra: extra);
  }

  /// Go back
  void goBack() {
    navigatorKey.currentState?.pop();
  }

  /// Replace current route
  void replaceWith(String route, {Object? extra}) {
    navigatorKey.currentState?.pushReplacementNamed(route, arguments: extra);
  }

  /// Push and remove all previous routes
  void pushAndRemoveUntil(String route, {Object? extra}) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: extra,
    );
  }

  /// Get current context
  BuildContext? get context => navigatorKey.currentContext;
}