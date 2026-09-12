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
import 'package:sahely/features/owner/screens/owner_earnings_screen.dart';
import 'package:sahely/features/owner/screens/owner_edit_bio_screen.dart';
import 'package:sahely/features/owner/screens/owner_history_screen.dart';
import 'package:sahely/features/owner/screens/violation_report_screen.dart';
import 'package:sahely/features/owner/screens/owner_manage_screen.dart';
import 'package:sahely/features/owner/screens/owner_properties_screen.dart';
import 'package:sahely/features/owner/screens/owner_property_detail_screens.dart';
import 'package:sahely/features/owner/screens/owner_rate_guest_screen.dart';
import 'package:sahely/features/owner/screens/owner_requests_screen.dart';
import 'package:sahely/features/owner/screens/owner_smart_lock_screen.dart';
import 'package:sahely/features/owner/screens/payout_bank_screen.dart';
import 'package:sahely/features/owner/screens/team_review_screen.dart';
import 'package:sahely/features/owner/screens/withdraw_amount_screen.dart';
import 'package:sahely/features/owner/screens/withdraw_receipt_screen.dart';

import '../../core/navigation/route_transitions.dart';
import '../shared/screens/all_properties_screen.dart';

final List<GoRoute> ownerGoRoutes = [
  GoRoute(
      path: AppRoutes.ownerManage,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerManageScreen()),
  GoRoute(
      path: AppRoutes.ownerProperties,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => OwnerPropertiesScreen(
            initialFilter: state.extra as String?,
          )),
  GoRoute(
    path: AppRoutes.ownerInsights,
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
      path: AppRoutes.ownerEdit,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => OwnerEditPropertyScreen(
          property: state.extra is Property ? state.extra as Property : null)),
  GoRoute(
      path: AppRoutes.ownerPreview,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => OwnerPreviewListingScreen(
          property: state.extra is Property ? state.extra as Property : null)),
  GoRoute(
      path: AppRoutes.ownerSmartLock,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerSmartLockScreen()),
  GoRoute(
      path: AppRoutes.ownerListingNew,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AddPropertyScreen()),
  GoRoute(
      path: AppRoutes.ownerListingSubmitted,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ListingSubmittedScreen()),
  GoRoute(
      path: AppRoutes.ownerTeamReview,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const TeamReviewScreen()),
  GoRoute(
      path: AppRoutes.ownerAllTrending,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AllPropertiesScreen()),
  GoRoute(
    path: AppRoutes.ownerBookingUpcoming,
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
    path: AppRoutes.ownerBookingActive,
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
    path: AppRoutes.ownerBookingPast,
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
      path: AppRoutes.ownerRequests,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerRequestsScreen()),
  GoRoute(
      path: AppRoutes.ownerRequestDetail,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => fadeSlideTransition(
            key: state.pageKey,
            child: OwnerRequestDetailScreen(
              data: state.extra as Map<String, dynamic>?,
            ),
          )),
  GoRoute(
      path: AppRoutes.ownerEarnings,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerEarningsScreen()),
  GoRoute(
      path: AppRoutes.ownerViolations,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ViolationsScreen()),
  GoRoute(
      path: AppRoutes.ownerViolationReport,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ViolationReportScreen()),
  GoRoute(
      path: AppRoutes.ownerHistory,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          OwnerHistoryScreen(period: state.extra as String?)),
  GoRoute(
      path: AppRoutes.ownerPortfolio,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PortfolioInsightsScreen()),
  GoRoute(
      path: AppRoutes.ownerAiChat,
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
      path: AppRoutes.ownerNotifications,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          const NotificationSettingsScreen(role: NotificationRole.owner)),
  GoRoute(
      path: AppRoutes.ownerRateGuest,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final args = state.extra;
        if (args is Property) return OwnerRateGuestScreen(property: args);
        return const OwnerRateGuestScreen();
      }),
  GoRoute(
      path: AppRoutes.ownerEditBio,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OwnerEditBioScreen()),
];
