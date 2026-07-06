import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/kit.dart';
import '../../../../../../data/models.dart';

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
              const Text(
                'Good morning,',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Karim Adel',
                style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy),
              ),
            ],
          ),
        ),
        const RoleBadge(role: Role.broker),
      ],
    );
  }
}
