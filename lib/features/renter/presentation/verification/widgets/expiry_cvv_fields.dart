import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class ExpiryCvvFields extends StatefulWidget {
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  const ExpiryCvvFields({
    super.key,
    required this.expiryController,
    required this.cvvController,
  });

  @override
  State<ExpiryCvvFields> createState() => _ExpiryCvvFieldsState();
}

class _ExpiryCvvFieldsState extends State<ExpiryCvvFields> {
  bool _showCvv = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expiry Date (50% width)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expiry Date',
                style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.expiryController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryDateFormatter(),
                ],
                maxLength: 5,
                decoration: InputDecoration(
                  hintText: 'MM/YY',
                  hintStyle: AppTheme.dm(
                    size: 14,
                    color: AppColors.placeholder,
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
                    borderSide:
                        const BorderSide(color: AppColors.gold, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  counterText: '',
                ),
                style: AppTheme.dm(
                  size: 14,
                  color: AppColors.dark,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (value.length < 5) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // CVV (50% width)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CVV',
                style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: widget.cvvController,
                keyboardType: TextInputType.number,
                obscureText: !_showCvv,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: InputDecoration(
                  hintText: '•••',
                  hintStyle: AppTheme.dm(
                    size: 14,
                    color: AppColors.placeholder,
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
                    borderSide:
                        const BorderSide(color: AppColors.gold, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _showCvv = !_showCvv);
                      // Auto-hide after 2 seconds
                      if (_showCvv) {
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() => _showCvv = false);
                          }
                        });
                      }
                    },
                    child: Icon(
                      _showCvv ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  counterText: '',
                ),
                style: AppTheme.dm(
                  size: 14,
                  color: AppColors.dark,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (value.length < 3) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
