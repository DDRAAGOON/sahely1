import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';

class PayoutAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String holderName;

  PayoutAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.holderName,
  });
}

class PayoutSelectionSheet extends StatelessWidget {
  final PayoutAccount? selectedAccount;
  final VoidCallback onAddAccount;

  const PayoutSelectionSheet({
    super.key,
    this.selectedAccount,
    required this.onAddAccount,
  });

  @override
  Widget build(BuildContext context) {
    final accounts = [
      PayoutAccount(
        id: '1',
        bankName: 'CIB Bank',
        accountNumber: 'EG••4821',
        holderName: 'Layla Mansour',
      ),
      PayoutAccount(
        id: '2',
        bankName: 'HSBC Egypt',
        accountNumber: 'EG••9902',
        holderName: 'Layla Mansour',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHandle(),
          const SizedBox(height: 16),
          Text(
            'Select Payout Account',
            style: AppTheme.dm(
              size: 20,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose where you want to receive your funds',
            style: AppTheme.dm(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          
          // Accounts List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: accounts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final acc = accounts[index];
                final isSelected = selectedAccount?.id == acc.id;
                
                return GestureDetector(
                  onTap: () => Navigator.pop(context, acc),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.gold : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.account_balance_outlined, color: AppColors.navy),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${acc.bankName} · ${acc.accountNumber}',
                                style: AppTheme.dm(size: 14, weight: FontWeight.w700),
                              ),
                              Text(
                                acc.holderName,
                                style: AppTheme.dm(size: 12, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.gold, size: 24),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Add Account Button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onAddAccount();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Add payout method',
                    style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
