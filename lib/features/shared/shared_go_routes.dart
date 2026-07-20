import 'package:go_router/go_router.dart';

import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'screens/add_payment_card_screen.dart';
import '../renter/presentation/screens/profile/pages/change_password_screen.dart';
import 'screens/blocked_gate_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/currency_screen.dart';
import 'screens/language_screen.dart';
import '../renter/presentation/screens/bookings/pages/upcoming_booking_detail_screen.dart';
import '../renter/presentation/screens/bookings/pages/past_booking_detail_screen.dart';
import 'screens/active_booking_detail_screen.dart';
import '../renter/presentation/screens/bookings/pages/smart_lock_screen.dart';
import 'screens/arrival_checklist_screen.dart';
import '../renter/presentation/screens/reviews/pages/write_review_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/all_properties_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/property_reviews_screen.dart';
import 'screens/services_screen.dart';
import 'screens/mawsem/mawsem_dashboard_screen.dart';
import 'screens/mawsem_level_screen.dart';
import 'screens/stars_earned_screen.dart';
import 'screens/star_nudges_screen.dart';
import 'screens/level_up_screen.dart';
import '../renter/presentation/screens/profile/pages/edit_profile_screen.dart';
import '../renter/presentation/screens/wishlist/pages/wishlist_screen.dart' as complex;
import '../renter/presentation/screens/property/page/property_detail_screen.dart' as renter_property;
import '../renter/presentation/screens/bookings/pages/my_bookings_screen.dart' as renter_bookings;
import '../renter/presentation/screens/wallet/pages/wallet_screen.dart';
import '../renter/presentation/screens/reviews/pages/my_reviews_screen.dart';
import '../renter/presentation/screens/profile/pages/notification_settings_screen.dart';
import 'screens/collection_inside_screen.dart';
import 'screens/collection_chat_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/share_collection_screen.dart';
import 'screens/share_earn_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/booking_confirmed_screen.dart';

/// GoRouter definitions for the shared screens.
final List<GoRoute> sharedGoRoutes = [
  // Browse / discovery
  GoRoute(path: '/browse', builder: (context, state) => const BrowseScreen()),
  GoRoute(
    path: '/filters',
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state) => const FiltersScreen(),
  ),
  GoRoute(path: '/all-properties', builder: (context, state) => const AllPropertiesScreen()),
  GoRoute(
    path: '/property',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return renter_property.PropertyDetailScreen(
          propertyId: args.name, // Wishlist logic uses name as ID
          propertyName: args.name,
          propertyImage: args.image,
          location: args.area,
          rating: args.rating,
          reviewCount: args.reviews,
          pricePerNight: args.price,
        );
      }
      if (args is Map<String, dynamic>) {
        return renter_property.PropertyDetailScreen(
          propertyId: args['name'] ?? 'Property', // Use name as ID
          propertyName: args['name'] ?? '',
          propertyImage: args['imageUrl'] ?? args['image'] ?? '',
          location: args['location'] ?? args['area'] ?? '',
          rating: (args['rating'] as num?)?.toDouble() ?? 4.8,
          reviewCount: (args['reviewCount'] as num?)?.toInt() ?? (args['reviews'] as num?)?.toInt() ?? 100,
          pricePerNight: (args['pricePerNight'] as num?)?.toInt() ?? (args['price'] as num?)?.toInt() ?? 5000,
        );
      }
      return const renter_property.PropertyDetailScreen(
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
      if (args is Map<String, dynamic>) return PropertyReviewsScreen(property: Property.fromMap(args));
      return const PropertyReviewsScreen();
    },
  ),

  GoRoute(
    path: '/booking',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return BookingScreen(property: args);
      if (args is Map<String, dynamic>) return BookingScreen(property: Property.fromMap(args));
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
  GoRoute(path: '/renter/bookings', builder: (context, state) => const renter_bookings.MyBookingsScreen()),
  GoRoute(
    path: '/booking-upcoming',
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) return UpcomingBookingDetailScreen(booking: args);
      return const UpcomingBookingDetailScreen(booking: {});
    },
  ),
  GoRoute(
    path: '/booking-past',
    builder: (context, state) {
      final args = state.extra;
      if (args is Map<String, dynamic>) return PastBookingDetailScreen(booking: args);
      return const PastBookingDetailScreen(booking: {});
    },
  ),
  GoRoute(
    path: '/booked-property',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) return ActiveBookingDetailScreen(property: args);
      if (args is Map<String, dynamic>) return ActiveBookingDetailScreen(property: Property.fromMap(args));
      return const ActiveBookingDetailScreen();
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
          checkOut: args['checkOut'] ?? DateTime.now().add(const Duration(days: 1)),
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
          checkOut: args['checkOut'] ?? DateTime.now().add(const Duration(days: 1)),
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
  GoRoute(path: '/arrival-checklist', builder: (context, state) => const ArrivalChecklistScreen()),
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
      return const WriteReviewScreen(propertyName: 'Property', propertyImage: '', stayDates: '');
    },
  ),

  // Wishlist / collections
  GoRoute(path: '/renter/wishlist', builder: (context, state) => const complex.WishlistScreen()),
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
  GoRoute(path: '/collection-chat', builder: (context, state) => const CollectionChatScreen()),
  GoRoute(path: '/compare', builder: (context, state) => const CompareScreen()),
  GoRoute(path: '/share-collection', builder: (context, state) => const ShareCollectionScreen()),
  GoRoute(path: '/share-earn', builder: (context, state) => const ShareEarnScreen()),

  // Services + AL MAWSEM
  GoRoute(path: '/services', builder: (context, state) => const ServicesScreen()),
  GoRoute(path: '/mawsem', parentNavigatorKey: rootNavigatorKey, builder: (context, state) => const MawsemDashboardScreen()),
  GoRoute(path: '/mawsem-level', parentNavigatorKey: rootNavigatorKey, builder: (context, state) => const MawsemLevelScreen()),
  GoRoute(path: '/stars-earned', parentNavigatorKey: rootNavigatorKey, builder: (context, state) => const StarsEarnedScreen()),
  GoRoute(path: '/star-nudges', parentNavigatorKey: rootNavigatorKey, builder: (context, state) => const StarNudgesScreen()),
  GoRoute(path: '/level-up', parentNavigatorKey: rootNavigatorKey, builder: (context, state) => const LevelUpScreen()),

  // Account utilities
  GoRoute(path: '/add-card', builder: (context, state) => const AddPaymentCardScreen()),
  GoRoute(path: '/change-password', builder: (context, state) => const ChangePasswordScreen()),
  GoRoute(path: '/blocked-gate', builder: (context, state) => const BlockedGateScreen()),
  GoRoute(path: '/sos', builder: (context, state) => const SosScreen()),
  GoRoute(path: '/sos-owner', builder: (context, state) => const SosScreen(owner: true)),
  GoRoute(
    path: '/ai-chat',
    builder: (context, state) => AiChatScreen(initialMessage: state.extra as String?),
  ),
  GoRoute(path: '/currency', builder: (context, state) => const CurrencyScreen()),
  GoRoute(path: '/language', builder: (context, state) => const LanguageScreen()),
  GoRoute(path: '/wallet', builder: (context, state) => const WalletScreen()),
  GoRoute(path: '/my-reviews', builder: (context, state) => const MyReviewsScreen()),
  GoRoute(path: '/notifications-settings', builder: (context, state) => const NotificationSettingsScreen()),
  GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfileScreen()),
];
