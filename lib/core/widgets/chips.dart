import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Selectable rounded chip (navy when active, white outline when not).
/// Now customizable with width, padding, and font size.
class ChoiceChipPill extends StatelessWidget {
  const ChoiceChipPill(
    this.label, {
    super.key,
    this.selected = false,
    this.onTap,
    this.height = 35,
    this.width,
    this.horizontalPadding = 15,
    this.fontSize = 12,
    this.borderColor = AppColors.navy,
    this.borderWidth = 1.0,
    this.borderRadius = 999,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final double horizontalPadding;
  final double fontSize;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.white,
          border: Border.all(color: AppColors.navy, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: AppTheme.dm(
                    size: fontSize,
                    weight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: selected ? AppColors.white : AppColors.navy)),
          ],
        ),
      ),
    );
  }
}

/// Search bar + filter + AI buttons row used atop browse/feed screens.
class SearchHeaderRow extends StatelessWidget {
  const SearchHeaderRow({
    super.key,
    this.placeholder = 'Find your perfect stay',
    this.value,
    this.onBack,
    this.onFilter,
    this.onSearchTap,
    this.showBack = false,
    this.large = true,
  });

  final String placeholder;
  final String? value;
  final VoidCallback? onBack;
  final VoidCallback? onFilter;
  final VoidCallback? onSearchTap;
  final bool showBack;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final h = large ? 54.0 : 46.0;
    return Row(
      children: [
        if (showBack) ...[
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
              child: const Icon(Icons.chevron_left, size: 22, color: AppColors.navy),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: h,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: AppColors.gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      value ?? placeholder,
                      style: AppTheme.dm(size: 14, color: value == null ? AppColors.faint : AppColors.ink),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilter,
          child: Container(
            width: h,
            height: h,
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.tune, size: 22, color: AppColors.gold),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: h,
          height: h,
          decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(14)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 22, color: AppColors.navy),
              const Positioned(top: 14, child: Icon(Icons.star, size: 9, color: AppColors.navy)),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2BB673),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
