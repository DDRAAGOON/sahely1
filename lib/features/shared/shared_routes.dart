import 'package:flutter/material.dart';
import 'screens/add_payment_card_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/blocked_gate_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/currency_screen.dart';
import 'screens/language_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'screens/upcoming_booking_detail_screen.dart';
import 'screens/past_booking_detail_screen.dart';
import 'screens/active_booking_detail_screen.dart';
import 'screens/smart_lock_screen.dart';
import 'screens/arrival_checklist_screen.dart';
import 'screens/write_review_screen.dart';
import 'screens/browse_screen.dart';
import 'screens/all_properties_screen.dart';
import 'screens/filters_screen.dart';
import 'screens/property_detail_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/booking_confirmed_screen.dart';
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

/// Screens shared by all three roles (browse, booking, wishlist, services,
/// AL MAWSEM, account utilities). Built once, reused everywhere.
final Map<String, WidgetBuilder> sharedRoutes = {
  // Browse / discovery
  '/browse': (_) => const BrowseScreen(),
  '/filters': (_) => const FiltersScreen(),
  '/all-properties': (_) => const AllPropertiesScreen(),
  '/property': (ctx) {
    final args = ModalRoute.of(ctx)?.settings.arguments;
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
  '/property-reviews': (_) => const PropertyReviewsScreen(),

  // Booking
  '/booking': (ctx) {
    final args = ModalRoute.of(ctx)?.settings.arguments;
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
  '/booking-confirmed': (ctx) {
    final args = ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>?;
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
  '/bookings': (_) => const renter_bookings.MyBookingsScreen(),
  '/booking-upcoming': (_) => const UpcomingBookingDetailScreen(),
  '/booking-past': (_) => const PastBookingDetailScreen(),
  '/booked-property': (_) => const ActiveBookingDetailScreen(),
  '/smart-lock': (_) => const SmartLockScreen(),
  '/door-out': (_) => const SmartLockScreen(outOfRange: true),
  '/arrival-checklist': (_) => const ArrivalChecklistScreen(),
  '/write-review': (_) => const WriteReviewScreen(),

  // Wishlist / collections
  '/wishlist': (_) => const complex.WishlistScreen(),
  '/collection': (_) => const CollectionInsideScreen(),
  '/collection-chat': (_) => const CollectionChatScreen(),
  '/compare': (_) => const CompareScreen(),
  '/share-collection': (_) => const ShareCollectionScreen(),
  '/share-earn': (_) => const ShareEarnScreen(),

  // Services + AL MAWSEM
  '/services': (_) => const ServicesScreen(),
  '/mawsem': (_) => const MawsemDashboardScreen(),
  '/mawsem-level': (_) => const MawsemLevelScreen(),
  '/stars-earned': (_) => const StarsEarnedScreen(),
  '/star-nudges': (_) => const StarNudgesScreen(),
  '/level-up': (_) => const LevelUpScreen(),

  // Account utilities
  '/add-card': (_) => const AddPaymentCardScreen(),
  '/change-password': (_) => const ChangePasswordScreen(),
  '/blocked-gate': (_) => const BlockedGateScreen(),
  '/sos': (_) => const SosScreen(),
  '/sos-owner': (_) => const SosScreen(owner: true),
  '/ai-chat': (_) => const AiChatScreen(),
  '/currency': (_) => const CurrencyScreen(),
  '/language': (_) => const LanguageScreen(),
};
