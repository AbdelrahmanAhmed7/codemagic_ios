import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mediconsult/features/notifications/repository/notification_repository.dart';
import 'package:mediconsult/core/services/notification_badge_service.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _repository;
  NotificationsCubit(this._repository) : super(const NotificationsState.initial());

  int _page = 1;
  int _pageSize = 10;
  bool _loadingMore = false;
  final List<NotificationItem> _items = [];

  Future<void> load({
    required String lang,
    int? pageSize,
    bool reset = false,
    bool forceRefresh = false,
  }) async {
    if (reset) {
      _page = 1;
      _items.clear();
    }
    _pageSize = pageSize ?? _pageSize;

    // Try cache for first page only
    if (_page == 1 && !forceRefresh) {
      final cachedData = await CacheService.getCachedNotificationsData();
      if (cachedData != null && cachedData.data != null) {
        final data = cachedData.data!;
        _items.clear();
        _items.addAll(data.notifications);
        NotificationBadgeService.instance.setCount(_items.where((e) => !e.isRead).length);
        emit(NotificationsState.loaded(
          notifications: _items,
          totalCount: data.pagination.totalCount,
          currentPage: data.pagination.currentPage,
          totalPages: data.pagination.totalPages,
          hasNextPage: data.pagination.hasNextPage,
          loadingMore: false,
        ));

        // Background refresh
        unawaited(_fetchAndCacheData(lang));
        return;
      }
    }

    if (_page == 1) {
      emit(const NotificationsState.loading());
    } else {
      _loadingMore = true;
      final currentState = state;
      if (currentState is Loaded) {
        emit(currentState.copyWith(loadingMore: true));
      }
    }

    await _fetchAndCacheData(lang);
  }

  Future<void> _fetchAndCacheData(String lang) async {
    final res = await _repository.getNotifications(
      lang: lang,
      page: _page,
      pageSize: _pageSize,
    );

    res.when(
      success: (response) async {
        final data = response.data!;
        if (_page == 1) {
          _items.clear();
          // Cache only first page
          await CacheService.cacheNotificationsData(response);
        }
        _items.addAll(data.notifications);
        _loadingMore = false;
        NotificationBadgeService.instance.setCount(_items.where((e) => !e.isRead).length);
        emit(NotificationsState.loaded(
          notifications: _items,
          totalCount: data.pagination.totalCount,
          currentPage: data.pagination.currentPage,
          totalPages: data.pagination.totalPages,
          hasNextPage: data.pagination.hasNextPage,
          loadingMore: false,
        ));
      },
      failure: (message) {
        _loadingMore = false;
        emit(NotificationsState.failed(message));
      },
    );
  }

  Future<void> loadMore({required String lang}) async {
    final current = state;
    if (current is Loaded && current.hasNextPage && !_loadingMore) {
      _page = current.currentPage + 1;
      await load(lang: lang);
    }
  }

  Future<void> refresh({required String lang}) async {
    await load(lang: lang, forceRefresh: true, reset: true);
  }

  Future<void> clearCache() async {
    await CacheService.clearNotificationsCache();
  }

  Future<bool> markAsRead({required String lang, required int notificationId}) async {
    final res = await _repository.markAsRead(lang: lang, notificationId: notificationId);
    bool ok = false;
    res.when(
      success: (_) {
        final index = _items.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final item = _items[index];
          _items[index] = NotificationItem(
            id: item.id,
            title: item.title,
            body: item.body,
            imageUrl: item.imageUrl,
            isSeen: 1,
            date: item.date,
            time: item.time,
          );
          final current = state;
          if (current is Loaded) {
            emit(current.copyWith(notifications: List.of(_items)));
          }
        }
        NotificationBadgeService.instance.setCount(_items.where((e) => !e.isRead).length);
        ok = true;
      },
      failure: (_) { ok = false; },
    );
    return ok;
  }

  Future<bool> markAllAsRead({required String lang}) async {
    final res = await _repository.markAllAsRead(lang: lang);
    bool ok = false;
    res.when(
      success: (_) {
        for (int i = 0; i < _items.length; i++) {
          final item = _items[i];
          _items[i] = NotificationItem(
            id: item.id,
            title: item.title,
            body: item.body,
            imageUrl: item.imageUrl,
            isSeen: 1,
            date: item.date,
            time: item.time,
          );
        }
        final current = state;
        if (current is Loaded) {
          emit(current.copyWith(notifications: List.of(_items)));
        }
        NotificationBadgeService.instance.setCount(0);
        ok = true;
      },
      failure: (_) { ok = false; },
    );
    return ok;
  }
}
