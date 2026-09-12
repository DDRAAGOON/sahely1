import 'package:flutter/material.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow(
      {super.key,
      required this.icon,
      required this.label,
      this.value,
      this.valueColor,
      this.iconColor,
      this.onTap,
      this.last = false});

  final IconData icon;
  final String label;
  final String? value;
  final Color? valueColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF4EFE7)))),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? AppColors.navy),
            const SizedBox(width: 12),
            Expanded(
                child: Text(label,
                    style: AppTheme.dm(size: 14, weight: FontWeight.w500))),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(value!,
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w700,
                        color: valueColor ?? AppColors.muted)),
              ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.navy),
          ],
        ),
      ),
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow(this.label, this.value,
      {super.key,
      this.valueColor = AppColors.navy,
      this.bold = false,
      this.topBorder = false});

  final String label;
  final String value;
  final Color valueColor;
  final bool bold;
  final bool topBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: topBorder
          ? const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTheme.dm(
                  size: 13,
                  color: AppColors.muted,
                  weight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(value,
              style: AppTheme.dm(
                  size: bold ? 14 : 13,
                  weight: FontWeight.w700,
                  color: valueColor)),
        ],
      ),
    );
  }
}
