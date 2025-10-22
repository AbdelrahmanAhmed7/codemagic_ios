import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/dio_factory.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/resend_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/reset_password_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/send_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/verify_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/repository/reset_password_repository.dart';
import 'package:mediconsult/features/auth/login/service/login_api_service.dart';
import 'package:mediconsult/features/auth/login/repository/login_repository.dart';
import 'package:mediconsult/features/auth/login/service/reset_password_api_service.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_cubit.dart';
import 'package:mediconsult/features/auth/signup/repository/register_repository.dart';
import 'package:mediconsult/features/auth/signup/service/register_api_service.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/repository/home_repository.dart';
import 'package:mediconsult/features/home/service/home_api_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final Dio dio = await DioFactory.getDio();
  // Services
  sl.registerLazySingleton<LoginApiService>(() => LoginApiService(dio));
  sl.registerLazySingleton<RegisterApiService>(() => RegisterApiService(dio));
  sl.registerLazySingleton<ResetPasswordApiService>(() => ResetPasswordApiService(dio));
  sl.registerLazySingleton<HomeApiService>(() => HomeApiService(dio));

  // Repositories
  sl.registerLazySingleton<LoginRepository>(() => LoginRepository(sl()));
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepository(sl()));
  sl.registerLazySingleton<ResetPasswordRepository>(() => ResetPasswordRepository(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl()));
  // Cubits
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl()));
  sl.registerFactory<SendOtpCubit>(() => SendOtpCubit(sl()));
  sl.registerFactory<ResetPasswordCubit>(() => ResetPasswordCubit(sl()));
  sl.registerFactory<ResendOtpCubit>(() => ResendOtpCubit(sl()));
  sl.registerFactory<VerifyOtpCubit>(() => VerifyOtpCubit(sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl()));
}