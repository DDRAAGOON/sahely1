import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/countries.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/auth/data/auth_api.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/features/shared/links/referral_code_store.dart';

class CreateAccountScreen extends StatefulWidget {
  final String? role;

  const CreateAccountScreen({super.key, this.role});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  Country _country = Countries.egypt;
  bool _agreed = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  /// Per-field validation messages, filled on submit.
  final Set<String> _errors = {};
  bool _hasAttemptedSubmit = false;

  static const _errName = 'name';
  static const _errEmail = 'email';
  static const _errPhone = 'phone';
  static const _errPassword = 'password';
  static const _errConfirm = 'confirm';
  static const _errDob = 'dob';

  void _clearError(String key) {
    if (_errors.contains(key)) {
      setState(() => _errors.remove(key));
    }
  }

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

  /// Maps canonical role values (from navigation) to localized display.
  static String _roleDisplay(AppLocalizations l, String canonical) {
    switch (canonical) {
      case 'Renter':
        return l.renter;
      case 'Property Owner':
        return l.roleOwnerTitle;
      case 'Broker':
        return l.broker;
      default:
        return canonical;
    }
  }

  final List<String> _days = List.generate(31, (i) => (i + 1).toString());
  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final List<String> _years =
      List.generate(100, (i) => (DateTime.now().year - i).toString());

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l) {
    final next = <String>{};

    if (_nameController.text.trim().length < 2) next.add(_errName);

    final email = _emailController.text.trim();
    if (email.isEmpty || !_emailRegex.hasMatch(email)) next.add(_errEmail);

    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) next.add(_errPhone);

    // Password validation: at least 8 chars with at least 1 letter and 1 number
    final password = _passwordController.text;
    if (password.length < 8 ||
        !password.contains(RegExp(r'[a-zA-Z]')) ||
        !password.contains(RegExp(r'[0-9]'))) {
      next.add(_errPassword);
    }

    if (_confirmController.text != _passwordController.text ||
        _confirmController.text.isEmpty) {
      next.add(_errConfirm);
    }

    if (_selectedDay == null ||
        _selectedMonth == null ||
        _selectedYear == null) {
      next.add(_errDob);
    }

    setState(() => _errors
      ..clear()
      ..addAll(next));
    return next.isEmpty && _agreed;
  }

  Future<void> _pickCountry() async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(selected: _country),
    );
    if (selected != null) {
      setState(() => _country = selected);
    }
  }

  void _showTermsAndPrivacy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _TermsAndPrivacySheet(role: widget.role ?? 'Renter'),
    );
  }

  bool _submitting = false;

  Future<void> _submit(AppLocalizations l, String role) async {
    setState(() => _hasAttemptedSubmit = true);

    final valid = _validate(l);
    if (!_agreed) setState(() => _errors.add('terms'));
    if (!valid || !_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.mustAgreeTerms),
        backgroundColor: AppColors.error,
      ));
      return;
    }

    setState(() => _submitting = true);
    try {
      final api = AuthApiService();

      final backendRole = role == 'Property Owner'
          ? Role.owner
          : (role == 'Broker' ? Role.broker : Role.renter);
      final sessionId = await api.registerStep1(backendRole);

      final dob = DateTime(
        int.parse(_selectedYear!),
        _months.indexOf(_selectedMonth!) + 1,
        int.parse(_selectedDay!),
      ).toIso8601String().substring(0, 10);

      await api.registerStep2(
        sessionId: sessionId,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone:
            '${_country.dialCode}${_phoneController.text.replaceAll(RegExp(r'\s'), '')}',
        dateOfBirth: dob,
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
        referralCode: await ReferralCodeStore.read(),
      );
      await ReferralCodeStore.clear();

      if (!mounted) return;
      context.push('/verify-email', extra: {
        'sessionId': sessionId,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone':
            '${_country.dialCode}${_phoneController.text.replaceAll(RegExp(r'\s'), '')}',
        'dateOfBirth': dob,
        'password': _passwordController.text,
        'role': role,
      });
    } on AuthApiException catch (e) {
      if (mounted) {
        // Map specific API errors to localized messages
        String errorMessage;
        switch (e.code) {
          case 'ERR_AUTH_INVALID_CREDENTIALS':
            errorMessage = l.invalidCredentials;
            break;
          case 'ERR_ACCOUNT_SUSPENDED':
            errorMessage = l.accountSuspendedWithDetails(
              e.data?['suspendedUntil'] ?? '',
            );
            break;
          case 'ERR_ACCOUNT_BANNED':
            errorMessage = l.accountBanned;
            break;
          case 'ERR_RATE_LIMIT':
            errorMessage = l.rateLimit;
            break;
          case 'ERR_NETWORK':
            errorMessage = l.noInternet;
            break;
          default:
            errorMessage = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l.serverError),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: l.retry,
            textColor: AppColors.white,
            onPressed: () {
              _submit(l, role);
            },
          ),
        ));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final role = widget.role ?? 'Renter';

    Widget? fieldError(String key, String message) => _errors.contains(key)
        ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(message,
                  style: AppTheme.dm(size: 11, color: AppColors.error)),
            ),
          )
        : null;

    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const BackChip(),
                  const SizedBox(width: 12),
                  Text(l.createAccount,
                      style: AppTheme.dm(
                          size: 22,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${l.registeringAs} ${_roleDisplay(l, role)}',
                      style: AppTheme.dm(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.navy)),
                ),
              ),
              const SizedBox(height: 16),
              FieldGroup(
                label: l.fullName,
                child: AppTextField(
                  controller: _nameController,
                  hintText: l.fullNameHint,
                  onChanged: _hasAttemptedSubmit
                      ? (value) {
                          _clearError(_errName);
                        }
                      : null,
                ),
              ),
              if (fieldError(_errName, l.requiredField) != null)
                fieldError(_errName, l.requiredField)!,
              const SizedBox(height: 11),
              FieldGroup(
                label: l.emailAddress,
                child: AppTextField(
                  controller: _emailController,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: _hasAttemptedSubmit
                      ? (value) {
                          _clearError(_errEmail);
                        }
                      : null,
                ),
              ),
              if (fieldError(_errEmail, l.enterValidEmail) != null)
                fieldError(_errEmail, l.enterValidEmail)!,
              const SizedBox(height: 11),
              FieldGroup(
                label: l.phoneNumber,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Country selector (all countries, SMS-ready) ----
                    GestureDetector(
                      onTap: _pickCountry,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_country.flag,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(_country.dialCode,
                                style: AppTheme.dm(size: 14)),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 16, color: AppColors.muted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppTextField(
                        controller: _phoneController,
                        hintText: '10 XXXX XXXX',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[\d\s\-()]')),
                        ],
                        onChanged: _hasAttemptedSubmit
                            ? (value) {
                                _clearError(_errPhone);
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              if (fieldError(_errPhone, l.enterValidPhone) != null)
                fieldError(_errPhone, l.enterValidPhone)!,
              const SizedBox(height: 11),
              FieldGroup(
                label: l.password,
                child: AppTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: _obscurePassword,
                  trailing: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.muted,
                    ),
                  ),
                  onChanged: _hasAttemptedSubmit
                      ? (value) {
                          _clearError(_errPassword);
                          _clearError(_errConfirm);
                        }
                      : null,
                ),
              ),
              if (fieldError(_errPassword, l.passwordMinChars) != null)
                fieldError(_errPassword, l.passwordMinChars)!,
              const SizedBox(height: 11),
              FieldGroup(
                label: l.confirmPassword,
                child: AppTextField(
                  controller: _confirmController,
                  hintText: '••••••••',
                  obscureText: _obscureConfirm,
                  trailing: GestureDetector(
                    onTap: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    child: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.muted,
                    ),
                  ),
                  onChanged: _hasAttemptedSubmit
                      ? (value) {
                          _clearError(_errConfirm);
                        }
                      : null,
                ),
              ),
              if (fieldError(_errConfirm, l.passwordsDoNotMatch) != null)
                fieldError(_errConfirm, l.passwordsDoNotMatch)!,
              const SizedBox(height: 11),
              FieldGroup(
                label: l.dateOfBirth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: _DobBox(
                        label: l.day,
                        value: _selectedDay,
                        items: _days,
                        onChanged: (v) => setState(() => _selectedDay = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 13,
                      child: _DobBox(
                        label: l.month,
                        value: _selectedMonth,
                        items: _months,
                        onChanged: (v) => setState(() => _selectedMonth = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 10,
                      child: _DobBox(
                        label: l.year,
                        value: _selectedYear,
                        items: _years,
                        onChanged: (v) => setState(() => _selectedYear = v),
                      ),
                    ),
                  ],
                ),
              ),
              if (fieldError(_errDob, l.requiredField) != null)
                fieldError(_errDob, l.requiredField)!,
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _agreed ? AppColors.navy : AppColors.white,
                        border: Border.all(
                            color: _agreed ? AppColors.navy : AppColors.border),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _agreed
                          ? const Icon(Icons.check,
                              size: 12, color: AppColors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to ',
                        style: AppTheme.dm(size: 12, color: AppColors.muted),
                        children: [
                          TextSpan(
                              text: 'Terms',
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsAndPrivacy,
                              style: AppTheme.dm(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                          TextSpan(
                              text: ' & ',
                              style: AppTheme.dm(
                                  size: 12, color: AppColors.muted)),
                          TextSpan(
                              text: 'Privacy Policy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = _showTermsAndPrivacy,
                              style: AppTheme.dm(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (!_agreed && _errors.contains('terms'))
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l.mustAgreeTerms,
                        style: AppTheme.dm(size: 11, color: AppColors.error)),
                  ),
                ),
              const SizedBox(height: 22),
              NavyButton(
                label: _submitting ? l.loading : l.createAccount,
                onTap: _submitting ? null : () => _submit(l, role),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Country picker bottom sheet — searchable list of every country.
// ---------------------------------------------------------------------------
class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.selected});

  final Country selected;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final TextEditingController _search = TextEditingController();
  late List<Country> _filtered = Countries.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? Countries.all
          : Countries.all.where((c) {
              return c.name.toLowerCase().contains(query) ||
                  c.dialCode.contains(query) ||
                  c.code.toLowerCase().contains(query);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.borderDefault,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Select Country',
                        style: AppTheme.dm(
                            size: 18,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close,
                        size: 20, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: TextField(
                controller: _search,
                onChanged: _onSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: AppColors.muted),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.cream,
                  hintText: 'Country or code…',
                  hintStyle: AppTheme.dm(size: 13, color: AppColors.muted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemExtent: 52,
                itemBuilder: (context, i) {
                  final c = _filtered[i];
                  final isSelected = c.code == widget.selected.code;
                  return InkWell(
                    onTap: () => Navigator.pop(context, c),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(c.flag, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(c.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.dm(
                                    size: 14,
                                    weight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.gold
                                        : AppColors.ink)),
                          ),
                          Text(c.dialCode,
                              style: AppTheme.dm(
                                  size: 13,
                                  color: isSelected
                                      ? AppColors.gold
                                      : AppColors.muted)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DobBox extends StatelessWidget {
  const _DobBox({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint:
              Text(label, style: AppTheme.dm(size: 13, color: AppColors.muted)),
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 16, color: AppColors.muted),
          isExpanded: true,
          menuMaxHeight: 300,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style: AppTheme.dm(size: 13, color: AppColors.ink)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TermsAndPrivacySheet extends StatelessWidget {
  final String role;
  const _TermsAndPrivacySheet({required this.role});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bool isOwner = role == 'Property Owner';
    final bool isBroker = role == 'Broker';

    final String title = isOwner
        ? l.termsOwnerTitle
        : (isBroker ? l.termsBrokerTitle : l.termsRenterTitle);

    final String intro = isOwner
        ? l.termsIntroOwner
        : (isBroker ? l.termsIntroBroker : l.termsIntroRenter);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: AppTheme.dm(
                  size: 18, weight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              l.termsDocRef,
              style: AppTheme.dm(size: 11, color: Colors.white54),
            ),
            const SizedBox(height: 20),
            Text(
              intro,
              style: AppTheme.dm(size: 13, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 24),
            if (isOwner) ...[
              _section(l.termsOwnerSection1Title, [
                l.termsOwnerSection1Point1,
                l.termsOwnerSection1Point2,
                l.termsOwnerSection1Point3,
              ]),
              _section(l.termsOwnerSection2Title, [
                l.termsOwnerSection2Point1,
                l.termsOwnerSection2Point2,
                l.termsOwnerSection2Point3,
                l.termsOwnerSection2Point4,
              ]),
              _section(l.termsOwnerSection3Title, [
                l.termsOwnerSection3Point1,
                l.termsOwnerSection3Point2,
                l.termsOwnerSection3Point3,
                l.termsOwnerSection3Point4,
              ]),
              _section(l.termsOwnerSection4Title, [
                l.termsOwnerSection4Point1,
                l.termsOwnerSection4Point2,
                l.termsOwnerSection4Point3,
                l.termsOwnerSection4Point4,
              ]),
            ] else if (isBroker) ...[
              _section(l.termsBrokerSection1Title, [
                l.termsBrokerSection1Point1,
                l.termsBrokerSection1Point2,
              ]),
              _section(l.termsBrokerSection2Title, [
                l.termsBrokerSection2Point1,
                l.termsBrokerSection2Point2,
                l.termsBrokerSection2Point3,
              ]),
              _section(l.termsBrokerSection3Title, [
                l.termsBrokerSection3Point1,
                l.termsBrokerSection3Point2,
                l.termsBrokerSection3Point3,
                l.termsBrokerSection3Point4,
              ]),
              _section(l.termsBrokerSection4Title, [
                l.termsBrokerSection4Point1,
                l.termsBrokerSection4Point2,
              ]),
              _section(l.termsBrokerSection5Title, [
                l.termsBrokerSection5Point1,
                l.termsBrokerSection5Point2,
              ]),
            ] else ...[
              _section(l.termsRenterSection1Title, [
                l.termsRenterSection1Point1,
                l.termsRenterSection1Point2,
                l.termsRenterSection1Point3,
                l.termsRenterSection1Point4,
                l.termsRenterSection1Point5,
                l.termsRenterSection1Point6,
              ]),
              _section(l.termsRenterSection2Title, [
                l.termsRenterSection2Point1,
                l.termsRenterSection2Point2,
                l.termsRenterSection2Point3,
              ]),
              _section(l.termsRenterSection3Title, [
                l.termsRenterSection3Point1,
                l.termsRenterSection3Point2,
                l.termsRenterSection3Point3,
              ]),
              _section(l.termsRenterSection4Title, [
                l.termsRenterSection4Point1,
                l.termsRenterSection4Point2,
                l.termsRenterSection4Point3,
              ]),
            ],
            _section(l.termsMasterRulesTitle, [
              l.termsMasterRulesPoint1,
              l.termsMasterRulesPoint2,
              l.termsMasterRulesPoint3,
              l.termsMasterRulesPoint4,
            ]),
            const SizedBox(height: 24),
            Text(
              l.termsAgreeFootnote(
                  isOwner ? l.owner : (isBroker ? l.broker : l.renter)),
              style: AppTheme.dm(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.gold,
                  height: 1.5),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.dm(
                size: 14, weight: FontWeight.w700, color: AppColors.goldSoft),
          ),
          const SizedBox(height: 10),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.white54)),
                    Expanded(
                      child: Text(
                        p,
                        style: AppTheme.dm(
                            size: 12, color: Colors.white60, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
