import 'package:flutter/material.dart';
import 'package:sahely/features/renter/renter_home.dart';
import 'screens/renter_profile_screen.dart';
import 'screens/my_reviews_screen.dart';
import 'screens/renter_wallet_screen.dart';
import 'screens/renter_history_screen.dart';

export 'screens/renter_profile_screen.dart';
export 'screens/my_reviews_screen.dart';
export 'screens/renter_wallet_screen.dart';
export 'screens/renter_history_screen.dart';

final Map<String, WidgetBuilder> renterRoutes = {
  '/renter/home': (_) => const RenterHomeScreen(),
  '/renter/profile': (_) => const RenterProfileScreen(),
  '/renter/reviews': (_) => const MyReviewsScreen(),
  '/renter/wallet': (_) => const RenterWalletScreen(),
  '/renter/history': (_) => const RenterHistoryScreen(),
};
