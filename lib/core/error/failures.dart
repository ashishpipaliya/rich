import 'package:dio/dio.dart';

// ─── Failure ────────────────────────────────────────────────────────────────

class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => 'Failure($message)';
}

// ─── Typed Exceptions ────────────────────────────────────────────────────────

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}

// ─── Error Handler ───────────────────────────────────────────────────────────

class ErrorHandler {
  ErrorHandler._();

  static Failure handleException(dynamic error) {
    if (error is Failure) return error;

    if (error is ServerException ||
        error is NetworkException ||
        error is CacheException) {
      return Failure((error as dynamic).message as String);
    }

    if (error is DioException) {
      return switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout => const Failure(
          'Connection timed out. Please try again.',
        ),
        DioExceptionType.connectionError => Failure(
          error.message ?? 'No internet connection',
        ),
        DioExceptionType.badResponse => Failure(
          _extractResponseMessage(error) ??
              'Server error (${error.response?.statusCode})',
        ),
        DioExceptionType.cancel => const Failure('Request was cancelled'),
        _ => Failure(error.message ?? 'An unexpected error occurred'),
      };
    }

    return Failure(error.toString());
  }

  static String? _extractResponseMessage(DioException error) {
    try {
      final data = error.response?.data;
      if (data is Map) {
        return (data['message'] ?? data['error'] ?? data['detail'])?.toString();
      }
    } catch (_) {}
    return null;
  }
}
