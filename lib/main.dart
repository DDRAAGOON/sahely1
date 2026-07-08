import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sahely/app.dart';
import 'package:sahely/injection_container.dart' as di;
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/providers/navigation_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/data/wishlist_state.dart';
import 'package:sahely/features/renter/verification/data/repositories/verification_repository.dart';
import 'package:sahely/features/renter/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:sahely/features/shared/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WishlistState()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => VerificationRepository()),
          RepositoryProvider<AuthRepository>(create: (context) => di.sl<AuthRepository>()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                loginUseCase: di.sl(),
                registerUseCase: di.sl(),
                verifyOtpUseCase: di.sl(),
                repository: di.sl(),
              ),
            ),
            BlocProvider(
              create: (context) => VerificationCubit(
                context.read<VerificationRepository>(),
              )..loadVerificationStatus(),
            ),
          ],
          child: const SahelyApp(),
        ),
      ),
    ),
  );
}
