import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class StarRatingWidget extends StatelessWidget {
  final int selectedRating;
  final ValueChanged<int> onRatingChanged;

  const StarRatingWidget({
    super.key,
    required this.selectedRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'How was your stay?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = starValue <= selectedRating;
            return GestureDetector(
              onTap: () => onRatingChanged(starValue),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  isSelected ? Icons.star : Icons.star_border,
                  size: 44,
                  color: isSelected ? AppColors.gold : const Color(0xFFE0E0E0),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
