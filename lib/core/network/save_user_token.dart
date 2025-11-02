import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/core/network/dio_factory.dart';

Future<void> saveUserToken(String token) async {
  await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
  DioFactory.setTokenIntoHeaderAfterLogin(token);
}
