// lib/config/environment.dart
class Environment {
  static const String appName = 'AnimeWeebs';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'https://api.animeweebs.app';
  static const String anilistApiUrl = 'https://graphql.anilist.co';
  static const String flixApiUrl = 'https://reanime.to/api/flix';
  static const String anikotoApiUrl = 'https://anikotoapi.site';
  
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool isDevelopment = !isProduction;
  static const bool isDebug = bool.fromEnvironment('dart.vm.debug');
  
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
  
  static const int cacheTTL = 86400; // 24 hours
}