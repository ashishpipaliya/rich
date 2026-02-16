import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/launch_model.dart';
import '../../data/repositories/spacex_repository.dart';

@injectable
class GetLatestLaunchUseCase {
  final SpaceXRepository repository;
  GetLatestLaunchUseCase(this.repository);

  Future<Either<Failure, Launch>> call() => repository.getLatestLaunch();
}

@injectable
class GetLaunchHistoryUseCase {
  final SpaceXRepository repository;
  GetLaunchHistoryUseCase(this.repository);

  Future<Either<Failure, List<Launch>>> call() => repository.getLaunches();
}
