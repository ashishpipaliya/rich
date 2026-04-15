import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/core/services/connectivity_service.dart';

@lazySingleton
class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService _connectivityService;

  ConnectivityInterceptor(this._connectivityService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!await _connectivityService.isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
          message: 'Please check your internet connection and try again',
        ),
      );
    }
    return handler.next(options);
  }
}
