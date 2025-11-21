import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_details_state.dart';
import 'package:mediconsult/features/policy/repository/get_policy_details_repo.dart';

class GetPolicyDetailsCubit extends Cubit<GetPolicyDetailsState> {
  final GetPolicyDetailsRepository _repository;
  GetPolicyDetailsCubit(this._repository) : super(const GetPolicyDetailsState.initial());

  Future<void> getDetails(String lang, int categoryId) async {
    emit(const GetPolicyDetailsState.loading());
    final response = await _repository.getByCategoryId(lang, categoryId);
    response.when(
      success: (data) => emit(GetPolicyDetailsState.loaded(data)),
      failure: (message) => emit(GetPolicyDetailsState.failed(message)),
    );
  }
}





