import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';

class PriceBreakdown extends StatelessWidget {
  final int nights;
  final int totalGuests;
  final int pricePerNight; // in piastres
  final int cleaningFee; // in piastres
  final int vat; // in piastres
  final int total; // in piastres

  const PriceBreakdown({
    super.key,
    required this.nights,
    required this.totalGuests,
    required this.pricePerNight,
    required this.cleaningFee,
    required this.vat,
    required this.total,
  });

  String _formatPrice(int amount) {
    return CurrencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final egpPricePerNight = _formatPrice(pricePerNight);
    final subtotal = nights * pricePerNight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nights > 0) ...[
            Text(
              '$nights night${nights > 1 ? 's' : ''} · $totalGuests guest${totalGuests > 1 ? 's' : ''}',
              style: AppTheme.dm(
                size: 14,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            _buildRow('$egpPricePerNight × $nights', _formatPrice(subtotal)),
            const SizedBox(height: 12),
            _buildRow('Cleaning fee', _formatPrice(cleaningFee)),
            const SizedBox(height: 12),
            _buildRow('VAT 14%', _formatPrice(vat)),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTheme.dm(
                    size: 16,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  _formatPrice(total),
                  style: AppTheme.dm(
                    size: 18,
                    weight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ] else
            Center(
              child: Text(
                'Select dates to see pricing',
                style: AppTheme.dm(
                  size: 14,
                  color: AppColors.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.dm(
            size: 14,
            color: AppColors.secondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.dm(
            size: 14,
            weight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
