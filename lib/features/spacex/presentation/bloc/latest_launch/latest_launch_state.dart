import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rich/features/spacex/domain/entities/launch_entity.dart';

part 'latest_launch_state.freezed.dart';

@freezed
sealed class LatestLaunchState with _$LatestLaunchState {
  const factory LatestLaunchState.initial() = LatestLaunchInitial;
  const factory LatestLaunchState.loading() = LatestLaunchLoading;
  const factory LatestLaunchState.loaded(LaunchEntity launch) =
      LatestLaunchLoaded;
  const factory LatestLaunchState.error(String message) = LatestLaunchError;
}
