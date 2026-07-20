import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.secondary,
          fontFamily: 'DM Sans',
          height: 1.4,
        ),
      ),
    );
  }
}