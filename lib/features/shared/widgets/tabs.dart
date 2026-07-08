import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';


class SegmentTabs extends StatelessWidget {
  const SegmentTabs({super.key, required this.tabs, this.active = 0, this.onTap});
  final List<String> tabs;
  final int active;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => onTap?.call(i),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == active ? AppColors.navy : AppColors.white,
                  border: i == active ? null : Border.all(color: AppColors.navy),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tabs[i],
                    style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: i == active ? AppColors.white : AppColors.navy)),
              ),
            ),
          ),
          if (i < tabs.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
