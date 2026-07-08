import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'upcoming_checkin_card.dart';

class UpcomingCheckinsSection extends StatelessWidget {
  final List<Map<String, dynamic>> checkins;
  final Function(Map<String, dynamic>) onCheckinTap;

  const UpcomingCheckinsSection({
    super.key,
    required this.checkins,
    required this.onCheckinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Check-ins',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 12),
          ...checkins.map((checkin) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: UpcomingCheckinCard(
                checkin: checkin,
                onTap: () => onCheckinTap(checkin),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
