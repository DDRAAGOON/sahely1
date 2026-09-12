import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sahely/core/config/app_env.dart';
import 'package:sahely/core/di/service_locator.dart' as di;
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/security/device/device_security_manager.dart';
import 'package:sahely/core/security/logger/security_logger.dart';
import 'package:sahely/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/bloc/broker_portfolio_cubit.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_properties_cubit.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/search/bloc/search_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/shared/bookings/presentation/bloc/bookings_cubit.dart';
import 'package:sahely/features/shared/profile/presentation/bloc/profile_cubit.dart';
import 'package:sahely/features/shared/reviews/presentation/bloc/review_cubit.dart';

/// Reproduces the app's startup path without a device.
///
/// `main()` runs `di.init()` before the first frame; if that throws, the app
/// never leaves the native launch screen. Every `sl<T>()` the app performs is
/// then resolved here too, because an unregistered dependency only explodes
/// the first time its screen opens - which neither the analyzer nor widget
/// tests would ever catch.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
  });

  test('the service locator initialises (no duplicate registrations)',
      () async {
    await di.init();
  });

  test('every object the app resolves from the service locator builds',
      () async {
    await di.init();

    // Every sl<T>() call site in lib/, so a missing registration anywhere in
    // a dependency chain is reported - all of them in one run.
    final resolvers = <String, Object Function()>{
      'AuthProvider': () => sl<AuthProvider>(),
      'DeviceSecurityManager': () => sl<DeviceSecurityManager>(),
      'SecurityLogger': () => sl<SecurityLogger>(),
      'EnvConfig': () => sl<EnvConfig>(),
      'ApiClient': () => sl<ApiClient>(),
      'OwnerRepository': () => sl<OwnerRepository>(),
      'AuthCubit': () => sl<AuthCubit>(),
      'VerificationCubit': () => sl<VerificationCubit>(),
      'WishlistCubit': () => sl<WishlistCubit>(),
      'BrokerHomeCubit': () => sl<BrokerHomeCubit>(),
      'BrokerBookingsCubit': () => sl<BrokerBookingsCubit>(),
      'BrokerPortfolioCubit': () => sl<BrokerPortfolioCubit>(),
      'OwnerHomeCubit': () => sl<OwnerHomeCubit>(),
      'OwnerPropertiesCubit': () => sl<OwnerPropertiesCubit>(),
      'RenterHomeCubit': () => sl<RenterHomeCubit>(),
      'SearchCubit': () => sl<SearchCubit>(),
      'BookingsCubit': () => sl<BookingsCubit>(),
      'ReviewCubit': () => sl<ReviewCubit>(),
      'ProfileCubit': () => sl<ProfileCubit>(),
    };

    final failures = <String>[];
    resolvers.forEach((name, resolve) {
      try {
        resolve();
      } catch (e) {
        failures.add('$name -> ${'$e'.split('\n').first}');
      }
    });

    expect(failures, isEmpty, reason: '\n${failures.join('\n')}');
  });
}
