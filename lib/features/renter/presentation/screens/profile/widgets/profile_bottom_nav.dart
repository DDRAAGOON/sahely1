import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ProfileBottomNav extends StatelessWidget {
  final int activeIndex;

  const ProfileBottomNav({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.favorite_border, label: 'Wishlist'),
      _NavItem(icon: Icons.calendar_today, label: 'Bookings'),
      _NavItem(icon: Icons.notifications_outlined, label: 'Services'),
      _NavItem(icon: Icons.person, label: 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      height: 62,
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.35),
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
                          ? AppColors.gold
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index].label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? AppColors.gold
                            : Colors.white.withValues(alpha: 0.5),
                        fontFamily: 'DM Sans',
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
