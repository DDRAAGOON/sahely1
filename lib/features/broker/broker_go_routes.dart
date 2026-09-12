import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/navigation/app_routes.dart';

import 'package:sahely/features/shared/screens/sos_screen.dart' as sos;
import 'package:sahely/features/shared/screens/active_booking_detail_screen.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/owner/screens/payout_bank_screen.dart';
import 'package:sahely/features/owner/screens/withdraw_amount_screen.dart';
import 'package:sahely/features/owner/screens/withdraw_receipt_screen.dart';
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/broker_dashboard_page.dart';
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/tier_dashboard_page.dart';
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/tier_upgrade_page.dart';
import 'package:sahely/features/broker/presentation/screens/mawsem/pages/broker_mawsem_page.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/broker_portfolio_page.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/refer_property_page.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/referral_issue_page.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/referred_property_detail_page.dart';
import 'package:sahely/features/broker/presentation/screens/smart_lock/pages/broker_smart_lock_screen.dart';
import 'package:sahely/features/broker/presentation/screens/wallet/pages/broker_history_page.dart';
import 'package:sahely/features/broker/presentation/screens/wallet/pages/broker_wallet_page.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/pages/broker_collection_inside_page.dart';

// NOTE: Global Broker Routes (not nested in Tabs)
// Tab-specific routes like Dashboard, Portfolio, Wallet are in AppRouter.

final List<GoRoute> brokerGoRoutes = [
  GoRoute(
      path: AppRoutes.brokerDashboard,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BrokerDashboardPage()),
  GoRoute(
      path: AppRoutes.brokerPortfolio,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BrokerPortfolioPage()),
  GoRoute(
      path: AppRoutes.brokerWallet,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BrokerWalletPage()),
  GoRoute(
      path: AppRoutes.brokerReferredDetail,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => ReferredPropertyDetailPage(
          property: state.extra is Property ? state.extra as Property : null)),
  GoRoute(
      path: AppRoutes.brokerReferralIssue,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ReferralIssuePage()),
  GoRoute(
      path: '/broker/collection',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return BrokerCollectionInsidePage(
          collectionId: args['collectionId'],
          collectionName: args['collectionName'],
          propertyCount: args['propertyCount'],
          sharedWithCount: args['sharedWithCount'],
          memberNames: args['memberNames'],
        );
      }),
  GoRoute(
      path: AppRoutes.brokerRefer,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ReferPropertyPage()),
  GoRoute(
      path: AppRoutes.brokerHistory,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BrokerHistoryPage()),
  GoRoute(
      path: AppRoutes.brokerTier,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const TierDashboardPage()),
  GoRoute(
      path: AppRoutes.brokerMawsem,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BrokerMawsemPage()),
  GoRoute(
      path: AppRoutes.brokerTierUpgrade,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BrokerTierUpgradePage()),
  GoRoute(
      path: AppRoutes.brokerSos,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          const sos.SosScreen(role: sos.UserRole.broker)),
  GoRoute(
    path: AppRoutes.brokerBookingDetails,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>? ?? {};
      final prop = args['prop'];
      return ActiveBookingDetailScreen(
        property: prop is Property ? prop : Property.fromMap(args),
        bookingData: args,
        role: ActiveBookingRole.broker,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.brokerSmartLock,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BrokerSmartLockScreen(
        propertyName: args?['propertyName'] ?? '',
        bookingRef: args?['bookingRef'] ?? '',
        bookingId: args?['bookingId'] ?? '',
        checkIn: args?['checkIn'] ?? DateTime.now(),
        checkOut:
            args?['checkOut'] ?? DateTime.now().add(const Duration(days: 1)),
        propertyLat: args?['propertyLat'] ?? args?['lat'] ?? 0.0,
        propertyLng: args?['propertyLng'] ?? args?['lng'] ?? 0.0,
      );
    },
  ),
  GoRoute(
      path: AppRoutes.brokerWithdraw,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const WithdrawAmountScreen()),
  GoRoute(
      path: AppRoutes.brokerWithdrawReceipt,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const WithdrawReceiptScreen()),
  GoRoute(
      path: AppRoutes.brokerPayout,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PayoutBankScreen()),
];
