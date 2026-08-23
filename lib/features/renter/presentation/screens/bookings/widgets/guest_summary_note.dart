import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class GuestSummaryNote extends StatelessWidget {
  final int totalGuests;
  final int adults;
  final int children;

  const GuestSummaryNote({
    super.key,
    required this.totalGuests,
    required this.adults,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    String guestText = '$totalGuests guest${totalGuests > 1 ? 's' : ''}';
    if (adults > 0 || children > 0) {
      guestText += ' · $adults adult${adults > 1 ? 's' : ''}';
      if (children > 0) {
        guestText += ', $children child${children > 1 ? 'ren' : ''}';
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline,
              size: 16,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$guestText — the host is notified of your party size',
              style: AppTheme.dm(
                size: 12,
                color: AppColors.navy,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
