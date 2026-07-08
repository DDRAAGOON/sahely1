import 'package:flutter/material.dart';
import '../owner/screens/payout_bank_screen.dart';
import '../owner/screens/withdraw_amount_screen.dart';
import '../owner/screens/withdraw_receipt_screen.dart';
import 'screens/broker_home_screen.dart';
import 'screens/broker_profile_screen.dart';
import 'screens/broker_dashboard_screen.dart';
import 'screens/broker_referred_screens.dart';
import 'screens/broker_portfolio_screen.dart';
import 'screens/broker_refer_screen.dart';
import 'screens/commission_wallet_screen.dart';
import 'screens/broker_history_screen.dart';
import 'screens/broker_tier_screens.dart';

export 'screens/broker_home_screen.dart';
export 'screens/broker_profile_screen.dart';
export 'screens/broker_dashboard_screen.dart';
export 'screens/broker_referred_screens.dart';
export 'screens/broker_portfolio_screen.dart';
export 'screens/broker_refer_screen.dart';
export 'screens/commission_wallet_screen.dart';
export 'screens/broker_history_screen.dart';
export 'screens/broker_tier_screens.dart';
export 'broker_nav.dart';

final Map<String, WidgetBuilder> brokerRoutes = {
  '/broker/home': (_) => const BrokerHomeScreen(),
  '/broker/profile': (_) => const BrokerProfileScreen(),
  '/broker/dashboard': (_) => const BrokerDashboardScreen(),
  '/broker/referred': (_) => const ReferredPropertiesScreen(),
  '/broker/referred-detail': (_) => const ReferredPropertyDetailScreen(),
  '/broker/portfolio': (_) => const BrokerPortfolioScreen(),
  '/broker/referral-issue': (_) => const ReferralIssueScreen(),
  '/broker/refer': (_) => const ReferPropertyScreen(),
  '/broker/wallet': (_) => const CommissionWalletScreen(),
  '/broker/history': (_) => const BrokerHistoryScreen(),
  '/broker/tier': (_) => const TierDashboardScreen(),
  '/broker/tier-upgrade': (_) => const BrokerTierUpgradeScreen(),
  '/broker/withdraw': (_) => const WithdrawAmountScreen(),
  '/broker/withdraw-receipt': (_) => const WithdrawReceiptScreen(),
  '/broker/payout': (_) => const PayoutBankScreen(),
};
