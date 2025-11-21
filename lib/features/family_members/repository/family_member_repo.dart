import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/features/family_members/service/family_member_api_service.dart';

class FamilyMemberRepository {
  final FamilyMemberApiService _familyMemberApiService;

  FamilyMemberRepository(this._familyMemberApiService);

  Future<ApiResult<FamilyResponse>> getFamilyMembers(String lang) async {
    try {
      final response = await _familyMemberApiService.getFamilyMembers(lang);

      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }
}
