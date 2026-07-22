import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sahely/features/owner/widgets/owner_bottom_nav.dart';
import 'package:sahely/core/theme/app_colors.dart';

class OwnerShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const OwnerShell({
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
          // The current tab's screen
          navigationShell,

          // The persistent floating navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OwnerBottomNav(
              activeIndex: navigationShell.currentIndex,
              onTap: _onTabChanged,
            ),
          ),
        ],
      ),
      extendBody: true,
    );
  }
}
