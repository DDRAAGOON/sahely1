import 'package:flutter/material.dart';
import 'package:sahely/features/owner/properties/presentation/pages/add_property_screen.dart';
import 'package:sahely/features/owner/properties/presentation/pages/listing_submitted_screen.dart';
import 'owner_screens_stubs.dart';
import 'owner_main_screen.dart';

final Map<String, WidgetBuilder> ownerRoutes = {
  '/owner/home': (_) => const OwnerMainScreen(),
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
  '/owner/notifications': (_) => const OwnerNotificationSettingsScreen(),
  '/owner/edit-bio': (_) => const OwnerEditBioScreen(),
};
