---
name: project-architecture
description: "Define Flutter project structure, folder organization, naming conventions, and required dependencies for clean architecture projects."
---

# Flutter Project Architecture

## Role
Define project structure, folder organization patterns, and required dependencies for Flutter clean architecture projects.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Related Skills

| Skill | Purpose |
|-------|---------|
| **clean_architecture** | Repository, UseCase, Entity patterns, layer separation |
| **solid_oop** | SOLID principles and OOP best practices across all layers |
| **state_management** | BLoC pattern, events, states, BLoC observer |
| **freezed_generation** | Code generation for models, events, states |
| **di_injectable** | Dependency injection with injectable/GetIt |
| **networking** | Dio, Retrofit, interceptors, error handling |
| **routing** | GoRouter, deep linking, navigation patterns |
| **theme** | Material 3 theming, shadcn/ui style, compact UI |
| **ui_patterns** | Widget patterns, performance, responsive design |
| **testing** | Unit, widget, integration testing patterns |
| **notifications** | FCM push notifications, all app states handling |
| **permissions** | Permission handler with dialogs for all platforms |
| **localization** | i18n, ARB files, RTL support |

---

## Quick Reference

### Adding a New Feature

1. **Domain** → See `clean_architecture` skill
2. **Data** → See `clean_architecture` + `freezed_generation` skills
3. **Presentation** → See `state_management` + `freezed_generation` skills
4. **DI** → See `di_injectable` skill

### Common Commands

```bash
dart run build_runner build -d
```

---

## Pre-Action Checklist

Before ANY code modification:
1. Read the file you're about to modify
2. Check existing patterns in similar files
3. Do NOT modify more than 5 files without explicit user permission
4. Check pubspec.yaml for available dependencies

---

## Project Structure Patterns

Two valid patterns are supported. Choose based on project size and team preference.

### Pattern A: Layer-Based Structure

Group by technical layer. Good for smaller projects.

```
lib/
  core/
    di/                          # Dependency injection
      injection.dart
      injection.config.dart
    error/                       # Failures, exceptions, error_handler
    network/                     # Dio, interceptors, connectivity
    storage/                     # Secure storage, Hive
    router/                      # GoRouter configuration
    theme/                       # AppTheme
    widgets/                     # Reusable UI components
    validation/                  # Form validators
    utils/                       # Utilities
    constants/                   
    
  features/
    feature_name/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
```

### Pattern B: Services-Centric Structure

Group all services together. Better for larger apps with many services.

```
lib/
  core/
    di/
    error/
    services/                    # ALL services grouped
      database_service.dart
      secure_storage_service.dart
      connectivity_service.dart
      navigation_service.dart
      analytics_service.dart
      preferences_service.dart
    network/                     # Dio config + interceptors only
      dio_client.dart
      interceptors/
    router/
    theme/
    widgets/
    validation/
    
  features/
    ... (same as Pattern A)
```

---

## Required Dependencies

### Adding Dependencies

Always add packages via terminal so pub resolves the latest compatible version automatically:

```bash
# Runtime dependencies
flutter pub add flutter_bloc injectable get_it fpdart freezed_annotation json_annotation
flutter pub add dio retrofit hive_ce flutter_secure_storage path_provider
flutter pub add envied go_router intl internet_connection_checker_plus
flutter pub add cached_network_image logger flutter_animate encrypt crypto
flutter pub add infinite_scroll_pagination

# Dev dependencies (code generators)
flutter pub add --dev build_runner freezed json_serializable injectable_generator
flutter pub add --dev envied_generator hive_ce_generator retrofit_generator
```

> Never hardcode versions in pubspec.yaml. Let pub pick the latest compatible version. Run `flutter pub outdated` periodically to keep dependencies fresh.

---

## Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Functions/Variables: `camelCase`
- Constants: `camelCase`
- Private members: `_underscorePrefix`

---

## Code Generation Commands

After changing freezed/injectable/retrofit classes:

```bash
dart run build_runner build -d
```

Watch mode for development:
```bash
dart run build_runner watch -d
```

---

## File Organization

Import order:
1. Dart SDK
2. Flutter
3. Third-party packages
4. Project imports

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:myapp/core/error/failures.dart';
```

---

## Industry Standard Approaches

### Feature-First vs Layer-First

**Feature-First** (Recommended for most apps):
```
lib/
  core/                        # Shared infrastructure
  features/
    auth/                      # Auth feature
      data/
      domain/
      presentation/
    home/                      # Home feature
    profile/                   # Profile feature
```
- Pros: Better code discovery, easier navigation, modular
- Cons: Slight duplication of layer structure

**Layer-First** (Traditional approach):
```
lib/
  data/                        # All repositories
  domain/                      # All use cases
  presentation/                # All pages
```
- Pros: Clear layer separation
- Cons: Harder to find feature code, tight coupling

### Monorepo vs Single Repo

**Single Repo** (Current project):
- One codebase, one CI/CD
- Simpler dependency management
- Good for small-medium teams

**Monorepo** (Enterprise):
```
packages/
  core/                        # Shared domain
  data/                        # Data layer package
  ui/                          # Design system
apps/
  mobile/                      # Flutter app
  web/                         # Web app
```

### Repository Pattern Variations

**Single Source** (Simple APIs):
```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  UserRepositoryImpl(this.remote);
}
```

**Multi-Source with Cache** (Offline support):
```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;
  final NetworkInfo networkInfo;
  
  Future<Either<Failure, User>> getUser(int id) async {
    if (await networkInfo.isConnected) {
      final user = await remote.getUser(id);
      await local.cacheUser(user);
      return Right(user);
    } else {
      final user = await local.getLastCachedUser(id);
      return Right(user);
    }
  }
}
```

### Dependency Injection Patterns

**Constructor Injection** (Always preferred):
```dart
@injectable
class LoginUsecase {
  final AuthRepository repository;
  LoginUsecase(this.repository);  // Clean, testable
}
```

**Service Locator** (Avoid in business logic):
```dart
// ❌ Don't do this
class BadUsecase {
  void execute() {
    final repo = getIt<AuthRepository>();  // Hidden dependency
  }
}
```

### Error Handling Strategies

**Either Pattern** (Current project - FP style):
```dart
Future<Either<Failure, User>> getUser();
result.fold(
  (failure) => handleError(failure),
  (user) => displayUser(user),
);
```

**Result Pattern** (Alternative):
```dart
Future<Result<User>> getUser();
if (result.isSuccess) {
  displayUser(result.data);
} else {
  handleError(result.error);
}
```

**Try-Catch with Custom Exceptions**:
```dart
try {
  final user = await repository.getUser();
} on NetworkException catch (e) {
  showNetworkError(e);
} on ServerException catch (e) {
  showServerError(e);
}
```

### Navigation Patterns

**Deep Linking with GoRouter**:
```dart
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);
    return ProductPage(id: id);
  },
)
```

**Guarded Routes** (Auth protection):
```dart
redirect: (context, state) {
  final isAuth = getIt<AuthRepository>().isAuthenticated();
  final isLoggingIn = state.matchedLocation == '/login';
  
  if (!isAuth && !isLoggingIn) return '/login';
  if (isAuth && isLoggingIn) return '/home';
  return null;
}
```

### Testing Pyramid

```
    /\
   /  \      Integration (10%)
  /----\
 /      \     Widget (30%)
/--------\
/          \  Unit (60%)
------------
```

**Unit Tests**: Use cases, repositories (mock data sources)
**Widget Tests**: Pages with mocked BLoCs
**Integration Tests**: End-to-end flows

### Performance Patterns

**const Constructors Everywhere**:
```dart
const SizedBox()  // Not rebuilt
SizedBox()        // Rebuilt on parent update
```

**ListView.builder for Long Lists**:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index].title),
  ),
)
```

**RepaintBoundary for Expensive Widgets**:
```dart
RepaintBoundary(
  child: ComplexChart(data: data),  // Isolated repaint
)
```

### Security Best Practices

1. **Store secrets in secure storage** - Never hardcode API keys
2. **Use envied for compile-time secrets** - Environment variables
3. **Certificate pinning** - Prevent MITM attacks
4. **Obfuscate code in release** - `flutter build apk --obfuscate`
5. **Biometric auth for sensitive actions** - `local_auth` package

---

## Best Practices Summary

### Code Organization
- One class per file (except BLoC events/states as part files)
- Keep files under 300 lines when possible
- Use barrel files (index.dart) for clean exports
- Group related files in folders

### Error Handling
- Always use Either<Failure, T> in repositories
- Never swallow exceptions silently
- Log errors with context
- Show user-friendly error messages

### State Management
- One BLoC per feature/screen
- Keep UI dumb, BLoC smart, UseCases smarter
- Don't store UI state in BLoC (use UI controllers)
- Always handle loading and error states

### Performance
- Use const constructors everywhere
- Use ListView.builder for lists > 10 items
- Cache expensive computations
- Dispose controllers and subscriptions

### Testing
- Write unit tests for business logic
- Mock external dependencies
- Test error paths, not just happy paths
- Use descriptive test names

---

## Prohibited Actions

❌ **Never do these:**

1. **Don't use GetIt directly in business logic**
```dart
// ❌ Wrong
class BadUsecase {
  void execute() {
    final repo = getIt<Repository>();  // Hidden dependency
  }
}
```

2. **Don't use dynamic types**
```dart
// ❌ Wrong
Future<dynamic> fetchData()  // Use proper types
```

3. **Don't expose data models to UI**
```dart
// ❌ Wrong
class UserPage extends StatelessWidget {
  final UserModel user;  // Should be UserEntity
}
```

4. **Don't skip error handling**
```dart
// ❌ Wrong
try {
  await repository.getData();
} catch (e) {
  // Ignored - BAD!
}
```

5. **Don't use setState for app-wide state**
```dart
// ❌ Wrong - use BLoC instead
setState(() => count++);
```

6. **Don't create God objects**
```dart
// ❌ Wrong - too many responsibilities
class GodRepository {
  Future<User> getUser() {}
  Future<Order> getOrder() {}
  Future<Payment> processPayment() {}
  Future<Notification> sendNotification() {}
}
```

7. **Don't modify more than 5 files without permission**
8. **Don't create unnecessary markdown files**
9. **Don't write tests unless explicitly requested**
10. **Don't use Navigator directly - use GoRouter**

---

## Pre-Submission Checklist

- [ ] Uses correct folder structure (Pattern A or B)
- [ ] All dependencies in pubspec.yaml
- [ ] File names follow snake_case
- [ ] Class names follow PascalCase
- [ ] Code generation commands documented
