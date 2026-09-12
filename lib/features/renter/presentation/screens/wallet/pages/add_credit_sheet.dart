import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';

class AddCreditSheet extends StatefulWidget {
  const AddCreditSheet({super.key});

  @override
  State<AddCreditSheet> createState() => _AddCreditSheetState();
}

class _AddCreditSheetState extends State<AddCreditSheet> {
  final TextEditingController _amountController = TextEditingController();
  final String _selectedMethod = 'Visa ending in 8842';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          const SizedBox(height: 12),
          Text(
            'Add Credit',
            style: AppTheme.dm(
                size: 20, weight: FontWeight.w700, color: AppColors.navy),
          ),
          const SizedBox(height: 24),

          // Amount Input
          _buildSectionTitle('Amount to add'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: AppTheme.dm(
                  size: 18, weight: FontWeight.w700, color: AppColors.navy),
              decoration: const InputDecoration(
                hintText: '0.00',
                prefixText: 'EGP ',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Payment Method
          _buildSectionTitle('Payment method'),
          const SizedBox(height: 12),
          _buildPaymentMethodTile(),
          const SizedBox(height: 32),

          NavyButton(
            label: 'Confirm Deposit',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Credit added successfully!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTheme.dm(
            size: 14, weight: FontWeight.w600, color: AppColors.muted),
      ),
    );
  }

  Widget _buildPaymentMethodTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card, color: AppColors.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedMethod,
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w600, color: AppColors.navy),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
        ],
      ),
    );
  }
}
