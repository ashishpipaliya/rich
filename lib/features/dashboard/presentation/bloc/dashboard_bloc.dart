import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:rich/features/dashboard/domain/usecases/get_dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase _getDashboard;

  DashboardBloc(this._getDashboard) : super(const DashboardState.initial()) {
    on<_Fetch>(_onFetch);
    on<_Refresh>(_onRefresh);
    on<_CategorySelected>(_onCategorySelected);
  }

  Future<void> _onFetch(_Fetch event, Emitter<DashboardState> emit) async {
    emit(const DashboardState.loading());
    final result = await _getDashboard();
    result.fold(
      (failure) => emit(DashboardState.failure(failure.message)),
      (dashboard) => emit(DashboardState.success(
        dashboard: dashboard,
        selectedCategoryId: dashboard.categories.first.id,
      )),
    );
  }

  Future<void> _onRefresh(_Refresh event, Emitter<DashboardState> emit) async {
    log('Dashboard refresh triggered', name: 'DashboardBloc');
    if (state case _Success(:final dashboard, :final selectedCategoryId)) {
      emit(DashboardState.success(
        dashboard: dashboard,
        selectedCategoryId: selectedCategoryId,
        isRefreshing: true,
      ));
      final result = await _getDashboard();
      result.fold(
        (failure) => emit(DashboardState.success(
          dashboard: dashboard,
          selectedCategoryId: selectedCategoryId,
        )),
        (fresh) => emit(DashboardState.success(
          dashboard: fresh,
          selectedCategoryId: selectedCategoryId,
        )),
      );
    }
  }

  void _onCategorySelected(
    _CategorySelected event,
    Emitter<DashboardState> emit,
  ) {
    if (state case _Success(:final dashboard, :final isRefreshing)) {
      emit(DashboardState.success(
        dashboard: dashboard,
        selectedCategoryId: event.categoryId,
        isRefreshing: isRefreshing,
      ));
    }
  }
}
