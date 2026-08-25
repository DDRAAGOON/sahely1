import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

class ReviewTextField extends StatelessWidget {
  final TextEditingController controller;

  const ReviewTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).yourReview,
          style: AppTheme.dm(
            size: 14,
            weight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText:
                  AppLocalizations.of(context).reviewHint,
              hintStyle: AppTheme.dm(
                size: 13,
                color: AppColors.placeholder,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
              counterStyle: AppTheme.dm(
                size: 11,
                color: AppColors.secondary,
              ),
            ),
            style: AppTheme.dm(
              size: 13,
              color: AppColors.dark,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
