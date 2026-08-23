import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class FeatureChipsSection extends StatelessWidget {
  const FeatureChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FeatureChip(label: 'Villa'),
            _FeatureChip(label: '320 m²'),
            _FeatureChip(label: '2 Floors'),
            _FeatureChip(label: 'Beachfront'),
            _FeatureChip(label: '6 Guests'),
            _FeatureChip(label: '4 Beds'),
            _FeatureChip(label: 'Pool'),
            _FeatureChip(label: 'Mixed groups OK', isSpecial: true),
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
