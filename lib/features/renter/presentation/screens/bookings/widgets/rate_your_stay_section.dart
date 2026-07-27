import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class RateYourStaySection extends StatelessWidget {
  final VoidCallback onAddReview;

  const RateYourStaySection({
    super.key,
    required this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How was your stay?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.star_border, color: Color(0xFFE0E0E0), size: 28),
              );
            }),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onAddReview,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: AppColors.gold, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Write a review Ã‚Â· earn +5 Ã¢Ëœâ€¦',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
