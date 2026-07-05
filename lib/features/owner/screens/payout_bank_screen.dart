import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../../../core/widgets/cream_background.dart';

class PayoutBankScreen extends StatefulWidget {
  const PayoutBankScreen({super.key});

  @override
  State<PayoutBankScreen> createState() => _PayoutBankScreenState();
}

class _PayoutBankScreenState extends State<PayoutBankScreen> {
  final _bankController = TextEditingController();
  final _nameController = TextEditingController();
  final _accountController = TextEditingController();
  final _ibanController = TextEditingController();
  final _swiftController = TextEditingController();

  @override
  void dispose() {
    _bankController.dispose();
    _nameController.dispose();
    _accountController.dispose();
    _ibanController.dispose();
    _swiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              const TopBar(title: 'Payout Account'),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.account_balance, color: AppColors.gold, size: 30),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Where your earnings are paid out. Make sure the name matches your verified ID.',
                    textAlign: TextAlign.center,
                    style: AppTheme.dm(size: 13, color: AppColors.muted),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FieldGroup(
                label: 'Bank Name',
                child: AppTextField(
                  controller: _bankController,
                  hintText: 'CIB — Commercial International Bank',
                  height: 52,
                ),
              ),
              const SizedBox(height: 16),
              FieldGroup(
                label: 'Account holder name',
                child: AppTextField(
                  controller: _nameController,
                  hintText: 'Layla Mansour',
                  height: 52,
                ),
              ),
              const SizedBox(height: 16),
              FieldGroup(
                label: 'Bank account number',
                child: AppTextField(
                  controller: _accountController,
                  hintText: '100 0214 8821 0045',
                  height: 52,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              FieldGroup(
                label: 'IBAN',
                child: AppTextField(
                  controller: _ibanController,
                  hintText: 'EG38 0019 0005 0000 0010 0214 8821',
                  height: 52,
                ),
              ),
              const SizedBox(height: 16),
              FieldGroup(
                label: 'SWIFT / BIC (optional)',
                child: AppTextField(
                  controller: _swiftController,
                  hintText: 'e.g. CIBEEGCX',
                  height: 52,
                ),
              ),
              const SizedBox(height: 20),
              const InfoNote(
                  text: 'Your bank details are encrypted and used only for payouts.', icon: Icons.lock_outline),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: NavyButton(label: 'Save Account', onTap: () => Navigator.maybePop(context)),
        ),
      ]),
    );
  }
}
