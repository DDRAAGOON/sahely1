import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class WhiteCard extends StatelessWidget {
  const WhiteCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.symmetric(horizontal: 14),
      this.radius = 14});

  final Widget child;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F1B2744), blurRadius: 12, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard(
      {super.key,
      required this.value,
      required this.label,
      this.valueColor = AppColors.navy,
      this.dark = false,
      this.onTap});

  final String value;
  final String label;
  final Color valueColor;
  final bool dark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: dark ? Colors.white.withValues(alpha: 0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: dark
              ? null
              : const [
                  BoxShadow(
                      color: Color(0x0F1B2744),
                      blurRadius: 12,
                      offset: Offset(0, 2))
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: AppTheme.dm(
                    size: 17, weight: FontWeight.w700, color: valueColor)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTheme.dm(
                    size: 11, color: dark ? Colors.white70 : AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.cards});

  final List<StatCard> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i < cards.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
