import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:sahely/features/broker/presentation/widgets/upcoming_checkin_card.dart';

class UpcomingCheckinsSection extends StatelessWidget {
  final List<Map<String, dynamic>> checkins;
  final VoidCallback onSeeAllTap;
  final Function(Map<String, dynamic>) onCheckinTap;

  const UpcomingCheckinsSection({
    super.key,
    required this.checkins,
    required this.onSeeAllTap,
    required this.onCheckinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Check-ins',
                style: AppTheme.dm(
                  size: 16,
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              BouncyButton(
                onTap: onSeeAllTap,
                child: Text(
                  'See All',
                  style: AppTheme.dm(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Check-in Cards
          ...checkins.map((checkin) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: UpcomingCheckinCard(
                checkin: checkin,
                onTap: () => onCheckinTap(checkin),
              ),
            );
          }),
        ],
      ),
    );
  }
}