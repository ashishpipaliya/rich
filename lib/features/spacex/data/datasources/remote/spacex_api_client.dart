import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/launch_model.dart';

part 'spacex_api_client.g.dart';

@LazySingleton()
@RestApi(baseUrl: "https://api.spacexdata.com/v5/")
abstract class SpaceXClient {
  @factoryMethod
  factory SpaceXClient(Dio dio) = _SpaceXClient;

  @GET("launches")
  Future<List<Launch>> getLaunches();

  @GET("launches/latest")
  Future<Launch> getLatestLaunch();
}
