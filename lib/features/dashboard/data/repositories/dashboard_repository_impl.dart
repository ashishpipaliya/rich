import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/core/error/failures.dart';
import 'package:rich/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:rich/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:rich/features/dashboard/domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _dataSource;

  DashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard() async {
    try {
      final data = await _dataSource.getDashboard();
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}
