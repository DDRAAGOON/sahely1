import 'package:get_it/get_it.dart';
import 'package:sahely/features/shared/auth/data/datasources/auth_local_data_source.dart';
import 'package:sahely/features/shared/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sahely/features/shared/auth/data/repositories/auth_repository_impl.dart';
import 'package:sahely/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:sahely/features/shared/auth/domain/usecases/login_usecase.dart';
import 'package:sahely/features/shared/auth/domain/usecases/register_usecase.dart';
import 'package:sahely/features/shared/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:sahely/features/shared/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

/// Shared Auth Module initialization.
void initAuthModule() {
  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        verifyOtpUseCase: sl(),
        repository: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
}
