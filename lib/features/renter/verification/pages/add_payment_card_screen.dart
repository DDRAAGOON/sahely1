import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../presentation/bloc/verification_cubit.dart';
import '../widgets/verification_progress_indicator.dart';
import '../widgets/card_number_field.dart';
import '../widgets/expiry_cvv_fields.dart';
import '../widgets/cardholder_name_field.dart';
import '../widgets/save_card_button.dart';

class AddPaymentCardScreen extends StatefulWidget {
  final String? legalName; // From ID verification

  const AddPaymentCardScreen({super.key, this.legalName});

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isVerifying = false;
  String? _cardType;

  @override
  void initState() {
    super.initState();
    if (widget.legalName != null) {
      _nameController.text = widget.legalName!;
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged(String value) {
    if (value.startsWith('4')) {
      setState(() => _cardType = 'visa');
    } else if (value.startsWith('5')) {
      setState(() => _cardType = 'mastercard');
    } else {
      setState(() => _cardType = null);
    }
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isVerifying = true);

    try {
      debugPrint('Starting card verification for: ${_nameController.text}');
      await Future.delayed(const Duration(seconds: 2)); // Mock API Call

      if (mounted) {
        context.read<VerificationCubit>().updateCardAdded();
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e'), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 22),
              ),
            ),
          ),
        ),
        title: const Text(
          'Account Verification',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 20),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const VerificationProgressIndicator(currentStep: 4),
                        const SizedBox(height: 30),
                        
                        const Text(
                          'Add Payment Card',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Required to book, refer, or manage properties.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildSecurityStrip(),
                        const SizedBox(height: 30),
                
                        CardNumberField(
                          controller: _cardNumberController,
                          cardType: _cardType,
                          onChanged: _onCardNumberChanged,
                        ),
                        const SizedBox(height: 16),
                        
                        ExpiryCvvFields(
                          expiryController: _expiryController,
                          cvvController: _cvvController,
                        ),
                        const SizedBox(height: 16),
                        
                        CardholderNameField(
                          controller: _nameController,
                          legalName: widget.legalName,
                        ),
                        const SizedBox(height: 12),
                        
                        const Text(
                          'Your card is used for identity verification only and will not be charged without your approval.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.secondary,
                            fontFamily: 'DM Sans',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        
                        const Spacer(),
                        const SizedBox(height: 20),
                        
                        SaveCardButton(
                          isLoading: _isVerifying,
                          onSave: _saveCard,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSecurityStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, color: AppColors.gold, size: 16),
        const SizedBox(width: 8),
        _buildSmallLogo('VISA', const Color(0xFF1A1F71)),
        const SizedBox(width: 8),
        _buildMastercardLogo(),
        const SizedBox(width: 10),
        const Text(
          'Secured by Sahely',
          style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSmallLogo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 20,
      height: 14,
      child: Stack(
        children: [
          Positioned(left: 0, child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle))),
          Positioned(right: 0, child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFF79E1B), shape: BoxShape.circle))),
        ],
      ),
    );
  }
}
