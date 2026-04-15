---
name: solid-oop
description: "Enforce all five SOLID principles and OOP best practices (encapsulation, immutability, composition) across every layer of a Flutter project."
---

# SOLID & OOP Principles

## Role
Enforce SOLID principles and OOP best practices across all layers of the Flutter project.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## The Five SOLID Principles

| Principle | Short Form | What It Means |
|-----------|-----------|---------------|
| Single Responsibility | SRP | One class, one reason to change |
| Open/Closed | OCP | Open for extension, closed for modification |
| Liskov Substitution | LSP | Subtypes must be substitutable for their base types |
| Interface Segregation | ISP | Prefer small, focused interfaces over fat ones |
| Dependency Inversion | DIP | Depend on abstractions, not concretions |

---

## S — Single Responsibility Principle

Each class has exactly one job. Split when a class does more than one thing.

### ❌ Violation — BLoC doing data fetching AND formatting

```dart
// WRONG: HistoryBloc formats dates AND manages state
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  Future<void> _onFetch(FetchHistory event, Emitter<HistoryState> emit) async {
    final result = await _getHistory();
    result.fold(
      (failure) => emit(HistoryState.error(failure.message)),
      (launches) {
        // Formatting logic does NOT belong in BLoC
        final formatted = launches.map((l) => '${l.name} - ${l.dateUtc.year}').toList();
        emit(HistoryState.loaded(allLaunches: launches, filteredLaunches: launches));
      },
    );
  }
}
```

### ✅ Correct — formatting extracted to a dedicated class

```dart
// Separate formatter — single responsibility
class LaunchFormatter {
  static String formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  static String formatFlightLabel(int number) => 'Flight #$number';
}

// BLoC only manages state
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  Future<void> _onFetch(FetchHistory event, Emitter<HistoryState> emit) async {
    emit(const HistoryState.loading());
    final result = await _getHistory();
    result.fold(
      (failure) => emit(HistoryState.error(failure.message)),
      (launches) => emit(HistoryState.loaded(allLaunches: launches, filteredLaunches: launches)),
    );
  }
}
```

### Applied to project layers

| Layer | Single Responsibility |
|-------|-----------------------|
| Entity | Holds domain data only — no JSON, no formatting |
| Model | Handles JSON serialization only |
| Mapper | Converts model ↔ entity only |
| Repository | Orchestrates data sources only |
| UseCase | Executes one business operation only |
| BLoC | Manages one feature's state only |
| Widget | Renders UI only — no business logic |

---

## O — Open/Closed Principle

Classes are open for extension but closed for modification. Add behavior by extending, not by editing existing code.

### ❌ Violation — adding new failure types by modifying ErrorHandler

```dart
// WRONG: every new error type requires editing this class
class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) { ... }
    if (error is CacheException) { ... }
    // Adding new type = modifying this class ❌
    if (error is AuthException) { ... }
  }
}
```

### ✅ Correct — extend via new Exception types, handler stays closed

```dart
// New exception types extend the hierarchy — ErrorHandler unchanged
class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed']);
}

// ErrorHandler handles it via the existing typed-exception branch
// No modification needed — it already handles any Exception with .message
class ErrorHandler {
  static Failure handleException(dynamic error) {
    if (error is ServerException ||
        error is NetworkException ||
        error is CacheException ||
        error is AuthException) {          // ← just add to the check
      return Failure((error as dynamic).message as String);
    }
    // ... rest unchanged
  }
}
```

### Applied to interceptors

```dart
// Base behavior closed — extend by adding new interceptors, not editing existing ones
@lazySingleton
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}

// Dio module wires them — adding new interceptor = adding one line here only
Dio dio(HeaderInterceptor h, ConnectivityInterceptor c, AuthInterceptor a) {
  return Dio()..interceptors.addAll([c, h, a]);
}
```

---

## L — Liskov Substitution Principle

Any implementation of an abstract class must be fully substitutable for it. Never override a method to throw or do nothing.

### ❌ Violation — implementation breaks the contract

```dart
abstract class SpaceXRepository {
  Future<Either<Failure, List<LaunchEntity>>> getLaunches();
}

// WRONG: throws instead of returning Either — breaks the contract
class BrokenRepositoryImpl implements SpaceXRepository {
  @override
  Future<Either<Failure, List<LaunchEntity>>> getLaunches() {
    throw UnimplementedError(); // ❌ callers expect Either, not an exception
  }
}
```

### ✅ Correct — implementation always honours the contract

```dart
@LazySingleton(as: SpaceXRepository)
class SpaceXRepositoryImpl implements SpaceXRepository {
  @override
  Future<Either<Failure, List<LaunchEntity>>> getLaunches() async {
    try {
      final models = await _remoteDataSource.getLaunches();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e)); // ✅ always returns Either
    }
  }
}
```

### Applied to services

```dart
// Abstract contract
abstract class ConnectivityService {
  Future<bool> get isConnected;
  Stream<InternetStatus> get onStatusChange;
}

// Implementation fully substitutable — no extra throws, no missing behaviour
@LazySingleton(as: ConnectivityService)
class ConnectivityServiceImpl implements ConnectivityService {
  @override
  Future<bool> get isConnected => _checker.hasInternetAccess;

  @override
  Stream<InternetStatus> get onStatusChange => _checker.onStatusChange;
}
```

---

## I — Interface Segregation Principle

Keep abstracts small and focused. Don't force implementors to depend on methods they don't use.

### ❌ Violation — fat repository interface

```dart
// WRONG: one interface forces all implementors to implement everything
abstract class SpaceXRepository {
  Future<Either<Failure, List<LaunchEntity>>> getLaunches();
  Future<Either<Failure, LaunchEntity>> getLatestLaunch();
  Future<Either<Failure, void>> clearCache();       // not all impls need this
  Future<Either<Failure, void>> syncOfflineData();  // not all impls need this
}
```

### ✅ Correct — split by concern

```dart
abstract class SpaceXRepository {
  Future<Either<Failure, List<LaunchEntity>>> getLaunches();
  Future<Either<Failure, LaunchEntity>> getLatestLaunch();
}

abstract class SpaceXCacheRepository {
  Future<Either<Failure, void>> clearCache();
}

abstract class SpaceXSyncRepository {
  Future<Either<Failure, void>> syncOfflineData();
}

// Implementation only implements what it needs
@LazySingleton(as: SpaceXRepository)
class SpaceXRepositoryImpl implements SpaceXRepository {
  // Only getLaunches + getLatestLaunch — no forced stubs
}
```

### Applied to data sources

```dart
// Focused interface — only what remote needs
abstract class SpaceXRemoteDataSource {
  Future<List<Launch>> getLaunches();
  Future<Launch> getLatestLaunch();
}

// Focused interface — only what local needs
abstract class SpaceXLocalDataSource {
  Future<List<Launch>> getCachedLaunches();
  Future<void> cacheLaunches(List<Launch> launches);
  Future<void> clearCache();
}
```

---

## D — Dependency Inversion Principle

High-level modules must not depend on low-level modules. Both depend on abstractions.

### ❌ Violation — UseCase depends on concrete implementation

```dart
// WRONG: UseCase imports the concrete class directly
import 'package:myapp/features/spacex/data/repositories/spacex_repository_impl.dart';

@injectable
class GetLatestLaunchUseCase {
  final SpaceXRepositoryImpl repository; // ❌ concrete, not abstract
  GetLatestLaunchUseCase(this.repository);
}
```

### ✅ Correct — UseCase depends on the domain abstraction

```dart
// CORRECT: UseCase depends on the abstract interface in domain layer
import 'package:myapp/features/spacex/domain/repositories/spacex_repository.dart';

@injectable
class GetLatestLaunchUseCase {
  final SpaceXRepository repository; // ✅ abstraction
  GetLatestLaunchUseCase(this.repository);

  Future<Either<Failure, LaunchEntity>> call() => repository.getLatestLaunch();
}
```

### DI wires the concrete at runtime — nothing else knows about it

```dart
// injectable resolves SpaceXRepository → SpaceXRepositoryImpl automatically
gh.lazySingleton<SpaceXRepository>(
  () => SpaceXRepositoryImpl(gh<SpaceXRemoteDataSource>()),
);
```

### Dependency direction rule

```
Presentation  →  Domain abstractions  ←  Data implementations
BLoC          →  UseCase
UseCase       →  Repository (abstract, in domain/)
RepositoryImpl → DataSource (abstract)
DataSourceImpl → API client / DB
```

Never import across layers in the wrong direction. Domain must never import from data or presentation.

---

## OOP Best Practices

### Encapsulation — keep internals private

```dart
// ❌ Bad — exposes internal state
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  List<LaunchEntity> launches = []; // public mutable field
}

// ✅ Good — state is encapsulated in immutable BLoC states
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetLaunchHistoryUseCase _getHistory; // private dependency

  // State is only accessible via stream — never mutated directly
}
```

### Composition over inheritance

```dart
// ❌ Bad — deep inheritance for reuse
class BaseBloc extends Bloc { ... }
class FeatureBloc extends BaseBloc { ... } // fragile hierarchy

// ✅ Good — compose via UseCases injected into BLoC
@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetLaunchHistoryUseCase _getHistory; // composed, not inherited
}
```

### Immutability — prefer immutable data

```dart
// ❌ Bad — mutable entity
class LaunchEntity {
  String name;        // mutable
  DateTime dateUtc;   // mutable
}

// ✅ Good — immutable entity with final fields
class LaunchEntity {
  final String name;
  final DateTime dateUtc;

  const LaunchEntity({required this.name, required this.dateUtc});
}
```

### Polymorphism via sealed states

```dart
// ✅ Sealed states enable exhaustive pattern matching — no missed cases
@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = HistoryInitial;
  const factory HistoryState.loading() = HistoryLoading;
  const factory HistoryState.loaded({...}) = HistoryLoaded;
  const factory HistoryState.error(String message) = HistoryError;
}

// Compiler enforces all cases are handled
return switch (state) {
  HistoryInitial() => ...,
  HistoryLoading() => ...,
  HistoryLoaded(:final filteredLaunches) => ...,
  HistoryError(:final message) => ...,
};
```

### Abstract classes for contracts, not for sharing code

```dart
// ✅ Abstract class = contract only
abstract class SpaceXRepository {
  Future<Either<Failure, List<LaunchEntity>>> getLaunches();
  Future<Either<Failure, LaunchEntity>> getLatestLaunch();
}

// ❌ Don't put shared logic in abstract classes — use composition instead
abstract class BaseRepository {
  ErrorHandler errorHandler = ErrorHandler(); // shared state = bad
  Future<void> logError(e) { ... }           // shared behaviour = use mixin or helper
}
```

---

## Checklist — Before Committing Code

### SRP
- [ ] Each class has one reason to change
- [ ] BLoCs contain no formatting, parsing, or business logic beyond state transitions
- [ ] Mappers only convert — no validation, no network calls
- [ ] Widgets only render — no direct repository or use case calls

### OCP
- [ ] New features added by creating new classes, not editing existing ones
- [ ] New exception types extend the exception hierarchy — `ErrorHandler` stays closed
- [ ] New interceptors added to Dio module without touching existing interceptors

### LSP
- [ ] Every repository implementation always returns `Either<Failure, T>` — never throws
- [ ] Every service implementation fully satisfies its abstract contract
- [ ] No `UnimplementedError` or empty method bodies in production code

### ISP
- [ ] Repository interfaces contain only methods the feature actually needs
- [ ] Remote and local data source interfaces are separate
- [ ] No interface has more than ~5 methods — split if larger

### DIP
- [ ] UseCases import from `domain/repositories/` — never from `data/`
- [ ] BLoCs import UseCases — never repositories or data sources directly
- [ ] All constructor parameters use abstract types, not concrete implementations
- [ ] `@Injectable(as: AbstractType)` used on all repository/service implementations

### OOP
- [ ] All entity fields are `final`
- [ ] Internal BLoC dependencies are `_private`
- [ ] No public mutable state outside of BLoC streams
- [ ] Sealed classes used for all BLoC states
- [ ] Composition preferred over inheritance for code reuse

---

## Prohibited Patterns

❌ **Don't let domain depend on data:**
```dart
// WRONG — domain importing data model
import 'package:myapp/features/spacex/data/models/launch_model.dart';
```

❌ **Don't put business logic in widgets:**
```dart
// WRONG
onTap: () async {
  final result = await repository.getLaunches(); // ❌ direct repo call in UI
}
```

❌ **Don't use dynamic types to bypass the type system:**
```dart
// WRONG
Future<dynamic> getUser() async { ... } // loses all type safety
```

❌ **Don't create God classes:**
```dart
// WRONG — one class doing everything
class AppManager {
  void fetchData() { ... }
  void navigate() { ... }
  void showDialog() { ... }
  void saveToCache() { ... }
}
```

❌ **Don't override abstract methods with throws:**
```dart
// WRONG
@override
Future<Either<Failure, List<LaunchEntity>>> getLaunches() {
  throw UnimplementedError();
}
```
