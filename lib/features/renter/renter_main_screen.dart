import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/navigation_provider.dart';
import 'home/presentation/pages/renter_home_page.dart';
import 'wishlist/presentation/pages/renter_wishlist_page.dart';
import '../shared/screens/my_bookings_screen.dart';
import '../shared/screens/services_screen.dart';
import '../shared/profile/presentation/pages/profile_page.dart';
import '../shared/widgets/floating_nav.dart';

class RenterMainScreen extends StatefulWidget {
  const RenterMainScreen({super.key});

  @override
  State<RenterMainScreen> createState() => _RenterMainScreenState();
}

class _RenterMainScreenState extends State<RenterMainScreen> {
  void _onTabChanged(int index) {
    context.read<NavigationProvider>().setTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, child) {
        final currentTab = nav.currentTabIndex;
        return Scaffold(
          backgroundColor: AppColors.cream,
          body: Stack(
            children: [
              _buildBody(currentTab),
              FloatingNav(
                active: currentTab,
                onTap: (index, item) => _onTabChanged(index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(int currentTab) {
    switch (currentTab) {
      case 0:
        return const RenterHomePage();
      case 1:
        return const RenterWishlistPage();
      case 2:
        return const MyBookingsScreen(showNav: false);
      case 3:
        return const ServicesScreen(showNav: false);
      case 4:
        return const ProfilePage();
      default:
        return const RenterHomePage();
    }
  }
}
