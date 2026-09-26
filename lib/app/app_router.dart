// lib/app/app_router.dart
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

/// Application router configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: getIt<NavigationService>().navigatorKey,
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    // =========================================================================
    // Main Routes
    // =========================================================================

    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        // Home sub-routes (tab navigation would go here)
      ],
    ),

    GoRoute(
      path: '/home',
      name: 'home-alt',
      builder: (context, state) => const HomePage(),
    ),

    // =========================================================================
    // Search Route
    // =========================================================================

    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => const SearchPage(),
    ),

    // =========================================================================
    // Anime Detail Route
    // =========================================================================

    GoRoute(
      path: '/anime/:id',
      name: 'anime-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AnimeDetailPage(id: id);
      },
    ),

    // =========================================================================
    // Watch Route
    // =========================================================================

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


    // =========================================================================
    // Character Route (optional)
    // =========================================================================

    GoRoute(
      path: '/character/:id',
      name: 'character',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CharacterPage(characterId: id);
      },
    ),
  ],
);

/// Placeholder Character Page
class CharacterPage extends StatelessWidget {
  final String characterId;
  const CharacterPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF2F0EA)),
        ),
        title: Text(
          'Character',
          style: const TextStyle(color: Color(0xFFF2F0EA)),
        ),
      ),
      body: Center(
        child: Text(
          'Character: $characterId',
          style: const TextStyle(color: Color(0xFFF2F0EA)),
        ),
      ),
    );
  }
}