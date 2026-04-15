---
name: testing
description: "Write Flutter tests following the testing pyramid: unit tests for business logic, widget tests with mocked BLoCs, and integration tests."
---

# Flutter Testing

## Role
Write tests following the testing pyramid: unit, widget, and integration tests.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Testing Pyramid

```
    /\              Integration (10%)
   /  \            - End-to-end flows
  /----\
 /      \          Widget (30%)
/--------\        - UI with mocked dependencies
/          \        Unit (60%)
------------       - Business logic, repositories
```

---

## Unit Testing

### Setup

```bash
flutter pub add --dev mocktail bloc_test
```

> Always add via terminal — pub resolves the latest compatible versions automatically.

### Repository Tests

```dart
// test/features/auth/data/repository/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import 'package:myapp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:myapp/features/auth/data/datasource/auth_remote_data_source.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('login', () {
    const tUsername = 'user';
    const tPassword = 'pass';

    test('should return User when login is successful', () async {
      // Arrange
      when(() => mockDataSource.login(any()))
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.login(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, equals(Right(tUserEntity)));
      verify(() => mockDataSource.login(any())).called(1);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      when(() => mockDataSource.login(any()))
          .thenThrow(ServerException());

      // Act
      final result = await repository.login(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, equals(Left(ServerFailure(''))));
    });
  });
}
```

### UseCase Tests

```dart
// test/features/auth/domain/usecase/login_usecase_test.dart
void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(mockRepository);
  });

  test('should call repository.login with correct params', () async {
    // Arrange
    when(() => mockRepository.login(
      username: any(named: 'username'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => Right(tUserEntity));

    // Act
    final result = await usecase(username: 'user', password: 'pass');

    // Assert
    expect(result, Right(tUserEntity));
    verify(() => mockRepository.login(username: 'user', password: 'pass'));
    verifyNoMoreInteractions(mockRepository);
  });
}
```

### BLoC Tests

```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';

void main() {
  late AuthBloc bloc;
  late MockLoginUsecase mockLoginUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    bloc = AuthBloc(loginUsecase: mockLoginUsecase);
  });

  blocTest<AuthBloc, AuthState>(
    'emits [loading, success] when login succeeds',
    build: () {
      when(() => mockLoginUsecase.call(
        username: any(named: 'username'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => Right(tUserEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthEvent.login(
      username: 'user',
      password: 'pass',
    )),
    expect: () => [
      const AuthState.loading(),
      AuthState.success(user: tUserEntity),
    ],
    verify: (_) {
      verify(() => mockLoginUsecase.call(
        username: 'user',
        password: 'pass',
      )).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, failure] when login fails',
    build: () {
      when(() => mockLoginUsecase.call(
        username: any(named: 'username'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => Left(ServerFailure('Server error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthEvent.login(
      username: 'user',
      password: 'pass',
    )),
    expect: () => [
      const AuthState.loading(),
      const AuthState.failure(message: 'Server error'),
    ],
  );
}
```

---

## Widget Testing

### Page Tests

```dart
// test/features/auth/presentation/view/login_page_test.dart
void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();
    when(() => mockBloc.state).thenReturn(const AuthState.initial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockBloc,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (WidgetTester tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.fromIterable([const AuthState.loading()]),
      initialState: const AuthState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error message when login fails',
      (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Invalid credentials';
    whenListen(
      mockBloc,
      Stream.fromIterable([
        const AuthState.initial(),
        const AuthState.loading(),
        const AuthState.failure(message: errorMessage),
      ]),
      initialState: const AuthState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should dispatch LoginEvent when login button tapped',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    await tester.enterText(find.byKey(const Key('username_field')), 'user');
    await tester.enterText(find.byKey(const Key('password_field')), 'pass');
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    verify(() => mockBloc.add(const AuthEvent.login(
      username: 'user',
      password: 'pass',
    ))).called(1);
  });
}
```

### Golden Tests

```dart
// test/goldens/login_page_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('LoginPage should match golden', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario('Default', const LoginPage())
      ..addScenario('Loading', const LoginPageLoadingState())
      ..addScenario('Error', const LoginPageErrorState());

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(),
    );

    await screenMatchesGolden(tester, 'login_page');
  });
}
```

---

## Integration Testing

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('login flow', (tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'testuser',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify navigation to home
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
```

Run integration tests:
```bash
flutter test integration_test/app_test.dart
```

---

## Testing Best Practices

### 1. Test Behavior, Not Implementation

```dart
// ❌ Bad - tests implementation detail
test('should call dataSource.getUser', () {
  repository.getUser(1);
  verify(() => dataSource.getUser(1)).called(1);
});

// ✅ Good - tests behavior
test('should return user when found', () async {
  final result = await repository.getUser(1);
  expect(result.isRight(), true);
});
```

### 2. One Assertion Per Test (Usually)

```dart
// ❌ Bad - too many assertions
test('login', () async {
  final result = await usecase.call();
  expect(result.isRight(), true);
  expect(result.getOrElse(() => null).id, 1);
  expect(result.getOrElse(() => null).name, 'Test');
});

// ✅ Good - focused test
test('should return authenticated user', () async {
  final result = await usecase.call();
  expect(result, equals(Right(tAuthenticatedUser)));
});
```

### 3. Use Descriptive Test Names

```dart
// ❌ Bad
void main() {
  test('test 1', () {});
  test('test 2', () {});
}

// ✅ Good
void main() {
  group('LoginUsecase', () {
    test('should return User when credentials are valid', () {});
    test('should return AuthFailure when password is incorrect', () {});
    test('should return NetworkFailure when offline', () {});
  });
}
```

### 4. Arrange-Act-Assert Pattern

```dart
test('should cache user after successful fetch', () async {
  // ARRANGE
  when(() => remoteDataSource.getUser(1))
      .thenAnswer((_) async => tUserModel);
  
  // ACT
  await repository.getUser(1);
  
  // ASSERT
  verify(() => localDataSource.cacheUser(tUserModel)).called(1);
});
```

### 5. Mock Only External Dependencies

```dart
// ✅ Good - mock external data source
class MockRemoteDataSource extends Mock implements RemoteDataSource {}

// ❌ Bad - don't mock simple value objects
class MockUserEntity extends Mock implements UserEntity {}
```

---

## Test Organization

```
test/
  unit/
    core/
      utils/
      error/
    features/
      auth/
        domain/
        data/
  widget/
    features/
      auth/
        presentation/
  integration/
    app_test.dart
  goldens/
```

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/domain/usecase/login_usecase_test.dart

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run widget tests only
flutter test test/widget/

# Run integration tests
flutter test integration_test/
```

---

## Prohibited Patterns

❌ **Don't test private methods directly:**
```dart
// ❌ Bad
repository._fetchFromCache();  // Can't test private methods

// ✅ Good - test through public API
repository.getUser(1);  // Tests private method indirectly
```

❌ **Don't share state between tests:**
```dart
// ❌ Bad
late User user;

setUp(() {
  user = User();  // Shared across all tests
});

// ✅ Good
setUp(() {
  final user = User();  // Fresh for each test
});
```

❌ **Don't skip setup/tearDown:**
```dart
// ❌ Bad
test('something', () async {
  final bloc = MyBloc();  // Not closed
});

// ✅ Good
late MyBloc bloc;

setUp(() => bloc = MyBloc());
tearDown(() => bloc.close());
```

# Flutter Testing

## Role
Write tests following the testing pyramid: unit, widget, and integration tests.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Testing Pyramid

```
    /\              Integration (10%)
   /  \            - End-to-end flows
  /----\
 /      \          Widget (30%)
/--------\        - UI with mocked dependencies
/          \        Unit (60%)
------------       - Business logic, repositories
```

---

## Unit Testing

### Setup

```bash
flutter pub add --dev mocktail bloc_test
```

> Always add via terminal — pub resolves the latest compatible versions automatically.

### Repository Tests

```dart
// test/features/auth/data/repository/auth_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import 'package:myapp/features/auth/data/repository/auth_repository_impl.dart';
import 'package:myapp/features/auth/data/datasource/auth_remote_data_source.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('login', () {
    const tUsername = 'user';
    const tPassword = 'pass';

    test('should return User when login is successful', () async {
      // Arrange
      when(() => mockDataSource.login(any()))
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.login(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, equals(Right(tUserEntity)));
      verify(() => mockDataSource.login(any())).called(1);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      when(() => mockDataSource.login(any()))
          .thenThrow(ServerException());

      // Act
      final result = await repository.login(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, equals(Left(ServerFailure(''))));
    });
  });
}
```

### UseCase Tests

```dart
// test/features/auth/domain/usecase/login_usecase_test.dart
void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(mockRepository);
  });

  test('should call repository.login with correct params', () async {
    // Arrange
    when(() => mockRepository.login(
      username: any(named: 'username'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => Right(tUserEntity));

    // Act
    final result = await usecase(username: 'user', password: 'pass');

    // Assert
    expect(result, Right(tUserEntity));
    verify(() => mockRepository.login(username: 'user', password: 'pass'));
    verifyNoMoreInteractions(mockRepository);
  });
}
```

### BLoC Tests

```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';

void main() {
  late AuthBloc bloc;
  late MockLoginUsecase mockLoginUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    bloc = AuthBloc(loginUsecase: mockLoginUsecase);
  });

  blocTest<AuthBloc, AuthState>(
    'emits [loading, success] when login succeeds',
    build: () {
      when(() => mockLoginUsecase.call(
        username: any(named: 'username'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => Right(tUserEntity));
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthEvent.login(
      username: 'user',
      password: 'pass',
    )),
    expect: () => [
      const AuthState.loading(),
      AuthState.success(user: tUserEntity),
    ],
    verify: (_) {
      verify(() => mockLoginUsecase.call(
        username: 'user',
        password: 'pass',
      )).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, failure] when login fails',
    build: () {
      when(() => mockLoginUsecase.call(
        username: any(named: 'username'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => Left(ServerFailure('Server error')));
      return bloc;
    },
    act: (bloc) => bloc.add(const AuthEvent.login(
      username: 'user',
      password: 'pass',
    )),
    expect: () => [
      const AuthState.loading(),
      const AuthState.failure(message: 'Server error'),
    ],
  );
}
```

---

## Widget Testing

### Page Tests

```dart
// test/features/auth/presentation/view/login_page_test.dart
void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();
    when(() => mockBloc.state).thenReturn(const AuthState.initial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockBloc,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (WidgetTester tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.fromIterable([const AuthState.loading()]),
      initialState: const AuthState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show error message when login fails',
      (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Invalid credentials';
    whenListen(
      mockBloc,
      Stream.fromIterable([
        const AuthState.initial(),
        const AuthState.loading(),
        const AuthState.failure(message: errorMessage),
      ]),
      initialState: const AuthState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should dispatch LoginEvent when login button tapped',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    await tester.enterText(find.byKey(const Key('username_field')), 'user');
    await tester.enterText(find.byKey(const Key('password_field')), 'pass');
    await tester.tap(find.byType(ElevatedButton));

    // Assert
    verify(() => mockBloc.add(const AuthEvent.login(
      username: 'user',
      password: 'pass',
    ))).called(1);
  });
}
```

### Golden Tests

```dart
// test/goldens/login_page_test.dart
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('LoginPage should match golden', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario('Default', const LoginPage())
      ..addScenario('Loading', const LoginPageLoadingState())
      ..addScenario('Error', const LoginPageErrorState());

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(),
    );

    await screenMatchesGolden(tester, 'login_page');
  });
}
```

---

## Integration Testing

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('login flow', (tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'testuser',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap login
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify navigation to home
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
```

Run integration tests:
```bash
flutter test integration_test/app_test.dart
```

---

## Testing Best Practices

### 1. Test Behavior, Not Implementation

```dart
// ❌ Bad - tests implementation detail
test('should call dataSource.getUser', () {
  repository.getUser(1);
  verify(() => dataSource.getUser(1)).called(1);
});

// ✅ Good - tests behavior
test('should return user when found', () async {
  final result = await repository.getUser(1);
  expect(result.isRight(), true);
});
```

### 2. One Assertion Per Test (Usually)

```dart
// ❌ Bad - too many assertions
test('login', () async {
  final result = await usecase.call();
  expect(result.isRight(), true);
  expect(result.getOrElse(() => null).id, 1);
  expect(result.getOrElse(() => null).name, 'Test');
});

// ✅ Good - focused test
test('should return authenticated user', () async {
  final result = await usecase.call();
  expect(result, equals(Right(tAuthenticatedUser)));
});
```

### 3. Use Descriptive Test Names

```dart
// ❌ Bad
void main() {
  test('test 1', () {});
  test('test 2', () {});
}

// ✅ Good
void main() {
  group('LoginUsecase', () {
    test('should return User when credentials are valid', () {});
    test('should return AuthFailure when password is incorrect', () {});
    test('should return NetworkFailure when offline', () {});
  });
}
```

### 4. Arrange-Act-Assert Pattern

```dart
test('should cache user after successful fetch', () async {
  // ARRANGE
  when(() => remoteDataSource.getUser(1))
      .thenAnswer((_) async => tUserModel);
  
  // ACT
  await repository.getUser(1);
  
  // ASSERT
  verify(() => localDataSource.cacheUser(tUserModel)).called(1);
});
```

### 5. Mock Only External Dependencies

```dart
// ✅ Good - mock external data source
class MockRemoteDataSource extends Mock implements RemoteDataSource {}

// ❌ Bad - don't mock simple value objects
class MockUserEntity extends Mock implements UserEntity {}
```

---

## Test Organization

```
test/
  unit/
    core/
      utils/
      error/
    features/
      auth/
        domain/
        data/
  widget/
    features/
      auth/
        presentation/
  integration/
    app_test.dart
  goldens/
```

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/domain/usecase/login_usecase_test.dart

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run widget tests only
flutter test test/widget/

# Run integration tests
flutter test integration_test/
```

---

## Prohibited Patterns

❌ **Don't test private methods directly:**
```dart
// ❌ Bad
repository._fetchFromCache();  // Can't test private methods

// ✅ Good - test through public API
repository.getUser(1);  // Tests private method indirectly
```

❌ **Don't share state between tests:**
```dart
// ❌ Bad
late User user;

setUp(() {
  user = User();  // Shared across all tests
});

// ✅ Good
setUp(() {
  final user = User();  // Fresh for each test
});
```

❌ **Don't skip setup/tearDown:**
```dart
// ❌ Bad
test('something', () async {
  final bloc = MyBloc();  // Not closed
});

// ✅ Good
late MyBloc bloc;

setUp(() => bloc = MyBloc());
tearDown(() => bloc.close());
```
