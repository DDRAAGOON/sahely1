import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../../../core/widgets/cream_background.dart';

class WithdrawReceiptScreen extends StatelessWidget {
  const WithdrawReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            children: [
              const Center(child: SuccessCheck(size: 96)),
              const SizedBox(height: 20),
              Center(
                  child: Text('Withdrawal requested',
                      style: AppTheme.dm(size: 24, weight: FontWeight.w700, color: AppColors.navy))),
              const SizedBox(height: 8),
              Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(style: AppTheme.dm(size: 14, color: AppColors.muted, height: 1.5), children: const [
                        TextSpan(text: 'EGP 20,000 is on its way. Expect it in your account within '),
                        TextSpan(text: '2 working days', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                        TextSpan(text: '.')
                      ]))),
              const SizedBox(height: 20),
              const WhiteCard(
                  padding: EdgeInsets.all(16),
                  child: Column(children: [
                    KeyValueRow('Amount', 'EGP 20,000'),
                    KeyValueRow('To', 'CIB ••4821'),
                    KeyValueRow('Reference', 'PO-4471-2026'),
                    KeyValueRow('Requested', 'Jun 18, 9:41 AM'),
                    KeyValueRow('Est. arrival', 'Jun 20', valueColor: AppColors.success, bold: true, topBorder: true),
                  ])),
              const SizedBox(height: 14),
              const InfoNote(text: "We'll notify you when the transfer is sent to your bank.", icon: Icons.schedule),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const WideButton(label: 'Download receipt', color: AppColors.navy, outline: true, height: 44),
            const SizedBox(height: 10),
            NavyButton(
                label: 'Done',
                onTap: () => Navigator.popUntil(
                    context,
                    (r) =>
                        r.settings.name == '/owner/earnings' ||
                        r.settings.name == '/broker/wallet' ||
                        r.isFirst)),
          ]),
        ),
      ]),
    );
  }
}
