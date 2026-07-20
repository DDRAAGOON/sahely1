import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class WalletPeriodTabs extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onTabSelected;

  const WalletPeriodTabs({
    super.key,
    required this.selectedPeriod,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _PeriodTab(
            label: 'This Month',
            isSelected: selectedPeriod == 'This Month',
            onTap: () => onTabSelected('This Month'),
          ),
          const SizedBox(width: 8),
          _PeriodTab(
            label: 'Last Month',
            isSelected: selectedPeriod == 'Last Month',
            onTap: () => onTabSelected('Last Month'),
          ),
        ],
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
      ),
    );
  }
}