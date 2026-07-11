import 'package:flutter/material.dart';

class LevelHeader extends StatelessWidget {
  final String levelName;
  final IconData levelIcon;
  final Color levelColor;
  final int starsRequired;
  final VoidCallback onClose;

  const LevelHeader({
    super.key,
    required this.levelName,
    required this.levelIcon,
    required this.levelColor,
    required this.starsRequired,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Level Icon with Gradient and Shadow
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  levelColor.withValues(alpha: 0.8),
                  levelColor,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: levelColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              levelIcon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          // Level Name & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  levelName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1B2744),
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$starsRequired ★ to unlock',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF717171),
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
          // Close Button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFF1F2937),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
