---
name: di-injectable
description: "Configure and use dependency injection in Flutter with the injectable package and GetIt service locator."
---

# Injectable Dependency Injection

## Role
Configure and use dependency injection with injectable package and GetIt.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Setup

### Main Entry Point

```dart
// lib/main.dart
import 'package:myapp/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}
```

### DI Configuration

```dart
// core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
}
```

---

## Registration Types

### @injectable - Transient

New instance each time:

```dart
@injectable
class FeatureUsecase {
  final FeatureRepository repository;
  FeatureUsecase(this.repository);
}
```

### @singleton - Eager Singleton

Created immediately, lives forever:

```dart
@singleton
class AnalyticsService {
  void trackEvent(String event) { }
}
```

### @lazySingleton - Lazy Singleton

Created on first use, lives forever:

```dart
@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;
  SecureStorageService(this._storage);
}
```

---

## Interface Registration

Register implementation as interface:

```dart
// Domain
abstract class FeatureRepository {
  Future<Either<Failure, Data>> getData();
}

// Data
@Injectable(as: FeatureRepository)
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource dataSource;
  FeatureRepositoryImpl(this.dataSource);
  
  @override
  Future<Either<Failure, Data>> getData() async { }
}
```

---

## Module Registration

For third-party dependencies:

```dart
// core/network/dio_client.dart
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    dio.interceptors.addAll([authInterceptor, loggingInterceptor]);
    return dio;
  }
}

// core/storage/secure_storage_service.dart
@module
abstract class SecureStorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
```

---

## Factory Methods

For Retrofit data sources:

```dart
@injectable
@RestApi(baseUrl: 'https://api.example.com')
abstract class FeatureRemoteDataSource {
  @factoryMethod
  factory FeatureRemoteDataSource(Dio dio) = _FeatureRemoteDataSource;
  
  @GET('/feature/{id}')
  Future<FeatureModel> getFeature(@Path('id') int id);
}
```

---

## Using Dependencies

### In BLoCs

```dart
@injectable
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureUsecase featureUsecase;
  
  FeatureBloc({required this.featureUsecase}) : super(const FeatureState.initial());
}
```

### In UI

```dart
BlocProvider(
  create: (_) => getIt<FeatureBloc>(),
  child: const FeatureView(),
)
```

### Direct Access

```dart
final analyticsService = getIt<AnalyticsService>();
analyticsService.trackEvent('button_click');
```

---

## Constructor Injection

Preferred pattern - dependencies via constructor:

```dart
@injectable
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorage;
  
  FeatureRepositoryImpl(
    this.remoteDataSource,
    this.secureStorage,
  );
}
```

---

## Order of Registration

For circular dependencies, use post-initialization:

```dart
// injection.dart
@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  
  // Add interceptors after DI graph is built
  final dio = getIt<Dio>();
  final refreshInterceptor = getIt<RefreshTokenInterceptor>();
  dio.interceptors.add(refreshInterceptor);
}
```

---

## Testing with DI

```dart
// Reset for each test
setUp(() {
  getIt.reset();
  configureDependencies();
});

// Mock dependencies
getIt.unregister<FeatureRepository>();
getIt.registerSingleton<FeatureRepository>(MockFeatureRepository());
```

---

## Common Mistakes

❌ **Don't use GetIt directly without registration:**
```dart
// WRONG
final dio = GetIt.instance<Dio>(); // May not be registered yet
```

✅ **Use registered types:**
```dart
// CORRECT
final dio = getIt<Dio>(); // Properly registered via @module
```

❌ **Don't forget @Injectable(as: ...) for interfaces:**
```dart
// WRONG - registers as Implementation
@injectable
class FeatureRepositoryImpl implements FeatureRepository { }
```

✅ **Use correct annotation:**
```dart
// CORRECT - registers as Interface
@Injectable(as: FeatureRepository)
class FeatureRepositoryImpl implements FeatureRepository { }
```

---

## Checklist

- [ ] @injectable / @singleton / @lazySingleton on classes
- [ ] @Injectable(as: Interface) for repository implementations
- [ ] @module for third-party dependencies
- [ ] @factoryMethod for Retrofit data sources
- [ ] configureDependencies() called in main()
- [ ] Run build_runner after adding new injectable classes
