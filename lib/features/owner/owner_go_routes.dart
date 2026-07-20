import 'package:go_router/go_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'screens/add_property_screen.dart';
import 'screens/listing_submitted_screen.dart';
import 'screens/owner_active_detail_screen.dart';
import 'screens/owner_ai_chat_screen.dart';
import 'screens/owner_all_trending_screen.dart';
import 'screens/owner_earnings_screen.dart';
import 'screens/owner_edit_bio_screen.dart';
import 'screens/owner_history_screen.dart';
import 'screens/owner_manage_screen.dart';
import 'screens/owner_notification_settings_screen.dart';
import 'screens/owner_past_detail_screen.dart';
import 'screens/owner_portfolio_screen.dart';
import 'screens/owner_properties_screen.dart';
import 'screens/owner_property_detail_screens.dart';
import 'screens/owner_requests_screen.dart';
import 'screens/owner_smart_lock_screen.dart';
import 'screens/owner_upcoming_detail_screen.dart';
import 'screens/payout_bank_screen.dart';
import 'screens/team_review_screen.dart';
import 'screens/withdraw_amount_screen.dart';
import 'screens/withdraw_receipt_screen.dart';

final List<GoRoute> ownerGoRoutes = [
  GoRoute(
      path: '/owner/manage',
      builder: (context, state) => const OwnerManageScreen()),
  GoRoute(
      path: '/owner/properties',
      builder: (context, state) => const OwnerPropertiesScreen()),
  GoRoute(
    path: '/owner/insights',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return OwnerPropertyInsightsScreen(property: args);
      if (args is Map<String, dynamic>)
        return OwnerPropertyInsightsScreen(property: Property.fromMap(args));
      return const OwnerPropertyInsightsScreen();
    },
  ),
  GoRoute(
      path: '/owner/edit',
      builder: (context, state) => const OwnerEditPropertyScreen()),
  GoRoute(
      path: '/owner/preview',
      builder: (context, state) => const OwnerPreviewListingScreen()),
  GoRoute(
      path: '/owner/smart-lock',
      builder: (context, state) => const OwnerSmartLockScreen()),
  GoRoute(
      path: '/owner/add-property',
      builder: (context, state) => const AddPropertyScreen()),
  GoRoute(
      path: '/owner/listing-submitted',
      builder: (context, state) => const ListingSubmittedScreen()),
  GoRoute(
      path: '/owner/team-review',
      builder: (context, state) => const TeamReviewScreen()),
  GoRoute(
      path: '/owner/all-trending',
      builder: (context, state) => const OwnerAllTrendingScreen()),
  GoRoute(
    path: '/owner/booking-upcoming',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return OwnerUpcomingDetailScreen(property: args);
      if (args is Map<String, dynamic>) {
        final prop = args['prop'];
        if (prop is Property) return OwnerUpcomingDetailScreen(property: prop);
        return OwnerUpcomingDetailScreen(property: Property.fromMap(args));
      }
      return const OwnerUpcomingDetailScreen();
    },
  ),
  GoRoute(
    path: '/owner/booking-active',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return OwnerActiveDetailScreen(property: args);
      if (args is Map<String, dynamic>) {
        final prop = args['prop'];
        if (prop is Property) return OwnerActiveDetailScreen(property: prop);
        return OwnerActiveDetailScreen(property: Property.fromMap(args));
      }
      return const OwnerActiveDetailScreen();
    },
  ),
  GoRoute(
    path: '/owner/booking-past',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return OwnerPastDetailScreen(property: args);
      if (args is Map<String, dynamic>) {
        final prop = args['prop'];
        if (prop is Property) return OwnerPastDetailScreen(property: prop);
        return OwnerPastDetailScreen(property: Property.fromMap(args));
      }
      return const OwnerPastDetailScreen();
    },
  ),
  GoRoute(
      path: '/owner/requests',
      builder: (context, state) => const OwnerRequestsScreen()),
  GoRoute(
      path: '/owner/request-detail',
      builder: (context, state) => const OwnerRequestDetailScreen()),
  GoRoute(
      path: '/owner/earnings',
      builder: (context, state) => const OwnerEarningsScreen()),
  GoRoute(
      path: '/owner/violations',
      builder: (context, state) => const ViolationsScreen()),
  GoRoute(
      path: '/owner/history',
      builder: (context, state) =>
          OwnerHistoryScreen(period: state.extra as String?)),
  GoRoute(
      path: '/owner/portfolio',
      builder: (context, state) => const PortfolioInsightsScreen()),
  GoRoute(
      path: '/owner/ai-chat',
      builder: (context, state) => const OwnerAiChatScreen()),
  GoRoute(
      path: '/owner/withdraw',
      builder: (context, state) => const WithdrawAmountScreen()),
  GoRoute(
      path: '/owner/withdraw-receipt',
      builder: (context, state) => const WithdrawReceiptScreen()),
  GoRoute(
      path: '/owner/payout',
      builder: (context, state) => const PayoutBankScreen()),
  GoRoute(
      path: '/owner/notifications',
      builder: (context, state) => const OwnerNotificationSettingsScreen()),
  GoRoute(
      path: '/owner/edit-bio',
      builder: (context, state) => const OwnerEditBioScreen()),
];
