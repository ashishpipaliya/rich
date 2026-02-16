import 'package:freezed_annotation/freezed_annotation.dart';

part 'latest_launch_event.freezed.dart';

@freezed
class LatestLaunchEvent with _$LatestLaunchEvent {
  const factory LatestLaunchEvent.fetch() = FetchLatest;
}
