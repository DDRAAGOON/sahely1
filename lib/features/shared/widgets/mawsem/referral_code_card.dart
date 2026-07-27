import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ReferralCodeCard extends StatelessWidget {
  final String referralCode;

  const ReferralCodeCard({super.key, required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy, // Background #1b2744
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Glow Circle - Bottom Right (Soft Gradient Style)
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6B644C).withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Row(
                  children: [
                    Icon(
                      Icons.copy_all_outlined, // Matching icon style
                      color: AppColors.gold,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Your referral code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Code + Copy Button Row
                Row(
                  children: [
                    // Dashed Box for Code
                    Expanded(
                      child: CustomPaint(
                        painter: DashedRectPainter(
                          color: AppColors.gold.withValues(alpha: 0.5),
                          strokeWidth: 1.5,
                          gap: 4,
                        ),
                        child: Container(
                          height: 54,
                          padding: const EdgeInsets.only(left: 18),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: AppColors.referralBoxBg,
                            // Background #323d57
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            referralCode,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                              fontFamily: 'DM Sans',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Copy Button
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: referralCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Referral code copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.copy_all, // Matching icon
                          color: AppColors.navy,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFFB8C4E0),
                      fontFamily: 'DM Sans',
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'Share it — when a friend you refer '),
                      TextSpan(
                        text: 'books & completes a stay',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      TextSpan(text: ' you earn '),
                      TextSpan(
                        text: '+15★',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: AppColors.gold),
                      ),
                      TextSpan(text: '. Refer an '),
                      TextSpan(
                        text: 'owner who lists',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      TextSpan(text: ' and earn '),
                      TextSpan(
                        text: '+50★',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: AppColors.gold),
                      ),
                      TextSpan(text: '. No stars for signups alone.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromLTRBR(
          0, 0, size.width, size.height, const Radius.circular(12)));

    // Drawing dashed path
    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
