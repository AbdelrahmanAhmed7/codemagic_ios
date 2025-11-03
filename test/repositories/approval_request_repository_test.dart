import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/approval_request/repository/approval_request_repository.dart';
import 'package:mediconsult/features/approval_request/service/approval_request_api_service.dart';
import 'package:mediconsult/features/approval_request/data/approval_request_models.dart';
import 'package:mediconsult/core/constants/api_result.dart';

class MockApprovalApiService extends Mock implements ApprovalRequestApiService {}

void main() {
  late MockApprovalApiService api;
  late ApprovalRequestRepository repo;

  setUp(() {
    api = MockApprovalApiService();
    repo = ApprovalRequestRepository(api);
  });

  test('create approval success', () async {
    final response = ApprovalRequestResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: ApprovalRequestData(
        id: 1,
        memberId: 1,
        providerId: 2,
        status: 'Pending',
        createdDate: '2025-01-01',
        notes: null,
      ),
    );
    when(() => api.createApprovalRequest(any(), any(), any(), any(), any())).thenAnswer((_) async => response);

    final res = await repo.createApprovalRequest(lang: 'ar', memberId: 1, providerId: 2, notes: null, attachmentPaths: const []);
    res.when(success: (r) => expect(r.success, true), failure: (_) => fail('should succeed'));
  });

  test('create approval failure', () async {
    final response = ApprovalRequestResponse(success: false, timestamp: 'now', message: 'bad', data: null);
    when(() => api.createApprovalRequest(any(), any(), any(), any(), any())).thenAnswer((_) async => response);

    final res = await repo.createApprovalRequest(lang: 'ar', memberId: 1, providerId: 2, notes: null, attachmentPaths: const []);
    res.when(success: (_) => fail('should fail'), failure: (m) => expect(m, 'bad'));
  });
}


