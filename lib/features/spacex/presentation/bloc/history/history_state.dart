import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rich/features/spacex/domain/entities/launch_entity.dart';

part 'history_state.freezed.dart';

@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = HistoryInitial;
  const factory HistoryState.loading() = HistoryLoading;
  const factory HistoryState.loaded({
    required List<LaunchEntity> allLaunches,
    required List<LaunchEntity> filteredLaunches,
    @Default('') String searchQuery,
  }) = HistoryLoaded;
  const factory HistoryState.error(String message) = HistoryError;
}
