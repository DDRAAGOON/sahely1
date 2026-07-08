import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PropertyCircleBtn extends StatelessWidget {
  const PropertyCircleBtn({super.key, required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: AppColors.navy),
      ),
    );
  }
}

class PropertyMetaChip extends StatelessWidget {
  const PropertyMetaChip({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.cardWarm, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.navy),
          const SizedBox(width: 5),
          Text(label, style: AppTheme.dm(size: 13)),
        ],
      ),
    );
  }
}

class PropertyFeature extends StatelessWidget {
  const PropertyFeature({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.navy),
        const SizedBox(width: 8),
        Text(label, style: AppTheme.dm(size: 13)),
      ],
    );
  }
}
