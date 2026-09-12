import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/navigation/shells/broker_shell.dart';
import 'package:sahely/core/navigation/route_transitions.dart';
import 'package:sahely/core/navigation/shells/owner_shell.dart';
import 'package:sahely/core/navigation/shells/renter_shell.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/auth/auth_screens.dart';
import 'package:sahely/features/broker/broker_go_routes.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/pages/broker_bookings_page.dart';
import 'package:sahely/features/broker/presentation/screens/home/pages/broker_home_page.dart';
import 'package:sahely/features/broker/presentation/screens/profile/pages/broker_profile_page.dart';
import 'package:sahely/features/broker/presentation/screens/services/pages/broker_services_page.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/screens/notification_settings_screen.dart';
import 'package:sahely/features/owner/owner_go_routes.dart';
import 'package:sahely/features/owner/screens/owner_bookings_screen.dart';
import 'package:sahely/features/owner/screens/owner_home_screen.dart';
import 'package:sahely/features/owner/screens/owner_profile_screen.dart';
import 'package:sahely/features/shared/screens/home_screen.dart';
import 'package:sahely/features/shared/screens/profile_screen.dart';
import 'package:sahely/features/shared/screens/wishlist_screen.dart';
import 'package:sahely/features/shared/screens/my_bookings_screen.dart';
import 'package:sahely/features/shared/screens/concierge_screen.dart';
import 'package:sahely/features/shared/screens/services_screen.dart';
import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/features/shared/shared_go_routes.dart';
import 'package:sahely/features/shared/links/link_screens.dart';

/// The global navigator key for the main router.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Creates the centralized router configuration using go_router.
GoRouter createAppRouter(AuthProvider authProvider, RoleState roleState) {
  final routerRefresh = _RouterRefresh(authProvider, roleState);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: false,
    refreshListenable: routerRefresh,
    redirect: (BuildContext context, GoRouterState state) {
      final loc = state.uri.toString();
      final isAuth = authProvider.isAuthenticated;
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
        // An invite link must work before the account exists.
        AppRoutes.referralLink,
      ];

      bool isPublic(String path) =>
          publicPrefixes.any((p) => path == p || path.startsWith(p));

      // 1. If not authenticated and trying to access a protected route -> send to signin
      if (!isAuth && !isPublic(loc)) {
        final encoded = Uri.encodeComponent(loc);
        return '${AppRoutes.signIn}?from=$encoded';
      }

      // 2. If authenticated and at an intro/auth screen, send them to their role home
      if (isAuth &&
          (loc.startsWith(AppRoutes.splash) ||
              loc.startsWith(AppRoutes.welcome) ||
              loc.startsWith(AppRoutes.signIn) ||
              loc.startsWith(AppRoutes.createAccount) ||
              loc.startsWith(AppRoutes.roleSelection))) {
        // Handle deep link if 'from' is present in query parameters
        final from = state.uri.queryParameters['from'];
        if (from != null) {
          return Uri.decodeComponent(from);
        }

        return switch (role) {
          Role.broker => AppRoutes.brokerHome,
          Role.owner => AppRoutes.ownerHome,
          _ => AppRoutes.renterHome,
        };
      }

      // 3. Root redirect to welcome if unauth, or home if auth
      if (loc == '/') {
        if (isAuth) {
          return switch (role) {
            Role.broker => AppRoutes.brokerHome,
            Role.owner => AppRoutes.ownerHome,
            _ => AppRoutes.renterHome,
          };
        }
        return AppRoutes.welcome;
      }

      // No redirect
      return null;
    },
    routes: [
      // ---- Global Routes ----
      GoRoute(
        path: AppRoutes.notificationsSettings,
        pageBuilder: (context, state) => fadeSlideTransition(
          key: state.pageKey,
          child: const NotificationSettingsScreen(),
        ),
      ),

      // ---- Shared links ----
      GoRoute(
        path: AppRoutes.joinCollectionLink,
        builder: (context, state) =>
            JoinCollectionScreen(token: state.pathParameters['token'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.referralLink,
        builder: (context, state) =>
            ReferralLinkScreen(code: state.uri.queryParameters['ref'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.propertyLink,
        builder: (context, state) =>
            PropertyLinkScreen(propertyId: state.pathParameters['id'] ?? ''),
      ),

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
        builder: (context, state) =>
            RegisterEmailOtpScreen(extra: state.extra as Map<String, dynamic>?),
      ),
      GoRoute(
        path: AppRoutes.verifyPhone,
        builder: (context, state) =>
            RegisterPhoneOtpScreen(extra: state.extra as Map<String, dynamic>?),
      ),
      GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
        path: AppRoutes.resetOtp,
        builder: (context, state) {
          final l = AppLocalizations.of(context);
          return OtpScreen(
            title: l.enterCodeTitle,
            subtitleSpans: [
              TextSpan(text: l.sentTo),
              TextSpan(
                  text: (state.extra as Map<String, dynamic>?)?['email'] ?? '',
                  style: AppTheme.dm(
                      weight: FontWeight.w700, color: const Color(0xFF2D2D2D))),
            ],
            icon: Icons.mail_outline,
            hint: l.verifyEmailHint,
            cta: l.verifyOtpCta,
            onVerify: () => context.push(AppRoutes.newPassword),
          );
        },
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

      // ---- Renter (Shell) ----
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        builder: (context, state, navigationShell) =>
            RenterShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.renterHome,
                builder: (context, state) => const HomeScreen())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.renterWishlist,
                builder: (context, state) =>
                    const WishlistScreen(showNav: false, role: Role.renter))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.renterBookings,
                builder: (context, state) => const MyBookingsScreen())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.renterServices,
                builder: (context, state) => const ConciergeScreen())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.renterProfile,
                builder: (context, state) => const ProfileScreen())
          ]),
        ],
      ),

      // ---- Broker (Shell) ----
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        builder: (context, state, navigationShell) =>
            BrokerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.brokerHome,
                builder: (context, state) => const BrokerHomePage())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.brokerWishlist,
                builder: (context, state) =>
                    const WishlistScreen(showNav: false, role: Role.broker))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.brokerBookings,
                builder: (context, state) => const BrokerBookingsPage())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.brokerServices,
                builder: (context, state) => const BrokerServicesPage())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.brokerProfile,
                builder: (context, state) => const BrokerProfilePage()),
          ]),
        ],
      ),

      // ---- Owner (Shell) ----
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        builder: (context, state, navigationShell) =>
            OwnerShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.ownerHome,
                builder: (context, state) => const OwnerHomeScreen())
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.ownerWishlist,
                builder: (context, state) =>
                    const WishlistScreen(showNav: false, role: Role.owner))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.ownerBookings,
                builder: (context, state) {
                  final tab = state.uri.queryParameters['tab'];
                  return OwnerBookingsScreen(
                      initialMainTab: tab == 'stays' ? 1 : 0);
                })
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.ownerServices,
                builder: (context, state) =>
                    const ServicesScreen(showNav: false))
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.ownerProfile,
                builder: (context, state) => const OwnerProfileScreen())
          ]),
        ],
      ),

      // ---- Shared & Extra Features ----
      ...sharedGoRoutes,
      ...ownerGoRoutes,
      ...brokerGoRoutes,
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

/// A container that animates between GoRouter's StatefulShellRoute branches
/// while keeping them in the widget tree (via Stack & Offstage/IgnorePointer)
/// so they preserve their state.
class AnimatedBranchContainer extends StatelessWidget {
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(children.length, (index) {
        final isActive = index == currentIndex;
        return IgnorePointer(
          ignoring: !isActive,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            opacity: isActive ? 1.0 : 0.0,
            child: children[index],
          ),
        );
      }),
    );
  }
}
