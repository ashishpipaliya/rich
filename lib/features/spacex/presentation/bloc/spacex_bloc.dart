import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/spacex_repository.dart';
import 'spacex_event.dart';
import 'spacex_state.dart';

@injectable
class SpaceXBloc extends Bloc<SpaceXEvent, SpaceXState> {
  final SpaceXRepository _repository;

  SpaceXBloc(this._repository) : super(const SpaceXState()) {
    on<FetchDashboard>(_onFetchDashboard);
    on<FetchHistory>(_onFetchHistory);
    on<FetchLatest>(_onFetchLatest);
    on<SearchLaunches>(_onSearchLaunches);
  }

  Future<void> _onFetchDashboard(FetchDashboard event, Emitter<SpaceXState> emit) async {
    add(const SpaceXEvent.fetchLatest());
    add(const SpaceXEvent.fetchHistory());
  }

  Future<void> _onFetchHistory(FetchHistory event, Emitter<SpaceXState> emit) async {
    emit(state.copyWith(historyStatus: SpaceXStatus.loading));
    final result = await _repository.getLaunches();
    result.fold((failure) => emit(state.copyWith(historyStatus: SpaceXStatus.failure, errorMessage: failure.message)), (launches) {
      if (launches.isEmpty) {
        emit(state.copyWith(historyStatus: SpaceXStatus.empty, allLaunches: [], filteredLaunches: []));
      } else {
        final query = state.searchQuery.toLowerCase();
        final filtered = query.isEmpty ? launches : launches.where((l) => l.name.toLowerCase().contains(query)).toList();
        emit(state.copyWith(historyStatus: SpaceXStatus.success, allLaunches: launches, filteredLaunches: filtered));
      }
    });
  }

  Future<void> _onFetchLatest(FetchLatest event, Emitter<SpaceXState> emit) async {
    emit(state.copyWith(latestStatus: SpaceXStatus.loading));
    final result = await _repository.getLatestLaunch();
    result.fold(
      (failure) => emit(state.copyWith(latestStatus: SpaceXStatus.failure)),
      (launch) => emit(state.copyWith(latestStatus: SpaceXStatus.success, latestLaunch: launch)),
    );
  }

  void _onSearchLaunches(SearchLaunches event, Emitter<SpaceXState> emit) {
    final query = event.query.toLowerCase();
    final filtered = state.allLaunches.where((launch) {
      return launch.name.toLowerCase().contains(query) || (launch.details?.toLowerCase().contains(query) ?? false);
    }).toList();
    emit(state.copyWith(filteredLaunches: filtered, searchQuery: event.query));
  }
}
