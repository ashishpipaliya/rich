import 'package:fpdart/fpdart.dart';
import 'package:rich/core/error/failures.dart';
import 'package:rich/features/spacex/domain/entities/launch_entity.dart';

abstract class SpaceXRepository {
  Future<Either<Failure, List<LaunchEntity>>> getLaunches();
  Future<Either<Failure, LaunchEntity>> getLatestLaunch();
}
