import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class WalletStatsTiles extends StatelessWidget {
  final int addedThisSeason; // In piastres
  final int openViolations;

  const WalletStatsTiles({
    super.key,
    required this.addedThisSeason,
    required this.openViolations,
  });

  @override
  Widget build(BuildContext context) {
    final egpAdded = addedThisSeason / 100;

    return Row(
      children: [
        // Added this season tile
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Added this season',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'EGP ${egpAdded.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Open violations tile
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Open violations',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$openViolations',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
