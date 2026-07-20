import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key,
      required this.title,
      this.action = 'See All',
      this.onAction,
      this.size = 18});

  final String title;
  final String? action;
  final VoidCallback? onAction;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTheme.dm(
                size: size, weight: FontWeight.w600, color: AppColors.navy),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: AppTheme.dm(
                    size: 13, weight: FontWeight.w600, color: AppColors.gold)),
          ),
        ],
      ],
    );
  }
}
