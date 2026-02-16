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

import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/spacex/data/datasources/remote/spacex_api_client.dart'
    as _i657;
import '../../features/spacex/data/datasources/remote/spacex_remote_data_source.dart'
    as _i690;
import '../../features/spacex/data/repositories/spacex_repository.dart'
    as _i423;
import '../../features/spacex/data/repositories/spacex_repository_impl.dart'
    as _i80;
import '../../features/spacex/domain/usecases/spacex_usecases.dart' as _i47;
import '../../features/spacex/presentation/bloc/history/history_bloc.dart'
    as _i1040;
import '../../features/spacex/presentation/bloc/latest_launch/latest_launch_bloc.dart'
    as _i892;
import '../../features/spacex/presentation/bloc/view_mode_cubit.dart' as _i483;
import '../network/interceptors/header_interceptor.dart' as _i463;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i463.HeaderInterceptor>(() => _i463.HeaderInterceptor());
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc());
    gh.factory<_i483.ViewModeCubit>(() => _i483.ViewModeCubit());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i657.SpaceXClient>(
      () => _i657.SpaceXClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i690.SpaceXRemoteDataSource>(
      () => _i690.SpaceXRemoteDataSourceImpl(gh<_i657.SpaceXClient>()),
    );
    gh.lazySingleton<_i423.SpaceXRepository>(
      () => _i80.SpaceXRepositoryImpl(gh<_i690.SpaceXRemoteDataSource>()),
    );
    gh.factory<_i47.GetLatestLaunchUseCase>(
      () => _i47.GetLatestLaunchUseCase(gh<_i423.SpaceXRepository>()),
    );
    gh.factory<_i47.GetLaunchHistoryUseCase>(
      () => _i47.GetLaunchHistoryUseCase(gh<_i423.SpaceXRepository>()),
    );
    gh.factory<_i892.LatestLaunchBloc>(
      () => _i892.LatestLaunchBloc(gh<_i47.GetLatestLaunchUseCase>()),
    );
    gh.factory<_i1040.HistoryBloc>(
      () => _i1040.HistoryBloc(gh<_i47.GetLaunchHistoryUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
