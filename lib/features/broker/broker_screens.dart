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

export 'presentation/screens/main/pages/broker_main_screen.dart';
export 'presentation/screens/portfolio/pages/referred_property_detail_page.dart';
export 'presentation/screens/portfolio/pages/referral_issue_page.dart';
export 'presentation/screens/portfolio/pages/refer_property_page.dart';
export 'presentation/screens/wallet/pages/broker_history_page.dart';
export 'presentation/screens/dashboard/pages/tier_dashboard_page.dart';
export 'presentation/screens/dashboard/pages/tier_upgrade_page.dart';

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
