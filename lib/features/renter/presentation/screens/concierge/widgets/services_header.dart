import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class ServicesHeader extends StatelessWidget {
  const ServicesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        const Text(
          'Elevate your stay with premium services',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
