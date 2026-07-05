import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/tags.dart';
import '../screens/owner_requests_screen.dart';

class PendingRequestCard extends StatelessWidget {
  const PendingRequestCard({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('Omar Khalil', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, size: 12, color: AppColors.gold),
                    Text(' 4.9', style: AppTheme.dm(size: 13, weight: FontWeight.w700, color: AppColors.gold)),
                  ]),
                  const SizedBox(height: 2),
                  Text('Azure Villa · Jun 21–25', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.faint),
          ]),
        ),
        const SizedBox(height: 14),
        const Row(children: [
          Pill('4 guests', bg: Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
          SizedBox(width: 8),
          Pill('2A · 2C', bg: Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
          SizedBox(width: 8),
          Pill('EGP 18,000', bg: Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: WideButton(
              label: 'Approve', 
              color: const Color(0xFF1B6B3A), 
              height: 48, 
              radius: 12,
              onTap: () => showApprovedSheet(context),
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
              onTap: () => showDeclineSheet(context),
            ),
          ),
        ]),
      ]),
    );
  }
  }
