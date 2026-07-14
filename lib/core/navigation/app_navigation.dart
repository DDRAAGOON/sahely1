import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation {
  AppNavigation._();

  // ═══════════════════════════════════════════════════════
  // CORE ROUTING HELPERS (Phase 4.1 Bridge)
  // ═══════════════════════════════════════════════════════

  /// Safely pushes a route, trying GoRouter first.
  static void safePush(BuildContext context, String path) {
    context.push(path);
  }

  /// Safely replaces a route, trying GoRouter first.
  static void safeGo(BuildContext context, String path) {
    context.go(path);
  }

  // ═══════════════════════════════════════════════════════
  // SHELL TAB ROUTES (Phase 4.4 — replaces NavigationProvider)
  // ═══════════════════════════════════════════════════════

  static const renterTabRoutes = <String>[
    '/renter/home',
    '/renter/wishlist',
    '/renter/bookings',
    '/renter/services',
    '/renter/profile',
  ];

  static const brokerTabRoutes = <String>[
    '/broker/home',
    '/broker/wishlist',
    '/broker/bookings',
    '/broker/services',
    '/broker/profile',
  ];

  /// Switches the Renter shell to the tab at [index] (0=Home … 4=Profile).
  static void goToRenterTab(BuildContext context, int index) {
    if (index < 0 || index >= renterTabRoutes.length) return;
    safeGo(context, renterTabRoutes[index]);
  }

  /// Switches the Broker shell to the tab at [index] (0=Home … 4=Profile).
  static void goToBrokerTab(BuildContext context, int index) {
    if (index < 0 || index >= brokerTabRoutes.length) return;
    safeGo(context, brokerTabRoutes[index]);
  }

  static void goToRenterBookings(BuildContext context) {
    safeGo(context, '/renter/bookings');
  }

  static void goToRenterHome(BuildContext context) {
    safeGo(context, '/renter/home');
  }

  // ═══════════════════════════════════════════════════════
  // RENTER FLOW
  // ═══════════════════════════════════════════════════════

  static void goToSearchResults(BuildContext context, {String query = '', Map<String, dynamic>? filters}) {
    context.push('/browse', extra: filters ?? query);
  }

  static void goToAllProperties(BuildContext context, {Map<String, dynamic>? filters}) {
    context.push('/all-properties', extra: filters);
  }

  // ═══════════════════════════════════════════════════════
  // BROKER FLOW
  // ═══════════════════════════════════════════════════════

  static void goToBrokerHome(BuildContext context) {
    safePush(context, '/broker/home');
  }

  static void goToBrokerRefer(BuildContext context) {
    safePush(context, '/broker/refer');
  }

  static void goToBrokerHistory(BuildContext context) {
    safePush(context, '/broker/history');
  }

  static void goToBrokerTier(BuildContext context) {
    safePush(context, '/broker/tier');
  }

  static void goToBrokerReferredDetail(BuildContext context) {
    safePush(context, '/broker/referred-detail');
  }

  static void goToBrokerReferralIssue(BuildContext context) {
    safePush(context, '/broker/referral-issue');
  }

  static void goToBrokerWithdraw(BuildContext context) {
    safePush(context, '/broker/withdraw');
  }

  static void goToBrokerPayout(BuildContext context) {
    safePush(context, '/broker/payout');
  }

  // ═══════════════════════════════════════════════════════
  // AUTH FLOW
  // ═══════════════════════════════════════════════════════

  static void goToWelcome(BuildContext context) {
    safeGo(context, '/welcome');
  }

  static void goToSignIn(BuildContext context) {
    safePush(context, '/signin');
  }

  static void goToSignUp(BuildContext context) {
    safePush(context, '/create');
  }

  static void goToForgotPassword(BuildContext context) {
    safePush(context, '/forgot');
  }

  static void goToRole(BuildContext context) {
    safePush(context, '/role');
  }

  // ═══════════════════════════════════════════════════════
  // UTILS
  // ═══════════════════════════════════════════════════════

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
