import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class WideButton extends StatelessWidget {
  const WideButton(
      {super.key,
      required this.label,
      this.color = AppColors.navy,
      this.textColor = AppColors.white,
      this.outline = false,
      this.icon,
      this.onTap,
      this.height = 52,
      this.radius = 12});

  final String label;
  final Color color;
  final Color textColor;
  final bool outline;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : color,
          border: outline ? Border.all(color: color, width: 1.5) : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: outline ? color : textColor),
              const SizedBox(width: 8)
            ],
            Text(label,
                style: AppTheme.dm(
                    size: 15,
                    weight: FontWeight.w700,
                    color: outline ? color : textColor)),
          ],
        ),
      ),
    );
  }
}

class ReviewButton extends StatelessWidget {
  const ReviewButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
            color: const Color(0xFFFDF9F4),
            border: Border.all(color: const Color(0xFFC9A84C), width: 1.2),
            borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.center,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.star, size: 18, color: Color(0xFFC9A84C)),
          const SizedBox(width: 10),
          Text('Add a review · earn +5 ★',
              style: AppTheme.dm(
                  size: 14,
                  weight: FontWeight.w700,
                  color: const Color(0xFF9A7A22))),
        ]),
      ),
    );
  }
}
