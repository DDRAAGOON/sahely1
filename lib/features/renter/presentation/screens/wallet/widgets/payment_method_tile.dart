import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class PaymentMethod {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String processingTime;

  const PaymentMethod({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.processingTime,
  });
}

class RegisteredPaymentMethod {
  final String methodId;
  final String displayLabel;
  final bool isDefault;

  const RegisteredPaymentMethod({
    required this.methodId,
    required this.displayLabel,
    this.isDefault = false,
  });
}

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
        color: isSelected
            ? AppColors.navy.withValues(alpha: 0.04)
            : Colors.transparent,
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
                          style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w600,
                            color: AppColors.navy,
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 10,
                                color: Color(0xFF2E7D32),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Registered',
                                style: AppTheme.dm(
                                  size: 10,
                                  weight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
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
                        style: AppTheme.dm(
                          size: 12,
                          color: AppColors.muted,
                        ),
                      ),
                      if (isRegistered && registeredData != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '· ${registeredData!.displayLabel}',
                          style: AppTheme.dm(
                            size: 12,
                            weight: FontWeight.w600,
                            color: AppColors.navy,
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
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        method.processingTime,
                        style: AppTheme.dm(
                          size: 11,
                          color: AppColors.muted,
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
                    color: isSelected ? AppColors.navy : AppColors.borderDefault,
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
                      ) : null,
              )
            else
              GestureDetector(
                onTap: () {
                  onRegisterTap();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Add',
                    style: AppTheme.dm(
                      size: 11,
                      weight: FontWeight.w600,
                      color: AppColors.gold,
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
