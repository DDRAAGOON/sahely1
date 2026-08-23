import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ReferredPropertiesDescription extends StatelessWidget {
  final String text;

  const ReferredPropertiesDescription({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: AppTheme.dm(
          size: 13,
          color: AppColors.secondary,
          height: 1.4,
        ),
      ),
    );
  }
}