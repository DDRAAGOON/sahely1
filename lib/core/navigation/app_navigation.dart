import 'package:flutter/material.dart';

class AppNavigation {
  AppNavigation._();

  // ═══════════════════════════════════════════════════════
  // RENTER FLOW
  // ═══════════════════════════════════════════════════════

  static void goToSearchResults(BuildContext context, {String query = '', Map<String, dynamic>? filters}) {
    // TODO: Implement search results navigation
  }

  static void goToAllProperties(BuildContext context, {Map<String, dynamic>? filters}) {
    // TODO: Implement all properties navigation
  }

  // ═══════════════════════════════════════════════════════
  // BROKER FLOW
  // ═══════════════════════════════════════════════════════

  static void goToBrokerHome(BuildContext context) {
    Navigator.pushNamed(context, '/broker/home');
  }

  static void goToBrokerRefer(BuildContext context) {
    Navigator.pushNamed(context, '/broker/refer');
  }

  static void goToBrokerHistory(BuildContext context) {
    Navigator.pushNamed(context, '/broker/history');
  }

  static void goToBrokerTier(BuildContext context) {
    Navigator.pushNamed(context, '/broker/tier');
  }

  static void goToBrokerReferredDetail(BuildContext context) {
    Navigator.pushNamed(context, '/broker/referred-detail');
  }

  static void goToBrokerReferralIssue(BuildContext context) {
    Navigator.pushNamed(context, '/broker/referral-issue');
  }

  static void goToBrokerWithdraw(BuildContext context) {
    Navigator.pushNamed(context, '/broker/withdraw');
  }

  static void goToBrokerPayout(BuildContext context) {
    Navigator.pushNamed(context, '/broker/payout');
  }

  // ═══════════════════════════════════════════════════════
  // AUTH FLOW
  // ═══════════════════════════════════════════════════════

  static void goToWelcome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  static void goToSignIn(BuildContext context) {
    Navigator.pushNamed(context, '/signin');
  }

  static void goToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/create');
  }

  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot');
  }

  static void goToRole(BuildContext context) {
    Navigator.pushNamed(context, '/role');
  }

  static void goToPhoneVerification(BuildContext context) {
    Navigator.pushNamed(context, '/verify-phone');
  }

  static void goToIDVerification(BuildContext context) {
    Navigator.pushNamed(context, '/secure-id');
  }

  static void goToOnboarding(BuildContext context) {
    Navigator.pushNamed(context, '/onboarding');
  }

  // ═══════════════════════════════════════════════════════
  // UTILS
  // ═══════════════════════════════════════════════════════

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
