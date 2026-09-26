part of '../dio_client.dart';


/// Error interceptor
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle specific error codes
    if (err.response?.statusCode == 401) {
      AppLogger.warning('⚠️ Unauthorized request - redirect to login');
    } else if (err.response?.statusCode == 404) {
      AppLogger.warning('⚠️ Resource not found');
    } else if (err.type == DioExceptionType.connectionTimeout) {
      AppLogger.warning('⚠️ Connection timeout');
    } else if (err.type == DioExceptionType.connectionError) {
      AppLogger.warning('⚠️ No internet connection');
    }
    handler.next(err);
  }
}