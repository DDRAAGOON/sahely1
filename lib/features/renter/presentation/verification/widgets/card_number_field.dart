import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sahely/core/theme/app_colors.dart';

class CardNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? cardType;
  final ValueChanged<String> onChanged;

  const CardNumberField({
    super.key,
    required this.controller,
    this.cardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Number',
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
          keyboardType: TextInputType.number,
          inputFormatters: [
            _CardNumberFormatter(),
          ],
          maxLength: 19,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '4242 4242 4242 4242',
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
            suffixIcon: cardType != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: _buildCardLogo(cardType!),
                  )
                : null,
            counterText: '',
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (value.replaceAll(' ', '').length < 16) return 'Invalid';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCardLogo(String type) {
    if (type == 'visa') {
      return Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F71),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: const Text(
          'VISA',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      );
    } else if (type == 'mastercard') {
      return SizedBox(
        width: 30,
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 0,
                child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEB001B), shape: BoxShape.circle))),
            Positioned(
                right: 0,
                child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Color(0xFFF79E1B), shape: BoxShape.circle))),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
