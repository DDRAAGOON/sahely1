import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class SahelyAiSuggestion extends StatelessWidget {
  final String suggestion;

  const SahelyAiSuggestion({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF0), // Light gold/cream background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // AI Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.navy,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          // Text
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.dark,
                  fontFamily: 'DM Sans',
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Sahely AI: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  TextSpan(text: 'Reach out to Tarek — a quick morning re-shoot usually clears this within a day.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
