import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sahely/features/renter/presentation/screens/home/widgets/renter_bottom_nav.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RenterBottomNav(
              activeIndex: navigationShell.currentIndex,
              onTap: _onTabChanged,
            ),
          ),
        ],
      ),
    );
  }
}
