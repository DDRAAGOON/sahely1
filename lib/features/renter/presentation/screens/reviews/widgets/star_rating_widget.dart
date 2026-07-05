import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'How was your stay?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final isSelected = starValue <= selectedRating;
              return GestureDetector(
                onTap: () => onRatingChanged(starValue),
                child: AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 40,
                    color: isSelected ? AppColors.gold : AppColors.border,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
