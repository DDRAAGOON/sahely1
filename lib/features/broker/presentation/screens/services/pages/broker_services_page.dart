import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';

class BrokerServicesPage extends StatelessWidget {
  const BrokerServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Broker Services',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'Cairo'),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.navy.withValues(alpha: 0.04),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.business_center_outlined,
                            size: 40, color: AppColors.gold),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Exclusive for Brokers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'Cairo'),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Manage your referrals, track payouts, and access premium tools for top brokers.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondary,
                              height: 1.4,
                              fontFamily: 'Cairo'),
                        ),
                      ),
                    ],
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
