import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// The listing's facts, each one straight from `GET /properties/:id`.
class FeatureChipsSection extends StatelessWidget {
  const FeatureChipsSection({super.key, this.property});

  /// Null until the listing is loaded.
  final Property? property;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final listing = property;
    if (listing == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final area = listing.areaSqm;
    final chips = <String>[
      if (listing.type.isNotEmpty) listing.type,
      if (area != null && area > 0) '${area.round()} m²',
      if (listing.tags.contains('Beachfront')) l.catBeachfront,
      if (listing.guests > 0) '${l.guestsLabel} ${listing.guests}',
      if (listing.beds > 0) '${l.bedsCount} ${listing.beds}',
      if (listing.baths > 0) '${listing.baths} bath',
    ];
    if (chips.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final chip in chips) _FeatureChip(label: chip)],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Text(
        label,
        style: AppTheme.dm(
          size: 12,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
