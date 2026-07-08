import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/theme/app_colors.dart';

class PaymentInstructionsCard extends StatelessWidget {
  final String methodId;
  final int amount;

  const PaymentInstructionsCard({
    super.key,
    required this.methodId,
    required this.amount,
  });

  Map<String, dynamic> _getInstructions() {
    switch (methodId) {
      case 'card':
        return {
          'title': 'Pay with Card',
          'steps': [
            'You will be redirected to Paymob secure checkout',
            'Enter your card details (Visa, Mastercard, or Meeza)',
            'Your wallet will be credited instantly',
          ],
          'note': 'No card data is stored on Sahely servers',
        };
      case 'instapay':
        return {
          'title': 'Send via Instapay',
          'reference': 'SAHELY-INSTA',
          'steps': [
            'Open your Instapay app',
            'Send EGP $amount to: sahely@instapay',
            'Use reference: YOUR_USER_ID',
            'Wallet credited within 5 minutes',
          ],
          'note': 'Include your User ID in the reference field',
        };
      case 'vodafone_cash':
        return {
          'title': 'Send via Vodafone Cash',
          'reference': '0100 123 4567',
          'steps': [
            'Open Vodafone Cash app or dial *9*100#',
            'Send EGP $amount to: 0100 123 4567',
            'Wallet credited within 5 minutes',
          ],
          'note': 'Send exact amount for faster processing',
        };
      case 'orange_money':
        return {
          'title': 'Send via Orange Money',
          'reference': '0120 987 6543',
          'steps': [
            'Dial #115# from your Orange line',
            'Send EGP $amount to: 0120 987 6543',
            'Wallet credited within 5 minutes',
          ],
          'note': 'Standard Orange Money fees may apply',
        };
      case 'etisalat_cash':
        return {
          'title': 'Send via Etisalat Cash',
          'reference': '0111 555 8888',
          'steps': [
            'Dial *778# from your Etisalat line',
            'Send EGP $amount to: 0111 555 8888',
            'Wallet credited within 5 minutes',
          ],
          'note': 'Standard Etisalat Cash fees may apply',
        };
      case 'fawry':
        return {
          'title': 'Pay at Fawry',
          'reference': 'Code will be generated',
          'steps': [
            'Tap "Continue" to generate your Fawry code',
            'Visit any Fawry point (grocery, pharmacy, etc.)',
            'Pay EGP $amount with the generated code',
            'Wallet credited within 1 hour of payment',
          ],
          'note': 'Code expires in 24 hours',
        };
      case 'bank_transfer':
        return {
          'title': 'Bank Transfer',
          'reference': 'CIB · EG••4821',
          'steps': [
            'Transfer EGP $amount to Sahely bank account',
            'Bank: CIB · IBAN: EG38 0010 0000 0000 0000 0000 4821',
            'Reference: YOUR_USER_ID',
            'Wallet credited within 1 business day',
          ],
          'note': 'Admin confirms transfers twice daily (10am & 6pm)',
        };
      default:
        return {'title': '', 'steps': [], 'note': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    final instructions = _getInstructions();
    final steps = instructions['steps'] as List<dynamic>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  instructions['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Reference (if applicable)
          if (methodId != 'card') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send to / Reference',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          instructions['reference'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: instructions['reference']),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reference copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.copy,
                          size: 16,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Steps
          const Text(
            'How it works',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
              fontFamily: 'DM Sans',
            ),
          ),
          const SizedBox(height: 8),

          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        step,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.dark,
                          fontFamily: 'DM Sans',
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          // Note
          if (instructions['note'].isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 14,
                    color: AppColors.gold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      instructions['note'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.dark,
                        fontFamily: 'DM Sans',
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
