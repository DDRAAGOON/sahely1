import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrokerCategoryChips extends StatefulWidget {
  final Function(String)? onCategorySelected;

  const BrokerCategoryChips({super.key, this.onCategorySelected});

  @override
  State<BrokerCategoryChips> createState() => _BrokerCategoryChipsState();
}

class _BrokerCategoryChipsState extends State<BrokerCategoryChips> {
  int _selectedIndex = 0;
  final List<String> _categories = [
    'All',
    'Villa',
    'Chalet',
    'Apartment',
    'Studio'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              if (widget.onCategorySelected != null) {
                widget.onCategorySelected!(_categories[index]);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.gold : AppColors.border,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : const [],
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: AppTheme.dm(
                  size: 13,
                  weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.navy : AppColors.muted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
