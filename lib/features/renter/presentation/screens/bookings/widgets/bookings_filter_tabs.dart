import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/chips.dart';
import 'package:sahely/l10n/app_localizations.dart';

class BookingsFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const BookingsFilterTabs({
    super.key,
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String tabLabel(String tab) {
      switch (tab.toLowerCase()) {
        case 'upcoming':
          return l.upcomingLabel;
        case 'active':
          return l.activeLabel;
        case 'past':
          return l.pastLabel;
        default:
          return tab;
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChipPill(
              tabLabel(tab),
              selected: isSelected,
              onTap: () => onTabSelected(tab),
              height: 44,
              fontSize: 14,
              horizontalPadding: 24,
              borderRadius: 22,
              borderColor:
                  isSelected ? AppColors.navy : AppColors.borderDefault,
            ),
          );
        }).toList(),
      ),
    );
  }
}
