import 'package:go_router/go_router.dart';

import '../owner/screens/payout_bank_screen.dart';
import '../owner/screens/withdraw_amount_screen.dart';
import '../owner/screens/withdraw_receipt_screen.dart';

import 'presentation/screens/portfolio/pages/referred_property_detail_page.dart';
import 'presentation/screens/portfolio/pages/referral_issue_page.dart';
import 'presentation/screens/portfolio/pages/refer_property_page.dart';
import 'presentation/screens/wallet/pages/broker_history_page.dart';
import 'presentation/screens/dashboard/pages/tier_dashboard_page.dart';
import 'presentation/screens/dashboard/pages/tier_upgrade_page.dart';
import 'presentation/screens/mawsem/pages/broker_mawsem_page.dart';
import 'presentation/screens/smart_lock/pages/broker_smart_lock_screen.dart';
import 'presentation/screens/bookings/pages/broker_booking_details_page.dart';
import 'presentation/screens/support/pages/broker_sos_chat_screen.dart';

final List<GoRoute> brokerGoRoutes = [
  GoRoute(path: '/broker/referred-detail', builder: (context, state) => const ReferredPropertyDetailPage()),
  GoRoute(path: '/broker/referral-issue', builder: (context, state) => const ReferralIssuePage()),
  GoRoute(path: '/broker/refer', builder: (context, state) => const ReferPropertyPage()),
  GoRoute(path: '/broker/history', builder: (context, state) => const BrokerHistoryPage()),
  GoRoute(path: '/broker/tier', builder: (context, state) => const TierDashboardPage()),
  GoRoute(path: '/broker/mawsem', builder: (context, state) => const BrokerMawsemPage()),
  GoRoute(path: '/broker/tier-upgrade', builder: (context, state) => const BrokerTierUpgradePage()),
  GoRoute(path: '/broker/sos', builder: (context, state) => const BrokerSOSChatScreen()),
  GoRoute(
    path: '/broker/booking-details',
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BrokerBookingDetailsPage(booking: args ?? {});
    },
  ),
  GoRoute(
    path: '/broker/smart-lock',
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BrokerSmartLockScreen(
        propertyName: args?['propertyName'] ?? 'Azure Beach Villa',
        bookingRef: args?['bookingRef'] ?? 'SHLY-8842',
        passcode: args?['passcode'] ?? '1248',
        checkIn: args?['checkIn'] ?? DateTime.now().subtract(const Duration(hours: 2)),
        checkOut: args?['checkOut'] ?? DateTime.now().add(const Duration(days: 3)),
        propertyLat: args?['lat'] ?? 31.02,
        propertyLng: args?['lng'] ?? 29.60,
      );
    },
  ),
  GoRoute(path: '/broker/withdraw', builder: (context, state) => const WithdrawAmountScreen()),
  GoRoute(path: '/broker/withdraw-receipt', builder: (context, state) => const WithdrawReceiptScreen()),
  GoRoute(path: '/broker/payout', builder: (context, state) => const PayoutBankScreen()),
];
