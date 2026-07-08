import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CardholderNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? legalName;

  const CardholderNameField({
    super.key,
    required this.controller,
    this.legalName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name on Card',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: legalName ?? 'Enter name as it appears on card',
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.placeholder,
              fontFamily: 'DM Sans',
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.gold, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
