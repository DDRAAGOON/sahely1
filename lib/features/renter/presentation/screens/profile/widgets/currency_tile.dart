import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class CurrencyTile extends StatelessWidget {
  final String countryCode;
  final String currencyCode;
  final String symbol;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CurrencyTile({
    super.key,
    required this.countryCode,
    required this.currencyCode,
    required this.symbol,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Expand tap area
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Country Code Circle
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  countryCode,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Currency Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                        fontFamily: 'DM Sans',
                      ),
                      children: [
                        TextSpan(
                          text: '$currencyCode ',
                        ),
                        TextSpan(
                          text: '· $symbol',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),

            // Radio Button
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.navy : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
