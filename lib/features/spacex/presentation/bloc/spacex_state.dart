import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/launch_model.dart';

part 'spacex_state.freezed.dart';

enum SpaceXStatus { initial, loading, success, failure, empty }

@freezed
sealed class SpaceXState with _$SpaceXState {
  const factory SpaceXState({
    @Default(SpaceXStatus.initial) SpaceXStatus historyStatus,
    @Default(SpaceXStatus.initial) SpaceXStatus latestStatus,
    @Default([]) List<Launch> allLaunches,
    @Default([]) List<Launch> filteredLaunches,
    Launch? latestLaunch,
    @Default('') String searchQuery,
    String? errorMessage,
  }) = _SpaceXState;
}
