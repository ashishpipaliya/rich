---
name: networking
description: "Configure Dio and Retrofit in Flutter, implement interceptors (auth, connectivity, logging), and handle network errors with ErrorHandler."
---

# Flutter Networking

## Role
Configure Dio, implement Retrofit APIs, set up interceptors, and handle network errors.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Dio Configuration

### Basic Setup

```dart
// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    dio.interceptors.addAll([
      authInterceptor,
      loggingInterceptor,
    ]);
    
    return dio;
  }
}
```

---

## Retrofit Data Sources

### Basic API

```dart
// features/user/data/datasource/user_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../model/user_model.dart';

part 'user_remote_datasource.g.dart';

@injectable
@RestApi()
abstract class UserRemoteDataSource {
  @factoryMethod
  factory UserRemoteDataSource(Dio dio, {@Header('baseUrl') String baseUrl})
      = _UserRemoteDataSource;
  
  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') int id);
  
  @GET('/users')
  Future<List<UserModel>> getUsers();
  
  @POST('/users')
  Future<UserModel> createUser(@Body() Map<String, dynamic> body);
  
  @PUT('/users/{id}')
  Future<UserModel> updateUser(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );
  
  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') int id);
}
```

### With Query Parameters

```dart
@GET('/users')
Future<List<UserModel>> getUsers(
  @Query('page') int page,
  @Query('limit') int limit,
  @Query('search') String? search,
);
```

---

## Interceptors

### Auth Interceptor

Attaches Bearer token to requests:

```dart
// core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../storage/secure_storage_service.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  
  AuthInterceptor(this._secureStorage);
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### Logging Interceptor

```dart
// core/network/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/core/utils/app_logger.dart';

@lazySingleton
class LoggingInterceptor extends Interceptor {
  final AppLogger _logger;
  
  LoggingInterceptor(this._logger);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('➡️ Request: ${options.method} ${options.uri}');
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('❌ Error: ${err.type} ${err.message}');
    handler.next(err);
  }
}
```

### Refresh Token Interceptor

Handle 401 and refresh token:

```dart
// core/network/interceptors/refresh_token_interceptor.dart
@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  final SecureStorageService _secureStorage;
  final AuthRepository _authRepository;
  
  RefreshTokenInterceptor(this._secureStorage, this._authRepository);
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _secureStorage.read('refresh_token');
        if (refreshToken == null) {
          handler.reject(err);
          return;
        }
        
        // Retry original request with new token
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.reject(err);
      }
    } else {
      handler.next(err);
    }
  }
  
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    return dio.fetch(requestOptions);
  }
}
```

**Important**: Add RefreshTokenInterceptor after DI init to avoid circular dependency:

```dart
// injection.dart
@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  
  final dio = getIt<Dio>();
  final refreshInterceptor = getIt<RefreshTokenInterceptor>();
  dio.interceptors.insert(dio.interceptors.length - 1, refreshInterceptor);
}
```

---

## Connectivity Service

Monitor network state:

```dart
// core/services/connectivity_service.dart or core/network/connectivity_service.dart
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  final InternetConnection _connectionChecker;
  
  ConnectivityService(this._connectionChecker);
  
  Stream<bool> get onConnectivityChanged => _connectionChecker.onStatusChange
      .map((status) => status == InternetStatus.connected);
  
  Future<bool> get isConnected => _connectionChecker.hasInternetAccess;
  
  void startMonitoring() {
    onConnectivityChanged.listen((connected) {
      // Handle connectivity changes
    });
  }
}
```

---

## Error Handling

Convert DioException to Failure:

```dart
// core/error/error_handler.dart
Failure _handleDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const Failure.network('Connection timeout. Please check your internet.');
      
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final message = _extractErrorMessage(error.response?.data);
      
      return switch (statusCode) {
        400 => Failure.validation(message ?? 'Invalid request'),
        401 => Failure.unauthorized(message ?? 'Unauthorized'),
        403 => Failure.unauthorized(message ?? 'Forbidden'),
        404 => Failure.server(message ?? 'Not found'),
        500 || 502 || 503 => Failure.server(message ?? 'Server error'),
        _ => Failure.server(message ?? 'Something went wrong'),
      };
      
    case DioExceptionType.connectionError:
      return const Failure.network('No internet connection');
      
    default:
      return Failure.unknown(error.message ?? 'Unknown error');
  }
}
```

---

## Best Practices

1. **Always use Either<Failure, T>** in repositories for error handling
2. **Separate interceptors** - Auth, Logging, Refresh each in own file
3. **Base URL via @RestApi** or via Dio BaseOptions
4. **Timeout configuration** - Set reasonable connect/receive timeouts
5. **Don't expose Dio** outside data layer - Use repositories
6. **Handle 401 globally** - Use RefreshTokenInterceptor
7. **Monitor connectivity** - Use ConnectivityService for offline detection

---

## Checklist

- [ ] Dio configured with timeouts and base URL
- [ ] AuthInterceptor attaches Bearer token
- [ ] LoggingInterceptor for debugging
- [ ] RefreshTokenInterceptor handles 401
- [ ] Retrofit data sources use @factoryMethod
- [ ] Repository catches exceptions, returns Either<Failure, T>
- [ ] ConnectivityService monitors network state

# Flutter Networking

## Role
Configure Dio, implement Retrofit APIs, set up interceptors, and handle network errors.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Dio Configuration

### Basic Setup

```dart
// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    dio.interceptors.addAll([
      authInterceptor,
      loggingInterceptor,
    ]);
    
    return dio;
  }
}
```

---

## Retrofit Data Sources

### Basic API

```dart
// features/user/data/datasource/user_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../model/user_model.dart';

part 'user_remote_datasource.g.dart';

@injectable
@RestApi()
abstract class UserRemoteDataSource {
  @factoryMethod
  factory UserRemoteDataSource(Dio dio, {@Header('baseUrl') String baseUrl})
      = _UserRemoteDataSource;
  
  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') int id);
  
  @GET('/users')
  Future<List<UserModel>> getUsers();
  
  @POST('/users')
  Future<UserModel> createUser(@Body() Map<String, dynamic> body);
  
  @PUT('/users/{id}')
  Future<UserModel> updateUser(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );
  
  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') int id);
}
```

### With Query Parameters

```dart
@GET('/users')
Future<List<UserModel>> getUsers(
  @Query('page') int page,
  @Query('limit') int limit,
  @Query('search') String? search,
);
```

---

## Interceptors

### Auth Interceptor

Attaches Bearer token to requests:

```dart
// core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../storage/secure_storage_service.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  
  AuthInterceptor(this._secureStorage);
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

### Logging Interceptor

```dart
// core/network/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/core/utils/app_logger.dart';

@lazySingleton
class LoggingInterceptor extends Interceptor {
  final AppLogger _logger;
  
  LoggingInterceptor(this._logger);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('➡️ Request: ${options.method} ${options.uri}');
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d('✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('❌ Error: ${err.type} ${err.message}');
    handler.next(err);
  }
}
```

### Refresh Token Interceptor

Handle 401 and refresh token:

```dart
// core/network/interceptors/refresh_token_interceptor.dart
@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  final SecureStorageService _secureStorage;
  final AuthRepository _authRepository;
  
  RefreshTokenInterceptor(this._secureStorage, this._authRepository);
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _secureStorage.read('refresh_token');
        if (refreshToken == null) {
          handler.reject(err);
          return;
        }
        
        // Retry original request with new token
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.reject(err);
      }
    } else {
      handler.next(err);
    }
  }
  
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio();
    return dio.fetch(requestOptions);
  }
}
```

**Important**: Add RefreshTokenInterceptor after DI init to avoid circular dependency:

```dart
// injection.dart
@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  
  final dio = getIt<Dio>();
  final refreshInterceptor = getIt<RefreshTokenInterceptor>();
  dio.interceptors.insert(dio.interceptors.length - 1, refreshInterceptor);
}
```

---

## Connectivity Service

Monitor network state:

```dart
// core/services/connectivity_service.dart or core/network/connectivity_service.dart
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  final InternetConnection _connectionChecker;
  
  ConnectivityService(this._connectionChecker);
  
  Stream<bool> get onConnectivityChanged => _connectionChecker.onStatusChange
      .map((status) => status == InternetStatus.connected);
  
  Future<bool> get isConnected => _connectionChecker.hasInternetAccess;
  
  void startMonitoring() {
    onConnectivityChanged.listen((connected) {
      // Handle connectivity changes
    });
  }
}
```

---

## Error Handling

Convert DioException to Failure:

```dart
// core/error/error_handler.dart
Failure _handleDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const Failure.network('Connection timeout. Please check your internet.');
      
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final message = _extractErrorMessage(error.response?.data);
      
      return switch (statusCode) {
        400 => Failure.validation(message ?? 'Invalid request'),
        401 => Failure.unauthorized(message ?? 'Unauthorized'),
        403 => Failure.unauthorized(message ?? 'Forbidden'),
        404 => Failure.server(message ?? 'Not found'),
        500 || 502 || 503 => Failure.server(message ?? 'Server error'),
        _ => Failure.server(message ?? 'Something went wrong'),
      };
      
    case DioExceptionType.connectionError:
      return const Failure.network('No internet connection');
      
    default:
      return Failure.unknown(error.message ?? 'Unknown error');
  }
}
```

---

## Best Practices

1. **Always use Either<Failure, T>** in repositories for error handling
2. **Separate interceptors** - Auth, Logging, Refresh each in own file
3. **Base URL via @RestApi** or via Dio BaseOptions
4. **Timeout configuration** - Set reasonable connect/receive timeouts
5. **Don't expose Dio** outside data layer - Use repositories
6. **Handle 401 globally** - Use RefreshTokenInterceptor
7. **Monitor connectivity** - Use ConnectivityService for offline detection

---

## Checklist

- [ ] Dio configured with timeouts and base URL
- [ ] AuthInterceptor attaches Bearer token
- [ ] LoggingInterceptor for debugging
- [ ] RefreshTokenInterceptor handles 401
- [ ] Retrofit data sources use @factoryMethod
- [ ] Repository catches exceptions, returns Either<Failure, T>
- [ ] ConnectivityService monitors network state
