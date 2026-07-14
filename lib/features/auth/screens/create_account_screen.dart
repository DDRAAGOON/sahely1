import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';
import '../../../core/utils/security_util.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _agreed = false;

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  final List<String> _days = List.generate(31, (i) => (i + 1).toString());
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<String> _years = List.generate(100, (i) => (DateTime.now().year - i).toString());

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role ?? 'Renter';

    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const BackChip(),
                  const SizedBox(width: 12),
                  Text('Create Account',
                      style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                  child: Text('Registering as: $role',
                      style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: AppColors.navy)),
                ),
              ),
              const SizedBox(height: 16),
              FieldGroup(
                label: 'Full Name',
                child: AppTextField(
                  controller: _nameController,
                  hintText: 'Your full name',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter your full name';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 11),
              FieldGroup(
                label: 'Email Address',
                child: AppTextField(
                  controller: _emailController,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || !SecurityUtil.isValidEmail(v)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 11),
              FieldGroup(
                label: 'Phone Number',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 78,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('🇪🇬 +20', style: AppTheme.dm(size: 14)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppTextField(
                        controller: _phoneController,
                        hintText: '10 XXXX XXXX', 
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || !SecurityUtil.isValidEgyptianPhone(v)) {
                            return 'Enter a valid Egyptian mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              FieldGroup(
                label: 'Password',
                child: AppTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  obscureText: true,
                  validator: (v) {
                    if (v == null || !SecurityUtil.isValidPassword(v)) {
                      return 'Must be min 8 chars with at least one number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 11),
              FieldGroup(
                label: 'Confirm Password',
                child: AppTextField(
                  controller: _confirmPasswordController,
                  hintText: '••••••••',
                  obscureText: true,
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 11),
              FieldGroup(
                label: 'Date of Birth',
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: _DobBox(
                        label: 'Day',
                        value: _selectedDay,
                        items: _days,
                        onChanged: (v) => setState(() => _selectedDay = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 13,
                      child: _DobBox(
                        label: 'Month',
                        value: _selectedMonth,
                        items: _months,
                        onChanged: (v) => setState(() => _selectedMonth = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 10,
                      child: _DobBox(
                        label: 'Year',
                        value: _selectedYear,
                        items: _years,
                        onChanged: (v) => setState(() => _selectedYear = v),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _agreed ? AppColors.navy : AppColors.white,
                        border: Border.all(color: _agreed ? AppColors.navy : AppColors.border),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _agreed ? const Icon(Icons.check, size: 12, color: AppColors.white) : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      text: 'I agree to ',
                      style: AppTheme.dm(size: 12, color: AppColors.muted),
                      children: [
                        TextSpan(text: 'Terms', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy)),
                        TextSpan(text: ' & ', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                        TextSpan(text: 'Privacy Policy', style: AppTheme.dm(size: 12, weight: FontWeight.w700, color: AppColors.navy)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              NavyButton(
                label: 'Create Account',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (!_agreed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You must agree to the Terms & Privacy Policy')),
                      );
                      return;
                    }

                    // Sanitize inputs at UI level to prevent XSS/injection before passing
                    final sanitizedName = SecurityUtil.sanitizeInput(_nameController.text);
                    final sanitizedEmail = SecurityUtil.sanitizeInput(_emailController.text);
                    final sanitizedPhone = SecurityUtil.sanitizeInput(_phoneController.text);

                    context.push(
                      '/verify-email', 
                      extra: {
                        'email': sanitizedEmail,
                        'phone': sanitizedPhone,
                        'role': role,
                      },
                    );
                  }
                },
              ),
            ],
          ),
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
          hint: Text(label, style: AppTheme.dm(size: 13, color: AppColors.muted)),
          icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.muted),
          isExpanded: true,
          menuMaxHeight: 300,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: AppTheme.dm(size: 13, color: AppColors.ink)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
