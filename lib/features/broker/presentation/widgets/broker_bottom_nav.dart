import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BrokerBottomNav extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTap;
  const BrokerBottomNav({super.key, required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(activeIcon: Icons.home_filled, inactiveIcon: Icons.home_outlined, label: 'Home'),
      _NavItem(activeIcon: Icons.favorite, inactiveIcon: Icons.favorite_border, label: 'Wishlist'),
      _NavItem(activeIcon: Icons.calendar_month, inactiveIcon: Icons.calendar_today_outlined, label: 'Bookings'),
      _NavItem(activeIcon: Icons.room_service, inactiveIcon: Icons.room_service_outlined, label: 'Services'),
      _NavItem(activeIcon: Icons.person, inactiveIcon: Icons.person_outline, label: 'My Role'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
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
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? items[index].activeIcon : items[index].inactiveIcon,
                        size: 23,
                        color: isActive
                            ? AppColors.navy
                            : AppColors.navy.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.navy
                              : AppColors.navy.withValues(alpha: 0.4),
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
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
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  _NavItem({required this.activeIcon, required this.inactiveIcon, required this.label});
}
