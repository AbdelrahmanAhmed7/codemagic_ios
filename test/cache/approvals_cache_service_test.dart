import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/core/cache/approvals_cache_service.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
  });

  ApprovalsResponse buildResp(String status) => ApprovalsResponse(
        success: true,
        timestamp: 'now',
        message: 'ok',
        data: ApprovalsData(
          approvals: const [],
          pagination: Pagination(
            currentPage: 1,
            pageSize: 10,
            totalCount: 0,
            totalPages: 0,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
          filter: ApprovalsFilter(status: status),
        ),
      );

  test('cache and read approvals per status', () async {
    await ApprovalsCacheService.cacheApprovalsData(buildResp('All'), 'All');
    final cached = await ApprovalsCacheService.getCachedApprovalsData('All');
    expect(cached?.success, true);
  });

  test('clear status cache removes data', () async {
    await ApprovalsCacheService.clearApprovalsCache('All');
    final cached = await ApprovalsCacheService.getCachedApprovalsData('All');
    expect(cached, isNull);
  });
}


