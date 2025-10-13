import 'package:mediconsult/core/constants/api_result.dart';

abstract class LoginRepository {
  Future<ApiResult<void>> login({required String identifier, required String password});
}


