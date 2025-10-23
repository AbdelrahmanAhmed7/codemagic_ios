import 'package:dio/dio.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';

part 'notification_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NotificationService {
  factory NotificationService(Dio dio, {String baseUrl}) = _NotificationService;

  @GET('{lang}/Home/GetNotifications')
  Future<NotificationsResponse> getNotifications(
    @Path('lang') String lang,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
}
