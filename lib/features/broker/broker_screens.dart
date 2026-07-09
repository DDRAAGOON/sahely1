import 'package:flutter/material.dart';
import '../owner/screens/payout_bank_screen.dart';
import '../owner/screens/withdraw_amount_screen.dart';
import '../owner/screens/withdraw_receipt_screen.dart';

import 'presentation/screens/main/pages/broker_main_screen.dart';
import 'presentation/screens/portfolio/pages/referred_property_detail_page.dart';
import 'presentation/screens/portfolio/pages/referral_issue_page.dart';
import 'presentation/screens/portfolio/pages/refer_property_page.dart';
import 'presentation/screens/wallet/pages/broker_history_page.dart';
import 'presentation/screens/dashboard/pages/tier_dashboard_page.dart';
import 'presentation/screens/dashboard/pages/tier_upgrade_page.dart';
import 'presentation/screens/smart_lock/pages/broker_smart_lock_screen.dart';
import 'presentation/screens/bookings/pages/broker_booking_details_page.dart';
import 'presentation/screens/support/pages/broker_sos_chat_screen.dart';

export 'presentation/screens/main/pages/broker_main_screen.dart';
export 'presentation/screens/portfolio/pages/referred_property_detail_page.dart';
export 'presentation/screens/portfolio/pages/referral_issue_page.dart';
export 'presentation/screens/portfolio/pages/refer_property_page.dart';
export 'presentation/screens/wallet/pages/broker_history_page.dart';
export 'presentation/screens/dashboard/pages/tier_dashboard_page.dart';
export 'presentation/screens/dashboard/pages/tier_upgrade_page.dart';
export 'presentation/screens/smart_lock/pages/broker_smart_lock_screen.dart';
export 'presentation/screens/bookings/pages/broker_booking_details_page.dart';
export 'presentation/screens/support/pages/broker_sos_chat_screen.dart';

final Map<String, WidgetBuilder> brokerRoutes = {
  // Main Hub (Tabbed)
  '/broker/home': (_) => const BrokerMainScreen(),
  
  // Sub-screens
  '/broker/referred-detail': (_) => const ReferredPropertyDetailPage(),
  '/broker/referral-issue': (_) => const ReferralIssuePage(),
  '/broker/refer': (_) => const ReferPropertyPage(),
  '/broker/history': (_) => const BrokerHistoryPage(),
  '/broker/tier': (_) => const TierDashboardPage(),
  '/broker/tier-upgrade': (_) => const BrokerTierUpgradePage(),
  '/broker/sos': (_) => const BrokerSOSChatScreen(),
  '/broker/booking-details': (ctx) {
    final args = ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>?;
    return BrokerBookingDetailsPage(booking: args ?? {});
  },
  '/broker/smart-lock': (ctx) {
    final args = ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>?;
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
  
  // Shared with Owner
  '/broker/withdraw': (_) => const WithdrawAmountScreen(),
  '/broker/withdraw-receipt': (_) => const WithdrawReceiptScreen(),
  '/broker/payout': (_) => const PayoutBankScreen(),
};
