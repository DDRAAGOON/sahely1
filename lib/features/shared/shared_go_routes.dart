import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/route_transitions.dart';

import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/screens/add_payment_card_screen.dart';
import 'package:sahely/features/renter/presentation/screens/profile/pages/change_password_screen.dart';
import 'package:sahely/features/shared/screens/sos_screen.dart' as sos;
import 'package:sahely/features/shared/screens/ai_chat_screen.dart';
import 'package:sahely/features/shared/screens/upcoming_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/past_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/active_booking_detail_screen.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/pages/smart_lock_screen.dart';
import 'package:sahely/features/shared/screens/arrival_checklist_screen.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/pages/write_review_screen.dart';
import 'package:sahely/features/shared/screens/browse_screen.dart';
import 'package:sahely/features/shared/screens/all_properties_screen.dart';
import 'package:sahely/features/shared/screens/property_reviews_screen.dart';
import 'package:sahely/features/shared/screens/services_screen.dart';
import 'package:sahely/features/shared/screens/mawsem/mawsem_dashboard_screen.dart';
import 'package:sahely/features/shared/screens/mawsem_level_screen.dart';
import 'package:sahely/features/shared/screens/stars_earned_screen.dart';
import 'package:sahely/features/shared/screens/star_nudges_screen.dart';
import 'package:sahely/features/shared/screens/level_up_screen.dart';
import 'package:sahely/features/shared/screens/edit_profile_screen.dart';
import 'package:sahely/features/shared/screens/property_detail_screen.dart'
    as shared_property;
import 'package:sahely/features/shared/screens/wallet_screen.dart';
import 'package:sahely/features/shared/screens/my_reviews_screen.dart';
import 'package:sahely/features/shared/screens/notification_settings_screen.dart';
import 'package:sahely/features/renter/presentation/screens/mawsem/celebration/pages/level_up_celebration_screen.dart';
import 'package:sahely/features/shared/screens/collection_inside_screen.dart';
import 'package:sahely/features/shared/screens/collection_chat_screen.dart';
import 'package:sahely/features/shared/screens/compare_screen.dart';
import 'package:sahely/features/shared/screens/transaction_history_screen.dart';
import 'package:sahely/features/shared/screens/booking_screen.dart';
import 'package:sahely/features/shared/screens/booking_confirmed_screen.dart';

/// GoRouter definitions for the shared screens.
final List<GoRoute> sharedGoRoutes = [
  // Browse / discovery
  GoRoute(
    path: '/browse',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => fadeSlideTransition(
      key: state.pageKey,
      child: const BrowseScreen(),
    ),
  ),
  // Filters is now a ModalBottomSheet called via AppNavigation, 
  // so we remove the separate route to avoid conflicts.
  GoRoute(
    path: '/all-properties',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => fadeSlideTransition(
      key: state.pageKey,
      child: const AllPropertiesScreen(),
    ),
  ),
  GoRoute(
    path: '/property',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) {
      final args = state.extra;
      Widget child;
      if (args is Property) {
        child = shared_property.PropertyDetailScreen(
          propertyId: args.name,
          propertyName: args.name,
          propertyImage: args.image,
          location: args.area,
          rating: args.rating,
          reviewCount: args.reviews,
          pricePerNight: args.price,
        );
      } else if (args is Map<String, dynamic>) {
        child = shared_property.PropertyDetailScreen(
          propertyId: args['name'] ?? 'Property',
          propertyName: args['name'] ?? '',
          propertyImage: args['imageUrl'] ?? args['image'] ?? '',
          location: args['location'] ?? args['area'] ?? '',
          rating: (args['rating'] as num?)?.toDouble() ?? 4.8,
          reviewCount: (args['reviewCount'] as num?)?.toInt() ??
              (args['reviews'] as num?)?.toInt() ??
              100,
          pricePerNight: (args['pricePerNight'] as num?)?.toInt() ??
              (args['price'] as num?)?.toInt() ??
              5000,
        );
      } else {
        child = const shared_property.PropertyDetailScreen(
          propertyId: 'Property',
          propertyName: 'Property',
          location: 'North Coast',
          propertyImage: '',
          rating: 4.8,
          reviewCount: 120,
          pricePerNight: 5000,
        );
      }

      return fadeSlideTransition(key: state.pageKey, child: child);
    },
  ),
  GoRoute(
    path: '/property-reviews',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return PropertyReviewsScreen(property: args);
      if (args is Map<String, dynamic>) {
        return PropertyReviewsScreen(property: Property.fromMap(args));
      }
      return const PropertyReviewsScreen();
    },
  ),
  GoRoute(
    path: '/booking',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) {
      final args = state.extra;
      Widget child;
      if (args is Property) {
        child = BookingScreen(property: args);
      } else if (args is Map<String, dynamic>) {
        child = BookingScreen(property: Property.fromMap(args));
      } else {
        child = const BookingScreen();
      }

      return fadeSlideTransition(key: state.pageKey, child: child);
    },
  ),
  GoRoute(
    path: '/booking-confirmed',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BookingConfirmedScreen(arguments: args);
    },
  ),
  GoRoute(
    path: '/booking-upcoming',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        final role = args['role'] is UpcomingBookingRole
            ? args['role'] as UpcomingBookingRole
            : UpcomingBookingRole.renter;
        return UpcomingBookingDetailScreen(
            bookingData: args, role: role);
      }
      return const UpcomingBookingDetailScreen(
          role: UpcomingBookingRole.renter);
    },
  ),
  GoRoute(
    path: '/booking-past',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        final role = args['role'] is PastBookingRole
            ? args['role'] as PastBookingRole
            : PastBookingRole.renter;
        return PastBookingDetailScreen(
            bookingData: args, role: role);
      }
      return const PastBookingDetailScreen(role: PastBookingRole.renter);
    },
  ),
  GoRoute(
    path: '/booked-property',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return ActiveBookingDetailScreen(
            property: args, role: ActiveBookingRole.renter);
      }
      if (args is Map<String, dynamic>) {
        final role = args['role'] is ActiveBookingRole
            ? args['role'] as ActiveBookingRole
            : ActiveBookingRole.renter;
        return ActiveBookingDetailScreen(
          property: args['prop'] is Property
              ? args['prop'] as Property
              : Property.fromMap(args),
          bookingData: args,
          role: role,
        );
      }
      return const ActiveBookingDetailScreen(role: ActiveBookingRole.renter);
    },
  ),
  GoRoute(
    path: '/smart-lock',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        return SmartLockScreen(
          propertyName: args['propertyName'] ?? 'Property',
          bookingRef: args['bookingRef'] ?? '',
          passcode: args['passcode'] ?? '',
          checkIn: args['checkIn'] ?? DateTime.now(),
          checkOut:
              args['checkOut'] ?? DateTime.now().add(const Duration(days: 1)),
          propertyLat: args['propertyLat'] ?? 0.0,
          propertyLng: args['propertyLng'] ?? 0.0,
        );
      }
      return SmartLockScreen(
        propertyName: 'Property',
        bookingRef: '',
        passcode: '',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 1)),
        propertyLat: 0.0,
        propertyLng: 0.0,
      );
    },
  ),
  GoRoute(
    path: '/door-out',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        return SmartLockScreen(
          propertyName: args['propertyName'] ?? 'Property',
          bookingRef: args['bookingRef'] ?? '',
          passcode: args['passcode'] ?? '',
          checkIn: args['checkIn'] ?? DateTime.now(),
          checkOut:
              args['checkOut'] ?? DateTime.now().add(const Duration(days: 1)),
          propertyLat: args['propertyLat'] ?? 0.0,
          propertyLng: args['propertyLng'] ?? 0.0,
        );
      }
      return SmartLockScreen(
        propertyName: 'Property',
        bookingRef: '',
        passcode: '',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 1)),
        propertyLat: 0.0,
        propertyLng: 0.0,
      );
    },
  ),
  GoRoute(
    path: '/arrival-checklist',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const ArrivalChecklistScreen(),
  ),
  GoRoute(
    path: '/write-review',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        return WriteReviewScreen(
          propertyName: args['propertyName'] ?? 'Property',
          propertyImage: args['propertyImage'] ?? '',
          stayDates: args['stayDates'] ?? '',
        );
      }
      return const WriteReviewScreen(
          propertyName: 'Property', propertyImage: '', stayDates: '');
    },
  ),
  GoRoute(
    path: '/collection',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>? ?? {};
      return CollectionInsideScreen(
        collectionId: args['collectionId'] ?? 'all_saved',
        collectionName: args['collectionName'] ?? 'All Saved',
        sharedWithCount: args['sharedWithCount'] ?? 0,
        memberNames: args['memberNames'] as List<String>? ?? const [],
      );
    },
  ),
  GoRoute(
    path: '/collection-chat',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const CollectionChatScreen(),
  ),
  GoRoute(
    path: '/compare',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const CompareScreen(),
  ),
  // Share collection and Share Earn are now ModalBottomSheets called via AppNavigation.
  // GoRoute(
  //   path: '/share-earn',
  //   parentNavigatorKey: rootNavigatorKey,
  //   builder: (context, state) => const ShareEarnScreen(),
  // ),
  // Services + AL MAWSEM
  GoRoute(
    path: '/services',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const ServicesScreen(),
  ),
  GoRoute(
    path: '/mawsem',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const MawsemDashboardScreen(),
  ),
  GoRoute(
    path: '/mawsem-level',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const MawsemLevelScreen(),
  ),
  GoRoute(
    path: '/stars-earned',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const StarsEarnedScreen(),
  ),
  GoRoute(
    path: '/star-nudges',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const StarNudgesScreen(),
  ),
  GoRoute(
    path: '/level-up',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const LevelUpScreen(),
  ),
  GoRoute(
    path: '/level-up-celebration',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>;
      return LevelUpCelebrationScreen(
        newLevel: args['newLevel'],
        levelName: args['levelName'],
        levelIcon: args['levelIcon'],
        levelColor: args['levelColor'],
        unlockBenefit: args['unlockBenefit'],
        unlockRewardTitle: args['unlockRewardTitle'],
        unlockRewardDescription: args['unlockRewardDescription'],
        currentSeasonStars: args['currentSeasonStars'],
        starsToNextLevel: args['starsToNextLevel'],
        onShare: args['onShare'],
        onKeepExploring: args['onKeepExploring'],
      );
    },
  ),
  // Account utilities
  GoRoute(
    path: '/add-card',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const AddPaymentCardScreen(),
  ),
  GoRoute(
    path: '/change-password',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const ChangePasswordScreen(),
  ),
  GoRoute(
    path: '/sos',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) {
      Widget child;
      try {
        final role = context.read<RoleState>().currentRole;
        final sosRole = switch (role) {
          Role.owner => sos.UserRole.owner,
          Role.broker => sos.UserRole.broker,
          _ => sos.UserRole.renter,
        };
        child = sos.SosScreen(role: sosRole);
      } catch (_) {
        child = const sos.SosScreen(role: sos.UserRole.renter);
      }

      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
      );
    },
  ),
  GoRoute(
    path: '/sos-owner',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const sos.SosScreen(role: sos.UserRole.owner),
  ),
  GoRoute(
    path: '/ai-chat',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => fadeSlideTransition(
      key: state.pageKey,
      child: AiChatScreen(initialMessage: state.extra as String?),
      begin: const Offset(0, 0.05),
    ),
  ),
  GoRoute(
    path: '/wallet',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => fadeSlideTransition(
      key: state.pageKey,
      child: const WalletScreen(),
    ),
  ),
  GoRoute(
    path: '/my-reviews',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const MyReviewsScreen(),
  ),
  GoRoute(
    path: '/transaction-history',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => fadeSlideTransition(
      key: state.pageKey,
      child: const TransactionHistoryScreen(),
    ),
  ),
  GoRoute(
    path: '/notifications',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) {
      Widget child;
      try {
        final role = context.read<RoleState>().currentRole;
        final notificationRole = switch (role) {
          Role.owner => NotificationRole.owner,
          Role.broker => NotificationRole.broker,
          _ => NotificationRole.renter,
        };
        child = NotificationSettingsScreen(role: notificationRole);
      } catch (_) {
        child = const NotificationSettingsScreen(role: NotificationRole.renter);
      }

      return fadeSlideTransition(key: state.pageKey, child: child);
    },
  ),
  GoRoute(
    path: '/edit-profile',
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) => fadeSlideTransition(
      key: state.pageKey,
      child: const EditProfileScreen(),
    ),
  ),
];
