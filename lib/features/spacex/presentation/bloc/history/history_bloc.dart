import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/spacex_usecases.dart';
import 'history_event.dart';
import 'history_state.dart';

@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetLaunchHistoryUseCase _getHistory;

  HistoryBloc(this._getHistory) : super(const HistoryState.initial()) {
    on<FetchHistory>(_onFetch);
    on<SearchHistory>(_onSearch);
  }

  Future<void> _onFetch(FetchHistory event, Emitter<HistoryState> emit) async {
    emit(const HistoryState.loading());
    final result = await _getHistory();
    result.fold(
      (failure) => emit(HistoryState.error(failure.message)),
      (launches) => emit(HistoryState.loaded(allLaunches: launches, filteredLaunches: launches)),
    );
  }

  void _onSearch(SearchHistory event, Emitter<HistoryState> emit) {
    if (state is HistoryLoaded) {
      final loadedState = state as HistoryLoaded;
      final query = event.query.toLowerCase();

      final filtered = loadedState.allLaunches.where((launch) {
        return launch.name.toLowerCase().contains(query) || (launch.details?.toLowerCase().contains(query) ?? false);
      }).toList();

      emit(loadedState.copyWith(filteredLaunches: filtered, searchQuery: event.query));
    }
  }
}
