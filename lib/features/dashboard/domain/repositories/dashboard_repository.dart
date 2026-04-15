import 'package:fpdart/fpdart.dart';
import 'package:rich/core/error/failures.dart';
import 'package:rich/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDashboard();
}
