import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_theme.dart';

class SubmitChecklistBanner extends StatelessWidget {
  final int starsEarned;
  final String collectionName;

  const SubmitChecklistBanner({
    super.key,
    required this.starsEarned,
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF3DE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1E4C2)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A84C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.star,
              color: Color(0xFF1B2744),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTheme.dm(
                  size: 13,
                  color: const Color(0xFF1B2744),
                ),
                children: [
                  const TextSpan(text: 'Submit your checklist to earn '),
                  TextSpan(
                    text: '+$starsEarned Sahel Stars',
                    style: AppTheme.dm(
                      weight: FontWeight.w700,
                      color: const Color(0xFFA08050),
                      size: 13,
                    ),
                  ),
                  TextSpan(text: ' on $collectionName.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
