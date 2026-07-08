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
import 'screens/collection_inside_screen.dart';
import 'screens/collection_chat_screen.dart';
import 'screens/compare_screen.dart';
import 'screens/share_collection_screen.dart';
import 'screens/share_earn_screen.dart';

/// Screens shared by all three roles (browse, booking, wishlist, services,
/// AL MAWSEM, account utilities). Built once, reused everywhere.
final Map<String, WidgetBuilder> sharedRoutes = {
  // Browse / discovery
  '/browse': (_) => const BrowseScreen(),
  '/filters': (_) => const FiltersScreen(),
  '/all-properties': (_) => const AllPropertiesScreen(),
  '/property': (_) => const PropertyDetailScreen(),
  '/property-reviews': (_) => const PropertyReviewsScreen(),

  // Booking
  '/booking': (_) => const BookingScreen(),
  '/booking-confirmed': (_) => const BookingConfirmedScreen(),
  '/bookings': (_) => const MyBookingsScreen(),
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
