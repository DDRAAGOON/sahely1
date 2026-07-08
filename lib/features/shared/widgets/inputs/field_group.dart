import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class FieldGroup extends StatelessWidget {
  const FieldGroup({
    super.key, 
    this.label, 
    required this.child, 
    this.trailingLabel, 
    this.labelWidget
  });

  final String? label;
  final Widget child;
  final Widget? trailingLabel;
  final Widget? labelWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (labelWidget != null)
                labelWidget!
              else
                Text(
                  label ?? '', 
                  style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.navy)
                ),
              if (trailingLabel != null) trailingLabel!,
            ],
          ),
        ),
        child,
      ],
    );
  }
}
