import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';
import '../../renter/presentation/verification/presentation/bloc/verification_cubit.dart';

class AddPaymentCardScreen extends StatefulWidget {
  const AddPaymentCardScreen({super.key});

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _cvvObscure = true;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

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
                      Container(height: 5, decoration: BoxDecoration(color: done ? AppColors.navy : AppColors.gold, borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 5),
                      Text(done ? '$label ✓' : label, style: AppTheme.dm(size: 10, weight: FontWeight.w600, color: done ? AppColors.success : AppColors.gold)),
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
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFF1A1F71), borderRadius: BorderRadius.circular(4)), child: const Text('VISA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11))),
                const SizedBox(width: 8),
                Text('Secured by Sahely', style: AppTheme.dm(size: 11, color: AppColors.muted)),
              ]),
              const SizedBox(height: 18),
              FieldGroup(
                label: 'Card Number', 
                child: AppTextField(
                  controller: _cardNumberController,
                  hintText: '4242 4242 4242 4242', 
                  height: 52,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    _CardNumberFormatter(),
                  ],
                  trailing: Container(
                    height: 52,
                    padding: const EdgeInsets.only(right: 14),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('VISA', style: TextStyle(color: Color(0xFF1A1F71), fontWeight: FontWeight.w700, fontSize: 11)),
                      ],
                    ),
                  ),
                )
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: FieldGroup(
                    label: 'Expiry Date', 
                    child: AppTextField(
                      controller: _expiryController,
                      hintText: '09 / 28', 
                      height: 52,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                    )
                  )
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FieldGroup(
                    label: 'CVV', 
                    child: AppTextField(
                      controller: _cvvController,
                      hintText: '•••', 
                      height: 52, 
                      obscureText: _cvvObscure,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      trailing: GestureDetector(
                        onTap: () => setState(() => _cvvObscure = !_cvvObscure),
                        child: Icon(
                          _cvvObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
                          size: 18, 
                          color: AppColors.muted
                        )
                      )
                    )
                  )
                ),
              ]),
              const SizedBox(height: 12),
              FieldGroup(
                label: 'Name on Card', 
                child: AppTextField(
                  controller: _nameController,
                  hintText: 'Mariam Hassan', 
                  height: 52,
                )
              ),
              const SizedBox(height: 14),
              Text('Your card is used for identity verification only and will not be charged without your approval.', textAlign: TextAlign.center, style: AppTheme.dm(size: 11, color: AppColors.muted).copyWith(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GoldButton(
                label: 'Save Card & Complete Setup',
                onTap: () {
                  final cardNumber = _cardNumberController.text.replaceAll(' ', '');
                  final expiry = _expiryController.text.replaceAll(' ', '');
                  final cvv = _cvvController.text.trim();
                  final name = _nameController.text.trim();

                  if (cardNumber.length < 16) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 16-digit card number')),
                    );
                    return;
                  }
                  if (expiry.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid expiry date (MM / YY)')),
                    );
                    return;
                  }
                  if (cvv.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 3-digit CVV')),
                    );
                    return;
                  }
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter the cardholder name')),
                    );
                    return;
                  }

                  // Update the VerificationCubit status safely
                  try {
                    context.read<VerificationCubit>().updateCardAdded();
                  } catch (_) {}

                  // Card details are handled strictly securely. No raw card data is ever printed or logged.
                  Navigator.maybePop(context);
                }
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // Skip for now during signup
                  Navigator.maybePop(context);
                },
                child: Text(
                  'Skip for now',
                  style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.gold),
                ),
              ),
            ],
          )
        ),
      ]),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonSpaceLength = i + 1;
      if (nonSpaceLength % 4 == 0 && nonSpaceLength != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonSpaceLength = i + 1;
      if (nonSpaceLength == 2 && nonSpaceLength != text.length) {
        buffer.write(' / ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
