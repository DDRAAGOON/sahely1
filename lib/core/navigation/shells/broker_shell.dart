import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/broker/presentation/widgets/broker_bottom_nav.dart';
import '../../theme/app_colors.dart';

class BrokerShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BrokerShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabChanged(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: navigationShell,
      bottomNavigationBar: BrokerBottomNav(
        activeIndex: navigationShell.currentIndex,
        onTap: _onTabChanged,
      ),
      extendBody: true,
    );
  }
}
