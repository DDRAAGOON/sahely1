import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/navigation_provider.dart';
import 'presentation/widgets/broker_bottom_nav.dart';
import 'dashboard/presentation/pages/broker_dashboard_page.dart';
import 'clients/presentation/pages/broker_clients_page.dart';
import 'commissions/presentation/pages/broker_commissions_page.dart';
import 'referrals/presentation/pages/broker_referrals_page.dart';
import 'presentation/screens/profile/pages/broker_profile_page.dart';

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
        return const BrokerDashboardPage();
      case 1:
        return const BrokerClientsPage();
      case 2:
        return const BrokerReferralsPage();
      case 3:
        return const BrokerCommissionsPage();
      case 4:
        return const BrokerProfilePage();
      default:
        return const BrokerDashboardPage();
    }
  }
}
