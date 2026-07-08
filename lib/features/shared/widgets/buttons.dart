import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

/// Full-width navy CTA button (52px tall, 12px radius) — the default action.
class NavyButton extends StatelessWidget {
  const NavyButton({
    super.key,
    required this.label,
    this.onTap,
    this.radius = 12,
    this.enabled = true,
    this.height = 52,
    this.width,
    this.outline = false,
  });

  final String label;
  final VoidCallback? onTap;
  final double radius;
  final bool enabled;
  final double height;
  final double? width;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: outline ? Colors.transparent : AppColors.navy,
            foregroundColor: outline ? AppColors.navy : AppColors.white,
            disabledBackgroundColor: outline ? Colors.transparent : AppColors.navy,
            disabledForegroundColor: outline ? AppColors.navy : AppColors.white,
            elevation: 0,
            side: outline ? const BorderSide(color: AppColors.navy, width: 1.5) : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          ),
          child: Text(
            label,
            style: AppTheme.dm(
              size: 15,
              weight: FontWeight.w700,
              color: outline ? AppColors.navy : AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width gold CTA button — used for primary "delight" actions.
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    this.onTap,
    this.radius = 12,
  });

  final String label;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [BoxShadow(color: Color(0x59C9A84C), blurRadius: 16, offset: Offset(0, 4))],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.navy,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          ),
          child: Text(label, style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
        ),
      ),
    );
  }
}

/// Rounded square "‹" back chip.
class BackChip extends StatelessWidget {
  const BackChip({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.chevron_left, size: 22, color: AppColors.navy),
      ),
    );
  }
}

class IconCircleButton extends StatelessWidget {
  const IconCircleButton({super.key, required this.icon, this.onTap, this.bg = AppColors.white, this.fg = AppColors.navy, this.size = 34});
  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final double size;
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: fg),
      ),
    );
  }
}
