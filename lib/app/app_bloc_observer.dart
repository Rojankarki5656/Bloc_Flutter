// lib/app/app_bloc_observer.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// Custom BLoC observer for logging, analytics, and error tracking
class AppBlocObserver extends BlocObserver {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 120,
      colors: !kReleaseMode,
      printEmojis: true,
    ),
  );

  /// Track performance metrics
  final Map<String, Stopwatch> _timers = {};

  // ============================================================================
  // BLoC Lifecycle Events
  // ============================================================================

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logInfo('🔄 BLoC Created: ${bloc.runtimeType}', bloc);
    _startTimer(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _stopTimer(bloc);
    _logInfo('✅ BLoC Closed: ${bloc.runtimeType}', bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logDebug('📤 Event: $event', bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    
    // Only log if currentState and nextState are different
    if (change.currentState != change.nextState) {
      _logDebug(
        '🔄 State Change: ${change.currentState} → ${change.nextState}',
        bloc,
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logDebug(
      '🔄 Transition: ${transition.currentState} → ${transition.nextState}',
      bloc,
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logError('❌ Error in ${bloc.runtimeType}: $error', bloc, error, stackTrace);
    
    // Track errors in production
    if (kReleaseMode) {
      _trackError(bloc, error, stackTrace);
    }
  }

  // ============================================================================
  // ❌ REMOVED: onCreateCubit and onCloseCubit
  // These methods don't exist in the superclass anymore.
  // Cubit lifecycle events are handled by onCreate and onClose.
  // ============================================================================

  // ============================================================================
  // Private Logging Methods
  // ============================================================================

  void _logInfo(String message, BlocBase bloc) {
    if (kReleaseMode) return;
    _logger.i('$message (${_getBlocName(bloc)})');
  }

  void _logDebug(String message, BlocBase bloc) {
    if (kReleaseMode) return;
    _logger.d('$message (${_getBlocName(bloc)})');
  }

  void _logError(String message, BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.e(
      '$message (${_getBlocName(bloc)})',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _getBlocName(BlocBase bloc) => bloc.runtimeType.toString();

  // ============================================================================
  // Performance Tracking
  // ============================================================================

  void _startTimer(BlocBase bloc) {
    if (kReleaseMode) return;
    final key = _getBlocName(bloc);
    _timers[key] = Stopwatch()..start();
  }

  void _stopTimer(BlocBase bloc) {
    if (kReleaseMode) return;
    final key = _getBlocName(bloc);
    final timer = _timers.remove(key);
    if (timer != null) {
      timer.stop();
      _logger.d('⏱️ BLoC Lifetime: $key - ${timer.elapsedMilliseconds}ms');
    }
  }

  // ============================================================================
  // Production Error Tracking
  // ============================================================================

  void _trackError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Send to your analytics service (Firebase, Sentry, etc.)
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // You can also send to your backend API
    // _reportErrorToServer(bloc, error, stackTrace);
  }

  // Optional: Report to server
  void _reportErrorToServer(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Implement your error reporting logic here
    // Example:
    // final payload = {
    //   'bloc': _getBlocName(bloc),
    //   'error': error.toString(),
    //   'stackTrace': stackTrace.toString(),
    //   'timestamp': DateTime.now().toIso8601String(),
    // };
    // _dio.post('/api/errors', data: payload);
  }
}

/// Extension for easier bloc logging
extension BlocLogging on BlocBase {
  /// Log a custom message with this bloc's context
  void log(String message, {LoggerLevel level = LoggerLevel.info}) {
    final logger = Logger();
    switch (level) {
      case LoggerLevel.debug:
        logger.d('[$runtimeType] $message');
        break;
      case LoggerLevel.info:
        logger.i('[$runtimeType] $message');
        break;
      case LoggerLevel.warning:
        logger.w('[$runtimeType] $message');
        break;
      case LoggerLevel.error:
        logger.e('[$runtimeType] $message');
        break;
    }
  }
}

/// Logger levels
enum LoggerLevel {
  debug,
  info,
  warning,
  error,
}