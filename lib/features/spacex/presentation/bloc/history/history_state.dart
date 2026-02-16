import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/launch_model.dart';

part 'history_state.freezed.dart';

@freezed
sealed class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = HistoryInitial;
  const factory HistoryState.loading() = HistoryLoading;
  const factory HistoryState.loaded({required List<Launch> allLaunches, required List<Launch> filteredLaunches, @Default('') String searchQuery}) =
      HistoryLoaded;
  const factory HistoryState.error(String message) = HistoryError;
}
