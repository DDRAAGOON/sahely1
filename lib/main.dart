import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'app.dart';
// --- Providers ---
import 'core/providers/auth_provider.dart';
import 'core/providers/bookings_provider.dart';
import 'core/providers/currency_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/profile_provider.dart';
// ✅ أضف هذا الاستيراد (تأكد من المسار الصحيح لملف RoleState في مشروعك)
import 'data/role_state.dart';
import 'features/broker/data/repositories/broker_bookings_repository.dart';
import 'features/broker/data/repositories/broker_wishlist_repository.dart';
import 'features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';
import 'features/broker/presentation/screens/wishlist/bloc/broker_wishlist_cubit.dart';
import 'features/renter/presentation/screens/wishlist/data/repositories/wishlist_repository.dart';
import 'features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
// --- Repositories & Cubits ---
import 'features/renter/presentation/verification/data/repositories/verification_repository.dart';
import 'features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة الـ AuthProvider واستعادة حالة تسجيل الدخول
  final authProvider = AuthProvider();
  await authProvider.checkAuthStatus();

  // 2. تهيئة الـ RoleState وتحديد دور المستخدم بناءً على بيانات الـ Auth
  final roleState = RoleState();
  // ✅ مهم: قم بتحديث دور المستخدم هنا إذا كان الـ AuthProvider يحتفظ به
  // مثال: if (authProvider.user != null) roleState.setRole(authProvider.user.role);

  runApp(
    MultiProvider(
      providers: [
        // توفير الـ instances التي تم تهيئتها مسبقاً
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: roleState),
        // ✅ توفير RoleState للـ App بالكامل

        ChangeNotifierProvider(create: (_) => BookingsProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
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
                authProvider:
                    authProvider, // ✅ هذا هو الربط الذي يجعل الـ Router يعمل
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
          // 3. تشغيل التطبيق
          child: const SahelyApp(),
        ),
      ),
    ),
  );
}
