---
name: clean-architecture
description: "Implement Clean Architecture in Flutter: Repository, UseCase, Entity, and strict layer separation with Either<Failure,T> error handling."
---

# Flutter Clean Architecture

## Role
Implement Clean Architecture patterns: Repository, UseCase, Entity, and layer separation.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## Layer Structure

```
features/feature_name/
  data/                        # Data layer
    datasources/               # Remote and local sources
    models/                    # Data models (freezed)
    repositories/              # Repository implementations
    mappers/                   # Model-to-entity mappers
  domain/                      # Domain layer (business logic)
    entities/                  # Plain entity classes
    repositories/              # Repository interfaces
    usecases/                  # Use cases
  presentation/                # UI layer
    bloc/                      # BLoC components
    pages/                     # Screens
    widgets/                   # Feature widgets
```

---

## Domain Layer

### Entity

Plain Dart class representing domain model.

```dart
// domain/entity/user_entity.dart
class UserEntity {
  final int id;
  final String name;
  final String? email;

  UserEntity({
    required this.id,
    required this.name,
    this.email,
  });
}
```

### Repository Interface

Abstract contract defining data operations.

```dart
// domain/repository/user_repository.dart
import 'package:fpdart/fpdart.dart';

import 'package:myapp/core/error/failures.dart';
import 'package:myapp/features/user/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser(int id);
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, UserEntity>> createUser({
    required String name,
    required String email,
  });
}
```

### UseCase

Single responsibility business logic.

```dart
// domain/usecase/get_user_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:myapp/core/error/failures.dart';
import 'package:myapp/features/user/domain/entity/user_entity.dart';
import 'package:myapp/features/user/domain/repository/user_repository.dart';

@injectable
class GetUserUsecase {
  final UserRepository repository;

  GetUserUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({required int id}) {
    return repository.getUser(id);
  }
}
```

---

## Data Layer

### Model

Freezed model with JSON serialization.

```dart
// data/model/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    String? email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### Mapper

Extension for model-to-entity conversion.

```dart
// data/mapper/user_mapper.dart
import 'package:myapp/features/user/data/model/user_model.dart';
import 'package:myapp/features/user/domain/entity/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
      );
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() => UserModel(
        id: id,
        name: name,
        email: email,
      );
}
```

### Repository Implementation

Concrete implementation with error handling.

```dart
// data/repository/user_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:myapp/core/error/error_handler.dart';
import 'package:myapp/core/error/failures.dart';
import 'package:myapp/features/user/data/datasource/user_remote_datasource.dart';
import 'package:myapp/features/user/data/mapper/user_mapper.dart';
import 'package:myapp/features/user/domain/entity/user_entity.dart';
import 'package:myapp/features/user/domain/repository/user_repository.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUser(int id) async {
    try {
      final model = await remoteDataSource.getUser(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final models = await remoteDataSource.getUsers();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final model = await remoteDataSource.createUser(
        name: name,
        email: email,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
```

---

## Dependency Rule

Dependencies point inward:
- Presentation → Domain
- Data → Domain
- Domain has NO dependencies on outer layers

```
Presentation Layer
      ↓
   Domain Layer
      ↓
   Data Layer
```

---

## Error Handling

All repository methods return `Either<Failure, T>`.

```dart
// In BLoC
result.fold(
  (failure) => emit(FeatureState.failure(
    message: ErrorHandler.getErrorMessage(failure)
  )),
  (data) => emit(FeatureState.success(data: data)),
);
```

---

## Best Practices

1. **Domain layer has no dependencies** - Pure business logic
2. **UseCases are single purpose** - One operation per use case
3. **Repositories handle multiple sources** - Remote + local
4. **Models are for data layer** - Don't leak to domain
5. **Entities are for domain** - Used across all layers
6. **Mappers in data layer** - Convert models to entities
