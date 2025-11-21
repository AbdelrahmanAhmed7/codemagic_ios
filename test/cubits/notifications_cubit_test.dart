import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mediconsult/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mediconsult/features/notifications/repository/notification_repository.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

NotificationsResponse buildPage({required int page, required int pageSize, required int total}) {
  final totalPages = (total / pageSize).ceil();
  final start = (page - 1) * pageSize;
  final items = List.generate(pageSize, (i) => NotificationItem(
    id: start + i + 1,
    title: 't',
    body: 'b',
    imageUrl: null,
    isSeen: 0,
    date: '2025-01-01',
    time: '12:00',
  ));
  return NotificationsResponse(
    success: true,
    timestamp: 'now',
    message: 'ok',
    data: NotificationsData(
      notifications: items,
      totalCount: total,
      page: page,
      pageSize: pageSize,
      totalPages: totalPages,
    ),
  );
}

// Helper function
Future<void> pumpEventQueue() {
  return Future.delayed(Duration.zero);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockNotificationRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    repo = MockNotificationRepository();
  });

  blocTest<NotificationsCubit, NotificationsState>(
    'load first page success',
    build: () {
      when(() => repo.getNotifications(lang: any(named: 'lang'), page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => ApiResult.success(buildPage(page: 1, pageSize: 2, total: 3)));
      return NotificationsCubit(repo);
    },
    act: (c) => c.load(lang: 'ar', reset: true, forceRefresh: true),
    expect: () => [
      const NotificationsState.loading(),
      isA<NotificationsState>().having((s) => s.maybeMap(loaded: (_) => true, orElse: () => false), 'loaded', true),
    ],
  );

  test('loadMore appends items', () async {
    // Setup mock responses
    when(() => repo.getNotifications(lang: any(named: 'lang'), page: 1, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => ApiResult.success(buildPage(page: 1, pageSize: 2, total: 4)));
    when(() => repo.getNotifications(lang: any(named: 'lang'), page: 2, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => ApiResult.success(buildPage(page: 2, pageSize: 2, total: 4)));

    final cubit = NotificationsCubit(repo);

    // حمل الصفحة الأولى
    await cubit.load(lang: 'ar', reset: true, forceRefresh: true);

    // انتظر كل الـ async operations تخلص
    await pumpEventQueue();
    await pumpEventQueue();

    // 🔍 Debug: اطبع الـ state
    print('State after load: ${cubit.state}');

    // تأكد من الصفحة الأولى
    var state = cubit.state;

    state.maybeMap(
      loaded: (l) {
        print('✅ Loaded: ${l.notifications.length} items, page ${l.currentPage}');
      },
      loading: (_) => print('⏳ Still loading...'),
      initial: (_) => print('❌ Still initial'),
      failed: (f) => print('❌ Failed: ${f.message}'),
      orElse: () => print('❓ Unknown state'),
    );

    expect(
      state.maybeMap(loaded: (l) => l.notifications.length, orElse: () => 0),
      2,
      reason: 'Should have 2 items after first load',
    );
    expect(
      state.maybeMap(loaded: (l) => l.currentPage, orElse: () => 0),
      1,
      reason: 'Should be on page 1',
    );

    // حمل المزيد
    await cubit.loadMore(lang: 'ar');

    // انتظر كل الـ async operations تخلص
    await pumpEventQueue();
    await pumpEventQueue();

    // 🔍 Debug: اطبع الـ state بعد loadMore
    print('State after loadMore: ${cubit.state}');

    // تأكد من النتيجة النهائية
    state = cubit.state;

    state.maybeMap(
      loaded: (l) {
        print('✅ After loadMore: ${l.notifications.length} items, page ${l.currentPage}, hasNext: ${l.hasNextPage}');
      },
      orElse: () => print('❌ Not loaded state'),
    );

    expect(
      state.maybeMap(
        loaded: (l) =>
        l.notifications.length == 4 &&
            l.currentPage == 2 &&
            l.hasNextPage == false,
        orElse: () => false,
      ),
      true,
      reason: 'Should have 4 items total, on page 2, with no next page',
    );

    await cubit.close();
  });

  test('loadMore with stream subscription', () async {
    // Setup mock responses
    when(() => repo.getNotifications(lang: any(named: 'lang'), page: 1, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => ApiResult.success(buildPage(page: 1, pageSize: 2, total: 4)));
    when(() => repo.getNotifications(lang: any(named: 'lang'), page: 2, pageSize: any(named: 'pageSize')))
        .thenAnswer((_) async => ApiResult.success(buildPage(page: 2, pageSize: 2, total: 4)));

    final cubit = NotificationsCubit(repo);

    // استخدم stream للتتبع
    final states = <NotificationsState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.load(lang: 'ar', reset: true, forceRefresh: true);
    await Future.delayed(const Duration(milliseconds: 100));

    print('States after load: ${states.length}');
    expect(states.isNotEmpty, true);
    expect(
      states.last.maybeMap(loaded: (l) => l.notifications.length, orElse: () => 0),
      2,
    );

    await cubit.loadMore(lang: 'ar');
    await Future.delayed(const Duration(milliseconds: 100));

    print('Total states: ${states.length}');
    expect(
      cubit.state.maybeMap(
        loaded: (l) => l.notifications.length == 4 && l.currentPage == 2,
        orElse: () => false,
      ),
      true,
    );

    await subscription.cancel();
    await cubit.close();
  });

  blocTest<NotificationsCubit, NotificationsState>(
    'failure shows failed state',
    build: () {
      when(() => repo.getNotifications(lang: any(named: 'lang'), page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => const ApiResult.failure('err'));
      return NotificationsCubit(repo);
    },
    act: (c) => c.load(lang: 'ar', reset: true, forceRefresh: true),
    expect: () => [
      const NotificationsState.loading(),
      isA<NotificationsState>().having((s) => s.maybeMap(failed: (_) => true, orElse: () => false), 'failed', true),
    ],
  );
}