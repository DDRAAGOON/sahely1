import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/data/models.dart';

class AppNavigation {
  AppNavigation._();

  static Future<T?> push<T>(BuildContext context, String path, {Object? extra}) => context.push<T>(path, extra: extra);
  static void go(BuildContext context, String path, {Object? extra}) => context.go(path, extra: extra);
  static Future<T?> safePush<T>(BuildContext context, String path, {Object? extra}) => context.push<T>(path, extra: extra);
  static void safeGo(BuildContext context, String path, {Object? extra}) => context.go(path, extra: extra);

  // Auth
  static void goToSplash(BuildContext context) => context.go(AppRoutes.splash);
  static void goToWelcome(BuildContext context) => context.push(AppRoutes.welcome);
  static void goToSignIn(BuildContext context, {String? from}) => 
      context.push(from != null ? '${AppRoutes.signIn}?from=$from' : AppRoutes.signIn);
  static void goToRegister(BuildContext context, {Object? extra}) => context.push(AppRoutes.createAccount, extra: extra);
  static void goToForgotPassword(BuildContext context) => context.push(AppRoutes.forgotPassword);
  static void goToOnboarding(BuildContext context) => context.push(AppRoutes.onboarding);
  static void goToRoleSelection(BuildContext context) => context.push(AppRoutes.roleSelection);
  static void goToResetOtp(BuildContext context, {Object? extra}) => context.push(AppRoutes.resetOtp, extra: extra);
  static void goToPasswordUpdated(BuildContext context) => context.push(AppRoutes.passwordUpdated);
  static void goToFacialScan(BuildContext context, {Object? extra}) => context.push(AppRoutes.facialScan, extra: extra);

  // Verification
  static void goToVerifyGate(BuildContext context) => context.push(AppRoutes.verifyGate);
  static void goToVerifyEmail(BuildContext context, {Object? extra}) => context.push(AppRoutes.verifyEmail, extra: extra);
  static void goToVerifyPhone(BuildContext context, {Object? extra}) => context.push(AppRoutes.verifyPhone, extra: extra);
  static void goToIdVerification(BuildContext context, {Object? extra}) => context.push(AppRoutes.idVerification, extra: extra);

  // Renter
  static void goToRenterHome(BuildContext context) => context.go(AppRoutes.renterHome);
  static void goToRenterWishlist(BuildContext context) => context.push(AppRoutes.renterWishlist);
  static void goToRenterBookings(BuildContext context) => context.push(AppRoutes.renterBookings);
  static void goToRenterServices(BuildContext context) => context.push(AppRoutes.renterServices);
  static void goToRenterProfile(BuildContext context) => context.push(AppRoutes.renterProfile);

  // Broker
  static void goToBrokerHome(BuildContext context) => context.go(AppRoutes.brokerHome);
  static void goToBrokerBookings(BuildContext context) => context.push(AppRoutes.brokerBookings);
  static void goToBrokerDashboard(BuildContext context) => context.push(AppRoutes.brokerDashboard);
  static void goToBrokerWallet(BuildContext context) => context.push(AppRoutes.brokerWallet);
  static void goToBrokerPortfolio(BuildContext context) => context.push(AppRoutes.brokerPortfolio); 
  static void goToBrokerRefer(BuildContext context) => context.push(AppRoutes.brokerRefer);
  static void goToBrokerTier(BuildContext context) => context.push(AppRoutes.brokerTier);
  static void goToBrokerTierUpgrade(BuildContext context) => context.push(AppRoutes.brokerTierUpgrade);
  static void goToBrokerHistory(BuildContext context) => context.push(AppRoutes.brokerHistory);
  static void goToBrokerWithdraw(BuildContext context) => context.push(AppRoutes.brokerWithdraw);
  static void goToBrokerWithdrawReceipt(BuildContext context) => context.push(AppRoutes.brokerWithdrawReceipt);
  static void goToBrokerReferredDetail(BuildContext context) => context.push(AppRoutes.brokerReferredDetail);
  static void goToBrokerReferralIssue(BuildContext context) => context.push(AppRoutes.brokerReferralIssue);
  static void goToBrokerSos(BuildContext context, {Object? extra}) => context.push(AppRoutes.brokerSos, extra: extra);
  static void goToBrokerSmartLock(BuildContext context, {Object? extra}) => context.push(AppRoutes.brokerSmartLock, extra: extra);
  static void goToBrokerPayout(BuildContext context) => context.push(AppRoutes.brokerPayout);

  // Owner
  static void goToOwnerHome(BuildContext context) => context.go(AppRoutes.ownerHome);
  static void goToOwnerListings(BuildContext context) => context.push(AppRoutes.ownerListings);
  static void goToOwnerBookings(BuildContext context) => context.push(AppRoutes.ownerBookings);
  static void goToOwnerProfile(BuildContext context) => context.push(AppRoutes.ownerProfile);
  static void goToOwnerManage(BuildContext context) => context.push(AppRoutes.ownerManage);
  static void goToOwnerInsights(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerInsights, extra: extra);
  static void goToOwnerEdit(BuildContext context) => context.push(AppRoutes.ownerEdit);
  static void goToOwnerPreview(BuildContext context) => context.push(AppRoutes.ownerPreview);
  static void goToOwnerSmartLock(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerSmartLock, extra: extra);
  static void goToOwnerHistory(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerHistory, extra: extra);
  static void goToOwnerPortfolio(BuildContext context) => context.push(AppRoutes.ownerPortfolio);
  static void goToOwnerAiChat(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerAiChat, extra: extra);
  static void goToOwnerNotifications(BuildContext context) => context.push(AppRoutes.ownerNotifications);
  static void goToOwnerEditBio(BuildContext context) => context.push(AppRoutes.ownerEditBio);
  static void goToOwnerEarnings(BuildContext context) => context.push(AppRoutes.ownerEarnings);
  static void goToOwnerViolations(BuildContext context) => context.push(AppRoutes.ownerViolations);
  static void goToOwnerViolationReport(BuildContext context) => context.push(AppRoutes.ownerViolationReport);
  static void goToOwnerDispute(BuildContext context) => context.push(AppRoutes.ownerDispute);
  static void goToOwnerListingSubmitted(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerListingSubmitted, extra: extra);
  static void goToOwnerRateGuest(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerRateGuest, extra: extra);
  static void goToOwnerRequests(BuildContext context) => context.push(AppRoutes.ownerRequests);
  static void goToOwnerRequestDetail(BuildContext context, {Object? extra}) => context.push(AppRoutes.ownerRequestDetail, extra: extra);
  static void goToOwnerWithdraw(BuildContext context) => context.push(AppRoutes.ownerWithdraw); 
  static void goToOwnerWithdrawReceipt(BuildContext context) => context.push(AppRoutes.ownerWithdrawReceipt);
  static void goToOwnerAllTrending(BuildContext context) => context.push(AppRoutes.ownerAllTrending);
  static void goToOwnerProperties(BuildContext context) => context.push(AppRoutes.ownerProperties);
  static void goToOwnerPayout(BuildContext context) => context.push(AppRoutes.ownerPayout);
  static void goToOwnerAddProperty(BuildContext context) => context.push(AppRoutes.ownerListingNew);
  static void goToSosOwner(BuildContext context) => context.push(AppRoutes.sosOwner);

  // Multi-role
  static void goToMyBookings(BuildContext context) {
    final role = RoleState().currentRole;
    if (role == Role.owner) {
      safeGo(context, '/owner/bookings?tab=stays');
    } else if (role == Role.broker) {
      safeGo(context, '/broker/bookings');
    } else {
      safeGo(context, '/renter/bookings');
    }
  }

  // Shared
  static Future<T?> goToPropertyDetail<T>(BuildContext context, {Object? extra}) => context.push<T>(AppRoutes.propertyDetail, extra: extra);
  static Future<T?> goToBookingDetail<T>(BuildContext context, {Object? extra}) => context.push<T>(AppRoutes.bookingDetail, extra: extra);
  static void goToSearch(BuildContext context) => context.push(AppRoutes.search);
  static void goToSearchResults(BuildContext context, {String query = '', Map<String, dynamic>? filters, Object? extra}) => context.push(AppRoutes.browse, extra: extra ?? filters ?? query);
  static void goToAllProperties(BuildContext context, {Map<String, dynamic>? filters, Object? extra}) => context.push(AppRoutes.allProperties, extra: extra ?? filters);
  static void goToMawsem(BuildContext context) => context.push(AppRoutes.mawsem);
  static void goToWallet(BuildContext context) => context.push(AppRoutes.wallet);
  static void goToNotifications(BuildContext context) => context.push(AppRoutes.notifications);
  static void goToBrowse(BuildContext context, {Object? extra}) => context.push(AppRoutes.browse, extra: extra);
  static Future<T?> goToFilters<T>(BuildContext context) => context.push<T>(AppRoutes.filters);
  static void goToAiChat(BuildContext context, {Object? extra}) => context.push(AppRoutes.aiChat, extra: extra);
  static void goToPropertyReviews(BuildContext context, {Object? extra}) => context.push(AppRoutes.propertyReviews, extra: extra);
  static void goToBooking(BuildContext context, {Object? extra}) => context.push(AppRoutes.booking, extra: extra);
  static void goToBookingConfirmed(BuildContext context, {Object? extra}) => context.push(AppRoutes.bookingConfirmed, extra: extra);
  static void goToSmartLock(BuildContext context, {Object? extra}) => context.push(AppRoutes.smartLock, extra: extra);
  static void goToSos(BuildContext context, {Object? extra}) => context.push(AppRoutes.sos, extra: extra);
  static void goToWriteReview(BuildContext context, {Object? extra}) => context.push(AppRoutes.writeReview, extra: extra);
  static void goToCollection(BuildContext context, {Object? extra}) => context.push(AppRoutes.collection, extra: extra);
  static void goToCollectionChat(BuildContext context) => context.push(AppRoutes.collectionChat);
  static void goToCompare(BuildContext context) => context.push(AppRoutes.compare);
  static void goToShareCollection(BuildContext context) => context.push(AppRoutes.shareCollection);
  static void goToShareEarn(BuildContext context) => context.push(AppRoutes.shareEarn);
  static void goToMawsemLevel(BuildContext context) => context.push(AppRoutes.mawsemLevel);
  static void goToStarsEarned(BuildContext context) => context.push(AppRoutes.starsEarned);
  static void goToStarNudges(BuildContext context) => context.push(AppRoutes.starNudges);
  static void goToLevelUp(BuildContext context) => context.push(AppRoutes.levelUp);
  static void goToProperty(BuildContext context, {Object? extra}) => context.push(AppRoutes.propertyDetail, extra: extra);
  static void goToLanguage(BuildContext context) => context.push(AppRoutes.language);
  static void goToCurrency(BuildContext context) => context.push(AppRoutes.currency);
  static void goToAddCard(BuildContext context) => context.push(AppRoutes.addCard);
  static void goToChangePassword(BuildContext context) => context.push(AppRoutes.changePassword);
  static void goToNotificationsSettings(BuildContext context) => context.push(AppRoutes.notificationsSettings);
  static void goToEditProfile(BuildContext context) => context.push(AppRoutes.editProfile);
  static void goToMyReviews(BuildContext context) => context.push(AppRoutes.myReviews);

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
