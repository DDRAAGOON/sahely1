import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/data/sample_data.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/features/owner/widgets/owner_property_card.dart';

class OwnerPropertiesScreen extends StatefulWidget {
  final String? initialFilter;
  const OwnerPropertiesScreen({super.key, this.initialFilter});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    final properties = Sample.ownerProperties.where((p) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Active') return p.status == PropertyStatus.active;
      if (_selectedFilter == 'Paused') return p.status == PropertyStatus.paused;
      if (_selectedFilter == 'Under Review') return p.status == PropertyStatus.underReview;
      if (_selectedFilter == 'Draft') return p.status == PropertyStatus.draft;
      return true;
    }).toList();

    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => AppNavigation.goBack(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left,
                        size: 20, color: AppColors.navy),
                  ),
                ),
                Text(AppLocalizations.of(context).myProperties,
                    style: AppTheme.dm(
                        size: 22,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
              ],
            ),
            GestureDetector(
                onTap: () => AppNavigation.goToOwnerAddProperty(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.add, size: 16, color: AppColors.navy),
                    const SizedBox(width: 4),
                    Text(AppLocalizations.of(context).addLabel,
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.navy))
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final filter in [
                    'All',
                    'Active',
                    'Paused',
                    'Under Review',
                    'Draft'
                  ]) ...[
                    ChoiceChipPill(
                      filter,
                      selected: _selectedFilter == filter,
                      height: 32,
                      onTap: () => setState(() => _selectedFilter = filter),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (properties.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Text(AppLocalizations.of(context).noProperties,
                      style: AppTheme.dm(color: AppColors.muted)),
                ),
              )
            else
              ...properties.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCard(p),
                  )),
          ],
        ),
    );
  }

  Widget _buildCard(Property p) {
    if (p.status == PropertyStatus.draft) {
      return OwnerPropertyCard(
        property: p,
        status: 'Draft',
        badgeKind: BadgeKind.gray,
        meta: '${p.type} · ${p.area} · ${p.beds} beds',
        stats: const [],
        note: 'Listing 60% complete — add photos',
        primaryActionLabel: AppLocalizations.of(context).continueSetup,
        secondaryActionLabel: AppLocalizations.of(context).delete,
        primaryActionColor: const Color(0xFFCEB15E),
        secondaryActionColor: const Color(0xFFB3261E),
        onPrimaryAction: () => AppNavigation.goToOwnerEdit(context),
        onSecondaryAction: () {
          setState(() {
            Sample.ownerProperties.remove(p);
          });
        },
      );
    }

    if (p.status == PropertyStatus.underReview) {
      return OwnerPropertyCard(
        property: p,
        status: 'Under review',
        badgeKind: BadgeKind.orange,
        meta: '${p.type} · ${p.area} · ${p.beds} beds',
        stats: const [],
        note: 'Submitted · our team is reviewing (1–24h)',
        primaryActionLabel: AppLocalizations.of(context).viewSubmissionStatus,
        primaryActionColor: const Color(0xFFCEB15E),
        onPrimaryAction: () => AppNavigation.goToOwnerListingSubmitted(
            context,
            extra: p),
        onSecondaryAction: null,
      );
    }

    return OwnerPropertyCard(
      property: p,
      status: 'Active',
      badgeKind: BadgeKind.green,
      meta: '${p.type} · ${p.area} · ${p.beds} beds',
      stats: ['★ ${p.rating}', '88% occ.', '${p.reviews * 10} views'],
      primaryActionColor: const Color(0xFFCEB15E),
      onPrimaryAction: () => AppNavigation.goToOwnerInsights(context,
          extra: p),
      onSecondaryAction: () => AppNavigation.goToOwnerEdit(context),
      onSosAction: () => AppNavigation.goToSosOwner(context),
    );
  }
}
