import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';

class CopyReferralLinkButton extends StatelessWidget {
  final VoidCallback onTap;

  const CopyReferralLinkButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.link, size: 18),
      label: const Text('Copy My Referral Link'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF9A7A22),
        side: const BorderSide(color: Color(0xFFEAD9A8)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFFEF7EC),
        textStyle: AppTheme.dm(size: 14, weight: FontWeight.w700),
      ),
    );
  }
}
