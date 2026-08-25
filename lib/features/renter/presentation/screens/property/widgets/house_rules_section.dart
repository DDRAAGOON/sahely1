import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

class HouseRulesSection extends StatelessWidget {
  const HouseRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context).houseRules,
          style: AppTheme.dm(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _RuleRow(
                    icon: Icons.access_time,
                    label: AppLocalizations.of(context).calmHours,
                    value: '11 PM – 8 AM',
                  ),
                  _Divider(),
                  _RuleRow(
                    icon: Icons.party_mode,
                    label: AppLocalizations.of(context).partiesLabel,
                    isAllowed: true,
                  ),
                  _Divider(),
                  _RuleRow(
                    icon: Icons.pets,
                    label: AppLocalizations.of(context).petsLabel,
                    isAllowed: true,
                  ),
                  _Divider(),
                  _RuleRow(
                    icon: Icons.groups,
                    label: AppLocalizations.of(context).mixedGroupsLabel,
                    isAllowed: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isAllowed;

  const _RuleRow({
    required this.icon,
    required this.label,
    this.value,
    this.isAllowed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.dm(
                size: 12,
                color: AppColors.dark,
              ),
            ),
          ),
          if (isAllowed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context).allowed,
                style: AppTheme.dm(
                  size: 12,
                  weight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            )
          else
            Text(
              value ?? '',
              style: AppTheme.dm(
                size: 12,
                weight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }
}
