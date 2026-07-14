import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';

class BrokerTierCard extends StatelessWidget {
  const BrokerTierCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/broker/tier'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF2A2418), Color(0xFF141D33)]), 
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('BROKER PASS', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.gold, letterSpacing: 3)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), 
              child: Text('Season 2026', style: AppTheme.dm(size: 10, color: AppColors.gold))
            ),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Container(
              width: 44, 
              height: 44, 
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), 
              child: const Icon(Icons.workspace_premium, color: AppColors.gold)
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tier 3 of 4 ط¢آ· 4% commission', style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF))),
              Text('Gold Broker', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: Colors.white)),
            ])),
            Text('55', style: AppTheme.dm(size: 20, weight: FontWeight.w700, color: AppColors.gold)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4), 
            child: const LinearProgressIndicator(
              value: 0.55, 
              minHeight: 6, 
              backgroundColor: Colors.white24, 
              valueColor: AlwaysStoppedAnimation(AppColors.gold)
            )
          ),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RichText(text: TextSpan(style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF)), children: const [
              TextSpan(text: '45 more', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold)), 
              TextSpan(text: ' to Elite (5%)')
            ])),
            Text('100', style: AppTheme.dm(size: 11, color: const Color(0xFF9FB0CF))),
          ]),
        ]),
      ),
    );
  }
}
