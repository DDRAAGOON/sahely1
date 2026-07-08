import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'This screen ($title) is being migrated.',
          style: AppTheme.dm(size: 16),
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Forgot Password');
}

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'New Password');
}

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Password Updated');
}

class IdVerificationScreen extends StatelessWidget {
  const IdVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'ID Verification');
}

class FacialScanScreen extends StatelessWidget {
  const FacialScanScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Facial Scan');
}

class VerificationCompleteScreen extends StatelessWidget {
  const VerificationCompleteScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Verification Complete');
}
