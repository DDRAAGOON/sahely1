// Shared links (App Links / universal links / sahely://app) arrive as router
// locations. These tests drive the real app router with them.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sahely/core/di/service_locator.dart' as di;
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/shared/links/referral_code_store.dart';
import 'package:sahely/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GoRouter router;
  late RoleState roleState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    await sl.reset();
    await di.init();
    roleState = RoleState();
    router = createAppRouter(sl<AuthProvider>(), roleState);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<AuthProvider>()),
        ChangeNotifierProvider.value(value: roleState),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AuthCubit>()),
          BlocProvider(create: (_) => sl<VerificationCubit>()),
          BlocProvider(create: (_) => sl<WishlistCubit>()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    ));
    await tester.pump();
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Uri location() => router.routerDelegate.currentConfiguration.uri;

  testWidgets('a collection invite sends a signed-out user to sign-in and back',
      (tester) async {
    await pumpApp(tester);
    router.go('/wishlists/join/abc123');
    await settle(tester);

    expect(location().path, AppRoutes.signIn);
    expect(location().queryParameters['from'], '/wishlists/join/abc123');
  });

  testWidgets('a shared listing needs sign-in first as well', (tester) async {
    await pumpApp(tester);
    router.go('/properties/prop-42');
    await settle(tester);

    expect(location().path, AppRoutes.signIn);
    expect(location().queryParameters['from'], '/properties/prop-42');
  });

  testWidgets('an invite link keeps the code and continues to Welcome',
      (tester) async {
    await pumpApp(tester);
    router.go('/join?ref=SAHELY42');
    await settle(tester);

    expect(await tester.runAsync(ReferralCodeStore.read), 'SAHELY42');
    expect(location().path, AppRoutes.welcome);
  });
}
