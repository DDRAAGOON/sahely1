import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:sahely/features/renter/presentation/screens/home/widgets/renter_bottom_nav.dart';
import 'package:sahely/core/theme/app_colors.dart';

class RenterShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RenterShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RenterShell> createState() => _RenterShellState();
}

class _RenterShellState extends State<RenterShell> {
  DateTime? _lastBackPressTime;

  void _onTabChanged(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (widget.navigationShell.currentIndex != 0) {
          _onTabChanged(0);
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Tap again to exit'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            ),
          );
          return;
        }
        
        // Use standard way to close app if on home and tapped twice
        SystemNavigator.pop(); 
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Stack(
          children: [
            widget.navigationShell,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RenterBottomNav(
                activeIndex: widget.navigationShell.currentIndex,
                onTap: _onTabChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

