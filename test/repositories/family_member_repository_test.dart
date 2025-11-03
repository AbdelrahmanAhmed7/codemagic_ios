import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/family_members/repository/family_member_repo.dart';
import 'package:mediconsult/features/family_members/service/family_member_api_service.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/core/constants/api_result.dart';

class MockFamilyApiService extends Mock implements FamilyMemberApiService {}

void main() {
  late MockFamilyApiService api;
  late FamilyMemberRepository repo;

  setUp(() {
    api = MockFamilyApiService();
    repo = FamilyMemberRepository(api);
  });

  test('success path', () async {
    final response = FamilyResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: FamilyData(familyMembers: const [], totalCount: 0),
    );
    when(() => api.getFamilyMembers(any())).thenAnswer((_) async => response);
    final res = await repo.getFamilyMembers('ar');
    res.when(success: (r) => expect(r.success, true), failure: (_) => fail('should succeed'));
  });

  test('failure path', () async {
    final response = FamilyResponse(success: false, timestamp: 'now', message: 'bad', data: FamilyData(familyMembers: const [], totalCount: 0));
    when(() => api.getFamilyMembers(any())).thenAnswer((_) async => response);
    final res = await repo.getFamilyMembers('ar');
    res.when(success: (_) => fail('should fail'), failure: (m) => expect(m, 'bad'));
  });
}


