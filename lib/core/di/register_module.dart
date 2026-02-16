import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../network/interceptors/header_interceptor.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    dio.interceptors.add(HeaderInterceptor());
    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }
}
