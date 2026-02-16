import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../models/launch_model.dart';
import 'spacex_repository.dart';
import '../datasources/remote/spacex_remote_data_source.dart';

@LazySingleton(as: SpaceXRepository)
class SpaceXRepositoryImpl implements SpaceXRepository {
  final SpaceXRemoteDataSource _remoteDataSource;

  SpaceXRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Launch>>> getLaunches() async {
    try {
      final remoteData = await _remoteDataSource.getLaunches();
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Launch>> getLatestLaunch() async {
    try {
      final data = await _remoteDataSource.getLatestLaunch();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
