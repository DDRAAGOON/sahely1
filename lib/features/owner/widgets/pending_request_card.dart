import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

import '../../../core/navigation/app_navigation.dart';

class PendingRequestCard extends StatelessWidget {
  const PendingRequestCard({
    super.key,
    this.onTap,
    this.onApprove,
    this.onDecline,
  });

  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  void _showDeclineBottomSheet(BuildContext context, String name) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Text('Decline Request',
                style: AppTheme.dm(
                    size: 20, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text('Please provide a reason for declining $name\'s request.',
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Unit is undergoing maintenance...',
                  border: InputBorder.none,
                ),
                style: AppTheme.dm(size: 14),
              ),
            ),
            const SizedBox(height: 24),
            NavyButton(
              label: 'Confirm Decline',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request for $name declined')),
                );
                if (onDecline != null) onDecline!();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockData = {
      'guestName': 'Omar Khalil',
      'rating': '4.9',
      'verified': true,
      'propertyName': 'Azure Villa',
      'stays': '12 stays',
      'dates': 'Jun 21–25',
      'total': '18,000',
      'guests': '4 guests · 2A 2C',
      'status': 'Pending',
    };

    return BouncyButton(
      onTap: onTap ?? () => AppNavigation.goToOwnerRequestDetail(context, extra: mockData),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Column(children: [
          Row(children: [
            const AvatarCircle(
              size: 48,
              colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('Omar Khalil',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, size: 12, color: AppColors.gold),
                    Text(' 4.9',
                        style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.gold)),
                  ]),
                  const SizedBox(height: 2),
                  Text('Azure Villa · Jun 21–25',
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.faint),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            const Pill('4 guests',
                bg: Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
            const SizedBox(width: 8),
            const Pill('2A · 2C',
                bg: Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
            const SizedBox(width: 8),
            Pill(CurrencyFormatter.format(18000),
                bg: const Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: WideButton(
                label: 'Approve',
                color: const Color(0xFF1B6B3A),
                height: 48,
                radius: 12,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request Approved')),
                  );
                  if (onApprove != null) onApprove!();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WideButton(
                label: 'Decline',
                color: const Color(0xFFB3261E),
                textColor: const Color(0xFFB3261E),
                outline: true,
                height: 48,
                radius: 12,
                onTap: () => _showDeclineBottomSheet(context, 'Omar Khalil'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
