import 'package:get_it/get_it.dart';

import 'package:mediconsult/features/auth/login/domain/login_repository.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:mediconsult/features/auth/signup/domain/signup_repository.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories (implementations to be registered later when available)
  // sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(apiClient: sl()));
  // sl.registerLazySingleton<SignupRepository>(() => SignupRepositoryImpl(apiClient: sl()));

  // Cubits depend on repositories; register factories so a fresh instance can be created per UI
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginRepository>()));
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl<SignupRepository>()));
}


