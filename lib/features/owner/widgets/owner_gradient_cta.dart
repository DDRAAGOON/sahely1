import 'package:flutter/material.dart';
import 'package:sahely/theme/app_colors.dart';
import 'package:sahely/theme/app_theme.dart';

class OwnerGradientCta extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final List<Color> colors;

  const OwnerGradientCta({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.dm(size: 11, color: AppColors.gold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gold),
          ],
        ),
      ),
    );
  }
}
