import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/navigation_provider.dart';
import '../../core/theme/app_colors.dart';
import '../shared/widgets/floating_nav.dart';
import 'broker_screens_stubs.dart';
import 'dashboard/presentation/pages/broker_dashboard_page.dart';

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