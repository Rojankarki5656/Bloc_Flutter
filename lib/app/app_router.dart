// lib/app/app_router.dart
import 'package:animeweebs/app/main_shell.dart';
import 'package:animeweebs/features/blog/presentation/widgets/trending_list.dart';
import 'package:animeweebs/features/recent/presentation/pages/recent_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/services/navigation_service.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/watch/presentation/pages/watch_page.dart';
import '../features/anime/presentation/pages/anime_detail_page.dart';
import '../features/blog/presentation/pages/blog_list_page.dart';
import '../shared/widgets/not_found/not_found_page.dart';


final GoRouter appRouter = GoRouter(
  navigatorKey: getIt<NavigationService>().navigatorKey,
  initialLocation: '/home',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    // =========================================================================
    // Shell Routes (WITH Bottom Navigation)
    // =========================================================================
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        // Home
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        // Search
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchPage(),
        ),

        // Recent
        GoRoute(
          path: '/recent',
          name: 'recent',
          builder: (context, state) => const RecentPage(),
        ),

        // Blog
        GoRoute(
          path: '/blog',
          name: 'blog',
          builder: (context, state) => const BlogListPage(),
          routes: [
            GoRoute(
              path: ':slug',
              name: 'blog-detail',
              builder: (context, state) {
                final slug = state.pathParameters['slug']!;
                return HomePage();
              },
            ),
          ],
        ),

        // Profile
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),

    // =========================================================================
    // Full-Screen Routes (NO Bottom Navigation)
    // =========================================================================

    // Root redirect
    GoRoute(
      path: '/',
      redirect: (context, state) => '/home',
    ),

    // Anime Detail (Full Screen)
    GoRoute(
      path: '/anime/:id',
      name: 'anime-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AnimeDetailPage(id: id);
      },
    ),

    // Watch (Full Screen)
    GoRoute(
      path: '/watch/:id/:type',
      name: 'watch',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final type = state.pathParameters['type']!;
        final ep = state.uri.queryParameters['ep'] ?? '1';
        return WatchPage(
          animeId: id,
          type: type,
          episode: ep,
        );
      },
    ),

    // List (Full Screen)
    GoRoute(
      path: '/list/:id',
      name: 'list',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return HomePage();
      },
    ),
  ],
);
