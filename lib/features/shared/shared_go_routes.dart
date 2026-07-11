import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'screens/add_payment_card_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/blocked_gate_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/currency_screen.dart';
import 'screens/language_screen.dart';
import 'screens/upcoming_booking_detail_screen.dart';
import 'screens/past_booking_detail_screen.dart';
import 'screens/active_booking_detail_screen.dart';
import 'screens/smart_lock_screen.dart';
import 'screens/arrival_checklist_screen.dart';
import 'screens/write_review_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/all_properties_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/property_reviews_screen.dart';
import 'screens/services_screen.dart';
import 'screens/mawsem_dashboard_screen.dart';
import 'screens/mawsem_level_screen.dart';
import 'screens/stars_earned_screen.dart';
import 'screens/star_nudges_screen.dart';
import 'screens/level_up_screen.dart';
import '../renter/presentation/screens/wishlist/pages/wishlist_screen.dart' as complex;
import '../renter/presentation/screens/property/page/property_detail_screen.dart' as renter_property;
import '../renter/presentation/screens/bookings/pages/booking_dates_guests_screen.dart' as renter_booking;
import '../renter/presentation/screens/bookings/pages/booking_confirmed_screen.dart' as renter_confirmed;
import '../renter/presentation/screens/bookings/pages/my_bookings_screen.dart' as renter_bookings;
import 'screens/collection_inside_screen.dart';
import 'screens/collection_chat_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/share_collection_screen.dart';
import 'screens/share_earn_screen.dart';
import '../../../data/models.dart';

/// GoRouter definitions for the shared screens.
final List<GoRoute> sharedGoRoutes = [
  // Browse / discovery
  GoRoute(path: '/browse', builder: (context, state) => const BrowseScreen()),
  GoRoute(path: '/filters', builder: (context, state) => const FiltersScreen()),
  GoRoute(path: '/all-properties', builder: (context, state) => const AllPropertiesScreen()),
  GoRoute(
    path: '/property',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return renter_property.PropertyDetailScreen(
          propertyId: args.id,
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
          propertyId: args['id']?.toString() ?? '1',
          propertyName: args['name'] ?? '',
          propertyImage: args['imageUrl'] ?? args['image'] ?? '',
          location: args['location'] ?? args['area'] ?? '',
          rating: (args['rating'] as num?)?.toDouble() ?? 4.8,
          reviewCount: (args['reviewCount'] as num?)?.toInt() ?? (args['reviews'] as num?)?.toInt() ?? 100,
          pricePerNight: (args['pricePerNight'] as num?)?.toInt() ?? (args['price'] as num?)?.toInt() ?? 5000,
        );
      }
      return const renter_property.PropertyDetailScreen(
        propertyId: '1',
        propertyName: 'Property',
        location: 'North Coast',
        propertyImage: '',
        rating: 4.8,
        reviewCount: 120,
        pricePerNight: 5000,
      );
    },
  ),
  GoRoute(path: '/property-reviews', builder: (context, state) => const PropertyReviewsScreen()),

  // Booking
  GoRoute(
    path: '/booking',
    builder: (context, state) {
      final args = state.extra;
      if (args is Property) {
        return renter_booking.BookingDatesGuestsScreen(
          propertyName: args.name,
          propertyImage: args.image,
          pricePerNight: args.price * 100,
          cleaningFee: 25000,
        );
      }
      if (args is Map<String, dynamic>) {
        return renter_booking.BookingDatesGuestsScreen(
          propertyName: args['name'] ?? args['propertyName'] ?? '',
          propertyImage: args['image'] ?? args['imageUrl'] ?? args['propertyImage'] ?? '',
          pricePerNight: ((args['price'] ?? args['pricePerNight'] ?? 5000) as num).toInt() * 100,
          cleaningFee: 25000,
        );
      }
      return const renter_booking.BookingDatesGuestsScreen(
        propertyName: '',
        propertyImage: '',
        pricePerNight: 500000,
        cleaningFee: 25000,
      );
    },
  ),
  GoRoute(
    path: '/booking-confirmed',
    builder: (context, state) {
      final args = state.extra as Map<String, dynamic>?;
      return renter_confirmed.BookingConfirmedScreen(
        propertyName: args?['propertyName'] ?? args?['property']?.name ?? 'Property',
        checkIn: args?['checkIn'] ?? DateTime.now(),
        checkOut: args?['checkOut'] ?? DateTime.now().add(const Duration(days: 4)),
        adults: args?['adults'] ?? args?['guests'] ?? 2,
        unitInfo: args?['unitInfo'] ?? 'Unit B-214',
        bookingRef: args?['bookingRef'] ?? args?['orderNumber'] ?? 'SHLY-0000',
        totalPaid: (args?['totalPaid'] ?? args?['total'] ?? 0).toInt(),
        starsEarned: args?['starsEarned'] ?? 10,
      );
    },
  ),
  GoRoute(path: '/bookings', builder: (context, state) => const renter_bookings.MyBookingsScreen()),
  GoRoute(path: '/booking-upcoming', builder: (context, state) => const UpcomingBookingDetailScreen()),
  GoRoute(path: '/booking-past', builder: (context, state) => const PastBookingDetailScreen()),
  GoRoute(path: '/booked-property', builder: (context, state) => const ActiveBookingDetailScreen()),
  GoRoute(path: '/smart-lock', builder: (context, state) => const SmartLockScreen()),
  GoRoute(path: '/door-out', builder: (context, state) => const SmartLockScreen(outOfRange: true)),
  GoRoute(path: '/arrival-checklist', builder: (context, state) => const ArrivalChecklistScreen()),
  GoRoute(path: '/write-review', builder: (context, state) => const WriteReviewScreen()),

  // Wishlist / collections
  GoRoute(path: '/wishlist', builder: (context, state) => const complex.WishlistScreen()),
  GoRoute(path: '/collection', builder: (context, state) => const CollectionInsideScreen()),
  GoRoute(path: '/collection-chat', builder: (context, state) => const CollectionChatScreen()),
  GoRoute(path: '/compare', builder: (context, state) => const CompareScreen()),
  GoRoute(path: '/share-collection', builder: (context, state) => const ShareCollectionScreen()),
  GoRoute(path: '/share-earn', builder: (context, state) => const ShareEarnScreen()),

  // Services + AL MAWSEM
  GoRoute(path: '/services', builder: (context, state) => const ServicesScreen()),
  GoRoute(path: '/mawsem', builder: (context, state) => const MawsemDashboardScreen()),
  GoRoute(path: '/mawsem-level', builder: (context, state) => const MawsemLevelScreen()),
  GoRoute(path: '/stars-earned', builder: (context, state) => const StarsEarnedScreen()),
  GoRoute(path: '/star-nudges', builder: (context, state) => const StarNudgesScreen()),
  GoRoute(path: '/level-up', builder: (context, state) => const LevelUpScreen()),

  // Account utilities
  GoRoute(path: '/add-card', builder: (context, state) => const AddPaymentCardScreen()),
  GoRoute(path: '/change-password', builder: (context, state) => const ChangePasswordScreen()),
  GoRoute(path: '/blocked-gate', builder: (context, state) => const BlockedGateScreen()),
  GoRoute(path: '/sos', builder: (context, state) => const SosScreen()),
  GoRoute(path: '/sos-owner', builder: (context, state) => const SosScreen(owner: true)),
  GoRoute(path: '/ai-chat', builder: (context, state) => const AiChatScreen()),
  GoRoute(path: '/currency', builder: (context, state) => const CurrencyScreen()),
  GoRoute(path: '/language', builder: (context, state) => const LanguageScreen()),
];
