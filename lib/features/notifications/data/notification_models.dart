import 'package:json_annotation/json_annotation.dart';

part 'notification_models.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationsResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final NotificationsData? data;

  NotificationsResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationsData {
  final List<NotificationItem> notifications;
  final Pagination pagination;

  NotificationsData({
    required this.notifications,
    required this.pagination,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsDataToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: 'currentPage')
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final int isSeen;
  final String date;
  final String time;
  final List<NotificationData>? notificationData;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.isSeen,
    required this.date,
    required this.time,
    this.notificationData,
  });

  bool get isRead => isSeen == 1;

  /// Get value from notification data by key
  String? getDataValue(String key) {
    if (notificationData == null) return null;
    try {
      final data = notificationData!.firstWhere(
        (item) => item.keyData.toLowerCase() == key.toLowerCase(),
      );
      return data.value;
    } catch (e) {
      return null;
    }
  }

  /// Check if notification data contains a key with specific value
  bool hasDataKeyValue(String key, String value) {
    final dataValue = getDataValue(key);
    return dataValue == value;
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}

@JsonSerializable()
class NotificationData {
  final int id;
  final String keyData;
  final String value;

  NotificationData({
    required this.id,
    required this.keyData,
    required this.value,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
