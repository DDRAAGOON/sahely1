import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/providers/navigation_provider.dart';
import 'package:sahely/features/broker/presentation/widgets/broker_bottom_nav.dart';
import 'package:sahely/features/broker/presentation/screens/home/pages/broker_home_page.dart';
import 'package:sahely/features/broker/presentation/screens/wishlist/pages/broker_wishlist_page.dart';
import 'package:sahely/features/broker/presentation/screens/bookings/pages/broker_bookings_page.dart';
import 'package:sahely/features/broker/presentation/screens/services/pages/broker_services_page.dart';
import 'package:sahely/features/broker/presentation/screens/profile/pages/broker_profile_page.dart';

class BrokerMainScreen extends StatefulWidget {
  const BrokerMainScreen({super.key});

  @override
  State<BrokerMainScreen> createState() => _BrokerMainScreenState();
}

class _BrokerMainScreenState extends State<BrokerMainScreen> {
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
          body: _buildBody(currentTab),
          bottomNavigationBar: BrokerBottomNav(
            activeIndex: currentTab,
            onTap: _onTabChanged,
          ),
          extendBody: true,
        );
      },
    );
  }

  Widget _buildBody(int currentTab) {
    switch (currentTab) {
      case 0:
        return const BrokerHomePage();
      case 1:
        return const BrokerWishlistPage();
      case 2:
        return const BrokerBookingsPage();
      case 3:
        return const BrokerServicesPage();
      case 4:
        return const BrokerProfilePage();
      default:
        return const BrokerHomePage();
    }
  }
}
