// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../features/dashboard/data/datasources/dashboard_local_datasource.dart'
    as _i806;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_dashboard_usecase.dart'
    as _i803;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/spacex/data/datasources/remote/spacex_api_client.dart'
    as _i657;
import '../../features/spacex/data/datasources/remote/spacex_remote_data_source.dart'
    as _i690;
import '../../features/spacex/data/repositories/spacex_repository_impl.dart'
    as _i80;
import '../../features/spacex/domain/repositories/spacex_repository.dart'
    as _i326;
import '../../features/spacex/domain/usecases/spacex_usecases.dart' as _i47;
import '../../features/spacex/presentation/bloc/history/history_bloc.dart'
    as _i1040;
import '../../features/spacex/presentation/bloc/latest_launch/latest_launch_bloc.dart'
    as _i892;
import '../../features/spacex/presentation/bloc/view_mode_cubit.dart' as _i483;
import '../network/interceptors/connectivity_interceptor.dart' as _i693;
import '../network/interceptors/header_interceptor.dart' as _i463;
import '../services/connectivity_service.dart' as _i47;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i483.ViewModeCubit>(() => _i483.ViewModeCubit());
    gh.lazySingleton<_i161.InternetConnection>(
      () => registerModule.internetConnection,
    );
    gh.lazySingleton<_i463.HeaderInterceptor>(() => _i463.HeaderInterceptor());
    gh.lazySingleton<_i806.DashboardLocalDataSource>(
      () => _i806.DashboardLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityServiceImpl(gh<_i161.InternetConnection>()),
    );
    gh.lazySingleton<_i693.ConnectivityInterceptor>(
      () => _i693.ConnectivityInterceptor(gh<_i47.ConnectivityService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(
        gh<_i463.HeaderInterceptor>(),
        gh<_i693.ConnectivityInterceptor>(),
      ),
    );
    gh.lazySingleton<_i665.DashboardRepository>(
      () => _i509.DashboardRepositoryImpl(gh<_i806.DashboardLocalDataSource>()),
    );
    gh.lazySingleton<_i657.SpaceXClient>(
      () => _i657.SpaceXClient(gh<_i361.Dio>()),
    );
    gh.factory<_i803.GetDashboardUseCase>(
      () => _i803.GetDashboardUseCase(gh<_i665.DashboardRepository>()),
    );
    gh.factory<_i652.DashboardBloc>(
      () => _i652.DashboardBloc(gh<_i803.GetDashboardUseCase>()),
    );
    gh.lazySingleton<_i690.SpaceXRemoteDataSource>(
      () => _i690.SpaceXRemoteDataSourceImpl(gh<_i657.SpaceXClient>()),
    );
    gh.lazySingleton<_i326.SpaceXRepository>(
      () => _i80.SpaceXRepositoryImpl(gh<_i690.SpaceXRemoteDataSource>()),
    );
    gh.factory<_i47.GetLatestLaunchUseCase>(
      () => _i47.GetLatestLaunchUseCase(gh<_i326.SpaceXRepository>()),
    );
    gh.factory<_i47.GetLaunchHistoryUseCase>(
      () => _i47.GetLaunchHistoryUseCase(gh<_i326.SpaceXRepository>()),
    );
    gh.factory<_i1040.HistoryBloc>(
      () => _i1040.HistoryBloc(gh<_i47.GetLaunchHistoryUseCase>()),
    );
    gh.factory<_i892.LatestLaunchBloc>(
      () => _i892.LatestLaunchBloc(gh<_i47.GetLatestLaunchUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
