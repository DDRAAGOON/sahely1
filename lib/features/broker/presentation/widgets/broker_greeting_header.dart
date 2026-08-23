import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/data/models.dart';

class BrokerGreetingHeader extends StatelessWidget {
  const BrokerGreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Karim Adel',
                style: AppTheme.dm(
                    size: 22, weight: FontWeight.w700, color: AppColors.navy),
              ),
            ],
          ),
        ),
        const RoleBadge(role: Role.broker),
      ],
    );
  }
}
