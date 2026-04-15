import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/core/error/failures.dart';
import 'package:rich/features/spacex/data/datasources/remote/spacex_remote_data_source.dart';
import 'package:rich/features/spacex/data/mappers/launch_mapper.dart';
import 'package:rich/features/spacex/domain/entities/launch_entity.dart';
import 'package:rich/features/spacex/domain/repositories/spacex_repository.dart';

@LazySingleton(as: SpaceXRepository)
class SpaceXRepositoryImpl implements SpaceXRepository {
  final SpaceXRemoteDataSource _remoteDataSource;

  SpaceXRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<LaunchEntity>>> getLaunches() async {
    try {
      final models = await _remoteDataSource.getLaunches();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, LaunchEntity>> getLatestLaunch() async {
    try {
      final model = await _remoteDataSource.getLatestLaunch();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
