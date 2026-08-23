import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

import 'package:sahely/features/shared/widgets/mawsem/earn_star_row.dart';

class BrokerHowToEarnSection extends StatelessWidget {
  const BrokerHowToEarnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'How to Earn Stars',
          style: AppTheme.dm(
            size: 18,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Complete broker milestones to climb faster.',
          style: AppTheme.dm(
            size: 13,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 16),

        // Earn Rows Container
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildRow(
                icon: Icons.verified_user_outlined,
                title: 'Verify your broker identity',
                subtitle: 'One-time · ID + Business Proof',
                stars: '+10',
                color: const Color(0xFF1B6B3A),
                bgColor: const Color(0xFFE8F5E9),
              ),
              _buildRow(
                icon: Icons.add_home_outlined,
                title: 'Refer your first property',
                subtitle: 'One-time · must be verified',
                stars: '+20',
                color: const Color(0xFF1565C0),
                bgColor: const Color(0xFFE3F2FD),
              ),
              _buildRow(
                icon: Icons.person_add_outlined,
                title: 'Refer a guest who books',
                subtitle: 'Per booking · over 5k EGP',
                stars: '+15',
                color: const Color(0xFFBC9B43),
                bgColor: const Color(0xFFFFF8E1),
              ),
              _buildRow(
                icon: Icons.star_outline,
                title: 'Maintain 4.8+ rating',
                subtitle: 'Monthly bonus',
                stars: '+25',
                color: const Color(0xFFBC9B43),
                bgColor: const Color(0xFFFFF8E1),
              ),
              _buildRow(
                icon: Icons.group_outlined,
                title: 'Refer another broker',
                subtitle: 'Once they complete first referral',
                stars: '+50',
                color: const Color(0xFF9A7A22),
                bgColor: const Color(0xFFBC9B43),
                rowBgColor: const Color(0xFFFBF3DE),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String stars,
    required Color color,
    required Color bgColor,
    Color? rowBgColor,
    BorderRadius? borderRadius,
    bool isLast = false,
  }) {
    return EarnStarRow(
      icon: icon,
      title: Text(title),
      subtitle: subtitle,
      stars: stars,
      iconColor: color,
      iconBgColor: bgColor,
      rowBgColor: rowBgColor,
      borderRadius: borderRadius,
      showDivider: !isLast && rowBgColor == null,
      titleColor: rowBgColor != null ? color : null,
    );
  }
}
