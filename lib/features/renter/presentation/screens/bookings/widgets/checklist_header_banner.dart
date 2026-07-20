import 'package:flutter/material.dart';

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
                const Text(
                  'Open for 1h 24m',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB8C4E0),
                      fontFamily: 'DM Sans',
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(text: 'Complete within '),
                      TextSpan(
                        text: '2h of check-in',
                        style: TextStyle(
                          color: Color(0xFFC9A84C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC9A84C),
                  fontFamily: 'DM Sans',
                ),
              ),
              const Text(
                'stars',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFC9A84C),
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
