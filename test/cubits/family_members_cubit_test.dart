import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_cubit.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_state.dart';
import 'package:mediconsult/features/family_members/repository/family_member_repo.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFamilyRepository extends Mock implements FamilyMemberRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFamilyRepository repository;
  late FamilyMembersCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = MockFamilyRepository();
    cubit = FamilyMembersCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<FamilyMembersCubit, FamilyMembersState>(
    'emits [loading, loaded] on success',
    build: () {
      when(() => repository.getFamilyMembers(any())).thenAnswer((_) async => ApiResult.success(
            FamilyResponse(
              success: true,
              timestamp: 'now',
              message: 'ok',
              data: FamilyData(familyMembers: const [], totalCount: 0),
            ),
          ));
      return cubit;
    },
    act: (c) => c.getFamilyMembers('ar', forceRefresh: true),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      FamilyMembersState.loading(),
      isA<FamilyMembersState>().having((s) => s.maybeMap(loaded: (_) => true, orElse: () => false), 'loaded', true),
    ],
  );

  blocTest<FamilyMembersCubit, FamilyMembersState>(
    'emits [loading, failed] on failure',
    build: () {
      when(() => repository.getFamilyMembers(any())).thenAnswer((_) async => const ApiResult.failure('err'));
      return cubit;
    },
    act: (c) => c.getFamilyMembers('ar', forceRefresh: true),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      FamilyMembersState.loading(),
      isA<FamilyMembersState>().having((s) => s.maybeMap(failed: (_) => true, orElse: () => false), 'failed', true),
    ],
  );
}


