import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class BrokerBookingsFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const BrokerBookingsFilterTabs({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: tab == tabs.last ? 0 : 8,
              ),
              child: BouncyButton(
                onTap: () => onTabSelected(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.navy : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: null,
                  ),
                  child: Center(
                    child: Text(
                      tab,
                      style: AppTheme.dm(
                        size: 14,
                        weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.navy,
                      ),
                    ),
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
