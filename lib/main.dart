import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sahely/app.dart';
import 'package:sahely/core/di/service_locator.dart' as di;
import 'package:sahely/core/di/service_locator.dart';
// --- Providers ---
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
// --- Repositories & Cubits ---
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/shared/profile/presentation/bloc/profile_cubit.dart';
import 'package:sahely/features/shared/reviews/presentation/bloc/review_cubit.dart';
import 'package:sahely/features/shared/bookings/presentation/bloc/bookings_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/search/bloc/search_cubit.dart';
import 'package:sahely/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Service Locator
  await di.init();

  // 2. Initialize AuthProvider and restore login state
  final authProvider = sl<AuthProvider>();
  await authProvider.checkAuthStatus();

  // 3. RoleState is already initialized inside checkAuthStatus, 
  // but we ensure it's loaded here as well.
  final roleState = RoleState();
  await roleState.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: roleState),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<RoleState>(
        builder: (context, roleState, child) {
          return MultiBlocProvider(
            key: ValueKey('bloc_tree_${roleState.currentRole.name}'),
            providers: [
              BlocProvider(create: (_) => sl<AuthCubit>()),
              BlocProvider(create: (_) => sl<VerificationCubit>()..loadVerificationStatus()),
              BlocProvider(create: (_) => sl<WishlistCubit>()..loadCollections(roleState.currentRole)),
              BlocProvider(create: (_) => sl<BrokerHomeCubit>()..loadDashboard()),
              BlocProvider(create: (_) => sl<BrokerBookingsCubit>()..loadBookings()),
              BlocProvider(create: (_) => sl<OwnerHomeCubit>()..loadDashboard()),
              BlocProvider(create: (_) => sl<RenterHomeCubit>()..loadProperties()),
              BlocProvider(create: (_) => sl<SearchCubit>()..init()),
              BlocProvider(create: (_) => sl<BookingsCubit>()..loadBookings()),
              BlocProvider(create: (_) => sl<ReviewCubit>()),
              BlocProvider(create: (_) => sl<ProfileCubit>()),
            ],
            child: const SahelyApp(),
          );
        },
      ),
    ),
  );
}
