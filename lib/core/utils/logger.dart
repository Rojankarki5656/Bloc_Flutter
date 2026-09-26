// lib/core/utils/logger.dart
import 'package:logger/logger.dart';

/// Application logger
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null && stackTrace != null) {
      _logger.e('$message\nError: $error\nStack: $stackTrace');
    } else if (error != null) {
      _logger.e('$message\nError: $error');
    } else {
      _logger.e(message);
    }
  }
  
  static void success(String message) => _logger.i('✅ $message');
}

/// Extension for logging in any class
extension LoggerExtension on Object {
  void logDebug(String message) => AppLogger.debug('[$runtimeType] $message');
  void logInfo(String message) => AppLogger.info('[$runtimeType] $message');
  void logWarning(String message) => AppLogger.warning('[$runtimeType] $message');
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    AppLogger.error('[$runtimeType] $message', error, stackTrace);
  }
  void logSuccess(String message) => AppLogger.success('[$runtimeType] $message');
}