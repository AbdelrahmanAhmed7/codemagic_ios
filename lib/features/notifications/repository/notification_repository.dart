import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:mediconsult/features/notifications/service/notification_service.dart';

class NotificationRepository {
  final NotificationService _notificationService;

  NotificationRepository(this._notificationService);

  Future<ApiResult<NotificationsResponse>> getNotifications({
    required String lang,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _notificationService.getNotifications(
        lang,
        page,
        pageSize,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
