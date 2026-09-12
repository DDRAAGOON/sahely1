import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// The listing's own description (`GET /properties/:id` → `description`).
class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, this.text = ''});

  /// Empty until the listing is loaded, and for listings without one.
  final String text;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.trim().isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: _isExpanded ? null : 3,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: AppTheme.dm(
                size: 14,
                color: AppColors.dark,
                height: 1.55,
              ),
            ),
            // Only worth a toggle when the text is longer than the 3 lines
            // shown by default.
            if (widget.text.length > 140)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _isExpanded
                        ? AppLocalizations.of(context).showLess
                        : AppLocalizations.of(context).showMore,
                    style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
