import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SahelyIconButton extends StatelessWidget {
  const SahelyIconButton({
    super.key, 
    required this.icon, 
    this.onTap, 
    this.bg = AppColors.white, 
    this.fg = AppColors.navy, 
    this.size = 40,
    this.iconSize = 20,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          border: bg == AppColors.white ? Border.all(color: AppColors.border) : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: iconSize, color: fg),
      ),
    );
  }
}
