import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class GuestCounterRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool canDecrement;

  const GuestCounterRow({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    size: 15,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.dm(
                    size: 12,
                    color: AppColors.secondary,
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
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border : null,
                  ),
                  child: Icon(
                    Icons.remove,
                    size: 18,
                    color: canDecrement ? AppColors.navy : AppColors.border,
                  ),
                ),
              ),
              const SizedBox(width: 20),
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
              const SizedBox(width: 20),
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 18,
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
