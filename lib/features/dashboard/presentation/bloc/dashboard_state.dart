part of 'dashboard_bloc.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.success({
    required DashboardEntity dashboard,
    required String selectedCategoryId,
    @Default(false) bool isRefreshing,
  }) = _Success;
  const factory DashboardState.failure(String message) = _Failure;
}
