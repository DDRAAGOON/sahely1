import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/di/service_locator.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/pull_to_refresh.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_properties_cubit.dart';
import 'package:sahely/features/owner/presentation/bloc/owner_properties_state.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/features/owner/widgets/owner_property_card.dart';

class OwnerPropertiesScreen extends StatelessWidget {
  final String? initialFilter;
  const OwnerPropertiesScreen({super.key, this.initialFilter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerPropertiesCubit>()..loadProperties(),
      child: _OwnerPropertiesView(initialFilter: initialFilter),
    );
  }
}

class _OwnerPropertiesView extends StatefulWidget {
  final String? initialFilter;
  const _OwnerPropertiesView({this.initialFilter});

  @override
  State<_OwnerPropertiesView> createState() => _OwnerPropertiesViewState();
}

class _OwnerPropertiesViewState extends State<_OwnerPropertiesView> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'All';
  }

  List<Property> _filter(List<Property> all) {
    return all.where((p) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Active') return p.status == PropertyStatus.active;
      if (_selectedFilter == 'Paused') return p.status == PropertyStatus.paused;
      if (_selectedFilter == 'Under Review') {
        return p.status == PropertyStatus.underReview;
      }
      if (_selectedFilter == 'Draft') return p.status == PropertyStatus.draft;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: BlocBuilder<OwnerPropertiesCubit, OwnerPropertiesState>(
        builder: (context, state) {
          final properties = state is OwnerPropertiesLoaded
              ? _filter(state.properties)
              : const <Property>[];

          return PullToRefresh(
            onRefresh: () =>
                context.read<OwnerPropertiesCubit>().loadProperties(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
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
                            Flexible(
                              child: Text(
                                  AppLocalizations.of(context).myProperties,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.dm(
                                      size: 22,
                                      weight: FontWeight.w700,
                                      color: AppColors.navy)),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            AppNavigation.goToOwnerAddProperty(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            const Icon(Icons.add,
                                size: 16, color: AppColors.navy),
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
                if (state is OwnerPropertiesLoading ||
                    state is OwnerPropertiesInitial)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  )
                else if (state is OwnerPropertiesError)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Text(state.message,
                          textAlign: TextAlign.center,
                          style: AppTheme.dm(color: AppColors.muted)),
                    ),
                  )
                else if (properties.isEmpty)
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
        },
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
        note: 'Listing incomplete — add photos',
        primaryActionLabel: AppLocalizations.of(context).continueSetup,
        secondaryActionLabel: AppLocalizations.of(context).delete,
        primaryActionColor: const Color(0xFFCEB15E),
        secondaryActionColor: const Color(0xFFB3261E),
        onPrimaryAction: () => AppNavigation.goToOwnerEdit(context, extra: p),
        onSecondaryAction: () =>
            context.read<OwnerPropertiesCubit>().deleteProperty(p.id),
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
        onPrimaryAction: () =>
            AppNavigation.goToOwnerListingSubmitted(context, extra: p),
        onSecondaryAction: null,
      );
    }

    return OwnerPropertyCard(
      property: p,
      status: 'Active',
      badgeKind: BadgeKind.green,
      meta: '${p.type} · ${p.area} · ${p.beds} beds',
      // Occupancy and view counts are not exposed per property by the API, so
      // the row shows only the rating and review count the listing carries.
      stats: ['★ ${p.rating}', '${p.reviews} reviews'],
      primaryActionColor: const Color(0xFFCEB15E),
      onPrimaryAction: () => AppNavigation.goToOwnerInsights(context, extra: p),
      onSecondaryAction: () => AppNavigation.goToOwnerEdit(context, extra: p),
      onSosAction: () => AppNavigation.goToSosOwner(context),
    );
  }
}
