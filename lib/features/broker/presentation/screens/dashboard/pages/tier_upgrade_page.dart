import 'package:flutter/material.dart';

import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

class BrokerTierUpgradePage extends StatelessWidget {
  const BrokerTierUpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(alignment: Alignment.center, children: [
              Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.goldBright, AppColors.gold]),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.5),
                            blurRadius: 30)
                      ]),
                  child: const Icon(Icons.workspace_premium,
                      color: AppColors.navy, size: 50)),
              Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                          color: AppColors.navy, shape: BoxShape.circle),
                      child: const Icon(Icons.star,
                          size: 20, color: AppColors.gold))),
            ]),
          ),
          const SizedBox(height: 18),
          Text('TIER 3 UNLOCKED',
              style: AppTheme.dm(
                  size: 12,
                  weight: FontWeight.w700,
                  color: const Color(0xFF9A7A22),
                  letterSpacing: 3)),
          const SizedBox(height: 8),
          Text("You're a Gold Broker!",
              style: AppTheme.dm(
                  size: 27, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 10),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: AppTheme.dm(
                      size: 14, color: AppColors.muted, height: 1.5),
                  children: const [
                    TextSpan(text: 'Your commission rate is now '),
                    TextSpan(
                        text: '4%',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9A7A22))),
                    TextSpan(text: ' on all new referrals this season.'),
                  ])),
          const SizedBox(height: 18),
          WhiteCard(
              padding: const EdgeInsets.all(14),
              radius: 18,
              child: Row(children: [
                Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFBF3DE),
                        borderRadius: BorderRadius.circular(12)),
                    child:
                        const Icon(Icons.home_outlined, color: AppColors.gold)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('NEW TIER PERKS',
                          style: AppTheme.dm(
                              size: 11,
                              weight: FontWeight.w700,
                              color: const Color(0xFF9A7A22))),
                      Text('2 free stays + beach pass',
                          style: AppTheme.dm(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                    ])),
              ])),
          const SizedBox(height: 12),
          const StatRow(cards: [
            StatCard(
                value: '4%', label: 'New rate', valueColor: Color(0xFF9A7A22)),
            StatCard(value: '55', label: 'Properties'),
            StatCard(value: '45', label: 'To Elite')
          ]),
          const SizedBox(height: 18),
          NavyButton(
            label: 'View My Wallet',
            radius: 999,
            onTap: () {
              AppNavigation.goToBrokerHistory(context);
            },
          ),
          const SizedBox(height: 14),
          GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Text('Keep referring',
                  style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.muted))),
        ]),
      ),
    );
  }
}
