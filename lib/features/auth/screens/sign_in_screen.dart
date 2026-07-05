import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/role_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome Back',
                style: AppTheme.dm(
                    size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 6),
            Text('Sign in to your Sahely account',
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
            const SizedBox(height: 26),
            FieldGroup(
              label: 'Email Address',
              child: AppTextField(
                controller: _emailController,
                hintText: 'you@example.com',
                height: 50,
              ),
            ),
            const SizedBox(height: 14),
            FieldGroup(
              label: 'Password',
              trailingLabel: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/forgot'),
                child: Text('Forgot Password?',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
              child: AppTextField(
                controller: _passwordController,
                hintText: '••••••••',
                obscureText: _obscure,
                height: 50,
                fontSize: 18,
                letterSpacing: 3,
                trailing: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            NavyButton(
                label: 'Sign In',
                onTap: () {
                  RoleState().setRole(Role.renter);
                  Navigator.pushReplacementNamed(context, '/renter/home');
                }),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or continue with',
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ),
                const Expanded(child: Divider(color: AppColors.border)),
              ],
            ),
            const SizedBox(height: 12),
            _SocialButton(
              label: 'Continue with Google',
              dark: false,
              leading: Image.network(
                'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(height: 12),
            const _SocialButton(
              label: 'Continue with Apple',
              dark: true,
              leading: Icon(Icons.apple, color: AppColors.white, size: 20),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/role'),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'New to Sahely? ',
                    style: AppTheme.dm(size: 13, color: AppColors.muted),
                    children: [
                      TextSpan(
                          text: 'Create Account',
                          style: AppTheme.dm(
                              size: 13,
                              weight: FontWeight.w700,
                              color: AppColors.gold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton(
      {required this.label, required this.dark, required this.leading});
  final String label;
  final bool dark;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: dark ? Colors.black : AppColors.white,
        border: dark ? null : Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: 10),
          Text(label,
              style: AppTheme.dm(
                  size: 14,
                  weight: FontWeight.w600,
                  color: dark ? AppColors.white : AppColors.ink)),
        ],
      ),
    );
  }
}
