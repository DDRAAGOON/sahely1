import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

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
            const Text(
              'House Rules',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
                fontFamily: 'DM Sans',
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
                  const _RuleRow(
                    icon: Icons.access_time,
                    label: 'Calm hours',
                    value: '11 PM - 8 AM',
                  ),
                  _Divider(),
                  const _RuleRow(
                    icon: Icons.party_mode,
                    label: 'Parties',
                    isAllowed: true,
                  ),
                  _Divider(),
                  const _RuleRow(
                    icon: Icons.pets,
                    label: 'Pets',
                    isAllowed: true,
                  ),
                  _Divider(),
                  const _RuleRow(
                    icon: Icons.groups,
                    label: 'Mixed groups',
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
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.dark,
                fontFamily: 'DM Sans',
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
              child: const Text(
                'Allowed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                  fontFamily: 'DM Sans',
                ),
              ),
            )
          else
            Text(
              value ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
                fontFamily: 'DM Sans',
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
