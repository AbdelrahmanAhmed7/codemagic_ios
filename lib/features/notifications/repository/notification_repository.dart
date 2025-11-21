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

  Future<ApiResult<bool>> markAsRead({
    required String lang,
    required int notificationId,
  }) async {
    try {
      final res = await _notificationService.markAsRead(lang, notificationId);
      if (res.response.statusCode != null && res.response.statusCode! >= 200 && res.response.statusCode! < 300) {
        return const ApiResult.success(true);
      }
      return const ApiResult.failure('Failed to mark as read');
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<bool>> markAllAsRead({
    required String lang,
  }) async {
    try {
      final res = await _notificationService.markAllAsRead(lang);
      if (res.response.statusCode != null && res.response.statusCode! >= 200 && res.response.statusCode! < 300) {
        return const ApiResult.success(true);
      }
      return const ApiResult.failure('Failed to mark all as read');
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
