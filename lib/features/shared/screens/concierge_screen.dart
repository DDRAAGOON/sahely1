import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';

class ConciergeScreen extends StatefulWidget {
  const ConciergeScreen({super.key});

  @override
  State<ConciergeScreen> createState() => _ConciergeScreenState();
}

class _ConciergeScreenState extends State<ConciergeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        child: EntranceFaded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.room_service_outlined,
                  size: 48,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Coming Soon',
                style: AppTheme.dm(
                  size: 28,
                  weight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'We are currently curating the most premium services for your stay. Check back soon for exclusive access.',
                  textAlign: TextAlign.center,
                  style: AppTheme.dm(
                    size: 14,
                    color: AppColors.secondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
