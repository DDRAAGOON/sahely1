import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

enum ButtonVariant { navy, gold, outline, danger }

class SahelyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final double? width;
  final double height;
  final bool isLoading;
  final IconData? icon;

  const SahelyButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.navy,
    this.width,
    this.height = 52,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color fgColor;
    BorderSide? border;

    switch (variant) {
      case ButtonVariant.gold:
        bgColor = AppColors.gold;
        fgColor = AppColors.navy;
        break;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.navy;
        border = const BorderSide(color: AppColors.navy, width: 1.5);
        break;
      case ButtonVariant.danger:
        bgColor = AppColors.error;
        fgColor = Colors.white;
        break;
      case ButtonVariant.navy:
      default:
        bgColor = AppColors.navy;
        fgColor = Colors.white;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          side: border,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Cairo'),
                  ),
                ],
              ),
      ),
    );
  }
}
