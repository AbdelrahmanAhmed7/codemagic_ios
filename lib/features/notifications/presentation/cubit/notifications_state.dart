import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = Initial;
  const factory NotificationsState.loading() = Loading;
  const factory NotificationsState.loaded({
    required List<NotificationItem> notifications,
    required int totalCount,
    required int currentPage,
    required int totalPages,
    required bool hasNextPage,
    required bool loadingMore,
    @Default(0) int updateCounter,
  }) = Loaded;
  const factory NotificationsState.failed(String message) = Failed;
}
