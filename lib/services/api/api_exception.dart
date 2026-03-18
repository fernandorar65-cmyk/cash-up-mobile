import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.originalError,
  });

  final String message;
  final int? statusCode;
  final Object? data;
  final Object? originalError;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';

  static ApiException fromDio(Object error) {
    if (error is DioException) {
      final res = error.response;
      final statusCode = res?.statusCode;
      final data = res?.data;

      final message = () {
        final dynamic d = data;
        if (d is Map && d['message'] is String) return d['message'] as String;
        if (error.message?.isNotEmpty == true) return error.message!;
        return 'Error de red';
      }();

      return ApiException(
        message: message,
        statusCode: statusCode,
        data: data,
        originalError: error,
      );
    }

    return ApiException(
      message: 'Error inesperado',
      originalError: error,
    );
  }
}

