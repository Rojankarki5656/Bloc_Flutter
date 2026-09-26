// lib/core/services/api_service.dart
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../constants/api_endpoints.dart';

/// API Service for making HTTP requests
class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        endpoint,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GraphQL request
  Future<dynamic> graphQL(String query, {Map<String, dynamic>? variables}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.anilist,
        data: {
          'query': query,
          'variables': variables ?? {},
        },
      );
      final body = response.data;
      if (body is Map<String, dynamic> && body['errors'] is List) {
        final errors = body['errors'] as List;
        final message = errors.isNotEmpty && errors.first is Map
            ? (errors.first['message'] ?? 'GraphQL request failed')
            : 'GraphQL request failed';
        throw Exception(message);
      }
      return body;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException e) {
    String message = 'Something went wrong';
    
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          message = 'Bad request';
          break;
        case 401:
          message = 'Unauthorized';
          break;
        case 403:
          message = 'Forbidden';
          break;
        case 404:
          message = 'Not found';
          break;
        case 500:
          message = 'Internal server error';
          break;
        default:
          message = e.response?.statusMessage ?? 'Something went wrong';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = 'Receive timeout';
    } else if (e.type == DioExceptionType.sendTimeout) {
      message = 'Send timeout';
    } else if (e.type == DioExceptionType.unknown) {
      message = 'No internet connection';
    }
    
    return Exception(message);
  }
}