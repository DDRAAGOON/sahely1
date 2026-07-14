import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/providers/auth_provider.dart';
import 'features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';

class SahelyApp extends StatelessWidget {
  const SahelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final verificationCubit = context.read<VerificationCubit>();

    return MaterialApp.router(
      title: 'Sahely',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: createAppRouter(auth, verificationCubit),
    );
  }
}

