import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final double? width;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final double? borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
    this.width,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onPressed,
      child: SizedBox(
        width: width ?? double.infinity,
        height: 54,
        child: outlined
            ? OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: borderColor ?? AppColors.primary,
                    width: borderWidth ?? 1.5,
                  ),
                  backgroundColor: backgroundColor ?? Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  ),
                ),
                child: Text(
                  text,
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: textColor ?? AppColors.navy,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  ),
                ),
                child: Text(
                  text,
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: textColor ?? Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
