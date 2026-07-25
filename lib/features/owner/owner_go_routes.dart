import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/features/owner/screens/owner_portfolio_screen.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/screens/active_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/upcoming_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/past_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/notification_settings_screen.dart';

import 'package:sahely/features/owner/screens/add_property_screen.dart';
import 'package:sahely/features/owner/screens/listing_submitted_screen.dart';
import 'package:sahely/features/owner/screens/owner_ai_chat_screen.dart';
import 'package:sahely/features/owner/screens/owner_all_trending_screen.dart';
import 'package:sahely/features/owner/screens/owner_earnings_screen.dart';
import 'package:sahely/features/owner/screens/owner_edit_bio_screen.dart';
import 'package:sahely/features/owner/screens/owner_history_screen.dart';
import 'package:sahely/features/owner/screens/dispute_violation_screen.dart';
import 'package:sahely/features/owner/screens/violation_report_screen.dart';
import 'package:sahely/features/owner/screens/owner_manage_screen.dart';
import 'package:sahely/features/owner/screens/owner_properties_screen.dart';
import 'package:sahely/features/owner/screens/owner_property_detail_screens.dart';
import 'package:sahely/features/owner/screens/owner_requests_screen.dart';
import 'package:sahely/features/owner/screens/owner_smart_lock_screen.dart';
import 'package:sahely/features/owner/screens/payout_bank_screen.dart';
import 'package:sahely/features/owner/screens/team_review_screen.dart';
import 'package:sahely/features/owner/screens/withdraw_amount_screen.dart';
import 'package:sahely/features/owner/screens/withdraw_receipt_screen.dart';

final List<GoRoute> ownerGoRoutes = [
  GoRoute(
      path: AppRoutes.ownerManage,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerManageScreen()),
  GoRoute(
      path: AppRoutes.ownerProperties,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerPropertiesScreen()),
  GoRoute(
    path: '/owner/insights',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return OwnerPropertyInsightsScreen(property: args);
      if (args is Map<String, dynamic>) {
        return OwnerPropertyInsightsScreen(property: Property.fromMap(args));
      }
      return const OwnerPropertyInsightsScreen();
    },
  ),
  GoRoute(
      path: '/owner/edit',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerEditPropertyScreen()),
  GoRoute(
      path: '/owner/preview',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerPreviewListingScreen()),
  GoRoute(
      path: '/owner/smart-lock',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerSmartLockScreen()),
  GoRoute(
      path: '/owner/listings/new',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AddPropertyScreen()),
  GoRoute(
      path: '/owner/listing-submitted',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ListingSubmittedScreen()),
  GoRoute(
      path: '/owner/team-review',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const TeamReviewScreen()),
  GoRoute(
      path: AppRoutes.ownerAllTrending,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerAllTrendingScreen()),
  GoRoute(
    path: '/owner/booking-upcoming',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return UpcomingBookingDetailScreen(
            property: args, role: UpcomingBookingRole.owner);
      }
      if (args is Map<String, dynamic>) {
        final prop = args['prop'];
        if (prop is Property) {
          return UpcomingBookingDetailScreen(
              property: prop,
              bookingData: args,
              role: UpcomingBookingRole.owner);
        }
        return UpcomingBookingDetailScreen(
            property: Property.fromMap(args),
            bookingData: args,
            role: UpcomingBookingRole.owner);
      }
      return const UpcomingBookingDetailScreen(role: UpcomingBookingRole.owner);
    },
  ),
  GoRoute(
    path: '/owner/booking-active',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return ActiveBookingDetailScreen(
            property: args, role: ActiveBookingRole.owner);
      }
      if (args is Map<String, dynamic>) {
        final prop = args['prop'];
        if (prop is Property) {
          return ActiveBookingDetailScreen(
              property: prop, bookingData: args, role: ActiveBookingRole.owner);
        }
        return ActiveBookingDetailScreen(
            property: Property.fromMap(args),
            bookingData: args,
            role: ActiveBookingRole.owner);
      }
      return const ActiveBookingDetailScreen(role: ActiveBookingRole.owner);
    },
  ),
  GoRoute(
    path: '/owner/booking-past',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return PastBookingDetailScreen(
            property: args, role: PastBookingRole.owner);
      }
      if (args is Map<String, dynamic>) {
        final prop = args['prop'];
        if (prop is Property) {
          return PastBookingDetailScreen(
              property: prop, bookingData: args, role: PastBookingRole.owner);
        }
        return PastBookingDetailScreen(
            property: Property.fromMap(args),
            bookingData: args,
            role: PastBookingRole.owner);
      }
      return const PastBookingDetailScreen(role: PastBookingRole.owner);
    },
  ),
  GoRoute(
      path: '/owner/requests',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerRequestsScreen()),
  GoRoute(
      path: '/owner/request-detail',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerRequestDetailScreen()),
  GoRoute(
      path: AppRoutes.ownerEarnings,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerEarningsScreen()),
  GoRoute(
      path: '/owner/violations',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ViolationsScreen()),
  GoRoute(
      path: '/owner/dispute',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const DisputeViolationScreen()),
  GoRoute(
      path: '/owner/violation-report',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ViolationReportScreen()),
  GoRoute(
      path: '/owner/history',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          OwnerHistoryScreen(period: state.extra as String?)),
  GoRoute(
      path: '/owner/portfolio',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PortfolioInsightsScreen()),
  GoRoute(
      path: '/owner/ai-chat',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerAiChatScreen()),
  GoRoute(
      path: AppRoutes.ownerWithdraw,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const WithdrawAmountScreen()),
  GoRoute(
      path: AppRoutes.ownerWithdrawReceipt,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const WithdrawReceiptScreen()),
  GoRoute(
      path: AppRoutes.ownerPayout,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PayoutBankScreen()),
  GoRoute(
      path: '/owner/notifications',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          const NotificationSettingsScreen(role: NotificationRole.owner)),
  GoRoute(
      path: '/owner/edit-bio',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerEditBioScreen()),
];
