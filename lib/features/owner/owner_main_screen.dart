import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/navigation_provider.dart';
import 'dashboard/presentation/pages/owner_dashboard_page.dart';
import 'properties/presentation/pages/owner_properties_page.dart';
import 'bookings/presentation/pages/owner_bookings_page.dart';
import 'earnings/presentation/pages/owner_earnings_page.dart';
import '../shared/profile/presentation/pages/profile_page.dart';
import '../shared/widgets/floating_nav.dart';

class OwnerMainScreen extends StatefulWidget {
  const OwnerMainScreen({super.key});

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen> {
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
        return const OwnerDashboardPage();
      case 1:
        return const OwnerPropertiesPage();
      case 2:
        return const OwnerBookingsPage();
      case 3:
        return const OwnerEarningsPage();
      case 4:
        return const ProfilePage();
      default:
        return const OwnerDashboardPage();
    }
  }
}
