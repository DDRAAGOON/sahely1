import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth & Core Screens
import '../../features/auth/auth_screens.dart';
import '../../features/notifications/notifications_screen.dart';

import 'shells/renter_shell.dart';
import 'shells/broker_shell.dart';
import '../../features/shared/shared_go_routes.dart';
import '../../features/owner/owner_go_routes.dart';
import '../../features/broker/broker_go_routes.dart';
import '../../core/providers/auth_provider.dart';
import '../../data/role_state.dart';
import '../../data/models.dart';

import '../../features/renter/presentation/screens/home/pages/home_screen.dart';
import '../../features/renter/presentation/screens/wishlist/pages/wishlist_screen.dart';
import '../../features/renter/presentation/screens/bookings/pages/my_bookings_screen.dart';
import '../../features/renter/presentation/screens/concierge/pages/concierge_screen.dart';
import '../../features/renter/presentation/screens/profile/pages/profile_screen.dart';

import '../../features/broker/presentation/screens/home/pages/broker_home_page.dart';
import '../../features/broker/presentation/screens/wishlist/pages/broker_wishlist_page.dart';
import '../../features/broker/presentation/screens/bookings/pages/broker_bookings_page.dart';
import '../../features/broker/presentation/screens/services/pages/broker_services_page.dart';
import '../../features/broker/presentation/screens/profile/pages/broker_profile_page.dart';

/// The global navigator key for the main router.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates the centralized router configuration using go_router.
///
/// The router depends on [AuthProvider] (and role state) to perform global
/// redirects and route-guarding. Pass the application's AuthProvider instance
/// so the router can listen to authentication changes and refresh.

GoRouter createAppRouter(AuthProvider authProvider) {
  // Small ChangeNotifier that listens to both authProvider and roleState
  // and notifies GoRouter when either changes.
  final roleState = RoleState();
  final routerRefresh = _RouterRefresh(authProvider, roleState);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true, // Helpful for debugging routing issues during migration
    refreshListenable: routerRefresh,

    redirect: (BuildContext context, GoRouterState state) {
      final loc = state.uri.toString();
      final isAuth = authProvider.isAuthenticated;

      // Public (unauthenticated) routes
      const publicPrefixes = <String>[
        '/splash',
        '/welcome',
        '/onboarding',
        '/role',
        '/create',
        '/signin',
        '/verify-email',
        '/verify-phone',
        '/forgot',
        '/reset-otp',
        '/new-password',
        '/password-updated',
        '/id-verification',
        '/facial-scan',
        '/verification-complete',
      ];

      bool isPublic(String path) => publicPrefixes.any((p) => path == p || path.startsWith(p));

      // If not authenticated and trying to access a protected route -> send to signin
      if (!isAuth && !isPublic(loc)) {
        final encoded = Uri.encodeComponent(loc);
        return '/signin?from=$encoded';
      }

      // If authenticated and at an auth screen, send them to their role home
      if (isAuth && (loc == '/signin' || loc == '/welcome' || loc == '/create' || loc == '/role')) {
        final role = roleState.currentRole;
        return switch (role) {
          Role.broker => '/broker/home',
          Role.owner => '/owner/home',
          _ => '/renter/home',
        };
      }

      // Role-based guarding: prevent access to broker/owner sections if role mismatches
      if (isAuth) {
        final role = roleState.currentRole;
        if (loc.startsWith('/broker') && role != Role.broker) {
          return role == Role.owner ? '/owner/home' : '/renter/home';
        }
        if (loc.startsWith('/owner') && role != Role.owner) {
          return role == Role.broker ? '/broker/home' : '/renter/home';
        }
      }

      // No redirect
      return null;
    },

    routes: [
    // ---- Auth ----
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/role', builder: (context, state) => const RoleSelectionScreen()),
    GoRoute(path: '/create', builder: (context, state) => CreateAccountScreen(role: state.extra as String?)),
    GoRoute(path: '/signin', builder: (context, state) => SignInScreen(from: state.uri.queryParameters['from'])),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => OtpScreen(
        title: 'Verify Your Email',
        icon: Icons.mail_outline,
        hint: 'Check your inbox — and your spam folder',
        cta: 'Verify Email',
        onVerify: () {
          context.push('/verify-phone', extra: state.extra);
        },
      ),
    ),
    GoRoute(
      path: '/verify-phone',
      builder: (context, state) => OtpScreen(
        title: 'Verify Your Number',
        icon: Icons.phone_iphone,
        hint: 'Check your messages for the SMS code',
        cta: 'Verify Number',
        bottomText: 'Wrong number? Change it',
        isPhone: true,
        onVerify: () {
          context.push('/id-verification', extra: state.extra);
        },
      ),
    ),
    GoRoute(path: '/forgot', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(
      path: '/reset-otp',
      builder: (context, state) => OtpScreen(
        title: 'Enter the code',
        subtitleSpans: const [
          TextSpan(text: 'Sent to '),
          TextSpan(text: 'mariam@example.com', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF2D2D2D))),
        ],
        icon: Icons.mail_outline,
        hint: 'Check your inbox — and your spam folder',
        cta: 'Verify OTP',
        onVerify: () => context.push('/new-password'),
      ),
    ),
    GoRoute(path: '/new-password', builder: (context, state) => const NewPasswordScreen()),
    GoRoute(path: '/password-updated', builder: (context, state) => const PasswordUpdatedScreen()),
    GoRoute(path: '/id-verification', builder: (context, state) => const IdVerificationScreen()),
    GoRoute(path: '/facial-scan', builder: (context, state) => const FacialScanScreen()),
    GoRoute(path: '/verification-complete', builder: (context, state) => const VerificationCompleteScreen()),

    // ---- Renter (Standalone Shell) ----
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RenterShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/renter/home', builder: (context, state) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/renter/wishlist', builder: (context, state) => const WishlistScreen(showNav: false))],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/renter/bookings', builder: (context, state) => const MyBookingsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/renter/services', builder: (context, state) => const ConciergeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/renter/profile', builder: (context, state) => const ProfileScreen())],
        ),
      ],
    ),

    // ---- Broker (Standalone Shell) ----
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => BrokerShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/broker/home', builder: (context, state) => const BrokerHomePage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/broker/wishlist', builder: (context, state) => const BrokerWishlistPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/broker/bookings', builder: (context, state) => const BrokerBookingsPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/broker/services', builder: (context, state) => const BrokerServicesPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/broker/profile', builder: (context, state) => const BrokerProfilePage())],
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
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    GoRoute(path: '/notif-banner', builder: (context, state) => const BannerAnatomyScreen()),
    GoRoute(path: '/notif-top', builder: (context, state) => const TopBannerScreen()),
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

