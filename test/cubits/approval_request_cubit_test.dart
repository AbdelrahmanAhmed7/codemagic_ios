import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_state.dart';
import 'package:mediconsult/features/approval_request/repository/approval_request_repository.dart';
import 'package:mediconsult/features/approval_request/data/approval_request_models.dart';

class MockApprovalRequestRepository extends Mock implements ApprovalRequestRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockApprovalRequestRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    repo = MockApprovalRequestRepository();
  });

  blocTest<ApprovalRequestCubit, ApprovalRequestState>(
    'create request success',
    build: () {
      when(() => repo.createApprovalRequest(lang: any(named: 'lang'), memberId: any(named: 'memberId'), providerId: any(named: 'providerId'), notes: any(named: 'notes'), attachmentPaths: any(named: 'attachmentPaths')))
          .thenAnswer((_) async => ApiResult.success(
                ApprovalRequestResponse(
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
                ),
              ));
      return ApprovalRequestCubit(repo);
    },
    act: (c) => c.createApprovalRequest(lang: 'ar', memberId: 1, providerId: 2, notes: null, attachmentPaths: const []),
    expect: () => [
      const ApprovalRequestState.loading(),
      isA<ApprovalRequestState>().having((s) => s.mapOrNull(success: (v) => v.data), 'success', isNotNull),
    ],
  );

  blocTest<ApprovalRequestCubit, ApprovalRequestState>(
    'create request failure',
    build: () {
      when(() => repo.createApprovalRequest(lang: any(named: 'lang'), memberId: any(named: 'memberId'), providerId: any(named: 'providerId'), notes: any(named: 'notes'), attachmentPaths: any(named: 'attachmentPaths')))
          .thenAnswer((_) async => const ApiResult.failure('err'));
      return ApprovalRequestCubit(repo);
    },
    act: (c) => c.createApprovalRequest(lang: 'ar', memberId: 1, providerId: 2, notes: null, attachmentPaths: const []),
    expect: () => [
      const ApprovalRequestState.loading(),
      isA<ApprovalRequestState>().having((s) => s.mapOrNull(failed: (v) => v.message), 'failed', isNotNull),
    ],
  );
}


