import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

/// Simple top app bar: back button + title (+ optional subtitle / trailing).
class TopBar extends StatelessWidget {
  const TopBar(
      {super.key,
      required this.title,
      this.subtitle,
      this.trailing,
      this.onBack,
      this.showBack = true});

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showBack) ...[
          BouncyButton(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left,
                  size: 22, color: AppColors.navy),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: AppTheme.dm(
                      size: 22,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              if (subtitle != null)
                Text(subtitle!,
                    style: AppTheme.dm(size: 12, color: AppColors.muted)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
