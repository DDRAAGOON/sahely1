import 'package:flutter/material.dart';
import 'broker_main_screen.dart';
import 'dashboard/presentation/pages/broker_dashboard_page.dart';
import 'clients/presentation/pages/broker_clients_page.dart';
import 'commissions/presentation/pages/broker_commissions_page.dart';
import 'referrals/presentation/pages/broker_referrals_page.dart';

export 'broker_main_screen.dart';
export 'dashboard/presentation/pages/broker_dashboard_page.dart';
export 'clients/presentation/pages/broker_clients_page.dart';
export 'commissions/presentation/pages/broker_commissions_page.dart';
export 'referrals/presentation/pages/broker_referrals_page.dart';

final Map<String, WidgetBuilder> brokerRoutes = {
  // Main Hub (Tabbed)
  '/broker/home': (_) => const BrokerMainScreen(),
  '/broker/dashboard': (_) => const BrokerDashboardPage(),
  '/broker/clients': (_) => const BrokerClientsPage(),
  '/broker/commissions': (_) => const BrokerCommissionsPage(),
  '/broker/referrals': (_) => const BrokerReferralsPage(),
  
  // Sub-screens (Placeholders)
  // '/broker/referred-detail': (_) => const ReferredPropertyDetailPage(),
  // '/broker/referral-issue': (_) => const ReferralIssuePage(),
  // '/broker/refer': (_) => const ReferPropertyPage(),
  // '/broker/history': (_) => const BrokerHistoryPage(),
  // '/broker/tier': (_) => const TierDashboardPage(),
  // '/broker/tier-upgrade': (_) => const BrokerTierUpgradePage(),
  // '/broker/withdraw': (_) => const WithdrawAmountScreen(),
  // '/broker/withdraw-receipt': (_) => const WithdrawReceiptScreen(),
  // '/broker/payout': (_) => const PayoutBankScreen(),
};
