// Layout regression test: renders every screen of the app on small phones,
// with a large system font and in the longest / right-to-left languages, and
// fails on any overflow (the yellow-and-black "OVERFLOWED BY n PIXELS" bar).
//
// Generated from every *Screen / *Page widget in lib/; screens that need
// arguments get realistic sample values. Bottom sheets are rendered inside a
// real modal bottom sheet with the height cap the app opens them with.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sahely/core/di/service_locator.dart' as di;
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/providers/currency_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:sahely/features/broker/presentation/bloc/broker_home_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/bloc/broker_bookings_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_home_cubit.dart';
import 'package:sahely/features/renter/presentation/bloc/renter_home_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/search/bloc/search_cubit.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/shared/bookings/presentation/bloc/bookings_cubit.dart';
import 'package:sahely/features/shared/profile/presentation/bloc/profile_cubit.dart';
import 'package:sahely/features/shared/reviews/presentation/bloc/review_cubit.dart';
import 'package:sahely/l10n/app_localizations.dart';

import 'package:sahely/data/models.dart' show Role;
import 'package:sahely/features/auth/screens/create_account_screen.dart'
    show CreateAccountScreen;
import 'package:sahely/features/auth/screens/forgot_password_screens.dart'
    show ForgotPasswordScreen, NewPasswordScreen, PasswordUpdatedScreen;
import 'package:sahely/features/auth/screens/onboarding_screen.dart'
    show OnboardingScreen;
import 'package:sahely/features/auth/screens/otp_screen.dart' show OtpScreen;
import 'package:sahely/features/auth/screens/register_otp_flow.dart'
    show RegisterEmailOtpScreen, RegisterPhoneOtpScreen;
import 'package:sahely/features/auth/screens/role_selection_screen.dart'
    show RoleSelectionScreen;
import 'package:sahely/features/auth/screens/sign_in_screen.dart'
    show SignInScreen;
import 'package:sahely/features/auth/screens/splash_screen.dart'
    show SplashScreen;
import 'package:sahely/features/auth/screens/verification_screens.dart'
    show FacialScanScreen, IdVerificationScreen, VerificationCompleteScreen;
import 'package:sahely/features/auth/screens/welcome_screen.dart'
    show WelcomeScreen;
import 'package:sahely/features/broker/presentation/screens/bookings/pages/broker_bookings_page.dart'
    show BrokerBookingsPage;
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/broker_dashboard_page.dart'
    show BrokerDashboardPage;
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/tier_dashboard_page.dart'
    show TierDashboardPage;
import 'package:sahely/features/broker/presentation/screens/dashboard/pages/tier_upgrade_page.dart'
    show BrokerTierUpgradePage;
import 'package:sahely/features/broker/presentation/screens/home/pages/broker_home_page.dart'
    show BrokerHomePage;
import 'package:sahely/features/broker/presentation/screens/mawsem/pages/broker_mawsem_page.dart'
    show BrokerMawsemPage;
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/broker_portfolio_page.dart'
    show BrokerPortfolioPage;
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/refer_property_page.dart'
    show ReferPropertyPage;
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/referral_issue_page.dart'
    show ReferralIssuePage;
import 'package:sahely/features/broker/presentation/screens/portfolio/pages/referred_property_detail_page.dart'
    show ReferredPropertyDetailPage;
import 'package:sahely/features/broker/presentation/screens/profile/pages/broker_profile_page.dart'
    show BrokerProfilePage;
import 'package:sahely/features/broker/presentation/screens/services/pages/broker_services_page.dart'
    show BrokerServicesPage;
import 'package:sahely/features/broker/presentation/screens/smart_lock/pages/broker_smart_lock_screen.dart'
    show BrokerSmartLockScreen;
import 'package:sahely/features/broker/presentation/screens/wallet/pages/broker_history_page.dart'
    show BrokerHistoryPage;
import 'package:sahely/features/broker/presentation/screens/wallet/pages/broker_wallet_page.dart'
    show BrokerWalletPage;
import 'package:sahely/features/broker/presentation/screens/wishlist/pages/broker_collection_inside_page.dart'
    show BrokerCollectionInsidePage;
import 'package:sahely/features/owner/screens/add_property_screen.dart'
    show AddPropertyScreen, MapPickerScreen;
import 'package:sahely/features/owner/screens/listing_submitted_screen.dart'
    show ListingSubmittedScreen;
import 'package:sahely/features/owner/screens/owner_ai_chat_screen.dart'
    show OwnerAiChatScreen;
import 'package:sahely/features/owner/screens/owner_bookings_screen.dart'
    show OwnerBookingsScreen;
import 'package:sahely/features/owner/screens/owner_earnings_screen.dart'
    show OwnerEarningsScreen;
import 'package:sahely/features/owner/screens/owner_edit_bio_screen.dart'
    show OwnerEditBioScreen;
import 'package:sahely/features/owner/screens/owner_history_screen.dart'
    show OwnerHistoryScreen, ViolationsScreen;
import 'package:sahely/features/owner/screens/owner_home_screen.dart'
    show OwnerHomeScreen;
import 'package:sahely/features/owner/screens/owner_manage_screen.dart'
    show OwnerManageScreen;
import 'package:sahely/features/owner/screens/owner_portfolio_screen.dart'
    show PortfolioInsightsScreen;
import 'package:sahely/features/owner/screens/owner_profile_screen.dart'
    show OwnerProfileScreen;
import 'package:sahely/features/owner/screens/owner_properties_screen.dart'
    show OwnerPropertiesScreen;
import 'package:sahely/features/owner/screens/owner_property_detail_screens.dart'
    show
        OwnerEditPropertyScreen,
        OwnerPreviewListingScreen,
        OwnerPropertyInsightsScreen;
import 'package:sahely/features/owner/screens/owner_rate_guest_screen.dart'
    show OwnerRateGuestScreen;
import 'package:sahely/features/owner/screens/owner_requests_screen.dart'
    show OwnerRequestDetailScreen, OwnerRequestsScreen;
import 'package:sahely/features/owner/screens/owner_smart_lock_screen.dart'
    show OwnerSmartLockScreen;
import 'package:sahely/features/owner/screens/payout_bank_screen.dart'
    show PayoutBankScreen;
import 'package:sahely/features/owner/screens/team_review_screen.dart'
    show TeamReviewScreen;
import 'package:sahely/features/owner/screens/violation_report_screen.dart'
    show ViolationReportScreen;
import 'package:sahely/features/owner/screens/withdraw_amount_screen.dart'
    show WithdrawAmountScreen;
import 'package:sahely/features/owner/screens/withdraw_receipt_screen.dart'
    show WithdrawReceiptScreen;
import 'package:sahely/features/owner/widgets/payout_selection_sheet.dart'
    show PayoutSelectionSheet;
import 'package:sahely/features/renter/presentation/screens/bookings/pages/gallery/photo_viewer_screen.dart'
    show PhotoViewerScreen;
import 'package:sahely/features/renter/presentation/screens/bookings/pages/smart_lock_screen.dart'
    show SmartLockScreen;
import 'package:sahely/features/renter/presentation/screens/mawsem/celebration/pages/level_up_celebration_screen.dart'
    show LevelUpCelebrationScreen;
import 'package:sahely/features/renter/presentation/screens/profile/pages/change_password_screen.dart'
    show ChangePasswordScreen;
import 'package:sahely/features/renter/presentation/screens/reviews/pages/write_review_screen.dart'
    show WriteReviewScreen;
import 'package:sahely/features/renter/presentation/screens/wallet/pages/add_credit_sheet.dart'
    show AddCreditSheet;
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/widgets/add_to_collection_sheet.dart'
    show AddToCollectionSheet;
import 'package:sahely/features/renter/presentation/screens/wishlist/widgets/create_collection_sheet.dart'
    show CreateCollectionSheet;
import 'package:sahely/features/shared/screens/active_booking_detail_screen.dart'
    show ActiveBookingDetailScreen;
import 'package:sahely/features/shared/screens/add_payment_card_screen.dart'
    show AddPaymentCardScreen;
import 'package:sahely/features/shared/screens/ai_chat_screen.dart'
    show AiChatScreen;
import 'package:sahely/features/shared/screens/all_properties_screen.dart'
    show AllPropertiesScreen;
import 'package:sahely/features/shared/screens/arrival_checklist_screen.dart'
    show ArrivalChecklistScreen;
import 'package:sahely/features/shared/screens/booking_confirmed_screen.dart'
    show BookingConfirmedScreen;
import 'package:sahely/features/shared/screens/booking_screen.dart'
    show BookingScreen;
import 'package:sahely/features/shared/screens/browse_screen.dart'
    show BrowseScreen;
import 'package:sahely/features/shared/screens/collection_chat_screen.dart'
    show CollectionChatScreen;
import 'package:sahely/features/shared/screens/collection_inside_screen.dart'
    show CollectionInsideScreen;
import 'package:sahely/features/shared/screens/compare_screen.dart'
    show CompareScreen;
import 'package:sahely/features/shared/screens/concierge_screen.dart'
    show ConciergeScreen;
import 'package:sahely/features/shared/screens/currency_screen.dart'
    show CurrencyScreen;
import 'package:sahely/features/shared/screens/edit_profile_screen.dart'
    show EditProfileScreen;
import 'package:sahely/features/shared/screens/home_screen.dart'
    show HomeScreen;
import 'package:sahely/features/shared/screens/language_screen.dart'
    show LanguageScreen;
import 'package:sahely/features/shared/screens/level_up_screen.dart'
    show LevelUpScreen;
import 'package:sahely/features/shared/screens/mawsem/mawsem_dashboard_screen.dart'
    show MawsemDashboardScreen;
import 'package:sahely/features/shared/screens/mawsem_level_screen.dart'
    show MawsemLevelScreen;
import 'package:sahely/features/shared/screens/my_bookings_screen.dart'
    show MyBookingsScreen;
import 'package:sahely/features/shared/screens/my_reviews_screen.dart'
    show MyReviewsScreen;
import 'package:sahely/features/shared/screens/notification_settings_screen.dart'
    show NotificationSettingsScreen;
import 'package:sahely/features/shared/screens/past_booking_detail_screen.dart'
    show PastBookingDetailScreen, PastBookingRole;
import 'package:sahely/features/shared/screens/profile_screen.dart'
    show ProfileScreen;
import 'package:sahely/features/shared/screens/property_detail_screen.dart'
    show PropertyDetailScreen;
import 'package:sahely/features/shared/screens/property_reviews_screen.dart'
    show PropertyReviewsScreen;
import 'package:sahely/features/shared/screens/services_screen.dart'
    show ServicesScreen;
import 'package:sahely/features/shared/screens/share_collection_screen.dart'
    show ShareCollectionScreen;
import 'package:sahely/features/shared/screens/share_earn_screen.dart'
    show ShareEarnScreen;
import 'package:sahely/features/shared/screens/sos_screen.dart' show SosScreen;
import 'package:sahely/features/shared/screens/star_nudges_screen.dart'
    show StarNudgesScreen;
import 'package:sahely/features/shared/screens/stars_earned_screen.dart'
    show StarsEarnedScreen;
import 'package:sahely/features/shared/screens/transaction_history_screen.dart'
    show TransactionHistoryScreen;
import 'package:sahely/features/shared/screens/upcoming_booking_detail_screen.dart'
    show UpcomingBookingDetailScreen, UpcomingBookingRole;
import 'package:sahely/features/shared/screens/wallet_screen.dart'
    show WalletScreen;
import 'package:sahely/features/shared/screens/wishlist_screen.dart'
    show WishlistScreen;
import 'package:sahely/features/shared/widgets/mawsem/level/level_detail_sheet.dart'
    show LevelDetailSheet;
import 'package:sahely/features/shared/widgets/mawsem/level/level_perk.dart'
    show LevelPerk;

const _image = 'https://example.com/property.jpg';

final Map<String, Widget Function()> _screens = {
  'CreateAccountScreen': () => const CreateAccountScreen(),
  'ForgotPasswordScreen': () => const ForgotPasswordScreen(),
  'NewPasswordScreen': () => const NewPasswordScreen(),
  'PasswordUpdatedScreen': () => const PasswordUpdatedScreen(),
  'OnboardingScreen': () => const OnboardingScreen(),
  'RegisterEmailOtpScreen': () => const RegisterEmailOtpScreen(),
  'RegisterPhoneOtpScreen': () => const RegisterPhoneOtpScreen(),
  'RoleSelectionScreen': () => const RoleSelectionScreen(),
  'SignInScreen': () => const SignInScreen(),
  'SplashScreen': () => const SplashScreen(),
  'IdVerificationScreen': () => const IdVerificationScreen(),
  'FacialScanScreen': () => const FacialScanScreen(),
  'VerificationCompleteScreen': () => const VerificationCompleteScreen(),
  'WelcomeScreen': () => const WelcomeScreen(),
  'BrokerBookingsPage': () => const BrokerBookingsPage(),
  'BrokerDashboardPage': () => const BrokerDashboardPage(),
  'TierDashboardPage': () => const TierDashboardPage(),
  'BrokerTierUpgradePage': () => const BrokerTierUpgradePage(),
  'BrokerHomePage': () => const BrokerHomePage(),
  'BrokerMawsemPage': () => const BrokerMawsemPage(),
  'BrokerPortfolioPage': () => const BrokerPortfolioPage(),
  'ReferPropertyPage': () => const ReferPropertyPage(),
  'ReferralIssuePage': () => const ReferralIssuePage(),
  'ReferredPropertyDetailPage': () => const ReferredPropertyDetailPage(),
  'BrokerProfilePage': () => const BrokerProfilePage(),
  'BrokerServicesPage': () => const BrokerServicesPage(),
  'BrokerHistoryPage': () => const BrokerHistoryPage(),
  'BrokerWalletPage': () => const BrokerWalletPage(),
  'AddPropertyScreen': () => const AddPropertyScreen(),
  'MapPickerScreen': () => const MapPickerScreen(),
  'ListingSubmittedScreen': () => const ListingSubmittedScreen(),
  'OwnerAiChatScreen': () => const OwnerAiChatScreen(),
  'OwnerBookingsScreen': () => const OwnerBookingsScreen(),
  'OwnerEarningsScreen': () => const OwnerEarningsScreen(),
  'OwnerEditBioScreen': () => const OwnerEditBioScreen(),
  'OwnerHistoryScreen': () => const OwnerHistoryScreen(),
  'ViolationsScreen': () => const ViolationsScreen(),
  'OwnerHomeScreen': () => const OwnerHomeScreen(),
  'OwnerManageScreen': () => const OwnerManageScreen(),
  'PortfolioInsightsScreen': () => const PortfolioInsightsScreen(),
  'OwnerProfileScreen': () => const OwnerProfileScreen(),
  'OwnerPropertiesScreen': () => const OwnerPropertiesScreen(),
  'OwnerPropertyInsightsScreen': () => const OwnerPropertyInsightsScreen(),
  'OwnerEditPropertyScreen': () => const OwnerEditPropertyScreen(),
  'OwnerPreviewListingScreen': () => const OwnerPreviewListingScreen(),
  'OwnerRateGuestScreen': () => const OwnerRateGuestScreen(),
  'OwnerRequestsScreen': () => const OwnerRequestsScreen(),
  'OwnerRequestDetailScreen': () => const OwnerRequestDetailScreen(),
  'OwnerSmartLockScreen': () => const OwnerSmartLockScreen(),
  'PayoutBankScreen': () => const PayoutBankScreen(),
  'TeamReviewScreen': () => const TeamReviewScreen(),
  'ViolationReportScreen': () => const ViolationReportScreen(),
  'WithdrawAmountScreen': () => const WithdrawAmountScreen(),
  'WithdrawReceiptScreen': () => const WithdrawReceiptScreen(),
  'ChangePasswordScreen': () => const ChangePasswordScreen(),
  'ActiveBookingDetailScreen': () => const ActiveBookingDetailScreen(),
  'AddPaymentCardScreen': () => const AddPaymentCardScreen(),
  'AiChatScreen': () => const AiChatScreen(),
  'AllPropertiesScreen': () => const AllPropertiesScreen(),
  'ArrivalChecklistScreen': () => const ArrivalChecklistScreen(),
  'BookingConfirmedScreen': () => const BookingConfirmedScreen(),
  'BookingScreen': () => const BookingScreen(),
  'BrowseScreen': () => const BrowseScreen(),
  'CollectionChatScreen': () => const CollectionChatScreen(),
  'CollectionInsideScreen': () => const CollectionInsideScreen(),
  'CompareScreen': () => const CompareScreen(),
  'ConciergeScreen': () => const ConciergeScreen(),
  'CurrencyScreen': () => const CurrencyScreen(),
  'EditProfileScreen': () => const EditProfileScreen(),
  'HomeScreen': () => const HomeScreen(),
  'LanguageScreen': () => const LanguageScreen(),
  'LevelUpScreen': () => const LevelUpScreen(),
  'MawsemDashboardScreen': () => const MawsemDashboardScreen(),
  'MawsemLevelScreen': () => const MawsemLevelScreen(),
  'MyBookingsScreen': () => const MyBookingsScreen(),
  'MyReviewsScreen': () => const MyReviewsScreen(),
  'NotificationSettingsScreen': () => const NotificationSettingsScreen(),
  'ProfileScreen': () => const ProfileScreen(),
  'PropertyReviewsScreen': () => const PropertyReviewsScreen(),
  'ServicesScreen': () => const ServicesScreen(),
  'ShareCollectionScreen': () => const ShareCollectionScreen(),
  'ShareEarnScreen': () => const ShareEarnScreen(),
  'SosScreen': () => const SosScreen(),
  'StarNudgesScreen': () => const StarNudgesScreen(),
  'StarsEarnedScreen': () => const StarsEarnedScreen(),
  'TransactionHistoryScreen': () => const TransactionHistoryScreen(),
  'WalletScreen': () => const WalletScreen(),
  'WishlistScreen': () => const WishlistScreen(),
  'PastBookingDetailScreen (renter)': () =>
      const PastBookingDetailScreen(role: PastBookingRole.renter),
  'PastBookingDetailScreen (owner)': () =>
      const PastBookingDetailScreen(role: PastBookingRole.owner),
  'UpcomingBookingDetailScreen (renter)': () =>
      const UpcomingBookingDetailScreen(role: UpcomingBookingRole.renter),
  'UpcomingBookingDetailScreen (owner)': () =>
      const UpcomingBookingDetailScreen(role: UpcomingBookingRole.owner),
  'PropertyDetailScreen': () => const PropertyDetailScreen(
        propertyId: 'p1',
        propertyName: 'Azure Villa Marassi North Coast',
        propertyImage: _image,
        location: 'Marassi, North Coast',
        rating: 4.8,
        reviewCount: 124,
        pricePerNight: 4500,
      ),
  'WriteReviewScreen': () => const WriteReviewScreen(
        propertyName: 'Azure Villa Marassi North Coast',
        propertyImage: _image,
        stayDates: 'Jun 21 - Jun 25, 2026',
      ),
  'LevelUpCelebrationScreen': () => LevelUpCelebrationScreen(
        newLevel: 3,
        levelName: 'Explorer',
        levelIcon: Icons.star,
        levelColor: Colors.amber,
        unlockBenefit: '10% off cleaning fees',
        unlockRewardTitle: 'Free late checkout',
        unlockRewardDescription:
            'Enjoy a free late checkout on your next stay.',
        currentSeasonStars: 120,
        starsToNextLevel: 80,
        onShare: () {},
        onKeepExploring: () {},
      ),
  'SmartLockScreen': () => SmartLockScreen(
        propertyName: 'Azure Villa Marassi North Coast',
        bookingRef: 'SHL-2026-0042',
        checkIn: DateTime(2026, 6, 21, 15),
        checkOut: DateTime(2026, 6, 25, 11),
        propertyLat: 30.9,
        propertyLng: 28.9,
      ),
  'BrokerSmartLockScreen': () => BrokerSmartLockScreen(
        propertyName: 'Azure Villa Marassi North Coast',
        bookingRef: 'SHL-2026-0042',
        checkIn: DateTime(2026, 6, 21, 15),
        checkOut: DateTime(2026, 6, 25, 11),
        propertyLat: 30.9,
        propertyLng: 28.9,
      ),
  'PhotoViewerScreen': () => const PhotoViewerScreen(photos: [_image, _image]),
  'BrokerCollectionInsidePage': () => const BrokerCollectionInsidePage(
        collectionId: 'c1',
        collectionName: 'Summer 2026 shortlist',
        propertyCount: 4,
        sharedWithCount: 2,
        memberNames: ['Omar Khalil', 'Sara Adel'],
      ),
  'OtpScreen': () => OtpScreen(
        title: 'Verify your phone',
        phone: '+20 100 000 0000',
        icon: Icons.phone_iphone,
        hint: 'Enter the 6-digit code',
        cta: 'Verify',
        onVerify: () {},
        isPhone: true,
      ),
};

/// Widgets the app shows in a modal bottom sheet, with whether that sheet is
/// opened with isScrollControlled (full height) or the default 9/16 cap.
final Map<String, (Widget Function(), bool)> _sheets = {
  'LevelDetailSheet': (
    () => LevelDetailSheet(
          levelName: 'Explorer',
          levelIcon: Icons.star,
          levelColor: Colors.amber,
          starsRequired: 200,
          currentStars: 120,
          seasonPerks: const [
            LevelPerk(
                title: '10% off cleaning fees',
                subtitle: 'On every stay this season'),
            LevelPerk(
                title: 'Priority support', subtitle: 'Skip the queue in chat'),
            LevelPerk(
                title: 'Free late checkout',
                subtitle: 'Up to 2 PM, when available'),
          ],
          unlockReward: 'Free late checkout on your next stay',
          onClose: () {},
        ),
    true,
  ),
  'AddCreditSheet': (() => const AddCreditSheet(), true),
  'CreateCollectionSheet': (() => const CreateCollectionSheet(), true),
  'AddToCollectionSheet': (
    () => const AddToCollectionSheet(
          propertyId: 'p1',
          propertyName: 'Azure Villa Marassi North Coast',
          propertyImage: _image,
          role: Role.renter,
        ),
    true,
  ),
  'PayoutSelectionSheet': (
    () => PayoutSelectionSheet(onAddAccount: () {}),
    true
  ),
};

class _Config {
  const _Config(this.name, this.size, this.locale, {this.textScale = 1.0});

  final String name;
  final Size size; // logical pixels
  final Locale locale;
  final double textScale;
}

const _configs = [
  // iPhone SE (1st gen) - the narrowest phone still supported.
  _Config('en 320x568', Size(320, 568), Locale('en')),
  // Small / budget Android phones.
  _Config('en 360x640', Size(360, 640), Locale('en')),
  // Large system font (Accessibility > Larger text).
  _Config('en 320x568 font x1.3', Size(320, 568), Locale('en'), textScale: 1.3),
  // Longest translations.
  _Config('de 360x640', Size(360, 640), Locale('de')),
  _Config('ru 360x640', Size(360, 640), Locale('ru')),
  // Right-to-left.
  _Config('ar 360x640', Size(360, 640), Locale('ar')),
  // Narrow but tall, so lazy lists build more rows and every card is laid
  // out at the narrowest width.
  _Config('en 320x1600', Size(320, 1600), Locale('en')),
];

/// The default test font draws every glyph as a full square - far wider
/// than DM Sans - which would report overflows no real phone shows. Load a
/// real proportional font under the family names google_fonts asks for.
Future<void> _loadRealFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'] ?? '';
  String? firstExisting(List<String> paths) {
    for (final p in paths) {
      if (File(p).existsSync()) return p;
    }
    return null;
  }

  final regular = firstExisting([
    'C:/Windows/Fonts/arial.ttf',
    '/Library/Fonts/Arial.ttf',
    '$flutterRoot/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
  ]);
  final bold = firstExisting([
    'C:/Windows/Fonts/arialbd.ttf',
    '/Library/Fonts/Arial Bold.ttf',
    '$flutterRoot/bin/cache/artifacts/material_fonts/roboto-bold.ttf',
  ]);
  if (regular == null || bold == null) return; // Stricter square font.

  final r = ByteData.sublistView(File(regular).readAsBytesSync());
  final b = ByteData.sublistView(File(bold).readAsBytesSync());
  Future<void> load(String family, List<ByteData> fonts) {
    final loader = FontLoader(family);
    for (final font in fonts) {
      loader.addFont(Future.value(font));
    }
    return loader.load();
  }

  // google_fonts names one family per weight ("DMSans_700").
  for (final family in ['DMSans', 'DM Sans']) {
    for (var w = 100; w <= 900; w += 100) {
      final font = w >= 600 ? b : r;
      await load('${family}_${w == 400 ? 'regular' : '$w'}', [font]);
      await load('${family}_${w == 400 ? '' : '$w'}italic', [font]);
    }
  }
  // Plain family names used directly in TextStyles. The app never bundles a
  // font called "DM Sans", so on a phone these fall back to the system font
  // (Roboto / SF) - a regular + bold proportional font measures the same.
  for (final family in ['DM Sans', 'Roboto']) {
    await load(family, [r, b]);
  }
}

/// Opens [sheet] the way the app does, over a blank page.
class _SheetHost extends StatefulWidget {
  const _SheetHost(this.sheet, this.scrollControlled);

  final Widget Function() sheet;
  final bool scrollControlled;

  @override
  State<_SheetHost> createState() => _SheetHostState();
}

class _SheetHostState extends State<_SheetHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: widget.scrollControlled,
        backgroundColor: Colors.transparent,
        builder: (_) => widget.sheet(),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

Widget _app(Widget screen, _Config config) {
  final router = GoRouter(
    routes: [GoRoute(path: '/', builder: (_, __) => screen)],
    // Navigation away from the screen under test lands on a blank page.
    errorBuilder: (_, __) => const SizedBox.shrink(),
  );
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: sl<AuthProvider>()),
      ChangeNotifierProvider(create: (_) => RoleState()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ChangeNotifierProvider(create: (_) => BookingsProvider()),
      ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<VerificationCubit>()),
        BlocProvider(create: (_) => sl<WishlistCubit>()),
        BlocProvider(create: (_) => sl<BrokerHomeCubit>()),
        BlocProvider(create: (_) => sl<BrokerBookingsCubit>()),
        BlocProvider(create: (_) => sl<OwnerHomeCubit>()),
        BlocProvider(create: (_) => sl<RenterHomeCubit>()),
        BlocProvider(create: (_) => sl<SearchCubit>()),
        BlocProvider(create: (_) => sl<BookingsCubit>()),
        BlocProvider(create: (_) => sl<ReviewCubit>()),
        BlocProvider(create: (_) => sl<ProfileCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        locale: config.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    ),
  );
}

final _sourceRef = RegExp(r'(lib/[A-Za-z0-9_/]+[.]dart):([0-9]+)');

/// Layout failures: overflows, plus the errors a broken responsive fix
/// produces (intrinsic sizing over a LayoutBuilder, unbounded flex, ...).
/// Anything else - failed image downloads, missing platform plugins in the
/// test environment - is not a layout problem and is ignored here.
bool _isLayoutError(String message) => const [
      'overflowed',
      'intrinsic',
      'was not laid out',
      'unbounded',
      'non-zero flex',
      'Incorrect use of ParentDataWidget',
    ].any(message.contains);

Future<void> _expectFitsEveryPhone(
    WidgetTester tester, Widget Function() build) async {
  final problems = <String>{};
  final previous = FlutterError.onError;
  var config = _configs.first;
  FlutterError.onError = (details) {
    final message = details.exceptionAsString();
    if (!_isLayoutError(message)) return;
    final where = _sourceRef.firstMatch(details.toString());
    problems.add('[${config.name}] ${message.split('\n').first.trim()}'
        '${where == null ? '' : ' at ${where.group(1)}:${where.group(2)}'}');
  };
  try {
    for (final c in _configs) {
      config = c;
      tester.view
        ..devicePixelRatio = 3
        ..physicalSize = c.size * 3
        ..padding = const FakeViewPadding(top: 24 * 3)
        ..viewPadding = const FakeViewPadding(top: 24 * 3);
      tester.platformDispatcher.textScaleFactorTestValue = c.textScale;
      await tester.pumpWidget(_app(build(), c));
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 400));
      }
      await tester.pumpWidget(const SizedBox.shrink());
    }
    // Let retries / debounces started by the screens run out.
    await tester.pump(const Duration(minutes: 2));
  } finally {
    FlutterError.onError = previous;
    tester.view.reset();
    tester.platformDispatcher.clearAllTestValues();
  }
  expect(problems, isEmpty, reason: '\n${problems.join('\n')}');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
    await sl.reset();
    await di.init();
    await _loadRealFonts();
  });

  const timeout = Timeout(Duration(minutes: 3));

  group('screen', () {
    for (final entry in _screens.entries) {
      testWidgets('${entry.key} fits every phone',
          (tester) => _expectFitsEveryPhone(tester, entry.value),
          timeout: timeout);
    }
  });

  group('bottom sheet', () {
    for (final entry in _sheets.entries) {
      final (build, scrollControlled) = entry.value;
      testWidgets(
          '${entry.key} fits every phone',
          (tester) => _expectFitsEveryPhone(
              tester, () => _SheetHost(build, scrollControlled)),
          timeout: timeout);
    }
  });
}
