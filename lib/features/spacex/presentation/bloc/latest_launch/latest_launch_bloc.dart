import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/spacex_usecases.dart';
import 'latest_launch_event.dart';
import 'latest_launch_state.dart';

@injectable
class LatestLaunchBloc extends Bloc<LatestLaunchEvent, LatestLaunchState> {
  final GetLatestLaunchUseCase _getLatestLaunch;

  LatestLaunchBloc(this._getLatestLaunch) : super(const LatestLaunchState.initial()) {
    on<FetchLatest>(_onFetch);
  }

  Future<void> _onFetch(FetchLatest event, Emitter<LatestLaunchState> emit) async {
    emit(const LatestLaunchState.loading());
    final result = await _getLatestLaunch();
    result.fold((failure) => emit(LatestLaunchState.error(failure.message)), (launch) => emit(LatestLaunchState.loaded(launch)));
  }
}
