import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class SearchHeaderWithInput extends StatelessWidget {
  const SearchHeaderWithInput({
    super.key,
    required this.onSubmitted,
    required this.controller,
    this.onBack,
    this.onFilter,
  });

  final ValueChanged<String> onSubmitted;
  final TextEditingController controller;
  final VoidCallback? onBack;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Navigator.maybePop(context),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.white,
              border : null,
              borderRadius: BorderRadius.circular(6),
            ),
            child:
                const Icon(Icons.chevron_left, size: 20, color: AppColors.navy),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => onSubmitted(controller.text),
                  child:
                      const Icon(Icons.search, size: 18, color: AppColors.gold),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    onSubmitted: onSubmitted,
                    textInputAction: TextInputAction.search,
                    autofocus: false,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search properties',
                      hintStyle: AppTheme.dm(
                          size: 11,
                          color: AppColors.navy.withValues(alpha: 0.5)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: AppTheme.dm(size: 12, color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFilter,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, size: 18, color: AppColors.gold),
          ),
        ),
      ],
    );
  }
}
