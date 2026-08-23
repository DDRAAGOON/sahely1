import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class AddPaymentCardScreen extends StatefulWidget {
  const AddPaymentCardScreen({super.key});

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

enum CardType { visa, mastercard, unknown }

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isCvvObscured = true;
  CardType _cardType = CardType.unknown;

  // ✅ متغيرات للـ state عشان البطاقة تتحدث فوراً
  String _displayExpiry = 'MM / YY';
  String _displayName = 'YOUR NAME HERE';

  final List<Map<String, dynamic>> _linkedCards = [
    {'type': CardType.visa, 'name': 'Visa Platinum', 'last4': '8842'},
    {'type': CardType.mastercard, 'name': 'Mastercard World Elite', 'last4': '1109'},
  ];

  void _deleteCard(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Card', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: Text('Are you sure you want to remove this payment method?', style: AppTheme.dm(size: 14, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _linkedCards.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: Text('Delete', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showManageAllSheet() {
    showModalBottomSheet(
      useRootNavigator: true, context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: AppColors.borderDefault, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Manage Payment Methods', style: AppTheme.dm(size: 20, weight: FontWeight.w800, color: AppColors.navy)),
                const SizedBox(height: 8),
                Text('Add, edit, or remove your linked cards.', style: AppTheme.dm(size: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                Expanded(
                  child: _linkedCards.isEmpty
                      ? Center(child: Text('No cards linked', style: AppTheme.dm(color: AppColors.textSecondary)))
                      : ListView.builder(
                    itemCount: _linkedCards.length,
                    itemBuilder: (context, index) {
                      final card = _linkedCards[index];
                      return _buildLinkedCardItem(card, onDelete: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Text('Delete Card', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.navy)),
                            content: Text('Are you sure you want to remove ${card['name']}?', style: AppTheme.dm(size: 14, color: AppColors.textSecondary)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text('Cancel', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.textSecondary)),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _linkedCards.removeAt(index);
                                  });
                                  setModalState(() {}); // Update modal state
                                  Navigator.pop(ctx);
                                },
                                child: Text('Delete', style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.error)),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
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
    final rawNumber = value.replaceAll(' ', '');
    setState(() {
      if (rawNumber.startsWith('4')) {
        _cardType = CardType.visa;
      } else if (rawNumber.startsWith('5')) {
        _cardType = CardType.mastercard;
      } else {
        _cardType = CardType.unknown;
      }
    });
  }

  // ✅ تحديث Expiry Date في البطاقة
  void _onExpiryChanged(String value) {
    setState(() {
      _displayExpiry = value.isEmpty ? 'MM / YY' : value;
    });
  }

  // ✅ تحديث Name في البطاقة
  void _onNameChanged(String value) {
    setState(() {
      _displayName = value.isEmpty ? 'YOUR NAME HERE' : value.toUpperCase();
    });
  }

  // ✅ تحديث CVV في البطاقة (اختياري - CVV عادة لا يظهر على البطاقة)
  void _onCvvChanged(String value) {
    setState(() {
    });
  }

  String _getPreviewCardNumber() {
    final raw = _cardNumberController.text.replaceAll(' ', '');
    if (raw.isEmpty) return '0000 0000 0000 0000';
    final padded = raw.padRight(16, '0');
    return '${padded.substring(0, 4)} ${padded.substring(4, 8)} ${padded.substring(8, 12)} ${padded.substring(12, 16)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _buildProgressBar(),
                  const SizedBox(height: 24),
                  _buildScreenTitles(),
                  const SizedBox(height: 16),
                  _buildTrustRow(),
                  const SizedBox(height: 24),
                  _buildVirtualCard(),
                  const SizedBox(height: 32),
                  _buildFormFields(),
                  const SizedBox(height: 16),
                  _buildDisclaimerText(),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                  const SizedBox(height: 40),
                  _buildLinkedCardsSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34, height: 34,
              decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.navy),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Account Verification',
            style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final steps = [
      ('Email', true), ('Phone', true), ('Identity', true), ('Card', false)
    ];
    return Row(
      children: List.generate(steps.length, (index) {
        final isDone = steps[index].$2;
        final label = steps[index].$1;
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.success : AppColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isDone ? '$label ✓' : label,
                style: AppTheme.dm(
                  size: 10, weight: FontWeight.w600,
                  color: isDone ? AppColors.success : AppColors.gold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildScreenTitles() {
    return Column(
      children: [
        Text('Add Payment Card', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
        const SizedBox(height: 6),
        Text('Required to book, refer, or manage properties.', style: AppTheme.dm(size: 13, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildTrustRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 14, color: AppColors.gold),
        const SizedBox(width: 8),
        _buildVisaBadge(size: 12),
        const SizedBox(width: 6),
        _buildMastercardIcon(size: 20),
        const SizedBox(width: 8),
        Text('Secured by Sahely', style: AppTheme.dm(size: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  // ✅ البطاقة الزرقاء - تعرض البيانات المدخلة فوراً
  Widget _buildVirtualCard() {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.navy, Color(0xFF2D3E5F)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 36, height: 26, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4))),
              Row(
                children: [
                  _buildVisaBadge(size: 14),
                  const SizedBox(width: 10),
                  _buildMastercardIcon(size: 28),
                ],
              ),
            ],
          ),

          Text(
            _getPreviewCardNumber(),
            style: AppTheme.dm(color: Colors.white, size: 20, weight: FontWeight.w600, letterSpacing: 2),
          ),

          // ✅ الاسم وتاريخ الانتهاء يتحدثان فوراً
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardLabel('CARD HOLDER NAME', _displayName),
              _buildCardLabel('EXPIRY DATE', _displayExpiry),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardLabel(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.dm(color: Colors.white.withValues(alpha: 0.6), size: 9, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: AppTheme.dm(color: Colors.white, size: 14, weight: FontWeight.w600)),
      ],
    );
  }

  // ✅ الحقول مع onChanged لتحديث البطاقة فوراً
  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'Card Number',
          controller: _cardNumberController,
          placeholder: '0000 0000 0000 0000',
          keyboardType: TextInputType.number,
          maxLength: 19,
          formatters: [FilteringTextInputFormatter.digitsOnly, _CardNumberFormatter()],
          onChanged: _onCardNumberChanged,
          trailing: _cardType != CardType.unknown
              ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _cardType == CardType.visa
                ? _buildVisaBadge(size: 14)
                : _buildMastercardIcon(size: 28),
          ) : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'Expiry Date',
                controller: _expiryController,
                placeholder: 'MM / YY',
                keyboardType: TextInputType.number,
                maxLength: 7,
                formatters: [FilteringTextInputFormatter.digitsOnly, _ExpiryDateFormatter()],
                onChanged: _onExpiryChanged, // ✅ تحديث البطاقة
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                label: 'CVV',
                controller: _cvvController,
                placeholder: '•••',
                obscureText: _isCvvObscured,
                keyboardType: TextInputType.number,
                maxLength: 4,
                formatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _onCvvChanged, // ✅ تحديث البطاقة
                trailing: GestureDetector(
                  onTap: () => setState(() => _isCvvObscured = !_isCvvObscured),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      _isCvvObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: 'Name on Card',
          controller: _nameController,
          placeholder: 'YOUR NAME HERE',
          textCapitalization: TextCapitalization.characters,
          onChanged: _onNameChanged, // ✅ تحديث البطاقة
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? formatters,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String>? onChanged,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.dm(size: 13, weight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    if (controller.text.isEmpty)
                      Positioned(
                        left: 14,
                        child: Text(
                          placeholder,
                          style: AppTheme.dm(
                            size: 14,
                            color: AppColors.textPlaceholder,
                          ),
                        ),
                      ),
                    TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      inputFormatters: formatters,
                      obscureText: obscureText,
                      textCapitalization: textCapitalization,
                      onChanged: (val) {
                        if (onChanged != null) onChanged(val);
                        setState(() {});
                      },
                      maxLength: maxLength,
                      style: AppTheme.dm(
                        size: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        hintText: '',
                        counterText: '',
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerText() {
    return Text(
      'Your card is used for identity verification only and will not be charged without your approval.',
      textAlign: TextAlign.center,
      style: AppTheme.dm(size: 11, color: AppColors.textSecondary, italic: true),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () { /* Handle Save */ },
          child: Center(
            child: Text('Save Card & Complete Setup', style: AppTheme.dm(size: 15, weight: FontWeight.w700, color: AppColors.navy)),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Linked Cards', style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy)),
            GestureDetector(
              onTap: _showManageAllSheet,
              child: Text('MANAGE ALL', style: AppTheme.dm(size: 11, weight: FontWeight.w700, color: AppColors.gold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._linkedCards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;
          return _buildLinkedCardItem(card, onDelete: () => _deleteCard(index));
        }),
      ],
    );
  }

  Widget _buildLinkedCardItem(Map<String, dynamic> card, {VoidCallback? onDelete}) {
    final CardType type = card['type'];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), boxShadow: AppColors.cardShadow),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 26,
            child: type == CardType.mastercard
                ? _buildMastercardIcon(size: 26)
                : Container(
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(4),
              ),
                child: Center(
                  child: Text(
                    'VISA',
                    style: AppTheme.dm(color: Colors.white, size: 9, weight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card['name'], style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 2),
                Text('•••• ${card['last4']}', style: AppTheme.dm(size: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaBadge({double size = 14}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size * 0.6, vertical: size * 0.3),
      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(4)),
      child: Text('VISA', style: AppTheme.dm(color: Colors.white, weight: FontWeight.w700, size: size * 0.8)),
    );
  }

  Widget _buildMastercardIcon({double size = 24}) {
    return SizedBox(
      width: size,
      height: size * 0.65,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: size * 0.4,
            top: 0,
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: const BoxDecoration(
                color: Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.isEmpty) return newValue;

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) buffer.write(' ');
    }
    var formatted = buffer.toString();
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '').replaceAll('/', '');
    if (text.isEmpty) return newValue;

    if (text.length >= 2) {
      text = '${text.substring(0, 2)} / ${text.substring(2)}';
    }
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
