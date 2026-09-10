import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/success_check.dart';

/// Screen 28 · "Renter Approved" bottom sheet.
///
/// Shown after the owner approves a booking request: a dim scrim over the
/// requests page with a white sheet containing the animated success circle,
/// the confirmation copy, and the expected payout.
Future<void> showApprovedRequestSheet(
  BuildContext context, {
  required String guestName,
  required String propertyName,
  required String dates,
  double? payoutAmount,
  String? payoutDisplay,
  int starsEarned = 5,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    enableDrag: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.navy.withValues(alpha: 0.45),
    builder: (sheetCtx) => Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [BoxShadow(color: Color(0x331B2744), blurRadius: 30)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 14, 26, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.borderDefault,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 22),
              const SuccessCheck(size: 88),
              const SizedBox(height: 20),
              Text('Booking Approved',
                  style: AppTheme.dm(
                      size: 21,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTheme.dm(
                      size: 14, color: AppColors.muted, height: 1.5),
                  children: [
                    TextSpan(text: '$guestName is confirmed for\n'),
                    TextSpan(
                        text: propertyName,
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    TextSpan(text: ' · $dates'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payout on check-in',
                            style:
                                AppTheme.dm(size: 12, color: AppColors.muted)),
                        const SizedBox(height: 2),
                        Text(
                            payoutDisplay ??
                                CurrencyFormatter.format(
                                    (payoutAmount ?? 18000).toInt()),
                            style: AppTheme.dm(
                                size: 17,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 13, color: AppColors.navy),
                          const SizedBox(width: 4),
                          Text('+$starsEarned ★',
                              style: AppTheme.dm(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.pop(sheetCtx),
                child: Text('Done',
                    style: AppTheme.dm(
                        size: 15,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
