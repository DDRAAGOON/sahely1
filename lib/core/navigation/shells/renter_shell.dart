import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/renter/presentation/screens/home/widgets1/renter_bottom_nav.dart';
import '../../theme/app_colors.dart';

class RenterShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RenterShell({
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
      bottomNavigationBar: RenterBottomNav(
        activeIndex: navigationShell.currentIndex,
        onTap: _onTabChanged,
      ),
      extendBody: true,
    );
  }
}
