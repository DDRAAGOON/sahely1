import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class AccountVerificationSection extends StatelessWidget {
  final bool emailConfirmed;
  final bool phoneVerified;
  final bool identityVerified;
  final bool paymentCardAdded;

  const AccountVerificationSection({
    super.key,
    required this.emailConfirmed,
    required this.phoneVerified,
    required this.identityVerified,
    required this.paymentCardAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Text(
              'Account Verification',
              style: AppTheme.dm(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 8),
            // Orange dot if incomplete
            if (!identityVerified || !paymentCardAdded)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Verification Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Email
              const _VerificationRow(
                icon: Icons.check_circle,
                iconColor: AppColors.green,
                label: 'Email Confirmed',
                status: VerificationStatus.done,
              ),
              _Divider(),
              // Phone
              const _VerificationRow(
                icon: Icons.check_circle,
                iconColor: AppColors.green,
                label: 'Phone Verified',
                status: VerificationStatus.done,
              ),
              _Divider(),
              // Identity
              _VerificationRow(
                icon: Icons.error_outline,
                iconColor: AppColors.warning,
                label: 'Identity Verified',
                status: VerificationStatus.pending,
                actionLabel: 'Verify Now →',
                onAction: () => AppNavigation.goToIdVerification(context),
              ),
              _Divider(),
              // Payment Card
              _VerificationRow(
                icon:
                    paymentCardAdded ? Icons.check_circle : Icons.error_outline,
                iconColor:
                    paymentCardAdded ? AppColors.green : AppColors.warning,
                label: 'Payment Card',
                status: paymentCardAdded
                    ? VerificationStatus.done
                    : VerificationStatus.pending,
                actionLabel: 'Add Card →',
                onAction: () => AppNavigation.goToAddCard(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum VerificationStatus { done, pending, inReview }

class _VerificationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VerificationStatus status;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _VerificationRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.status,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.dm(
                size: 14,
                color: AppColors.dark,
              ),
            ),
          ),
          if (status == VerificationStatus.pending && actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.gold,
                ),
              ),
            )
          else if (status == VerificationStatus.done)
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
      indent: 0,
      endIndent: 0,
    );
  }
}
