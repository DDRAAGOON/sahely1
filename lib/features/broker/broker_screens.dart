import 'package:flutter/material.dart';
import 'broker_main_screen.dart';
import 'broker_screens_stubs.dart';

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
  
  // Shared with Owner
  '/broker/withdraw': (_) => const WithdrawAmountScreen(),
  '/broker/withdraw-receipt': (_) => const WithdrawReceiptScreen(),
  '/broker/payout': (_) => const PayoutBankScreen(),
};
