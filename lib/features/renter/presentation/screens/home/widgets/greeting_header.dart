import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final profileName = context.watch<ProfileProvider>().name;
    final displayName = profileName.isNotEmpty
        ? profileName
        : AppLocalizations.of(context).guestFallback;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.goodMorning,
                style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                displayName,
                style: AppTheme.dm(
                    size: 24, weight: FontWeight.w700, color: AppColors.navy),
              ),
            ],
          ),
        ),
        // Renter Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.renterPillBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.navy,
              ),
              const SizedBox(width: 6),
              Text(
                l.renter,
                style: AppTheme.dm(
                  size: 12,
                  weight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
