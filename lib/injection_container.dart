import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sahely/core/network/network_info.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/storage/local_storage.dart';
import 'package:sahely/core/storage/secure_storage.dart';
import 'package:sahely/features/shared/auth/auth_shared_module.dart';
import 'package:sahely/features/shared/chat/chat_shared_module.dart';
import 'package:sahely/features/shared/profile/profile_shared_module.dart';

final sl = GetIt.instance;

/// Dependency Injection initialization.
Future<void> init() async {
  //! Features
  initAuthModule();
  initChatModule();
  initProfileModule();

  //! Core
  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ApiClient(sl()));
  
  // Storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorage>(() => LocalStorageImpl(sharedPreferences));
  
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<SecureStorage>(() => SecureStorageImpl(sl()));

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
