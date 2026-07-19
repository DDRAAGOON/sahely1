import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. استيراد ملف الـ Constants اللي انت عملته
import '../../features/broker/presentation/screens/bookings/pages/broker_bookings_page.dart';
import '../../features/broker/presentation/screens/services/pages/broker_services_page.dart';
import '../../features/broker/presentation/screens/wishlist/pages/broker_wishlist_page.dart';
import '../../features/renter/presentation/screens/property/page/property_detail_screen.dart';
import '../constants/app_routes.dart';
import 'app_routes.dart';

// 2. استيراد الشاشات (أمثلة، استبدلها بمسارات الشاشات الفعلية عندك)
import 'package:sahely/features/auth/screens/splash_screen.dart';
import 'package:sahely/features/auth/screens/sign_in_screen.dart';
import 'package:sahely/features/broker/presentation/screens/home/pages/broker_home_page.dart';
import 'package:sahely/features/broker/presentation/screens/profile/pages/broker_profile_page.dart';
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/broker_dashboard_page.dart';
import 'package:sahely/core/navigation/shells/broker_shell.dart';

// Global Navigator Key
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash, // ✅ استخدام الـ Constant
    debugLogDiagnostics: true,

    routes: [
      // =======================================================================
      // 1. AUTH ROUTES
      // =======================================================================
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyGate,
        name: 'verifyGate',
        builder: (context, state) => const VerificationGateScreen(),
      ),

      // =======================================================================
      // 2. BROKER SHELL (Bottom Navigation)
      // =======================================================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BrokerShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brokerHome,
                name: 'brokerHome',
                builder: (context, state) => const BrokerHomePage(),
              ),
            ],
          ),
          // Tab 2: Wishlist
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brokerWishlist,
                name: 'brokerWishlist',
                builder: (context, state) => const BrokerWishlistPage(),
              ),
            ],
          ),
          // Tab 3: Bookings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brokerBookings,
                name: 'brokerBookings',
                builder: (context, state) => const BrokerBookingsPage(),
              ),
            ],
          ),
          // Tab 4: Services
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brokerServices,
                name: 'brokerServices',
                builder: (context, state) => const BrokerServicesPage(),
              ),
            ],
          ),
          // Tab 5: Profile (My Role) ✅
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brokerProfile, // ✅ هنا بنستخدم الـ Constant بتاعك
                name: 'brokerProfile',
                builder: (context, state) => const BrokerProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // =======================================================================
      // 3. DYNAMIC ROUTES (مع Parameters)
      // =======================================================================
      GoRoute(
        // ✅ نستخدم الـ Constant ونضيف الـ Parameter بتاع الـ GoRouter
        path: '${AppRoutes.propertyDetails}/:id',
        name: 'propertyDetail',
        builder: (context, state) {
          final propertyId = state.pathParameters['id']!;
          return PropertyDetailScreen(propertyId: propertyId);
        },
      ),

      GoRoute(
        path: '${AppRoutes.bookingDetail}/:id',
        name: 'bookingDetail',
        builder: (context, state) {
          final bookingId = state.pathParameters['id']!;
          return BookingDetailScreen(bookingId: bookingId);
        },
      ),
    ],
  );
}