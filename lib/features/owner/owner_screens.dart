import 'package:flutter/material.dart';
import 'screens/owner_home_screen.dart';
import 'screens/owner_profile_screen.dart';
import 'screens/owner_manage_screen.dart';
import 'screens/owner_properties_screen.dart';
import 'screens/add_property_screen.dart';
import 'screens/listing_submitted_screen.dart';
import 'screens/team_review_screen.dart';
import 'screens/owner_all_trending_screen.dart';
import 'screens/owner_bookings_screen.dart';
import 'screens/owner_requests_screen.dart';
import 'screens/owner_earnings_screen.dart';
import 'screens/withdraw_amount_screen.dart';
import 'screens/withdraw_receipt_screen.dart';
import 'screens/payout_bank_screen.dart';
import 'screens/owner_property_detail_screens.dart';
import 'screens/owner_smart_lock_screen.dart';
import 'screens/owner_history_screen.dart';
import 'screens/owner_portfolio_screen.dart';
import 'screens/owner_ai_chat_screen.dart';

import 'screens/owner_upcoming_detail_screen.dart';
import 'screens/owner_active_detail_screen.dart';
import 'screens/owner_past_detail_screen.dart';

export 'screens/owner_home_screen.dart';
export 'screens/owner_profile_screen.dart';
export 'screens/owner_manage_screen.dart';
export 'screens/owner_properties_screen.dart';
export 'screens/add_property_screen.dart';
export 'screens/listing_submitted_screen.dart';
export 'screens/team_review_screen.dart';
export 'screens/owner_all_trending_screen.dart';
export 'screens/owner_bookings_screen.dart';
export 'screens/owner_requests_screen.dart';
export 'screens/owner_property_detail_screens.dart';
export 'screens/owner_smart_lock_screen.dart';
export 'screens/owner_history_screen.dart';
export 'screens/owner_portfolio_screen.dart';
export 'screens/owner_ai_chat_screen.dart';

final Map<String, WidgetBuilder> ownerRoutes = {
  '/owner/home': (_) => const OwnerHomeScreen(),
  '/owner/profile': (_) => const OwnerProfileScreen(),
  '/owner/manage': (_) => const OwnerManageScreen(),
  '/owner/properties': (_) => const OwnerPropertiesScreen(),
  '/owner/insights': (_) => const OwnerPropertyInsightsScreen(),
  '/owner/edit': (_) => const OwnerEditPropertyScreen(),
  '/owner/preview': (_) => const OwnerPreviewListingScreen(),
  '/owner/smart-lock': (_) => const OwnerSmartLockScreen(),
  '/owner/add-property': (_) => const AddPropertyScreen(),
  '/owner/listing-submitted': (_) => const ListingSubmittedScreen(),
  '/owner/team-review': (_) => const TeamReviewScreen(),
  '/owner/all-trending': (_) => const OwnerAllTrendingScreen(),
  '/owner/bookings': (_) => const OwnerBookingsScreen(),
  '/owner/booking-upcoming': (_) => const OwnerUpcomingDetailScreen(),
  '/owner/booking-active': (_) => const OwnerActiveDetailScreen(),
  '/owner/booking-past': (_) => const OwnerPastDetailScreen(),
  '/owner/requests': (_) => const OwnerRequestsScreen(),
  '/owner/request-detail': (_) => const OwnerRequestDetailScreen(),
  '/owner/earnings': (_) => const OwnerEarningsScreen(),
  '/owner/violations': (_) => const ViolationsScreen(),
  '/owner/history': (_) => const OwnerHistoryScreen(),
  '/owner/portfolio': (_) => const PortfolioInsightsScreen(),
  '/owner/ai-chat': (_) => const OwnerAiChatScreen(),
  '/owner/withdraw': (_) => const WithdrawAmountScreen(),
  '/owner/withdraw-receipt': (_) => const WithdrawReceiptScreen(),
  '/owner/payout': (_) => const PayoutBankScreen(),
};
