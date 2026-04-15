part of 'dashboard_bloc.dart';

@freezed
sealed class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.fetch() = _Fetch;
  const factory DashboardEvent.refresh() = _Refresh;
  const factory DashboardEvent.categorySelected(String categoryId) = _CategorySelected;
}
