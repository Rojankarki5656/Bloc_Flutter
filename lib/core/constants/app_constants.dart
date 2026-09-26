// lib/core/constants/app_constants.dart
import 'package:flutter/material.dart'; // Add this import

class AppConstants {
  static const String appName = 'AnimeWeebs';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Watch anime online for free';
  static const String appUrl = 'https://animeweebs.app';

  // Shared Preferences Keys
  static const String prefToken = 'auth_token';
  static const String prefUser = 'user_data';
  static const String prefThemeMode = 'theme_mode';
  static const String prefLanguage = 'language';
  static const String prefPreferredLanguage = 'preferred_language';
  static const String prefRememberMe = 'remember_me';
  static const String prefContinueWatching = 'continue_watching';
  static const String prefWatchHistory = 'watch_history';

  // Cache Keys
  static const String cacheAnime = 'anime_cache';
  static const String cacheWatchHistory = 'watch_history';
  static const String cacheUserPreferences = 'user_preferences';
  static const String cacheBlogPosts = 'blog_posts';

  // API URLs
  static const String anilistApiUrl = 'https://graphql.anilist.co';
  static const String flixApiUrl = 'https://reanime.to/api/flix';
  static const String anikotoApiUrl = 'https://anikotoapi.site';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Cache TTLs
  static const int cacheTTLShort = 300; // 5 minutes
  static const int cacheTTLMedium = 3600; // 1 hour
  static const int cacheTTLLong = 86400; // 24 hours

  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';

  // Video Quality Options
  static const List<String> videoQualities = ['1080p', '720p', '480p', '360p'];

  // Language Options
  static const List<String> languageOptions = ['English', 'Spanish', 'Japanese'];

  // Supported Languages
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
  ];

  // Default Language
  static const Locale defaultLocale = Locale('en', 'US');
}