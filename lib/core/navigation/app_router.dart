import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/shells/broker_shell.dart';
import 'package:sahely/core/navigation/shells/owner_shell.dart';
import 'package:sahely/core/navigation/shells/renter_shell.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/auth/auth_screens.dart';
import 'package:sahely/features/broker/broker_go_routes.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/pages/broker_bookings_page.dart';
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/broker_dashboard_page.dart';
import 'package:sahely/features/broker/presentation/screens/home/pages/broker_home_page.dart';
import 'package:sahely/features/broker/presentation/screens/profile/pages/broker_profile_page.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/broker_portfolio_page.dart';
import 'package:sahely/features/broker/presentation/screens/services/pages/broker_services_page.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/pages/broker_wishlist_page.dart';
import 'package:sahely/features/notifications/notifications_screen.dart';
import 'package:sahely/features/owner/owner_go_routes.dart';
import 'package:sahely/features/owner/screens/owner_bookings_screen.dart';
import 'package:sahely/features/owner/screens/owner_home_screen.dart';
import 'package:sahely/features/owner/screens/owner_profile_screen.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/pages/my_bookings_screen.dart';
import 'package:sahely/features/renter/presentation/screens/concierge/pages/concierge_screen.dart';
import 'package:sahely/features/renter/presentation/screens/home/pages/home_screen.dart';
import 'package:sahely/features/renter/presentation/screens/profile/pages/profile_screen.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/pages/wishlist_screen.dart';
import 'package:sahely/features/shared/screens/services_screen.dart';
import 'package:sahely/features/shared/shared_go_routes.dart';

import 'app_routes.dart';

/// The global navigator key for the main router.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates the centralized router configuration using go_router.
GoRouter createAppRouter(AuthProvider authProvider, RoleState roleState) {
  final routerRefresh = _RouterRefresh(authProvider, roleState);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: routerRefresh,
    redirect: (BuildContext context, GoRouterState state) {
      final loc = state.uri.toString();
      final isAuth = authProvider.isAuthenticated;
      final isVerified = authProvider.isVerified;
      final role = roleState.currentRole;

      // Public (unauthenticated) routes using constants
      final publicPrefixes = <String>[
        AppRoutes.splash,
        AppRoutes.welcome,
        AppRoutes.onboarding,
        AppRoutes.roleSelection,
        AppRoutes.createAccount,
        AppRoutes.signIn,
        AppRoutes.verifyEmail,
        AppRoutes.verifyPhone,
        AppRoutes.forgotPassword,
        AppRoutes.resetOtp,
        AppRoutes.newPassword,
        AppRoutes.passwordUpdated,
        AppRoutes.idVerification,
        AppRoutes.facialScan,
        AppRoutes.verificationComplete,
        AppRoutes.verifyGate,
      ];

      bool isPublic(String path) =>
          publicPrefixes.any((p) => path == p || path.startsWith(p));

      // If not authenticated and trying to access a protected route -> send to signin
      if (!isAuth && !isPublic(loc)) {
        final encoded = Uri.encodeComponent(loc);
        return '${AppRoutes.signIn}?from=$encoded';
      }

      // If authenticated and at an auth screen, send them to their role home
      if (isAuth &&
          (loc == AppRoutes.signIn ||
              loc == AppRoutes.welcome ||
              loc == AppRoutes.createAccount ||
              loc == AppRoutes.roleSelection)) {
        return switch (role) {
          Role.broker => AppRoutes.brokerHome,
          Role.owner => AppRoutes.ownerHome,
          _ => AppRoutes.renterHome,
        };
      }

      // Verification Gate: Renter-only guard.
      final verifyGateRoutes = <String>[
        AppRoutes.verifyGate,
        AppRoutes.addCard,
        AppRoutes.blockedGate,
      ];
      final isOnVerifyRoute = verifyGateRoutes.any(
        (r) => loc == r || loc.startsWith(r),
      );

      if (isAuth &&
          role == Role.renter &&
          !isVerified &&
          !isOnVerifyRoute &&
          !isPublic(loc)) {
        return AppRoutes.verifyGate;
      }

      // Role-based guarding: prevent access to broker/owner sections if role mismatches
      if (isAuth) {
        if (loc.startsWith('/broker') && role != Role.broker) {
          return role == Role.owner ? AppRoutes.ownerHome : AppRoutes.renterHome;
        }
        if (loc.startsWith('/owner') && role != Role.owner) {
          return role == Role.broker ? AppRoutes.brokerHome : AppRoutes.renterHome;
        }
      }

      // Root redirect to splash
      if (loc == '/') return AppRoutes.splash;

      // No redirect
      return null;
    },
    routes: [
      // ---- Auth ----
      GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: AppRoutes.welcome,
          builder: (context, state) => const WelcomeScreen()),
      GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen()),
      GoRoute(
          path: AppRoutes.roleSelection,
          builder: (context, state) => const RoleSelectionScreen()),
      GoRoute(
          path: AppRoutes.createAccount,
          builder: (context, state) =>
              CreateAccountScreen(role: state.extra as String?)),
      GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) =>
              SignInScreen(from: state.uri.queryParameters['from'])),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            title: 'Verify Your Email',
            email: extra?['email'],
            icon: Icons.mail_outline,
            hint: 'Check your inbox — and your spam folder',
            cta: 'Verify Email',
            onVerify: () {
              context.push(AppRoutes.verifyPhone, extra: extra);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.verifyPhone,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpScreen(
            title: 'Verify Your Number',
            phone: extra?['phone'],
            icon: Icons.phone_iphone,
            hint: 'Check your messages for the SMS code',
            cta: 'Verify Number',
            bottomText: 'Wrong number? Change it',
            isPhone: true,
            onVerify: () {
              context.push(AppRoutes.idVerification, extra: extra);
            },
          );
        },
      ),
      GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
        path: AppRoutes.resetOtp,
        builder: (context, state) => OtpScreen(
          title: 'Enter the code',
          subtitleSpans: [
            const TextSpan(text: 'Sent to '),
            TextSpan(
                text: (state.extra as Map<String, dynamic>?)?['email'] ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Color(0xFF2D2D2D))),
          ],
          icon: Icons.mail_outline,
          hint: 'Check your inbox — and your spam folder',
          cta: 'Verify OTP',
          onVerify: () => context.push(AppRoutes.newPassword),
        ),
      ),
      GoRoute(
          path: AppRoutes.newPassword,
          builder: (context, state) => const NewPasswordScreen()),
      GoRoute(
          path: AppRoutes.passwordUpdated,
          builder: (context, state) => const PasswordUpdatedScreen()),
      GoRoute(
          path: AppRoutes.idVerification,
          builder: (context, state) => const IdVerificationScreen()),
      GoRoute(
          path: AppRoutes.facialScan,
          builder: (context, state) => const FacialScanScreen()),
      GoRoute(
          path: AppRoutes.verificationComplete,
          builder: (context, state) => const VerificationCompleteScreen()),

      // ---- Renter (Standalone Shell) ----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RenterShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.renterHome,
                  builder: (context, state) => const HomeScreen())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.renterWishlist,
                  builder: (context, state) =>
                      const WishlistScreen(showNav: false))
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.renterBookings,
                  builder: (context, state) => const MyBookingsScreen())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.renterServices,
                  builder: (context, state) => const ConciergeScreen())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.renterProfile,
                  builder: (context, state) => const ProfileScreen())
            ],
          ),
        ],
      ),

      // ---- Broker (Standalone Shell) ----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BrokerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.brokerHome,
                  builder: (context, state) => const BrokerHomePage())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.brokerWishlist,
                  builder: (context, state) => const BrokerWishlistPage())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.brokerBookings,
                  builder: (context, state) => const BrokerBookingsPage())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.brokerServices,
                  builder: (context, state) => const BrokerServicesPage())
            ],
          ),
          // ✅ Tab 5: My Role (Profile & Dashboard)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.brokerProfile,
                builder: (context, state) => const BrokerProfilePage(),
                routes: [
                  GoRoute(
                    path: 'dashboard', // matches /broker/profile/dashboard
                    builder: (context, state) => const BrokerDashboardPage(),
                  ),
                  GoRoute(
                    path: 'portfolio', // matches /broker/profile/portfolio
                    builder: (context, state) => const BrokerPortfolioPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ---- Owner (Standalone Shell) ----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            OwnerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.ownerHome,
                  builder: (context, state) => const OwnerHomeScreen())
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.ownerWishlist,
                  builder: (context, state) =>
                      const WishlistScreen(showNav: false))
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.ownerBookings,
                builder: (context, state) {
                  final tab = state.uri.queryParameters['tab'];
                  return OwnerBookingsScreen(
                      initialMainTab: tab == 'stays' ? 1 : 0);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.ownerServices,
                  builder: (context, state) =>
                      const ServicesScreen(showNav: false))
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.ownerProfile,
                  builder: (context, state) => const OwnerProfileScreen())
            ],
          ),
        ],
      ),

      // ---- Shared ----
      ...sharedGoRoutes,

      // ---- Owner ----
      ...ownerGoRoutes,

      // ---- Broker ----
      ...brokerGoRoutes,

      // ---- Notifications ----
      GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) => const NotificationsScreen()),
      GoRoute(
          path: AppRoutes.notifBanner,
          builder: (context, state) => const BannerAnatomyScreen()),
      GoRoute(
          path: AppRoutes.notifTop,
          builder: (context, state) => const TopBannerScreen()),
    ],
  );
}

/// Small helper that merges [AuthProvider] and [RoleState] into a single
/// ChangeNotifier that GoRouter can listen to for changes.
class _RouterRefresh extends ChangeNotifier {
  final AuthProvider _auth;
  final RoleState _roleState;

  _RouterRefresh(this._auth, this._roleState) {
    _auth.addListener(_onNotify);
    _roleState.addListener(_onNotify);
  }

  void _onNotify() => notifyListeners();

  @override
  void dispose() {
    _auth.removeListener(_onNotify);
    _roleState.removeListener(_onNotify);
    super.dispose();
  }
}
