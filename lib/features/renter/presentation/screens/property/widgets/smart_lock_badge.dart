import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// Shown only for listings the backend reports a smart lock on.
class SmartLockBadge extends StatelessWidget {
  const SmartLockBadge({super.key, this.enabled = false});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context).smartLockCode),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline,
                      color: AppColors.navy, size: 15),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).smartLockEnabled,
                    style: AppTheme.dm(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
