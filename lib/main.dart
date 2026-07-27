import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sahely/app.dart';
// --- Providers ---
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/broker/data/repositories/broker_bookings_repository.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';
import 'package:sahely/features/renter/data/datasources/mock_renter_data_source.dart';
import 'package:sahely/features/renter/data/repositories/renter_repository_impl.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/data/repositories/wishlist_repository.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
// --- Repositories & Cubits ---
import 'package:sahely/features/renter/presentation/verification/data/repositories/verification_repository.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize AuthProvider and restore login state
  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();

  // 2. Initialize RoleState
  final roleState = RoleState();

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
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => VerificationRepository()),
          RepositoryProvider(create: (context) => WishlistRepository()),
          RepositoryProvider(create: (context) => BrokerBookingsRepository()),
          RepositoryProvider<RenterRepository>(
            create: (context) => RenterRepositoryImpl(
              remoteDataSource: MockRenterDataSource(),
            ),
          ),
        ],
        child: Consumer<RoleState>(
          builder: (context, roleState, child) {
            return MultiBlocProvider(
              // The Key ensures that whenever the Role changes, the entire Bloc tree 
              // (including WishlistCubit) is DISPOSED and RECREATED.
              // This is the architectural solution to prevent state leakage between roles.
              key: ValueKey('bloc_tree_${roleState.currentRole.name}'),
              providers: [
                BlocProvider(
                  create: (context) => VerificationCubit(
                    context.read<VerificationRepository>(),
                    authProvider: authProvider,
                  )..loadVerificationStatus(),
                ),
                BlocProvider(
                  create: (context) => WishlistCubit(
                    context.read<WishlistRepository>(),
                  )..loadCollections(roleState.currentRole),
                ),
                BlocProvider(
                  create: (context) => BrokerBookingsCubit(
                    context.read<BrokerBookingsRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => RenterHomeCubit(
                    repository: context.read<RenterRepository>(),
                  )..loadProperties(),
                ),
              ],
              child: const SahelyApp(),
            );
          },
        ),
      ),
    ),
  );
}
