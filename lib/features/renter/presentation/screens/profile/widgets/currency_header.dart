import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class CurrencyHeader extends StatelessWidget {
  const CurrencyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose currency',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          SizedBox(height: 6),
          Text(
            'All prices across the app update instantly',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.secondary,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }
}
