import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/dio_factory.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:mediconsult/features/auth/login/service/login_api_service.dart';
import 'package:mediconsult/features/auth/login/repository/login_repository.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_cubit.dart';
import 'package:mediconsult/features/auth/signup/repository/register_repository.dart';
import 'package:mediconsult/features/auth/signup/service/register_api_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final Dio dio = await DioFactory.getDio();
  // Services
  sl.registerLazySingleton<LoginApiService>(() => LoginApiService(dio));
  sl.registerLazySingleton<RegisterApiService>(() => RegisterApiService(dio));

  // Repositories
  sl.registerLazySingleton<LoginRepository>(() => LoginRepository(sl()));
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepository(sl()));
  // Cubits
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl()));
}