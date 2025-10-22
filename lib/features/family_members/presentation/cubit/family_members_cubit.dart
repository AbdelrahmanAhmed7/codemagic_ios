import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_state.dart';
import 'package:mediconsult/features/family_members/repository/family_member_repo.dart';

class FamilyMembersCubit extends Cubit<FamilyMembersState> {
  final FamilyMemberRepository _familyMemberRepository;

  FamilyMembersCubit(this._familyMemberRepository)
    : super(FamilyMembersState.initial());

  Future<void> getFamilyMembers(String lang) async {
    emit(FamilyMembersState.loading());
    final response = await _familyMemberRepository.getFamilyMembers(lang);
    response.when(
      success: (response) {
        emit(FamilyMembersState.loaded(response));
      },
      failure: (error) {
        emit(FamilyMembersState.failed(error));
      },
    );
  }
}
