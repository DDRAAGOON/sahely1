import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

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
        const Text(
          'Your review',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
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
              hintText: 'Tell others about the property, cleanliness, check-in...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.placeholder,
                fontFamily: 'DM Sans',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
              counterStyle: const TextStyle(
                fontSize: 11,
                color: AppColors.secondary,
              ),
            ),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.dark,
              fontFamily: 'DM Sans',
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
