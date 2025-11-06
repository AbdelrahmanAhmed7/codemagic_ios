import 'package:dio/dio.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';

part 'notification_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NotificationService {
  factory NotificationService(Dio dio, {String baseUrl}) = _NotificationService;

  @GET('{lang}/Notifications/GetAll')
  Future<NotificationsResponse> getNotifications(
    @Path('lang') String lang,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );

  @POST('{lang}/Notifications/MarkAsReadById/{notificationId}')
  Future<HttpResponse<dynamic>> markAsRead(
    @Path('lang') String lang,
    @Path('notificationId') int notificationId,
  );

  @POST('{lang}/Notifications/MarkAllAsRead')
  Future<HttpResponse<dynamic>> markAllAsRead(
    @Path('lang') String lang,
  );
}
