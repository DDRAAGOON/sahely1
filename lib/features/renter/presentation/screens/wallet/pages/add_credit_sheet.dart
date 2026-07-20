import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../verification/pages/add_payment_card_screen.dart';
import '../widgets/payment_instructions_card.dart';
import '../widgets/payment_method_tile.dart';

class AddCreditSheet extends StatefulWidget {
  /// الطرق المسجلة للمستخدم (من البروفايل)
  final List<RegisteredPaymentMethod> registeredMethods;

  const AddCreditSheet({
    super.key,
    required this.registeredMethods,
  });

  @override
  State<AddCreditSheet> createState() => _AddCreditSheetState();
}

class _AddCreditSheetState extends State<AddCreditSheet> {
  String? _selectedMethod;
  int _selectedAmount = 500; // Default amount in EGP
  late TextEditingController _amountController;

  final List<int> _quickAmounts = [100, 250, 500, 1000, 2500, 5000];

  // كل طرق الدفع المتاحة في Sahely
  final List<PaymentMethod> _allMethods = [
    const PaymentMethod(
      id: 'card',
      name: 'Credit / Debit Card',
      subtitle: 'Visa, Mastercard, Meeza',
      icon: Icons.credit_card,
      iconColor: Color(0xFF1A1F71),
      iconBgColor: Color(0xFFE8EAF6),
      processingTime: 'Instant',
    ),
    const PaymentMethod(
      id: 'instapay',
      name: 'Instapay',
      subtitle: 'Instant bank transfer',
      icon: Icons.account_balance,
      iconColor: Color(0xFFE91E63),
      iconBgColor: Color(0xFFFCE4EC),
      processingTime: 'Within 5 minutes',
    ),
    const PaymentMethod(
      id: 'vodafone_cash',
      name: 'Vodafone Cash',
      subtitle: 'Mobile wallet',
      icon: Icons.phone_android,
      iconColor: Color(0xFFE60000),
      iconBgColor: Color(0xFFFFEBEE),
      processingTime: 'Within 5 minutes',
    ),
    const PaymentMethod(
      id: 'orange_money',
      name: 'Orange Money',
      subtitle: 'Mobile wallet',
      icon: Icons.phone_android,
      iconColor: Color(0xFFFF6600),
      iconBgColor: Color(0xFFFFF3E0),
      processingTime: 'Within 5 minutes',
    ),
    const PaymentMethod(
      id: 'etisalat_cash',
      name: 'Etisalat Cash',
      subtitle: 'Mobile wallet',
      icon: Icons.phone_android,
      iconColor: Color(0xFF00A651),
      iconBgColor: Color(0xFFE8F5E9),
      processingTime: 'Within 5 minutes',
    ),
    const PaymentMethod(
      id: 'fawry',
      name: 'Fawry',
      subtitle: 'Pay at any Fawry point',
      icon: Icons.point_of_sale,
      iconColor: Color(0xFFFFC107),
      iconBgColor: Color(0xFFFFF8E1),
      processingTime: 'Within 1 hour',
    ),
    const PaymentMethod(
      id: 'bank_transfer',
      name: 'Bank Transfer',
      subtitle: 'Direct from your bank',
      icon: Icons.account_balance_wallet,
      iconColor: AppColors.navy,
      iconBgColor: Color(0xFFE6EAF2),
      processingTime: '1 business day',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _selectedAmount.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool _isMethodRegistered(String methodId) {
    return widget.registeredMethods.any((m) => m.methodId == methodId);
  }

  RegisteredPaymentMethod? _getRegisteredMethod(String methodId) {
    try {
      return widget.registeredMethods.firstWhere((m) => m.methodId == methodId);
    } catch (_) {
      return null;
    }
  }

  void _proceedToPayment() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // TODO: Navigate to payment flow based on selected method
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Proceeding with $_selectedMethod for EGP $_selectedAmount'),
        backgroundColor: AppColors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Credit',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Top up your Sahely wallet',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondary,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.navy,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Section
                  _buildAmountSection(),

                  const SizedBox(height: 24),

                  // Payment Methods Section
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                      fontFamily: 'DM Sans',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Payment Methods List
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: _allMethods.asMap().entries.map((entry) {
                        final index = entry.key;
                        final method = entry.value;
                        final isLast = index == _allMethods.length - 1;
                        final isRegistered = _isMethodRegistered(method.id);
                        final registeredData = _getRegisteredMethod(method.id);

                        return Column(
                          children: [
                            PaymentMethodTile(
                              method: method,
                              isSelected: _selectedMethod == method.id,
                              isRegistered: isRegistered,
                              registeredData: registeredData,
                              onTap: () {
                                setState(() {
                                  _selectedMethod = method.id;
                                });
                              },
                              onRegisterTap: () {
                                if (method.id == 'card') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddPaymentCardScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Registration for ${method.name} coming soon'),
                                    ),
                                  );
                                }
                              },
                            ),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                color: AppColors.border,
                                indent: 16,
                                endIndent: 16,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Instructions Card (if method selected)
                  if (_selectedMethod != null)
                    PaymentInstructionsCard(
                      methodId: _selectedMethod!,
                      amount: _selectedAmount,
                    ),

                  const SizedBox(height: 16),

                  // Security Note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: AppColors.gold,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All transactions are secured by Sahely. Your payment information is encrypted and never stored on our servers.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.secondary,
                              fontFamily: 'DM Sans',
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Proceed Button (pinned at bottom)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.cream,
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedMethod != null
                        ? AppColors.navy
                        : AppColors.border,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _selectedMethod != null
                        ? 'Continue · EGP $_selectedAmount'
                        : 'Select a payment method',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AMOUNT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),

        // Amount Input Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add to wallet',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Text(
                          'EGP',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              fontFamily: 'DM Sans',
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              if (parsed != null) {
                                setState(() {
                                  _selectedAmount = parsed;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Quick Amount Pills
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickAmounts.map((amount) {
            final isSelected = _selectedAmount == amount;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAmount = amount;
                  _amountController.text = amount.toString();
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.navy : AppColors.border,
                    width: 1,
                  ),
                ),
                child: Text(
                  'EGP $amount',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        // Limits note
        const Text(
          'Min 100 EGP · Max 50,000 EGP per transaction',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }
}

/// Payment Method Model
class PaymentMethod {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String processingTime;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.processingTime,
  });
}

/// Registered Payment Method Model (من البروفايل)
class RegisteredPaymentMethod {
  final String methodId;
  final String displayLabel; // e.g., "•••• 7890" or "mariam@instapay"
  final bool isDefault;

  const RegisteredPaymentMethod({
    required this.methodId,
    required this.displayLabel,
    this.isDefault = false,
  });
}
