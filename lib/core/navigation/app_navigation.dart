import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';

class AppNavigation {
  AppNavigation._(); // Private constructor

  /// Safely pushes a route.
  static void safePush(BuildContext context, String path) => context.push(path);

  /// Safely replaces a route.
  static void safeGo(BuildContext context, String path) => context.go(path);

  // --------------------------------------------------------------------------
  // Auth Navigation
  // --------------------------------------------------------------------------
  static void goToSplash(BuildContext context) => context.go(AppRoutes.splash);
  static void goToWelcome(BuildContext context) => context.push(AppRoutes.welcome);
  static void goToSignIn(BuildContext context, {String? from}) {
    if (from != null) {
      context.push('${AppRoutes.signIn}?from=$from');
    } else {
      context.push(AppRoutes.signIn);
    }
  }
  static void goToRegister(BuildContext context, {String? role}) => 
      context.push(AppRoutes.createAccount, extra: role);
  static void goToForgotPassword(BuildContext context) => context.push(AppRoutes.forgotPassword);
  
  // Verification
  static void goToVerifyGate(BuildContext context) => context.push(AppRoutes.verifyGate);
  static void goToVerifyEmail(BuildContext context, {Map<String, dynamic>? extra}) => 
      context.push(AppRoutes.verifyEmail, extra: extra);
  static void goToVerifyPhone(BuildContext context, {Map<String, dynamic>? extra}) => 
      context.push(AppRoutes.verifyPhone, extra: extra);
  static void goToIdVerification(BuildContext context, {Map<String, dynamic>? extra}) => 
      context.push(AppRoutes.idVerification, extra: extra);

  // --------------------------------------------------------------------------
  // Renter Navigation
  // --------------------------------------------------------------------------
  static void goToRenterHome(BuildContext context) => context.go(AppRoutes.renterHome);
  static void goToRenterWishlist(BuildContext context) => context.push(AppRoutes.renterWishlist);
  static void goToRenterBookings(BuildContext context) => context.push(AppRoutes.renterBookings);
  static void goToRenterServices(BuildContext context) => context.push(AppRoutes.renterServices);
  static void goToRenterProfile(BuildContext context) => context.push(AppRoutes.renterProfile);

  // --------------------------------------------------------------------------
  // Broker Navigation
  // --------------------------------------------------------------------------
  static void goToBrokerHome(BuildContext context) => context.go(AppRoutes.brokerHome);
  static void goToBrokerDashboard(BuildContext context) => context.push(AppRoutes.brokerDashboard);
  static void goToBrokerWallet(BuildContext context) => context.push(AppRoutes.wallet); // Note: using shared wallet route usually
  static void goToBrokerPortfolio(BuildContext context) => context.push(AppRoutes.brokerReferredDetail); // Using referred detail for portfolio
  static void goToBrokerRefer(BuildContext context) => context.push(AppRoutes.brokerRefer);
  static void goToBrokerTier(BuildContext context) => context.push(AppRoutes.brokerTier);
  static void goToBrokerTierUpgrade(BuildContext context) => context.push(AppRoutes.brokerTierUpgrade);
  static void goToBrokerHistory(BuildContext context) => context.push(AppRoutes.brokerHistory);
  static void goToBrokerProfile(BuildContext context) => context.push(AppRoutes.brokerProfile);
  static void goToBrokerReferredDetail(BuildContext context) => context.push(AppRoutes.brokerReferredDetail);

  // --------------------------------------------------------------------------
  // Owner Navigation
  // --------------------------------------------------------------------------
  static void goToOwnerHome(BuildContext context) => context.go(AppRoutes.ownerHome);
  static void goToOwnerListings(BuildContext context) => context.push(AppRoutes.ownerListings);
  static void goToOwnerBookings(BuildContext context) => context.push(AppRoutes.ownerBookings);
  static void goToOwnerProfile(BuildContext context) => context.push(AppRoutes.ownerProfile);

  // --------------------------------------------------------------------------
  // Multi-role Navigation
  // --------------------------------------------------------------------------
  static void goToMyBookings(BuildContext context) {
    final role = RoleState().currentRole;
    if (role == Role.owner) {
      context.go('${AppRoutes.ownerBookings}?tab=stays');
    } else if (role == Role.broker) {
      context.go(AppRoutes.brokerBookings);
    } else {
      context.go(AppRoutes.renterBookings);
    }
  }
  // --------------------------------------------------------------------------
  // Shared Navigation
  // --------------------------------------------------------------------------
  static void goToPropertyDetail(BuildContext context, dynamic propertyOrId) => 
      context.push(AppRoutes.propertyDetail, extra: propertyOrId);
      
  static void goToBookingDetail(BuildContext context, dynamic bookingOrId) => 
      context.push(AppRoutes.bookingDetail, extra: bookingOrId);
      
  static void goToSearch(BuildContext context) => context.push(AppRoutes.search);
  
  static void goToSearchResults(BuildContext context, {String query = '', Map<String, dynamic>? filters}) {
    context.push(AppRoutes.browse, extra: filters ?? query);
  }

  static void goToAllProperties(BuildContext context, {Map<String, dynamic>? filters}) {
    context.push(AppRoutes.allProperties, extra: filters);
  }

  static void goToMawsem(BuildContext context) => context.push(AppRoutes.mawsem);
  static void goToWallet(BuildContext context) => context.push(AppRoutes.wallet);
  static void goToNotifications(BuildContext context) => context.push(AppRoutes.notifications);
}
