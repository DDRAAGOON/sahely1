import 'package:flutter/material.dart';
import 'owner_main_screen.dart';
import 'dashboard/presentation/pages/owner_dashboard_page.dart';
import 'properties/presentation/pages/owner_properties_page.dart';
import 'properties/presentation/pages/add_property_screen.dart';
import 'properties/presentation/pages/listing_submitted_screen.dart';
import 'bookings/presentation/pages/owner_bookings_page.dart';
import 'earnings/presentation/pages/owner_earnings_page.dart';
import '../shared/profile/presentation/pages/profile_page.dart';

// Exports
export 'owner_main_screen.dart';
export 'dashboard/presentation/pages/owner_dashboard_page.dart';
export 'properties/presentation/pages/owner_properties_page.dart';
export 'properties/presentation/pages/add_property_screen.dart';
export 'properties/presentation/pages/listing_submitted_screen.dart';
export 'bookings/presentation/pages/owner_bookings_page.dart';
export 'earnings/presentation/pages/owner_earnings_page.dart';

final Map<String, WidgetBuilder> ownerRoutes = {
  '/owner/home': (_) => const OwnerMainScreen(),
  '/owner/dashboard': (_) => const OwnerDashboardPage(),
  '/owner/profile': (_) => const ProfilePage(),
  '/owner/properties': (_) => const OwnerPropertiesPage(),
  '/owner/add-property': (_) => const AddPropertyScreen(),
  '/owner/listing-submitted': (_) => const ListingSubmittedScreen(),
  '/owner/bookings': (_) => const OwnerBookingsPage(),
  '/owner/earnings': (_) => const OwnerEarningsPage(),
  
  // The following routes are placeholders as the screens are not yet implemented
  // or use the main owner screen as a fallback.
  // '/owner/manage': (_) => const OwnerManageScreen(),
  // '/owner/insights': (_) => const OwnerPropertyInsightsScreen(),
  // '/owner/edit': (_) => const OwnerEditPropertyScreen(),
  // '/owner/preview': (_) => const OwnerPreviewListingScreen(),
  // '/owner/smart-lock': (_) => const OwnerSmartLockScreen(),
  // '/owner/team-review': (_) => const TeamReviewScreen(),
  // '/owner/all-trending': (_) => const OwnerAllTrendingScreen(),
  // '/owner/booking-upcoming': (_) => const OwnerUpcomingDetailScreen(),
  // '/owner/booking-active': (_) => const OwnerActiveDetailScreen(),
  // '/owner/booking-past': (_) => const OwnerPastDetailScreen(),
  // '/owner/requests': (_) => const OwnerRequestsScreen(),
  // '/owner/request-detail': (_) => const OwnerRequestDetailScreen(),
  // '/owner/violations': (_) => const ViolationsScreen(),
  // '/owner/history': (_) => const OwnerHistoryScreen(),
  // '/owner/portfolio': (_) => const PortfolioInsightsScreen(),
  // '/owner/ai-chat': (_) => const OwnerAiChatScreen(),
  // '/owner/withdraw': (_) => const WithdrawAmountScreen(),
  // '/owner/withdraw-receipt': (_) => const WithdrawReceiptScreen(),
  // '/owner/payout': (_) => const PayoutBankScreen(),
  // '/owner/notifications': (_) => const OwnerNotificationSettingsScreen(),
  // '/owner/edit-bio': (_) => const OwnerEditBioScreen(),
};
