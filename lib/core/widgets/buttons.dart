import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

/// Standard dark navy primary button.
class NavyButton extends StatelessWidget {
  const NavyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.outline = false,
    this.radius = 16,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool outline;
  final double radius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: IgnorePointer(
            ignoring: !enabled,
            child: ElevatedButton(
              onPressed: enabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: outline ? Colors.transparent : AppColors.navy,
                foregroundColor: outline ? AppColors.navy : Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: outline
                      ? const BorderSide(color: AppColors.navy, width: 1.5)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: Text(
                label,
                style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: outline ? AppColors.navy : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gold action button.
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.color,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: enabled ? onTap : null,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: enabled ? AppColors.goldButtonShadow : const [],
          ),
          child: IgnorePointer(
            ignoring: !enabled,
            child: ElevatedButton(
              onPressed: enabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? AppColors.gold,
                foregroundColor: AppColors.navy,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(label,
                  style: AppTheme.dm(
                      size: 16,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating back button chip.
class BackChip extends StatelessWidget {
  const BackChip({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 42,
        height: 42,
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

/// Circular icon action button.
class IconCircleButton extends StatelessWidget {
  const IconCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.bg = AppColors.white,
    this.fg = AppColors.navy,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
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
