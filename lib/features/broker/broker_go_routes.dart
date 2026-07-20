import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_routes.dart';

import '../owner/screens/payout_bank_screen.dart';
import '../owner/screens/withdraw_amount_screen.dart';
import '../owner/screens/withdraw_receipt_screen.dart';
import 'presentation/screens/bookings/pages/broker_booking_details_page.dart';
import 'presentation/screens/dashboard/pages/tier_dashboard_page.dart';
import 'presentation/screens/dashboard/pages/tier_upgrade_page.dart';
import 'presentation/screens/mawsem/pages/broker_mawsem_page.dart';
import 'presentation/screens/portfolio/pages/refer_property_page.dart';
import 'presentation/screens/portfolio/pages/referral_issue_page.dart';
import 'presentation/screens/portfolio/pages/referred_property_detail_page.dart';
import 'presentation/screens/smart_lock/pages/broker_smart_lock_screen.dart';
import 'presentation/screens/support/pages/broker_sos_chat_screen.dart';
import 'presentation/screens/wallet/pages/broker_history_page.dart';

final List<GoRoute> brokerGoRoutes = [
  GoRoute(
      path: AppRoutes.brokerReferredDetail,
      builder: (context, state) => const ReferredPropertyDetailPage()),
  GoRoute(
      path: AppRoutes.brokerReferralIssue,
      builder: (context, state) => const ReferralIssuePage()),
  GoRoute(
      path: AppRoutes.brokerRefer,
      builder: (context, state) => const ReferPropertyPage()),
  GoRoute(
      path: AppRoutes.brokerHistory,
      builder: (context, state) => const BrokerHistoryPage()),
  GoRoute(
      path: AppRoutes.brokerTier,
      builder: (context, state) => const TierDashboardPage()),
  GoRoute(
      path: AppRoutes.brokerMawsem,
      builder: (context, state) => const BrokerMawsemPage()),
  GoRoute(
      path: AppRoutes.brokerTierUpgrade,
      builder: (context, state) => const BrokerTierUpgradePage()),
  GoRoute(
      path: AppRoutes.brokerSos,
      builder: (context, state) => const BrokerSOSChatScreen()),
  GoRoute(
    path: AppRoutes.brokerBookingDetails,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BrokerBookingDetailsPage(booking: args ?? {});
    },
  ),
  GoRoute(
    path: AppRoutes.brokerSmartLock,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BrokerSmartLockScreen(
        propertyName: args?['propertyName'] ?? 'Azure Beach Villa',
        bookingRef: args?['bookingRef'] ?? 'SHLY-8842',
        passcode: args?['passcode'] ?? '1248',
        checkIn: args?['checkIn'] ??
            DateTime.now().subtract(const Duration(hours: 2)),
        checkOut:
            args?['checkOut'] ?? DateTime.now().add(const Duration(days: 3)),
        propertyLat: args?['lat'] ?? 31.02,
        propertyLng: args?['lng'] ?? 29.60,
      );
    },
  ),
  GoRoute(
      path: AppRoutes.brokerWithdraw,
      builder: (context, state) => const WithdrawAmountScreen()),
  GoRoute(
      path: AppRoutes.brokerWithdrawReceipt,
      builder: (context, state) => const WithdrawReceiptScreen()),
  GoRoute(
      path: AppRoutes.brokerPayout,
      builder: (context, state) => const PayoutBankScreen()),
];
