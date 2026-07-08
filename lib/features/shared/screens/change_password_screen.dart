import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/cream_background.dart';
import '../widgets/forms.dart';
import '../widgets/top_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  int _strengthScore = 0;

  @override
  void initState() {
    super.initState();
    _newController.addListener(_updateStrength);
  }

  void _updateStrength() {
    final pass = _newController.text;
    int score = 0;
    if (pass.isEmpty) {
      score = 0;
    } else if (pass.length < 6) {
      score = 1;
    } else {
      score = 1;
      if (pass.length >= 8) score++;
      if (pass.contains(RegExp(r'[0-9]')) || pass.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
      if (pass.contains(RegExp(r'[A-Z]'))) score++;
    }
    setState(() => _strengthScore = score);
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasInput = _newController.text.isNotEmpty;
    final (strengthText, strengthColor) = switch (_strengthScore) {
      1 => ('Weak password', AppColors.danger),
      2 => ('Fair password', AppColors.gold),
      3 => ('Strong password', AppColors.success),
      4 => ('Very strong password', AppColors.success),
      _ => ('', Colors.transparent),
    };

    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
              children: [
                const TopBar(title: 'Change Password'),
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.navy.withOpacity(0.04),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline, color: AppColors.gold, size: 32),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Use at least 8 characters with a mix of letters, numbers & symbols.',
                    textAlign: TextAlign.center,
                    style: AppTheme.dm(size: 14, color: AppColors.muted, height: 1.45),
                  ),
                ),
                const SizedBox(height: 32),
                FieldGroup(
                  label: 'Current Password',
                  child: AppTextField(
                    controller: _currentController,
                    hintText: 'Enter your current password',
                    obscureText: !_showCurrent,
                    trailing: _toggleBtn(_showCurrent, (v) => setState(() => _showCurrent = v)),
                  ),
                ),
                const SizedBox(height: 20),
                FieldGroup(
                  label: 'New Password',
                  child: AppTextField(
                    controller: _newController,
                    hintText: 'Minimum 8 characters',
                    obscureText: !_showNew,
                    trailing: _toggleBtn(_showNew, (v) => setState(() => _showNew = v)),
                  ),
                ),
                const SizedBox(height: 20),
                FieldGroup(
                  label: 'Confirm New Password',
                  child: AppTextField(
                    controller: _confirmController,
                    hintText: 'Repeat your new password',
                    obscureText: !_showConfirm,
                    trailing: _toggleBtn(_showConfirm, (v) => setState(() => _showConfirm = v)),
                  ),
                ),
                if (hasInput) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      for (var i = 1; i <= 4; i++) ...[
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 6,
                            decoration: BoxDecoration(
                              color: i <= _strengthScore ? strengthColor : AppColors.border.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        if (i < 4) const SizedBox(width: 8),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(_strengthScore >= 3 ? Icons.check_circle_outline : Icons.error_outline,
                          size: 14, color: strengthColor),
                      const SizedBox(width: 6),
                      Text(strengthText, style: AppTheme.dm(size: 12, weight: FontWeight.w600, color: strengthColor)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 32),
            child: NavyButton(
              label: 'Update Password',
              enabled: _strengthScore >= 3 && _newController.text == _confirmController.text,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password updated successfully!'), backgroundColor: AppColors.success),
                );
                Navigator.maybePop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(bool visible, ValueChanged<bool> onToggle) {
    return GestureDetector(
      onTap: () => onToggle(!visible),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: AppColors.faint,
        ),
      ),
    );
  }
}
