import 'package:fpdart/fpdart.dart';
import '../models/launch_model.dart';
import '../../../../core/error/failures.dart';

abstract class SpaceXRepository {
  Future<Either<Failure, List<Launch>>> getLaunches();

  Future<Either<Failure, Launch>> getLatestLaunch();
}
