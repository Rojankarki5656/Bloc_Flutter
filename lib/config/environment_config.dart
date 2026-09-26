class EnvironmentConfig {
  final String baseUrl;
  final String anilistUrl;
  final String flixUrl;
  final String anikotoUrl;
  final bool isProduction;
  final bool isDevelopment;
  
  const EnvironmentConfig({
    required this.baseUrl,
    required this.anilistUrl,
    required this.flixUrl,
    required this.anikotoUrl,
    required this.isProduction,
    required this.isDevelopment,
  });
  
  factory EnvironmentConfig.development() {
    return const EnvironmentConfig(
      baseUrl: 'https://dev-api.animeweebs.app',
      anilistUrl: 'https://graphql.anilist.co',
      flixUrl: 'https://dev.reanime.to/api/flix',
      anikotoUrl: 'https://dev.anikotoapi.site',
      isProduction: false,
      isDevelopment: true,
    );
  }
  
  factory EnvironmentConfig.staging() {
    return const EnvironmentConfig(
      baseUrl: 'https://staging-api.animeweebs.app',
      anilistUrl: 'https://graphql.anilist.co',
      flixUrl: 'https://staging.reanime.to/api/flix',
      anikotoUrl: 'https://staging.anikotoapi.site',
      isProduction: false,
      isDevelopment: false,
    );
  }
  
  factory EnvironmentConfig.production() {
    return const EnvironmentConfig(
      baseUrl: 'https://api.animeweebs.app',
      anilistUrl: 'https://graphql.anilist.co',
      flixUrl: 'https://reanime.to/api/flix',
      anikotoUrl: 'https://anikotoapi.site',
      isProduction: true,
      isDevelopment: false,
    );
  }
}