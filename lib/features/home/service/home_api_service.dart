import 'package:dio/dio.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';

part 'home_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET("{lang}/Home/GetHomeInfo")
  Future<HomeResponse> getHomeInfo(@Path("lang") String lang);
}