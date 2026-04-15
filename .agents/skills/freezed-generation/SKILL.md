---
name: freezed-generation
description: "Generate immutable data classes, BLoC events and states using freezed with build_runner in Flutter."
---

# Freezed Code Generation

## Role
Generate immutable data classes, BLoC events/states using freezed with build_runner.

---

## Commands

### One-time generation
```bash
dart run build_runner build -d
```

### Watch mode (development)
```bash
dart run build_runner watch -d
```

---

## Model Generation

### Basic Model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    String? email,
    @Default(false) bool isActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### List Handling

```dart
@freezed
abstract class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    required List<UserModel> users,
    required int total,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}
```

### Custom JSON Keys

```dart
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'user_id') required int id,
    @JsonKey(name: 'full_name') required String name,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### DateTime Handling

```dart
@freezed
abstract class EventModel with _$EventModel {
  const factory EventModel({
    required String title,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime createdAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
String _dateTimeToJson(DateTime date) => date.toIso8601String();
```

---

## BLoC Event Generation

```dart
part of 'feature_bloc.dart';

@freezed
sealed class FeatureEvent with _$FeatureEvent {
  const factory FeatureEvent.started() = _Started;
  const factory FeatureEvent.load({required String id}) = _Load;
  const factory FeatureEvent.submit({required FormData data}) = _Submit;
  const factory FeatureEvent.refresh() = _Refresh;
}
```

---

## BLoC State Generation

```dart
part of 'feature_bloc.dart';

@freezed
sealed class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = Initial;
  const factory FeatureState.loading() = Loading;
  const factory FeatureState.success({required Data data}) = Success;
  const factory FeatureState.failure({required String message}) = Failure;
  
  // Form validation state
  const factory FeatureState.validating() = Validating;
  const factory FeatureState.valid({required bool isValid}) = Valid;
}
```

---

## Failure Class Generation

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.server(String message) = ServerFailure;
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.validation(String message) = ValidationFailure;
  const factory Failure.unauthorized(String message) = UnauthorizedFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}
```

---

## Troubleshooting

### Generated file not found
Run build_runner again:
```bash
dart run build_runner build -d
```

### Conflicting outputs error
Always use `--delete-conflicting-outputs` flag

### Import errors in generated files
Check that `part` statements match file names exactly

### Analysis errors
Add to `analysis_options.yaml`:
```yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
```

---

## Checklist

Before running build_runner:
- [ ] `@freezed` annotation present
- [ ] `part 'filename.freezed.dart'` declared
- [ ] `part 'filename.g.dart'` declared (if using fromJson)
- [ ] `with _$ClassName` in class declaration
- [ ] File name matches part declarations

After running build_runner:
- [ ] `.freezed.dart` file generated
- [ ] `.g.dart` file generated (if using JSON)
- [ ] No analysis errors
