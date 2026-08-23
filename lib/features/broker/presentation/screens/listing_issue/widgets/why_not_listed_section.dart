import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class WhyNotListedSection extends StatelessWidget {
  final String explanation;

  const WhyNotListedSection({
    super.key,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Why it isn\'t listed yet',
            style: AppTheme.dm(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          // Explanation Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: RichText(
              text: TextSpan(
                style: AppTheme.dm(
                  size: 13,
                  color: AppColors.dark,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'The review team paused this listing because the current photos don\'t meet Sahely\'s quality bar — they\'re low-light and don\'t show the full space, so guests can\'t see what they\'re booking. The listing stays ',
                  ),
                  TextSpan(
                    text: 'offline',
                    style: AppTheme.dm(
                      weight: FontWeight.w700,
                      color: AppColors.red,
                    ),
                  ),
                  const TextSpan(
                    text: ' until the items above are added and it passes a re-review (about 24h). No commission is earned while a referred property is offline.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}