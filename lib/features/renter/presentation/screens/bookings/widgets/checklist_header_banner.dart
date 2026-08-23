import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ChecklistHeaderBanner extends StatelessWidget {
  final Duration timeRemaining;
  final int starsEarned;

  const ChecklistHeaderBanner({
    super.key,
    required this.timeRemaining,
    required this.starsEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2744),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Clock Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.access_time,
              color: Color(0xFFC9A84C),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Open for 1h 24m',
                style: AppTheme.dm(
                  size: 16,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: AppTheme.dm(
                    size: 12,
                    color: const Color(0xFFB8C4E0),
                    height: 1.3,
                  ),
                  children: [
                    const TextSpan(text: 'Complete within '),
                    TextSpan(
                      text: '2h of check-in',
                      style: AppTheme.dm(
                        size: 12,
                        color: const Color(0xFFC9A84C),
                        weight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                        text: ' — confirms the home matched the listing.'),
                  ],
                ),
              ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Stars Badge
          Column(
            children: [
              Text(
                '+$starsEarned',
                style: AppTheme.dm(
                  size: 20,
                  weight: FontWeight.w700,
                  color: const Color(0xFFC9A84C),
                ),
              ),
              Text(
                'stars',
                style: AppTheme.dm(
                  size: 10,
                  color: const Color(0xFFC9A84C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
