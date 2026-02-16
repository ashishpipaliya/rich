import 'package:freezed_annotation/freezed_annotation.dart';

part 'spacex_event.freezed.dart';

@freezed
sealed class SpaceXEvent with _$SpaceXEvent {
  const factory SpaceXEvent.fetchDashboard() = FetchDashboard;
  const factory SpaceXEvent.fetchHistory() = FetchHistory;
  const factory SpaceXEvent.fetchLatest() = FetchLatest;
  const factory SpaceXEvent.searchLaunches(String query) = SearchLaunches;
}
