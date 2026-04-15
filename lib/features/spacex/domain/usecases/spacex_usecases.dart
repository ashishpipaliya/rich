import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/core/error/failures.dart';
import 'package:rich/features/spacex/domain/entities/launch_entity.dart';
import 'package:rich/features/spacex/domain/repositories/spacex_repository.dart';

@injectable
class GetLatestLaunchUseCase {
  final SpaceXRepository repository;
  GetLatestLaunchUseCase(this.repository);

  Future<Either<Failure, LaunchEntity>> call() => repository.getLatestLaunch();
}

@injectable
class GetLaunchHistoryUseCase {
  final SpaceXRepository repository;
  GetLaunchHistoryUseCase(this.repository);

  Future<Either<Failure, List<LaunchEntity>>> call() =>
      repository.getLaunches();
}
