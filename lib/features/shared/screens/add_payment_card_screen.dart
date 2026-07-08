import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/ui.dart';

class AddPaymentCardScreen extends StatelessWidget {
  const AddPaymentCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            children: [
              Row(children: [
                const BackChip(),
                const SizedBox(width: 12),
                Text('Account Verification', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy)),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                for (final (label, done) in [('Email', true), ('Phone', true), ('Identity', true), ('Card', false)]) ...[
                  Expanded(
                    child: Column(children: [
                      Container(height: 5, decoration: BoxDecoration(color: done ? AppColors.navy : const Color(0xFFD2760A), borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 5),
                      Text(done ? '$label ✓' : label, style: AppTheme.dm(size: 10, weight: FontWeight.w600, color: done ? AppColors.success : const Color(0xFFD2760A))),
                    ]),
                  ),
                  if (label != 'Card') const SizedBox(width: 6),
                ],
              ]),
              const SizedBox(height: 18),
              Center(child: Text('Add Payment Card', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy))),
              const SizedBox(height: 6),
              Center(child: Text('Required to book, refer, or manage properties.', style: AppTheme.dm(size: 13, color: AppColors.muted))),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.lock_outline, size: 16, color: AppColors.gold),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFF1A1F71), borderRadius: BorderRadius.circular(4)), child: Text('VISA', style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: Colors.white))),
                const SizedBox(width: 8),
                Text('Secured by Sahely', style: AppTheme.dm(size: 11, color: AppColors.muted)),
              ]),
              const SizedBox(height: 18),
              const FieldGroup(label: 'Card Number', child: FakeField(value: '4242 4242 4242 4242', focused: true, height: 52, trailing: Text('VISA', style: TextStyle(color: Color(0xFF1A1F71), fontWeight: FontWeight.w700, fontSize: 11)))),
              const SizedBox(height: 12),
              const Row(children: [
                Expanded(child: FieldGroup(label: 'Expiry Date', child: FakeField(value: '09 / 28', height: 52))),
                SizedBox(width: 12),
                Expanded(child: FieldGroup(label: 'CVV', child: FakeField(value: '•••', height: 52, trailing: Icon(Icons.visibility_outlined, size: 18, color: AppColors.muted)))),
              ]),
              const SizedBox(height: 12),
              const FieldGroup(label: 'Name on Card', child: FakeField(value: 'Mariam Hassan', height: 52)),
              const SizedBox(height: 14),
              Text('Your card is used for identity verification only and will not be charged without your approval.', textAlign: TextAlign.center, style: AppTheme.dm(size: 11, color: AppColors.muted).copyWith(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(16), child: GoldButton(label: 'Save Card & Complete Setup', onTap: () => Navigator.maybePop(context))),
      ]),
    );
  }
}
