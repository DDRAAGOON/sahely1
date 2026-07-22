import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class VerificationProgressIndicator extends StatelessWidget {
  final int currentStep; // 1-4

  const VerificationProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    // Labels match the screen design
    final stepLabels = ['Email', 'Phone', 'Identity', 'Card'];

    return Row(
      children: List.generate(stepLabels.length, (index) {
        final stepNumber = index + 1;
        final isDone = stepNumber < currentStep;
        final isCurrent = stepNumber == currentStep;

        Color barColor;
        Color textColor;
        String label = stepLabels[index];

        if (isDone) {
          barColor = AppColors.navy;
          textColor = AppColors.levelUnlockedText; // Greenish
          label += ' ✓';
        } else if (isCurrent) {
          barColor = AppColors.warning; // Orange/Gold
          textColor = AppColors.warning;
        } else {
          barColor = AppColors.border;
          textColor = AppColors.secondary;
        }

        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(right: index == stepLabels.length - 1 ? 0 : 8),
            child: Column(
              children: [
                // Progress Bar
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                // Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
