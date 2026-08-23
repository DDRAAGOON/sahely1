import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class CategoryChips extends StatefulWidget {
  final Function(String)? onCategorySelected;

  const CategoryChips({super.key, this.onCategorySelected});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selectedIndex = 0;
  final List<String> _categories = ['All', 'Villa', 'Chalet', 'Penthouse', 'Beachfront', 'Pool'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return BouncyButton(
            onTap: () {
              setState(() => _selectedIndex = index);
              if (widget.onCategorySelected != null) {
                widget.onCategorySelected!(_categories[index]);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutQuart,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.navy : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.navy : AppColors.borderDefault,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ] : const [],
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: AppTheme.dm(
                  size: 13,
                  weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.navy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
