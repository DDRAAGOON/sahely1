import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';
import '../../../core/utils/security_util.dart';

// ========================================================= 09 · New Password
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(alignment: Alignment.centerLeft, child: BackChip()),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.lock_outline, color: AppColors.gold, size: 30),
              ),
            ),
            const SizedBox(height: 20),
            Text('Set a new password',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text('At least 8 characters with letters, numbers & a symbol',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 13, color: AppColors.muted, height: 1.5)),
            const SizedBox(height: 14),
            FieldGroup(
              label: 'New Password',
              child: AppTextField(
                controller: _passController,
                hintText: '••••••••',
                height: 50,
                radius: 999,
                fontSize: 18,
                letterSpacing: 3,
                obscureText: _obscure1,
                trailing: GestureDetector(
                  onTap: () => setState(() => _obscure1 = !_obscure1),
                  child: Icon(
                    _obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20, color: AppColors.muted
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FieldGroup(
              label: 'Confirm Password',
              child: AppTextField(
                controller: _confirmController,
                hintText: '••••••••',
                height: 50,
                radius: 999,
                fontSize: 18,
                letterSpacing: 3,
                obscureText: _obscure2,
                trailing: GestureDetector(
                  onTap: () => setState(() => _obscure2 = !_obscure2),
                  child: Icon(
                    _obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20, color: AppColors.muted
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: _StrengthBar(on: true)),
                SizedBox(width: 6),
                Expanded(child: _StrengthBar(on: true)),
                SizedBox(width: 6),
                Expanded(child: _StrengthBar(on: true)),
                SizedBox(width: 6),
                Expanded(child: _StrengthBar(on: false)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Strong password', style: AppTheme.dm(size: 11, weight: FontWeight.w600, color: AppColors.success)),
            const SizedBox(height: 30),
            NavyButton(
                label: 'Update Password',
                radius: 999,
                onTap: () {
                  final pass = _passController.text;
                  final confirm = _confirmController.text;
                  if (!SecurityUtil.isValidPassword(pass)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password must be at least 8 characters long and contain at least one number.')),
                    );
                    return;
                  }
                  if (pass != confirm) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match.')),
                    );
                    return;
                  }
                  Navigator.pushNamed(context, '/password-updated');
                }),
          ],
        ),
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.on});
  final bool on;
  @override
  Widget build(BuildContext context) => Container(
        height: 5,
        decoration: BoxDecoration(
          color: on ? AppColors.success : AppColors.border,
          borderRadius: BorderRadius.circular(3),
        ),
      );
}
