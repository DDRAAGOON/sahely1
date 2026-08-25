import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

class FeatureChipsSection extends StatelessWidget {
  const FeatureChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FeatureChip(label: AppLocalizations.of(context).catVilla),
            const _FeatureChip(label: '320 m²'),
            _FeatureChip(label: AppLocalizations.of(context).floorsCount(2)),
            _FeatureChip(label: AppLocalizations.of(context).catBeachfront),
            _FeatureChip(label: AppLocalizations.of(context).guestsCount(6)),
            _FeatureChip(label: AppLocalizations.of(context).bedsCount(4)),
            _FeatureChip(label: AppLocalizations.of(context).catPool),
            _FeatureChip(label: AppLocalizations.of(context).mixedGroupsOk, isSpecial: true),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final bool isSpecial;

  const _FeatureChip({
    required this.label,
    this.isSpecial = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSpecial ? const Color(0xFFE8F5E9) : AppColors.cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Text(
        label,
        style: AppTheme.dm(
          size: 12,
          color: isSpecial ? const Color(0xFF2E7D32) : AppColors.navy,
        ),
      ),
    );
  }
}
