import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BrokerBottomNav extends StatelessWidget {
  const BrokerBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home, label: 'Home', isActive: true),
      _NavItem(icon: Icons.favorite_border, label: 'Wishlist'),
      _NavItem(icon: Icons.calendar_today, label: 'Bookings'),
      _NavItem(icon: Icons.notifications_outlined, label: 'Services'),
      _NavItem(icon: Icons.home_work_outlined, label: 'My Role'),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                // Navigate to tab
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 23,
                    color: item.isActive
                        ? AppColors.gold
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: item.isActive
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
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool isActive;
  _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });
}
