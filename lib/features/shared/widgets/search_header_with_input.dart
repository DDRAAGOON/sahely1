import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.chevron_left, size: 22, color: AppColors.navy),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      const Icon(Icons.search, size: 20, color: AppColors.gold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onSubmitted: onSubmitted,
                    textInputAction: TextInputAction.search,
                    autofocus: false,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search properties',
                      hintStyle: AppTheme.dm(
                          size: 13,
                          color: AppColors.navy.withValues(alpha: 0.5)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: AppTheme.dm(size: 14, color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilter,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.tune, size: 22, color: AppColors.gold),
          ),
        ),
      ],
    );
  }
}
