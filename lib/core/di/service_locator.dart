import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/config/app_env.dart';
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/dio_factory.dart';
import 'package:sahely/core/network/image_cache/cached_network_image_service.dart';
import 'package:sahely/core/network/image_cache/image_cache_manager.dart';
import 'package:sahely/core/network/image_cache/image_cache_service.dart';
import 'package:sahely/core/network/request_cache/request_cache_manager.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/storage/cache/cache_manager.dart';
import 'package:sahely/core/storage/cache/cache_service.dart';
import 'package:sahely/core/storage/cache/shared_preferences_cache_service.dart';
import 'package:sahely/core/utils/lazy_loading/lazy_loader.dart';
import 'package:sahely/core/utils/lazy_loading/lazy_load_controller.dart';
import 'package:sahely/core/utils/lazy_loading/lazy_load_policy.dart';
import 'package:sahely/core/pagination/infinite_scroll/infinite_scroll_controller.dart';
import 'package:sahely/core/pagination/infinite_scroll/infinite_scroll_policy.dart';
import 'package:sahely/core/network/retry/retry_manager.dart';
import 'package:sahely/core/network/upload/upload_manager.dart';
import 'package:sahely/core/network/download/download_manager.dart';
import 'package:sahely/core/config/feature_flags/feature_flag_manager.dart';
import 'package:sahely/core/navigation/deep_link/deep_link_manager.dart';
import 'package:sahely/core/auth/token_storage.dart';
import 'package:sahely/core/security/storage/secure_storage_service.dart';
import 'package:sahely/core/security/storage/flutter_secure_storage_service.dart';
import 'package:sahely/core/security/storage/secure_storage_manager.dart';
import 'package:sahely/core/security/encryption/encryption_service.dart';
import 'package:sahely/core/security/encryption/aes_encryption_service.dart';
import 'package:sahely/core/security/encryption/encryption_manager.dart';
import 'package:sahely/core/security/device/device_security_service.dart';
import 'package:sahely/core/security/device/safe_device_security_service.dart';
import 'package:sahely/core/security/device/device_security_manager.dart';
import 'package:sahely/core/security/network/certificate_provider.dart';
import 'package:sahely/core/security/network/asset_certificate_provider.dart';
import 'package:sahely/core/security/network/ssl_pinning_service.dart';
import 'package:sahely/core/security/network/ssl_pinning_service_impl.dart';
import 'package:sahely/core/security/network/network_security_manager.dart';
import 'package:sahely/core/security/logger/security_logger.dart';
import 'package:sahely/core/security/logger/console_security_logger.dart';
import 'package:sahely/core/security/logger/security_log_manager.dart';
import 'package:sahely/core/security/security_manager.dart';

// Features - Auth
import 'package:sahely/features/auth/domain/repositories/auth_repository.dart';
import 'package:sahely/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sahely/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sahely/features/auth/data/auth_api.dart';
import 'package:sahely/features/auth/domain/services/role_resolver.dart';
import 'package:sahely/features/auth/domain/usecases/login_usecase.dart';
import 'package:sahely/features/auth/domain/usecases/logout_usecase.dart';
import 'package:sahely/features/auth/domain/usecases/register_usecase.dart'
    show
        RegisterStep1UseCase,
        RegisterStep2UseCase,
        VerifyEmailOtpUseCase,
        SendPhoneOtpUseCase,
        VerifyPhoneOtpUseCase;
import 'package:sahely/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sahely/features/auth/presentation/bloc/auth_cubit.dart';

// Features - Broker
import 'package:sahely/features/broker/domain/repositories/broker_repository.dart';
import 'package:sahely/features/broker/data/repositories/broker_repository_impl.dart';
import 'package:sahely/features/broker/domain/repositories/broker_bookings_repository.dart';
import 'package:sahely/features/broker/data/repositories/broker_bookings_repository_impl.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';

// Features - Owner
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/owner/data/repositories/owner_repository_impl.dart';
import 'package:sahely/features/owner/domain/use_cases/get_owner_dashboard_use_case.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_properties_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/bloc/broker_portfolio_cubit.dart';

// Features - Renter
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/renter/data/repositories/renter_repository_impl.dart';
import 'package:sahely/features/renter/data/datasources/renter_api_data_source.dart';
import 'package:sahely/features/renter/presentation/screens/search/bloc/search_cubit.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/domain/repositories/verification_repository.dart';
import 'package:sahely/features/renter/data/repositories/verification_repository_impl.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/renter/domain/use_cases/verify_email_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/verify_phone_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/verify_identity_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/add_payment_card_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/get_verification_status_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/get_wishlist_collections_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/get_wishlist_items_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/add_to_wishlist_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/remove_from_wishlist_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/toggle_wishlist_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/create_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/rename_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/delete_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/add_to_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/remove_from_collection_use_case.dart';
import 'package:sahely/features/renter/domain/use_cases/check_wishlist_status_use_case.dart';
import 'package:sahely/features/renter/domain/repositories/wishlist_repository.dart';
import 'package:sahely/features/renter/data/repositories/wishlist_repository_impl.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_local_data_source.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';

// Features - Shared Profile
import 'package:sahely/features/shared/profile/domain/repositories/profile_repository.dart';
import 'package:sahely/features/shared/profile/data/repositories/profile_repository_impl.dart';
import 'package:sahely/features/shared/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sahely/features/shared/profile/data/datasources/profile_api_data_source.dart';
import 'package:sahely/features/shared/profile/domain/usecases/get_profile_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/update_profile_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/change_password_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/update_language_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/update_currency_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/delete_account_usecase.dart';
import 'package:sahely/features/shared/profile/domain/usecases/logout_usecase.dart'
    as profile_logout;
import 'package:sahely/features/shared/profile/presentation/bloc/profile_cubit.dart';

// Features - Properties
import 'package:sahely/features/properties/domain/repositories/property_repository.dart'
    as new_property;
import 'package:sahely/features/properties/data/repositories/property_repository_impl.dart'
    as new_property_impl;
import 'package:sahely/features/properties/data/datasources/property_remote_data_source.dart';
import 'package:sahely/features/properties/domain/usecases/get_properties_usecase.dart'
    as new_property_usecase;
import 'package:sahely/features/properties/domain/usecases/get_property_details_usecase.dart'
    as new_property_usecase;
import 'package:sahely/features/properties/domain/usecases/get_trending_properties_usecase.dart'
    as new_property_usecase;
import 'package:sahely/features/properties/domain/usecases/get_offers_usecase.dart'
    as new_property_usecase;
import 'package:sahely/features/properties/domain/usecases/search_properties_usecase.dart'
    as new_property_usecase;
import 'package:sahely/features/properties/presentation/bloc/property_bloc.dart';

// Features - Bookings
import 'package:sahely/features/bookings/domain/repositories/booking_repository.dart'
    as new_booking;
import 'package:sahely/features/bookings/data/repositories/booking_repository_impl.dart'
    as new_booking_impl;
import 'package:sahely/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:sahely/features/checklist/data/checklist_remote_data_source.dart';
import 'package:sahely/features/user/data/datasources/user_remote_data_source.dart';
import 'package:sahely/features/user/data/repositories/user_repository_impl.dart';
import 'package:sahely/features/user/domain/repositories/user_repository.dart';
import 'package:sahely/features/mawsem/data/datasources/mawsem_remote_data_source.dart';
import 'package:sahely/features/mawsem/data/repositories/mawsem_repository_impl.dart';
import 'package:sahely/features/mawsem/domain/repositories/mawsem_repository.dart';
import 'package:sahely/core/network/upload/file_upload_api.dart';
import 'package:sahely/features/broker/data/datasources/broker_api_data_source.dart';
import 'package:sahely/features/renter/data/datasources/verification_api_data_source.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_api_data_source.dart';
import 'package:sahely/features/shared/chat/data/chat_api_data_source.dart';
import 'package:sahely/features/shared/chat/data/chatbot_api_data_source.dart';
import 'package:sahely/features/shared/compound/data/compound_api_data_source.dart';
import 'package:sahely/features/shared/concierge/data/concierge_api_data_source.dart';
import 'package:sahely/features/shared/notifications/data/notifications_api_data_source.dart';
import 'package:sahely/features/shared/referrals/data/referrals_api_data_source.dart';
import 'package:sahely/features/shared/reviews/data/datasources/reviews_api_data_source.dart';
import 'package:sahely/features/shared/violations/data/violations_api_data_source.dart';
import 'package:sahely/features/smart_lock/data/smart_lock_api_data_source.dart';
import 'package:sahely/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:sahely/features/bookings/domain/usecases/calculate_booking_usecase.dart';
import 'package:sahely/features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'package:sahely/features/bookings/domain/usecases/cancel_booking_usecase.dart';
import 'package:sahely/features/bookings/presentation/bloc/booking_bloc.dart';

// Features - Payments
import 'package:sahely/features/payments/domain/repositories/payment_repository.dart';
import 'package:sahely/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:sahely/features/payments/data/datasources/payment_remote_data_source.dart';
import 'package:sahely/features/payments/domain/usecases/initiate_payment_usecase.dart';
import 'package:sahely/features/payments/domain/usecases/get_payment_cards_usecase.dart';
import 'package:sahely/features/payments/presentation/bloc/payment_bloc.dart';

// Features - Wallet
import 'package:sahely/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:sahely/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:sahely/features/wallet/data/datasources/wallet_remote_data_source.dart';
import 'package:sahely/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:sahely/features/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:sahely/features/wallet/presentation/bloc/wallet_bloc.dart';

// Features - Shared Reviews
import 'package:sahely/features/shared/reviews/domain/repositories/review_repository.dart';
import 'package:sahely/features/shared/reviews/data/repositories/review_repository_impl.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/get_property_reviews_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/get_user_reviews_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/add_review_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/update_review_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/delete_review_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/like_review_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/report_review_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/reply_to_review_use_case.dart';
import 'package:sahely/features/shared/reviews/domain/use_cases/get_property_review_stats_use_case.dart';
import 'package:sahely/features/shared/reviews/presentation/bloc/review_cubit.dart';

// Features - Shared Notifications

// Features - Shared Rewards

// Features - Shared Properties
import 'package:sahely/features/shared/properties/domain/repositories/search_repository.dart';
import 'package:sahely/features/shared/properties/data/repositories/search_repository_impl.dart';
import 'package:sahely/features/shared/properties/domain/use_cases/get_properties_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/get_trending_properties_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/search_properties_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/filter_properties_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/sort_properties_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/search_suggestions_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/recent_searches_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/clear_recent_searches_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/domain/use_cases/save_search_use_case.dart'
    as shared_property_usecase;
import 'package:sahely/features/shared/properties/data/datasources/search_local_data_source.dart';

// Features - Shared Bookings
import 'package:sahely/features/shared/bookings/domain/repositories/booking_repository.dart'
    as shared_booking;
import 'package:sahely/features/shared/bookings/data/repositories/booking_repository_impl.dart'
    as shared_booking_impl;
import 'package:sahely/features/shared/bookings/domain/services/booking_status_service.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/get_upcoming_bookings_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/get_active_bookings_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/get_past_bookings_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/update_checklist_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/book_property_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/get_booking_details_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/confirm_booking_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/reject_booking_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/check_booking_availability_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/extend_booking_use_case.dart';
import 'package:sahely/features/shared/bookings/domain/use_cases/complete_booking_use_case.dart';

// Features - Broker Bookings
import 'package:sahely/features/broker/domain/use_cases/get_broker_dashboard_use_case.dart';
import 'package:sahely/features/broker/domain/use_cases/get_broker_portfolio_use_case.dart';
import 'package:sahely/features/broker/domain/use_cases/get_broker_wallet_use_case.dart';
import 'package:sahely/features/broker/domain/use_cases/get_broker_bookings_use_case.dart';
import 'package:sahely/features/broker/domain/use_cases/filter_broker_bookings_use_case.dart';
import 'package:sahely/features/shared/bookings/presentation/bloc/bookings_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefs);

  // Config
  sl.registerLazySingleton<EnvConfig>(() => AppConfig.config);

  // Storage & Cache
  sl.registerLazySingleton<CacheService>(
      () => SharedPreferencesCacheService(sl()));
  sl.registerLazySingleton(() => CacheManager(sl()));
  sl.registerLazySingleton(() => RequestCacheManager(sl()));
  sl.registerLazySingleton<ImageCacheService>(
      () => CachedNetworkImageService());
  sl.registerLazySingleton(() => ImageCacheManager(sl()));

  // Core
  sl.registerLazySingleton<Dio>(() => DioFactory.instance);
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dio: sl()));
  sl.registerLazySingleton<AuthProvider>(() => AuthProvider());

  // Network
  sl.registerLazySingleton(() => RetryManager());
  sl.registerLazySingleton(() => UploadManager());
  sl.registerLazySingleton(() => DownloadManager());
  sl.registerLazySingleton(() => FeatureFlagManager());
  sl.registerLazySingleton(() => DeepLinkManager());
  sl.registerLazySingleton<SecureStorageService>(
    () => FlutterSecureStorageService(),
  );
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton(() => SecureStorageManager(service: sl()));
  sl.registerLazySingleton<EncryptionService>(() => AesEncryptionService());
  sl.registerLazySingleton(() => EncryptionManager(sl()));
  sl.registerLazySingleton<DeviceSecurityService>(
      () => SafeDeviceSecurityService());
  sl.registerLazySingleton(() => DeviceSecurityManager(sl()));

  // Security - Network
  sl.registerLazySingleton<CertificateProvider>(() {
    final env = sl<EnvConfig>().environment;
    final certPaths = switch (env) {
      AppEnvironment.dev => ['assets/certs/dev_cert.pem'],
      AppEnvironment.staging => ['assets/certs/staging_cert.pem'],
      AppEnvironment.prod => ['assets/certs/prod_cert.pem'],
    };
    return AssetCertificateProvider(certificatePaths: certPaths);
  });
  sl.registerLazySingleton<SSLPinningService>(
      () => SSLPinningServiceImpl(sl()));
  sl.registerLazySingleton(() => NetworkSecurityManager(sl()));
  sl.registerLazySingleton<SecurityLogger>(() => ConsoleSecurityLogger());
  sl.registerLazySingleton(() {
    final manager = SecurityLogManager();
    manager.addLogger(sl<SecurityLogger>());
    return manager;
  });
  sl.registerLazySingleton(() => SecurityManager(
        storage: sl(),
        encryption: sl(),
        device: sl(),
        network: sl(),
        logger: sl(),
      ));

  // Lazy Loading
  sl.registerFactoryParam<LazyLoadController<dynamic>, LazyLoaderTask<dynamic>,
      Map<String, dynamic>?>(
    (task, params) => LazyLoadController<dynamic>(
      task: task,
      policy: params?['policy'] ?? LazyLoadPolicy.deferred,
      timeout: params?['timeout'],
      maxRetries: params?['maxRetries'] ?? 3,
      retryInterval: params?['retryInterval'] ?? const Duration(seconds: 2),
      periodicInterval: params?['periodicInterval'],
    ),
  );

  sl.registerFactoryParam<LazyLoader<dynamic>, LazyLoaderTask<dynamic>,
      Map<String, dynamic>?>(
    (task, params) => LazyLoader<dynamic>(
      task: task,
      policy: params?['policy'] ?? LazyLoadPolicy.deferred,
      timeout: params?['timeout'],
      maxRetries: params?['maxRetries'] ?? 3,
      retryInterval: params?['retryInterval'] ?? const Duration(seconds: 2),
      periodicInterval: params?['periodicInterval'],
    ),
  );

  // Infinite Scroll
  sl.registerFactoryParam<InfiniteScrollController<dynamic>,
      InfiniteScrollTask<dynamic>, Map<String, dynamic>?>(
    (task, params) => InfiniteScrollController<dynamic>(
      task: task,
      pageSize: params?['pageSize'] ?? 10,
      policy: params?['policy'] ?? InfiniteScrollPolicy.automatic,
      initialParams: params?['initialParams'],
      timeout: params?['timeout'],
      maxRetries: params?['maxRetries'] ?? 3,
      retryInterval: params?['retryInterval'] ?? const Duration(seconds: 2),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<SearchLocalDataSource>(
      () => SearchLocalDataSourceImpl());
  sl.registerLazySingleton<WishlistLocalDataSource>(
      () => WishlistLocalDataSource());
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ApiProfileRemoteDataSource(sl<ApiClient>()));

  // Remote API data sources - one per backend module. Every one of them shares
  // the single authenticated ApiClient registered above.
  sl.registerLazySingleton<FileUploadApi>(() => FileUploadApi(sl()));
  sl.registerLazySingleton<ChecklistRemoteDataSource>(
    () => ChecklistRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<WishlistApiDataSource>(
    () => WishlistApiDataSource(sl()),
  );
  sl.registerLazySingleton<ReviewsApiDataSource>(
    () => ReviewsApiDataSource(sl()),
  );
  sl.registerLazySingleton<ChatApiDataSource>(() => ChatApiDataSource(sl()));
  sl.registerLazySingleton<ChatbotApiDataSource>(
    () => ChatbotApiDataSource(sl()),
  );
  sl.registerLazySingleton<NotificationsApiDataSource>(
    () => NotificationsApiDataSource(sl()),
  );
  sl.registerLazySingleton<ConciergeApiDataSource>(
    () => ConciergeApiDataSource(sl()),
  );
  sl.registerLazySingleton<ReferralsApiDataSource>(
    () => ReferralsApiDataSource(sl()),
  );
  sl.registerLazySingleton<ViolationsApiDataSource>(
    () => ViolationsApiDataSource(sl()),
  );
  sl.registerLazySingleton<CompoundApiDataSource>(
    () => CompoundApiDataSource(sl()),
  );
  sl.registerLazySingleton<SmartLockApiDataSource>(
    () => SmartLockApiDataSource(sl()),
  );
  sl.registerLazySingleton<BrokerApiDataSource>(
    () => BrokerApiDataSource(sl()),
  );
  sl.registerLazySingleton<VerificationApiDataSource>(
    () => VerificationApiDataSource(sl(), uploads: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<MawsemRemoteDataSource>(
    () => MawsemRemoteDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiService(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
    ),
  );
  sl.registerLazySingleton<BrokerRepository>(
    () => BrokerRepositoryImpl(api: sl()),
  );
  sl.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<RenterRepository>(
    () => RenterRepositoryImpl(api: RenterApiDataSource(sl())),
  );

  sl.registerLazySingleton<BrokerBookingsRepository>(
    () => BrokerBookingsRepositoryImpl(),
  );
  sl.registerLazySingleton<VerificationRepository>(
    () => VerificationRepositoryImpl(api: sl()),
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(dataSource: sl(), api: sl()),
  );
  sl.registerLazySingleton<shared_booking.BookingRepository>(
    () => shared_booking_impl.BookingRepositoryImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(api: sl(), violations: sl()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(localDataSource: sl(), properties: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Properties
  sl.registerLazySingleton<PropertyRemoteDataSource>(
    () => PropertyRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<new_property.PropertyRepository>(
    () => new_property_impl.PropertyRepositoryImpl(remoteDataSource: sl()),
  );

  // Bookings
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<new_booking.BookingRepository>(
    () => new_booking_impl.BookingRepositoryImpl(
      remoteDataSource: sl(),
      checklistDataSource: sl(),
    ),
  );

  // Payments
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );

  // Wallet
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: sl()),
  );

  // User profile
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl(), uploads: sl()),
  );

  // MAWSEM loyalty program
  sl.registerLazySingleton<MawsemRepository>(
    () => MawsemRepositoryImpl(remoteDataSource: sl()),
  );

  // Domain Services
  sl.registerLazySingleton(() => RoleResolver());
  sl.registerLazySingleton(() => BookingStatusService());

  // UseCases
  sl.registerLazySingleton(() => GetOwnerDashboardUseCase(sl()));
  sl.registerLazySingleton(() => GetBrokerDashboardUseCase(sl()));
  sl.registerLazySingleton(() => GetBrokerPortfolioUseCase(sl()));
  sl.registerLazySingleton(() => GetBrokerWalletUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl(), sl()));
  sl.registerLazySingleton(() => RegisterStep1UseCase(sl()));
  sl.registerLazySingleton(() => RegisterStep2UseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailOtpUseCase(sl()));
  sl.registerLazySingleton(() => SendPhoneOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPhoneOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetVerificationStatusUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPhoneUseCase(sl()));
  sl.registerLazySingleton(() => VerifyIdentityUseCase(sl()));
  sl.registerLazySingleton(() => AddPaymentCardUseCase(sl()));

  // Wishlist UseCases
  sl.registerLazySingleton(() => GetWishlistCollectionsUseCase(sl()));
  sl.registerLazySingleton(() => GetWishlistItemsUseCase(sl()));
  sl.registerLazySingleton(() => AddToWishlistUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUseCase(sl()));
  sl.registerLazySingleton(() => ToggleWishlistUseCase(
        repository: sl(),
      ));
  sl.registerLazySingleton(() => CreateCollectionUseCase(sl()));
  sl.registerLazySingleton(() => RenameCollectionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCollectionUseCase(sl()));
  sl.registerLazySingleton(() => AddToCollectionUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCollectionUseCase(sl()));
  sl.registerLazySingleton(() => CheckWishlistStatusUseCase(sl()));

  // Review UseCases
  sl.registerLazySingleton(() => GetPropertyReviewsUseCase(sl()));
  sl.registerLazySingleton(() => GetUserReviewsUseCase(sl()));
  sl.registerLazySingleton(() => AddReviewUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));
  sl.registerLazySingleton(() => LikeReviewUseCase(sl()));
  sl.registerLazySingleton(() => ReportReviewUseCase(sl()));
  sl.registerLazySingleton(() => ReplyToReviewUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyReviewStatsUseCase(sl()));

  // Profile UseCases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLanguageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCurrencyUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(() => profile_logout.LogoutUseCase(sl(), sl()));

  // Properties UseCases
  sl.registerLazySingleton(
      () => new_property_usecase.GetPropertiesUseCase(sl()));
  sl.registerLazySingleton(
      () => new_property_usecase.GetPropertyDetailsUseCase(sl()));
  sl.registerLazySingleton(
      () => new_property_usecase.GetTrendingPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => new_property_usecase.GetOffersUseCase(sl()));
  sl.registerLazySingleton(
      () => new_property_usecase.SearchPropertiesUseCase(sl()));

  // Bookings UseCases
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => CalculateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));

  // Payments UseCases
  sl.registerLazySingleton(() => InitiatePaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentCardsUseCase(sl()));

  // Wallet UseCases
  sl.registerLazySingleton(() => GetWalletUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletTransactionsUseCase(sl()));

  // Shared property UseCases - the renter home and search cubits depend on
  // these. They are distinct classes from the same-named ones in
  // features/properties (registered above via new_property_usecase), hence
  // the prefix.
  sl.registerLazySingleton(
      () => shared_property_usecase.GetPropertiesUseCase(sl()));
  sl.registerLazySingleton(
      () => shared_property_usecase.GetTrendingPropertiesUseCase());
  sl.registerLazySingleton(
      () => shared_property_usecase.SearchPropertiesUseCase());
  sl.registerLazySingleton(
      () => shared_property_usecase.FilterPropertiesUseCase());
  sl.registerLazySingleton(
      () => shared_property_usecase.SortPropertiesUseCase());
  sl.registerLazySingleton(
      () => shared_property_usecase.SearchSuggestionsUseCase(sl()));
  sl.registerLazySingleton(
      () => shared_property_usecase.RecentSearchesUseCase(sl()));
  sl.registerLazySingleton(
      () => shared_property_usecase.ClearRecentSearchesUseCase(sl()));
  sl.registerLazySingleton(
      () => shared_property_usecase.SaveSearchUseCase(sl()));

  // Bookings UseCases
  sl.registerLazySingleton(() => GetUpcomingBookingsUseCase(sl(), sl()));
  sl.registerLazySingleton(() => GetActiveBookingsUseCase(sl(), sl()));
  sl.registerLazySingleton(() => GetPastBookingsUseCase(sl(), sl()));
  sl.registerLazySingleton(() => UpdateChecklistUseCase(sl()));
  sl.registerLazySingleton(() => BookPropertyUseCase(sl()));
  sl.registerLazySingleton(() => GetBookingDetailsUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmBookingUseCase(sl()));
  sl.registerLazySingleton(() => RejectBookingUseCase(sl()));
  sl.registerLazySingleton(() => CheckBookingAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => ExtendBookingUseCase(sl()));
  sl.registerLazySingleton(() => CompleteBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetBrokerBookingsUseCase(sl()));
  sl.registerLazySingleton(() => FilterBrokerBookingsUseCase());

  // Cubits
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        registerStep1UseCase: sl(),
        registerStep2UseCase: sl(),
        verifyEmailOtpUseCase: sl(),
        sendPhoneOtpUseCase: sl(),
        verifyPhoneOtpUseCase: sl(),
        resetPasswordUseCase: sl(),
      ));
  sl.registerFactory(() => BrokerHomeCubit(getBrokerDashboardUseCase: sl()));
  sl.registerFactory(() => BrokerBookingsCubit(
        getBrokerBookingsUseCase: sl(),
        filterBrokerBookingsUseCase: sl(),
      ));
  sl.registerFactory(() => BookingsCubit(
        getUpcomingBookingsUseCase: sl(),
        getActiveBookingsUseCase: sl(),
        getPastBookingsUseCase: sl(),
        bookPropertyUseCase: sl(),
        updateChecklistUseCase: sl(),
      ));
  sl.registerFactory(() => OwnerHomeCubit(getOwnerDashboardUseCase: sl()));
  sl.registerFactory(() => OwnerPropertiesCubit(repository: sl()));
  sl.registerFactory(
    () => BrokerPortfolioCubit(getBrokerPortfolioUseCase: sl()),
  );
  sl.registerFactory(() => RenterHomeCubit(
        getPropertiesUseCase: sl(),
        getTrendingPropertiesUseCase: sl(),
        searchPropertiesUseCase: sl(),
        filterPropertiesUseCase: sl(),
        sortPropertiesUseCase: sl(),
      ));
  sl.registerFactory(() => SearchCubit(
        getPropertiesUseCase: sl(),
        searchPropertiesUseCase: sl(),
        filterPropertiesUseCase: sl(),
        sortPropertiesUseCase: sl(),
        searchSuggestionsUseCase: sl(),
        recentSearchesUseCase: sl(),
        clearRecentSearchesUseCase: sl(),
        saveSearchUseCase: sl(),
      ));
  sl.registerFactory(() => WishlistCubit(
        getCollectionsUseCase: sl(),
        getItemsUseCase: sl(),
        toggleUseCase: sl(),
        addToWishlistUseCase: sl(),
        removeFromWishlistUseCase: sl(),
        addToCollectionUseCase: sl(),
        removeFromCollectionUseCase: sl(),
        createCollectionUseCase: sl(),
        renameCollectionUseCase: sl(),
        deleteCollectionUseCase: sl(),
        checkStatusUseCase: sl(),
      ));
  sl.registerFactory(() => VerificationCubit(
        getStatusUseCase: sl(),
        verifyEmailUseCase: sl(),
        verifyPhoneUseCase: sl(),
        verifyIdUseCase: sl(),
        addCardUseCase: sl(),
        authProvider: sl<AuthProvider>(),
      ));
  sl.registerFactory(() => ReviewCubit(
        getPropertyReviewsUseCase: sl(),
        getUserReviewsUseCase: sl(),
        addReviewUseCase: sl(),
        updateReviewUseCase: sl(),
        deleteReviewUseCase: sl(),
        likeReviewUseCase: sl(),
        reportReviewUseCase: sl(),
        replyToReviewUseCase: sl(),
        getStatsUseCase: sl(),
      ));
  sl.registerFactory(() => ProfileCubit(
        getProfileUseCase: sl(),
        updateProfileUseCase: sl(),
        uploadProfileImageUseCase: sl(),
        deleteProfileImageUseCase: sl(),
        changePasswordUseCase: sl(),
        updateLanguageUseCase: sl(),
        updateCurrencyUseCase: sl(),
        deleteAccountUseCase: sl(),
        logoutUseCase: sl(),
      ));

  // Properties BLoC
  sl.registerFactory(() => PropertyBloc(
        getPropertiesUseCase: sl(),
        getPropertyDetailsUseCase: sl(),
        getTrendingPropertiesUseCase: sl(),
        getOffersUseCase: sl(),
        searchPropertiesUseCase: sl(),
      ));

  // Bookings BLoC
  sl.registerFactory(() => BookingBloc(
        createBookingUseCase: sl(),
        calculateBookingUseCase: sl(),
        getMyBookingsUseCase: sl(),
        cancelBookingUseCase: sl(),
      ));

  // Payments BLoC
  sl.registerFactory(() => PaymentBloc(
        initiatePaymentUseCase: sl(),
        getPaymentCardsUseCase: sl(),
      ));

  // Wallet BLoC
  sl.registerFactory(() => WalletBloc(
        getWalletUseCase: sl(),
        getWalletTransactionsUseCase: sl(),
      ));
}
