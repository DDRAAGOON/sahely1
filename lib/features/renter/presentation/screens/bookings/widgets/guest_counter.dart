import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class GuestCounter extends StatelessWidget {
  final String label;
  final String subtitle;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool canDecrement;

  const GuestCounter({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.canDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          // Label & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.dm(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.dm(
                    size: 11,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          // Counter Buttons
          Row(
            children: [
              GestureDetector(
                onTap: canDecrement ? onDecrement : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: canDecrement ? AppColors.white : AppColors.faint,
                    shape: BoxShape.circle,
                    border: Border.all(color: canDecrement ? AppColors.navy : AppColors.borderDefault),
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 16,
                    color: canDecrement ? AppColors.navy : AppColors.borderDefault,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 24,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
