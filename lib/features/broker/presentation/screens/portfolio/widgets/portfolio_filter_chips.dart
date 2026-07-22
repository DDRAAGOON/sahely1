import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class PortfolioFilterChips extends StatelessWidget {
  final int totalCount;
  final int liveCount;
  final int pendingCount;
  final int issueCount;
  final int cancelledCount;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const PortfolioFilterChips({
    super.key,
    required this.totalCount,
    required this.liveCount,
    required this.pendingCount,
    required this.issueCount,
    required this.cancelledCount,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'label': 'All', 'count': totalCount},
      {'label': 'Live', 'count': liveCount},
      {'label': 'Pending', 'count': pendingCount},
      {'label': 'Issue', 'count': issueCount},
      {'label': 'Cancelled', 'count': cancelledCount},
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter['label'] == selectedFilter;

          return GestureDetector(
            onTap: () => onFilterSelected(filter['label'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.navy : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.navy : AppColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.navy,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.cream,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filter['count']}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.secondary,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}