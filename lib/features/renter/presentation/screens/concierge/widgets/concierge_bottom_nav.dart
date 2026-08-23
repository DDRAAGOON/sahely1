import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ConciergeBottomNav extends StatelessWidget {
  final int activeIndex;

  const ConciergeBottomNav({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.favorite_border, label: 'Wishlist'),
      _NavItem(icon: Icons.calendar_today, label: 'Bookings'),
      _NavItem(icon: Icons.notifications, label: 'Services'),
      _NavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(28),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = index == activeIndex;
              return GestureDetector(
                onTap: () {
                  // Navigate to tab
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index].icon,
                      size: 23,
                      color: isActive
                          ? AppColors.navy
                          : AppColors.navy.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index].label,
                      style: AppTheme.dm(
                        size: 11,
                        weight: FontWeight.w600,
                        color: isActive
                            ? AppColors.navy
                            : AppColors.navy.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
