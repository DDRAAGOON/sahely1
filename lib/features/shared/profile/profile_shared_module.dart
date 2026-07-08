import 'package:get_it/get_it.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'presentation/bloc/profile_cubit.dart';

final sl = GetIt.instance;

void initProfileModule() {
  // Cubit
  sl.registerFactory(() => ProfileCubit(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      apiClient: sl(),
      networkInfo: sl(),
    ),
  );
}
