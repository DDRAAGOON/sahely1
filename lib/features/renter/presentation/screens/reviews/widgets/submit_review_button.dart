import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class SubmitReviewButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final bool hasRating;

  const SubmitReviewButton({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.hasRating,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.navy.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Submit Review & earn +5',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.star,
                    size: 18,
                    color: AppColors.gold,
                  ),
                ],
              ),
      ),
    );
  }
}
