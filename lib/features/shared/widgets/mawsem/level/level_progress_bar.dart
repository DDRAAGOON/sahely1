import 'package:flutter/material.dart';

class LevelProgressBar extends StatelessWidget {
  final int currentStars;
  final int starsRequired;
  final Color levelColor;

  const LevelProgressBar({
    super.key,
    required this.currentStars,
    required this.starsRequired,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    final int starsNeeded = (starsRequired - currentStars).clamp(0, 999999);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1EDE4), // Specific cream/beige from image
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '$starsNeeded ★ more to unlock',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF717171),
              fontFamily: 'DM Sans',
            ),
          ),
        ),
      ),
    );
  }
}
