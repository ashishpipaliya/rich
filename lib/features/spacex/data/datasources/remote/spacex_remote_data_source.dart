import 'package:injectable/injectable.dart';
import '../../models/launch_model.dart';
import 'spacex_api_client.dart';

abstract class SpaceXRemoteDataSource {
  Future<List<Launch>> getLaunches();
  Future<Launch> getLatestLaunch();
}

@LazySingleton(as: SpaceXRemoteDataSource)
class SpaceXRemoteDataSourceImpl implements SpaceXRemoteDataSource {
  final SpaceXClient _apiClient;

  SpaceXRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Launch>> getLaunches() {
    return _apiClient.getLaunches();
  }

  @override
  Future<Launch> getLatestLaunch() {
    return _apiClient.getLatestLaunch();
  }
}
