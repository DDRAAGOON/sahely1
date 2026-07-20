import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/chips.dart';
import 'package:sahely/core/widgets/floating_nav.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/data/sample_data.dart';

import '../widgets/owner_property_card.dart';

class OwnerPropertiesScreen extends StatefulWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Properties',
                  style: AppTheme.dm(
                      size: 22,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
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
                    Text('Add',
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
            if (_selectedFilter == 'All' || _selectedFilter == 'Active') ...[
              OwnerPropertyCard(
                property: Sample.azure,
                status: 'Active',
                badgeKind: BadgeKind.green,
                meta: 'Villa · Hacienda Bay · 320 m²',
                stats: const ['★ 4.8', '88% occ.', '1,284 views'],
                onPrimaryAction: () => AppNavigation.goToOwnerInsights(context,
                    extra: Sample.azure),
                onSecondaryAction: () => AppNavigation.goToOwnerEdit(context),
                onSosAction: () => AppNavigation.goToSosOwner(context),
              ),
              const SizedBox(height: 12),
              OwnerPropertyCard(
                property: Sample.dunes,
                status: 'Active',
                badgeKind: BadgeKind.green,
                meta: 'Chalet · Marassi · 180 m² · 2 floors',
                stats: const ['★ 4.7', '62% occ.', '643 views'],
                onPrimaryAction: () => AppNavigation.goToOwnerInsights(context,
                    extra: Sample.dunes),
                onSecondaryAction: () => AppNavigation.goToOwnerEdit(context),
                onSosAction: () => AppNavigation.goToSosOwner(context),
              ),
              const SizedBox(height: 12),
            ],
            if (_selectedFilter == 'All' || _selectedFilter == 'Paused') ...[
              OwnerPropertyCard(
                property: Sample.lagoon,
                status: 'Under review',
                badgeKind: BadgeKind.orange,
                meta: 'Chalet · Marassi · 165 m²',
                stats: const [],
                nameOverride: 'Palm Shores',
                note: 'Submitted · our team is reviewing (1–24h)',
                primaryActionLabel: 'View submission status',
                onPrimaryAction: () => AppNavigation.goToOwnerListingSubmitted(
                    context,
                    extra: Sample.lagoon),
                onSecondaryAction: () => AppNavigation.goToOwnerEdit(context),
              ),
              const SizedBox(height: 12),
            ],
            if (_selectedFilter == 'All' || _selectedFilter == 'Draft') ...[
              OwnerPropertyCard(
                property: null,
                status: 'Draft',
                badgeKind: BadgeKind.gray,
                meta: 'Apartment · Marina · 140 m² · Floor 4',
                stats: const [],
                nameOverride: 'Marina Loft',
                note: 'Listing 60% complete — add photos',
                primaryActionLabel: 'Continue setup',
                secondaryActionLabel: 'Delete',
                onPrimaryAction: () => AppNavigation.goToOwnerEdit(context),
                onSecondaryAction: () {
                  /* Handle Delete */
                },
              ),
            ],
          ],
        ),
        const FloatingNav(active: 4),
      ]),
    );
  }
}
