import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/core/error/failures.dart';
import 'package:rich/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:rich/features/dashboard/domain/repositories/dashboard_repository.dart';

@injectable
class GetDashboardUseCase {
  final DashboardRepository repository;
  GetDashboardUseCase(this.repository);

  Future<Either<Failure, DashboardEntity>> call() => repository.getDashboard();
}
