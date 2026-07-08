import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../pages/add_credit_sheet.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final bool isRegistered;
  final RegisteredPaymentMethod? registeredData;
  final VoidCallback onTap;
  final VoidCallback onRegisterTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.isRegistered,
    this.registeredData,
    required this.onTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: isSelected ? AppColors.navy.withOpacity(0.04) : Colors.transparent,
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: method.iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                method.icon,
                color: method.iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Method Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          method.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dark,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ),
                      // Registered Badge
                      if (isRegistered)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 10,
                                color: Color(0xFF2E7D32),
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Registered',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        method.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      if (isRegistered && registeredData != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '· ${registeredData!.displayLabel}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 11,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        method.processingTime,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action (Radio or Add button)
            if (isRegistered)
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
              )
            else
              GestureDetector(
                onTap: () {
                  onRegisterTap();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gold, width: 0.5),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
