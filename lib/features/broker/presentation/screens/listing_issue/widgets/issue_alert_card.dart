import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class IssueAlertCard extends StatelessWidget {
  final String title;
  final String flaggedBy;
  final String flaggedDate;

  const IssueAlertCard({
    super.key,
    required this.title,
    required this.flaggedBy,
    required this.flaggedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0), // Light red/pink background
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Warning Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$flaggedBy · $flaggedDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
