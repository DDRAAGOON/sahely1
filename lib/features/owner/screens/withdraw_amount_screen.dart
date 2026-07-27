import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/owner/widgets/payout_selection_sheet.dart';

class WithdrawAmountScreen extends StatefulWidget {
  const WithdrawAmountScreen({super.key});

  @override
  State<WithdrawAmountScreen> createState() => _WithdrawAmountScreenState();
}

class _WithdrawAmountScreenState extends State<WithdrawAmountScreen> {
  final _amountController = TextEditingController(text: '20,000');
  final double _available = 38900;
  String _selectedP = '50%';
  
  PayoutAccount _selectedAccount = PayoutAccount(
    id: '1',
    bankName: 'CIB Bank',
    accountNumber: 'EG••4821',
    holderName: 'Layla Mansour',
  );

  void _setPercent(String p, double factor) {
    setState(() {
      _selectedP = p;
      final amount = (_available * factor).round();
      final formatted = amount
          .toString()
          .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
      _amountController.text = formatted;
    });
  }

  void _onWithdraw() {
    final role = context.read<RoleState>().currentRole;
    if (role == Role.broker) {
      AppNavigation.goToBrokerWithdrawReceipt(context);
    } else {
      AppNavigation.goToOwnerWithdrawReceipt(context);
    }
  }

  void _onChangeAccount() async {
    final result = await showModalBottomSheet<PayoutAccount>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PayoutSelectionSheet(
        selectedAccount: _selectedAccount,
        onAddAccount: () {
          final role = context.read<RoleState>().currentRole;
          if (role == Role.broker) {
            AppNavigation.goToBrokerPayout(context);
          } else {
            AppNavigation.goToOwnerPayout(context);
          }
        },
      ),
    );

    if (result != null) {
      setState(() {
        _selectedAccount = result;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
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
              const TopBar(title: 'Withdraw to Bank'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF22335A), AppColors.navy]),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Available to withdraw',
                          style: AppTheme.dm(
                              size: 13, color: const Color(0xFFCDD4E0))),
                      const SizedBox(height: 6),
                      Text('EGP 38,900',
                          style: AppTheme.dm(
                              size: 30,
                              weight: FontWeight.w700,
                              color: AppColors.gold)),
                      const SizedBox(height: 4),
                      Text(
                          'EGP 5,000 still pending (clears 48h after check-in)',
                          style: AppTheme.dm(
                              size: 11, color: const Color(0xFF9FB0CF))),
                    ]),
              ),
              const SizedBox(height: 16),
              Text('Amount to withdraw',
                  style: AppTheme.dm(size: 13, weight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.gold, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text('EGP',
                        style: AppTheme.dm(size: 22, color: AppColors.muted)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ThousandsFormatter()
                        ],
                        style: AppTheme.dm(
                            size: 34,
                            weight: FontWeight.w700,
                            color: AppColors.navy),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) {
                          if (_selectedP.isNotEmpty)
                            setState(() => _selectedP = '');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                for (final (p, factor) in [
                  ('25%', 0.25),
                  ('50%', 0.5),
                  ('75%', 0.75),
                  ('All', 1.0)
                ]) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _setPercent(p, factor),
                      child: Container(
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedP == p
                              ? AppColors.navy
                              : AppColors.white,
                          border: _selectedP == p
                              ? null
                              : Border.all(color: AppColors.navy),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          p,
                          style: AppTheme.dm(
                            size: 13,
                            weight: FontWeight.w600,
                            color:
                                _selectedP == p ? Colors.white : AppColors.navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (p != 'All') const SizedBox(width: 8),
                ],
              ]),
              const SizedBox(height: 16),
              Text('To account',
                  style: AppTheme.dm(size: 13, weight: FontWeight.w700)),
              const SizedBox(height: 8),
              WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.account_balance_outlined,
                            color: AppColors.navy)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('${_selectedAccount.bankName} · ${_selectedAccount.accountNumber}',
                              style: AppTheme.dm(
                                  size: 13, weight: FontWeight.w700)),
                          Text(_selectedAccount.holderName,
                              style: AppTheme.dm(
                                  size: 11, color: AppColors.muted)),
                        ])),
                    GestureDetector(
                      onTap: _onChangeAccount,
                      behavior: HitTestBehavior.opaque,
                      child: Text('Change',
                          style: AppTheme.dm(
                              size: 12,
                              weight: FontWeight.w600,
                              color: AppColors.gold)),
                    ),
                  ])),
              const SizedBox(height: 14),
              const InfoNote(
                  text:
                      'Funds arrive in 2 working days. No fee for transfers over EGP 5,000.'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ListenableBuilder(
            listenable: _amountController,
            builder: (context, _) => NavyButton(
              label: 'Withdraw EGP ${_amountController.text}',
              onTap: _onWithdraw,
            ),
          ),
        ),
      ]),
    );
  }
}



class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldV, TextEditingValue newV) {
    if (newV.text.isEmpty) return newV;
    final num = int.tryParse(newV.text.replaceAll(',', '')) ?? 0;
    final formatted = num.toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
