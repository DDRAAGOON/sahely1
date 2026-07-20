import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class HistoryFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const HistoryFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: filters.asMap().entries.map((entry) {
          final filter = entry.value;
          final index = entry.key;
          final isSelected = filter == selectedFilter;

          return Padding(
            padding:
                EdgeInsets.only(right: index == filters.length - 1 ? 0 : 8),
            child: GestureDetector(
              onTap: () => onFilterSelected(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.navy,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
