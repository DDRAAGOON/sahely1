import 'package:go_router/go_router.dart';

import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/screens/add_payment_card_screen.dart';
import 'package:sahely/features/renter/presentation/screens/profile/pages/change_password_screen.dart';
import 'package:sahely/features/shared/screens/blocked_gate_screen.dart';
import 'package:sahely/features/shared/screens/sos_screen.dart' as sos;
import 'package:sahely/features/shared/screens/ai_chat_screen.dart';
import 'package:sahely/features/shared/screens/currency_screen.dart';
import 'package:sahely/features/shared/screens/language_screen.dart';
import 'package:sahely/features/shared/screens/upcoming_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/past_booking_detail_screen.dart';
import 'package:sahely/features/shared/screens/active_booking_detail_screen.dart';
import 'package:sahely/features/renter/presentation/screens/bookings/pages/smart_lock_screen.dart';
import 'package:sahely/features/shared/screens/arrival_checklist_screen.dart';
import 'package:sahely/features/renter/presentation/screens/reviews/pages/write_review_screen.dart';
import 'package:sahely/features/shared/screens/browse_screen.dart';
import 'package:sahely/features/shared/screens/all_properties_screen.dart';
import 'package:sahely/features/shared/screens/filters_screen.dart';
import 'package:sahely/features/shared/screens/property_reviews_screen.dart';
import 'package:sahely/features/shared/screens/services_screen.dart';
import 'package:sahely/features/shared/screens/mawsem/mawsem_dashboard_screen.dart';
import 'package:sahely/features/shared/screens/mawsem_level_screen.dart';
import 'package:sahely/features/shared/screens/stars_earned_screen.dart';
import 'package:sahely/features/shared/screens/star_nudges_screen.dart';
import 'package:sahely/features/shared/screens/level_up_screen.dart';
import 'package:sahely/features/shared/screens/edit_profile_screen.dart';
import 'package:sahely/features/shared/screens/wishlist_screen.dart' as complex;
import 'package:sahely/features/shared/screens/property_detail_screen.dart'
    as shared_property;
import 'package:sahely/features/shared/screens/my_bookings_screen.dart'
    as shared_bookings;
import 'package:sahely/features/shared/screens/wallet_screen.dart';
import 'package:sahely/features/shared/screens/my_reviews_screen.dart';
import 'package:sahely/features/shared/screens/notification_settings_screen.dart';
import 'package:sahely/features/shared/screens/collection_inside_screen.dart';
import 'package:sahely/features/shared/screens/collection_chat_screen.dart';
import 'package:sahely/features/shared/screens/compare_screen.dart';
import 'package:sahely/features/shared/screens/share_collection_screen.dart';
import 'package:sahely/features/shared/screens/share_earn_screen.dart';
import 'package:sahely/features/shared/screens/booking_screen.dart';
import 'package:sahely/features/shared/screens/booking_confirmed_screen.dart';

/// GoRouter definitions for the shared screens.
final List<GoRoute> sharedGoRoutes = [
  // Browse / discovery
  GoRoute(path: '/browse', builder: (context, state) => const BrowseScreen()),
  GoRoute(
    path: '/filters',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const FiltersScreen(),
  ),
  GoRoute(
      path: '/all-properties',
      builder: (context, state) => const AllPropertiesScreen()),
  GoRoute(
    path: '/property',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return shared_property.PropertyDetailScreen(
          propertyId: args.name,
          propertyName: args.name,
          propertyImage: args.image,
          location: args.area,
          rating: args.rating,
          reviewCount: args.reviews,
          pricePerNight: args.price,
        );
      }
      if (args is Map<String, dynamic>) {
        return shared_property.PropertyDetailScreen(
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
      }
      return const shared_property.PropertyDetailScreen(
        propertyId: 'Property',
        propertyName: 'Property',
        location: 'North Coast',
        propertyImage: '',
        rating: 4.8,
        reviewCount: 120,
        pricePerNight: 5000,
      );
    },
  ),
  GoRoute(
    path: '/property-reviews',
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
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return BookingScreen(property: args);
      if (args is Map<String, dynamic>) {
        return BookingScreen(property: Property.fromMap(args));
      }
      return const BookingScreen();
    },
  ),
  GoRoute(
    path: '/booking-confirmed',
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return BookingConfirmedScreen(arguments: args);
    },
  ),
  GoRoute(
      path: '/renter/bookings',
      builder: (context, state) => const shared_bookings.MyBookingsScreen()),
  GoRoute(
    path: '/booking-upcoming',
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        return UpcomingBookingDetailScreen(
            bookingData: args, role: UpcomingBookingRole.renter);
      }
      return const UpcomingBookingDetailScreen(
          role: UpcomingBookingRole.renter);
    },
  ),
  GoRoute(
    path: '/booking-past',
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) {
        return PastBookingDetailScreen(
            bookingData: args, role: PastBookingRole.renter);
      }
      return const PastBookingDetailScreen(role: PastBookingRole.renter);
    },
  ),
  GoRoute(
    path: '/booked-property',
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
      builder: (context, state) => const ArrivalChecklistScreen()),
  GoRoute(
    path: '/write-review',
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
  // Wishlist / collections
  GoRoute(
      path: '/renter/wishlist',
      builder: (context, state) => const complex.WishlistScreen()),
  GoRoute(
    path: '/collection',
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
      builder: (context, state) => const CollectionChatScreen()),
  GoRoute(path: '/compare', builder: (context, state) => const CompareScreen()),
  GoRoute(
      path: '/share-collection',
      builder: (context, state) => const ShareCollectionScreen()),
  GoRoute(
      path: '/share-earn',
      builder: (context, state) => const ShareEarnScreen()),
  // Services + AL MAWSEM
  GoRoute(
      path: '/services', builder: (context, state) => const ServicesScreen()),
  GoRoute(
      path: '/mawsem',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const MawsemDashboardScreen()),
  GoRoute(
      path: '/mawsem-level',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const MawsemLevelScreen()),
  GoRoute(
      path: '/stars-earned',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const StarsEarnedScreen()),
  GoRoute(
      path: '/star-nudges',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const StarNudgesScreen()),
  GoRoute(
      path: '/level-up',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LevelUpScreen()),
  // Account utilities
  GoRoute(
      path: '/add-card',
      builder: (context, state) => const AddPaymentCardScreen()),
  GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen()),
  GoRoute(
      path: '/blocked-gate',
      builder: (context, state) => const BlockedGateScreen()),
  GoRoute(
      path: '/sos',
      builder: (context, state) =>
          const sos.SosScreen(role: sos.UserRole.renter)),
  GoRoute(
      path: '/sos-owner',
      builder: (context, state) =>
          const sos.SosScreen(role: sos.UserRole.owner)),
  GoRoute(
      path: '/ai-chat',
      builder: (context, state) =>
          AiChatScreen(initialMessage: state.extra as String?)),
  GoRoute(
      path: '/currency', builder: (context, state) => const CurrencyScreen()),
  GoRoute(
      path: '/language', builder: (context, state) => const LanguageScreen()),
  GoRoute(path: '/wallet', builder: (context, state) => const WalletScreen()),
  GoRoute(
      path: '/my-reviews',
      builder: (context, state) => const MyReviewsScreen()),
  GoRoute(
      path: '/notifications',
      builder: (context, state) =>
          const NotificationSettingsScreen(role: NotificationRole.renter)),
  GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen()),
];
