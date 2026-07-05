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

  // ═══════════════════════════════════════════════════════
  // UTILS
  // ═══════════════════════════════════════════════════════

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
