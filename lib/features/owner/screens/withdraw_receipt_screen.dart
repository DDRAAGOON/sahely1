import 'package:flutter/material.dart';

import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/l10n/app_localizations.dart';

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
                  child: Text(AppLocalizations.of(context).withdrawalRequested,
                      style: AppTheme.dm(
                          size: 24,
                          weight: FontWeight.w700,
                          color: AppColors.navy))),
              const SizedBox(height: 8),
              Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: AppTheme.dm(
                              size: 14, color: AppColors.muted, height: 1.5),
                          children: [
                            TextSpan(
                                text:
                                    '${CurrencyFormatter.format(20000)} is on its way. Expect it in your account within '),
                            TextSpan(
                                text: '2 working days',
                                style: AppTheme.dm(
                                    weight: FontWeight.w700,
                                    color: AppColors.ink)),
                            const TextSpan(text: '.')
                          ]))),
              const SizedBox(height: 20),
              WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    KeyValueRow(AppLocalizations.of(context).amountLabel,
                        CurrencyFormatter.format(20000)),
                    KeyValueRow(
                        AppLocalizations.of(context).toLabel, 'CIB ••4821'),
                    KeyValueRow(AppLocalizations.of(context).referenceLabel,
                        'PO-4471-2026'),
                    KeyValueRow(AppLocalizations.of(context).requestedLabel,
                        'Jun 18, 9:41 AM'),
                    KeyValueRow(
                        AppLocalizations.of(context).estArrival, 'Jun 20',
                        valueColor: AppColors.success,
                        bold: true,
                        topBorder: true),
                  ])),
              const SizedBox(height: 14),
              InfoNote(
                  text: AppLocalizations.of(context).notifyWhenSent,
                  icon: Icons.schedule),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            WideButton(
                label: AppLocalizations.of(context).downloadReceipt,
                color: AppColors.navy,
                outline: true,
                height: 44),
            const SizedBox(height: 10),
            NavyButton(
                label: AppLocalizations.of(context).doneLabel,
                onTap: () => Navigator.popUntil(
                    context,
                    (r) =>
                        r.settings.name == AppRoutes.ownerEarnings ||
                        r.settings.name == AppRoutes.brokerWallet ||
                        r.isFirst)),
          ]),
        ),
      ]),
    );
  }
}
