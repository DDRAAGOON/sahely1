import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/ui.dart';
import '../../../widgets/cream_background.dart';

class ReferPropertyScreen extends StatelessWidget {
  const ReferPropertyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
            children: [
              const Align(alignment: Alignment.centerLeft, child: BackChip()),
              const SizedBox(height: 16),
              Text('Refer a Property', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 6),
              Text('Refer a property owner and earn commissions on every booking', style: AppTheme.dm(size: 14, color: AppColors.muted)),
              const SizedBox(height: 20),
              const FieldGroup(label: 'Owner Name', child: FakeField(value: 'Full name', hint: true, height: 50)),
              const SizedBox(height: 14),
              const FieldGroup(label: 'Phone', child: FakeField(value: '+20 ...', hint: true, height: 50)),
              const SizedBox(height: 14),
              const FieldGroup(label: 'Property Name', child: FakeField(value: 'Property name', hint: true, height: 50)),
              const SizedBox(height: 14),
              const FieldGroup(label: 'Location Area', child: FakeField(value: 'Select area', hint: true, height: 50, trailing: Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.muted))),
              const SizedBox(height: 18),
              Container(
                height: 48,
                decoration: BoxDecoration(color: const Color(0xFFFDF9F4), border: Border.all(color: AppColors.gold, width: 1.5), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.link, size: 16, color: Color(0xFFA9863A)),
                  const SizedBox(width: 8),
                  Text('Copy My Referral Link', style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: const Color(0xFFA9863A))),
                ])),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
          child: NavyButton(label: 'Submit Referral', onTap: () => Navigator.maybePop(context)),
        ),
      ]),
    );
  }
}
