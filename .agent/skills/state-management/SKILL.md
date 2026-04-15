---
name: state-management
description: "Implement Flutter state management using the BLoC pattern with freezed sealed states, BlocObserver, and event transformation patterns."
---

# Flutter BLoC State Management

## Role
Implement state management using BLoC pattern with freezed for events and states.

> **Note on package names:** All code examples use `package:myapp` as a placeholder. Replace `myapp` with the actual project package name (e.g., `package:rich`). Focus on the code structure and patterns, not the package name.

---

## BLoC Structure

One BLoC consists of 3 files:
1. `feature_bloc.dart` - Main bloc class
2. `feature_event.dart` - Events (part of bloc)
3. `feature_state.dart` - States (part of bloc)

Plus generated file: `feature_bloc.freezed.dart`

---

## BLoC Observer

### Implementation

```dart
// core/monitoring/app_bloc_observer.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../utils/app_logger.dart';

@lazySingleton
class AppBlocObserver extends BlocObserver {
  final AppLogger _logger;

  AppBlocObserver(this._logger);

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.d('[BLoC] Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.d('[BLoC] Event: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.d('[BLoC] State: ${bloc.runtimeType}: ${change.currentState} -> ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.d('[BLoC] Transition: ${transition.currentState} -> ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.e('[BLoC] Error in ${bloc.runtimeType}: $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.d('[BLoC] Closed: ${bloc.runtimeType}');
  }
}
```

### Registration in main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  
  Bloc.observer = getIt<AppBlocObserver>();
  
  runApp(const MyApp());
}
```

### Production Observer (with Crash Reporting)

```dart
@lazySingleton
class AppBlocObserver extends BlocObserver {
  final AppLogger _logger;
  final CrashReportingService _crashReporter;

  AppBlocObserver(this._logger, this._crashReporter);

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.e('[BLoC] Error: $error');
    _crashReporter.reportError(error, stackTrace, context: bloc.runtimeType.toString());
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Track state changes for analytics
    _crashReporter.log('state_change', {
      'bloc': bloc.runtimeType.toString(),
      'from': change.currentState.toString(),
      'to': change.nextState.toString(),
    });
  }
}
```

---

## Industry Standard Patterns

### 1. Hydrated BLoC (State Persistence)

Persist state across app restarts:

```dart
// Not in current project - add hydrated_bloc if needed
class UserBloc extends HydratedBloc<UserEvent, UserState> {
  @override
  UserState fromJson(Map<String, dynamic> json) =>
      UserState.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserState state) => state.toJson();
}
```

### 2. Replay BLoC (Undo/Redo)

For features needing undo functionality:

```dart
// Wrap events to enable replay
class ReplayBloc extends Bloc<ReplayEvent, ReplayState> {
  final List<ReplayEvent> _history = [];
  int _currentIndex = -1;
  
  void undo() {
    if (_currentIndex > 0) {
      _currentIndex--;
      add(_history[_currentIndex]);
    }
  }
}
```

### 3. Event Transformation Patterns

#### Debounce (Search Input)

```dart
@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchUsecase}) : super(const SearchState.initial()) {
    on<_QueryChanged>(_onQueryChanged, transformer: debounce(const Duration(milliseconds: 500)));
  }
}

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).asyncExpand(mapper);
}
```

#### Throttle (Button Clicks)

```dart
on<_Submit>(_onSubmit, transformer: throttle(const Duration(milliseconds: 1000)));

EventTransformer<E> throttle<E>(Duration duration) {
  return (events, mapper) => events.throttleTime(duration).asyncExpand(mapper);
}
```

### 4. BLoC-to-BLoC Communication

Via Repository Pattern (Preferred):

```dart
@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  
  NotificationBloc(this._repository) : super(const NotificationState.initial()) {
    // Listen to shared data source
    _repository.unreadCountStream.listen((count) {
      add(NotificationEvent.countChanged(count: count));
    });
  }
}
```

Via EventBus (Avoid when possible):

```dart
// Only for cross-feature communication without direct dependency
class GlobalEventBus {
  final _controller = StreamController<Event>.broadcast();
  Stream<Event> get stream => _controller.stream;
  void emit(Event event) => _controller.add(event);
}
```

### 5. Multi-BLoC Listener Pattern

For pages needing multiple blocs:

```dart
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<StatsBloc>()),
        BlocProvider(create: (_) => getIt<ChartBloc>()),
        BlocProvider(create: (_) => getIt<RecentActivityBloc>()),
      ],
      child: const DashboardView(),
    );
  }
}
```

### 6. BLoC Selector (Performance)

Rebuild only when specific state changes:

```dart
BlocSelector<CartBloc, CartState, int>(
  selector: (state) => state.itemCount, // Only rebuild when itemCount changes
  builder: (context, itemCount) {
    return Badge(count: itemCount);
  },
)
```

---

## File Template

### feature_bloc.dart

```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:myapp/core/error/error_handler.dart';
import 'package:myapp/features/feature/domain/usecase/feature_usecase.dart';

part 'feature_event.dart';
part 'feature_state.dart';
part 'feature_bloc.freezed.dart';

@injectable
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureUsecase featureUsecase;

  FeatureBloc({required this.featureUsecase}) : super(const FeatureState.initial()) {
    on<_Load>(_onLoad);
    on<_Submit>(_onSubmit);
  }

  Future<void> _onLoad(_Load event, Emitter<FeatureState> emit) async {
    emit(const FeatureState.loading());
    
    final result = await featureUsecase.call(param: event.param);
    
    result.fold(
      (failure) => emit(FeatureState.failure(
        message: ErrorHandler.getErrorMessage(failure)
      )),
      (data) => emit(FeatureState.success(data: data)),
    );
  }

  FutureOr<void> _onSubmit(_Submit event, Emitter<FeatureState> emit) {
    // Handle submit logic
  }
}
```

### feature_event.dart

```dart
part of 'feature_bloc.dart';

@freezed
sealed class FeatureEvent with _$FeatureEvent {
  const factory FeatureEvent.load({required String param}) = _Load;
  const factory FeatureEvent.submit({required String data}) = _Submit;
}
```

### feature_state.dart

```dart
part of 'feature_bloc.dart';

@freezed
sealed class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = Initial;
  const factory FeatureState.loading() = Loading;
  const factory FeatureState.success({required FeatureEntity data}) = Success;
  const factory FeatureState.failure({required String message}) = Failure;
}
```

---

## UI Integration

### Providing the BLoC

```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeatureBloc>(),
      child: const FeatureView(),
    );
  }
}
```

### Consuming States

```dart
BlocBuilder<FeatureBloc, FeatureState>(
  builder: (context, state) => state.when(
    initial: () => const SizedBox(),
    loading: () => const AppLoading(),
    success: (data) => FeatureWidget(data: data),
    failure: (message) => AppEmptyState.error(message: message),
  ),
)
```

### Dispatching Events

```dart
textButton: () {
  context.read<FeatureBloc>().add(
    const FeatureEvent.load(param: 'value'),
  );
}
```

---

## BLoC Observer

Register in main.dart for logging:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  
  Bloc.observer = AppBlocObserver(
    getIt<AppLogger>(),
    getIt<CrashReportingService>(),
  );
  
  runApp(const MyApp());
}
```

---

## State Design Rules

1. **Always have initial state** - Used when BLoC is first created
2. **Always have loading state** - Emit before async operations
3. **Always handle failure** - With user-friendly error message
4. **Use const constructors** when possible for performance
5. **Keep states immutable** via freezed

---

## Event Naming

- `FeatureEvent.load()` - Load/refresh data
- `FeatureEvent.submit()` - Form submission
- `FeatureEvent.refresh()` - Pull to refresh
- `FeatureEvent.retry()` - Retry failed operation
- `FeatureEvent.filter({required Filter filter})` - Apply filters

---

## Best Practices

- One BLoC per screen or feature
- BLoCs should be injectable (`@injectable`)
- Use `fold()` to handle Either results
- Never emit after BLoC is closed (check `!isClosed`)
- Keep business logic in UseCases, not BLoCs
