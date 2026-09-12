import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ReferPropertyInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const ReferPropertyInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.dm(
            size: 13,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTheme.dm(size: 15, color: AppColors.navy),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.dm(size: 15, color: AppColors.subtle),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
