import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/renter/presentation/verification/data/repositories/verification_repository.dart';
import 'features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'features/renter/presentation/screens/wishlist/data/repositories/wishlist_repository.dart';
import 'features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';

import 'features/broker/data/repositories/broker_wishlist_repository.dart';
import 'features/broker/presentation/screens/wishlist/bloc/broker_wishlist_cubit.dart';
import 'features/broker/data/repositories/broker_bookings_repository.dart';
import 'features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/bookings_provider.dart';
import 'core/providers/currency_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/navigation_provider.dart';
import 'core/providers/profile_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => VerificationRepository()),
          RepositoryProvider(create: (context) => WishlistRepository()),
          RepositoryProvider(create: (context) => BrokerWishlistRepository()),
          RepositoryProvider(create: (context) => BrokerBookingsRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => VerificationCubit(
                context.read<VerificationRepository>(),
              )..loadVerificationStatus(),
            ),
            BlocProvider(
              create: (context) => WishlistCubit(
                context.read<WishlistRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => BrokerWishlistCubit(
                context.read<BrokerWishlistRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => BrokerBookingsCubit(
                context.read<BrokerBookingsRepository>(),
              ),
            ),
          ],
          child: const SahelyApp(),
        ),
      ),
    ),
  );
}
