import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:sahely/l10n/app_localizations.dart';

class CategoryChips extends StatefulWidget {
  final Function(String)? onCategorySelected;

  const CategoryChips({super.key, this.onCategorySelected});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selectedIndex = 0;

  /// Canonical (English) values passed to callbacks so filtering logic
  /// stays stable regardless of the display language.
  static const List<String> _categories = [
    'All', 'Villa', 'Chalet', 'Penthouse', 'Beachfront', 'Pool'
  ];

  List<String> _displayLabels(AppLocalizations l) => [
        l.catAll, l.catVilla, l.catChalet, l.catPenthouse, l.catBeachfront, l.catPool
      ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = _displayLabels(l);
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
                labels[index],
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
