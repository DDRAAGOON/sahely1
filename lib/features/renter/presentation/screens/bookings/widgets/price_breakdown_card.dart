import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';

class PriceBreakdownCard extends StatelessWidget {
  final dynamic pricePerNight;
  final dynamic nights;
  final dynamic cleaningVat;
  final dynamic total;

  const PriceBreakdownCard({
    super.key,
    required this.pricePerNight,
    required this.nights,
    required this.cleaningVat,
    required this.total,
  });

  String _formatNumber(dynamic number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final num p = (pricePerNight is num) ? pricePerNight : 0;
    final num n = (nights is num) ? nights : 0;
    final num subtotal = p * n;
    final num vat = (cleaningVat is num) ? cleaningVat : 0;
    final num t = (total is num) ? total : 0;

    // Soft divider color
    final Color softDivider = AppColors.border.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('EGP ${_formatNumber(p)} × $n', _formatNumber(subtotal)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: softDivider),
          ),
          _buildRow('Cleaning + VAT', _formatNumber(vat)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: softDivider),
          ),
          _buildRow('Total paid', 'EGP ${_formatNumber(t)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}
