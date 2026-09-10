import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/features/auth/data/auth_api.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/cream_background.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/features/auth/mock_auth_service.dart';
import 'package:sahely/l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  final String? from;

  const SignInScreen({super.key, this.from});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _busy = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _emailError;
  String? _passwordError;
  bool _hasAttemptedSubmit = false;
  
  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final l = AppLocalizations.of(context);

    setState(() => _hasAttemptedSubmit = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Client-side validation before API call
    setState(() {
      _emailError = _validateEmail(email);
      _passwordError = _validatePassword(password);
    });

    if (_emailError != null || _passwordError != null) return;

    setState(() => _busy = true);
    AuthResponse resp;
    try {
      resp = await MockAuthService().signIn(email, password);
    } on AuthApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      
      // Map specific API errors to localized messages
      String errorMessage;
      switch (e.code) {
        case 'ERR_AUTH_INVALID_CREDENTIALS':
          errorMessage = l.invalidCredentials;
          break;
        case 'ERR_ACCOUNT_SUSPENDED':
          errorMessage = l.accountSuspendedWithDetails(
            e.data?['suspendedUntil'] ?? '',
            e.data?['reason'] ?? ''
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
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: AppColors.error,
      ));
      return;
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      final serverError = l.serverError;
      final retryLabel = l.retry;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(serverError),
        backgroundColor: AppColors.error,
        action: SnackBarAction(
          label: retryLabel,
          textColor: AppColors.white,
          onPressed: _submit,
        ),
      ));
      return;
    }

    await auth.login(token: resp.token, role: resp.role);
    // Pull the REAL identity immediately.
    if (!mounted) return;
    context.read<ProfileProvider>().fetchProfileData(force: true);

    if (!mounted) return;
    setState(() => _busy = false);

    // If router provided a 'from' query param, go there; otherwise go to role home
    final target = widget.from != null
        ? Uri.decodeComponent(widget.from!)
        : (resp.role == Role.broker
            ? '/broker/home'
            : (resp.role == Role.owner
                ? '/owner/home'
                : '/renter/home'));

    if (!mounted) return;
    context.go(target);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).emailRequired;
    }
    if (!_emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context).enterValidEmail;
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).passwordRequired;
    }
    return null;
  }

  void _clearEmailError() {
    if (_emailError != null) {
      setState(() => _emailError = null);
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() => _passwordError = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PhoneScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.welcomeBack,
                style: AppTheme.dm(
                    size: 26, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 6),
            Text(l.signInSubtitle,
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
            const SizedBox(height: 26),
            FieldGroup(
              label: l.emailAddress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _emailController,
                    hintText: 'you@example.com',
                    height: 50,
                    borderColor: _emailError != null ? AppColors.error : null,
                    onChanged: _hasAttemptedSubmit ? (value) {
                      _clearEmailError();
                    } : null,
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(_emailError!,
                          style: AppTheme.dm(size: 12, color: AppColors.error)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            FieldGroup(
              label: l.password,
              trailingLabel: GestureDetector(
                onTap: () => AppNavigation.goToForgotPassword(context),
                child: Text(l.forgotPassword,
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _passwordController,
                    hintText: '••••••••',
                    obscureText: _obscure,
                    height: 50,
                    fontSize: 18,
                    letterSpacing: 3,
                    borderColor: _passwordError != null ? AppColors.error : null,
                    onChanged: _hasAttemptedSubmit ? (value) {
                      _clearPasswordError();
                    } : null,
                    trailing: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text(_passwordError!,
                          style: AppTheme.dm(size: 12, color: AppColors.error)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            NavyButton(
                label: _busy ? l.loading : l.signIn,
                onTap: _busy ? null : _submit,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(l.orContinueWith,
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ),
                const Expanded(child: Divider(color: AppColors.border)),
              ],
            ),
            const SizedBox(height: 12),
            _SocialButton(
              label: l.continueGoogle,
              dark: false,
              leading: const AppNetworkImage(url: 'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png', width: 22, height: 22),
            ),
            const SizedBox(height: 12),
            _SocialButton(
              label: l.continueApple,
              dark: true,
              leading: const Icon(Icons.apple, color: AppColors.white, size: 20),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => AppNavigation.goToRoleSelection(context),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: l.newToSahely,
                    style: AppTheme.dm(size: 13, color: AppColors.muted),
                    children: [
                      TextSpan(
                          text: l.createAccount,
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
        border: dark ? null : null,
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

