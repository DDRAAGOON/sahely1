import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/data/role_state.dart';

class SahelyApp extends StatefulWidget {
  const SahelyApp({super.key});

  @override
  State<SahelyApp> createState() => _SahelyAppState();
}

class _SahelyAppState extends State<SahelyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Initialize the router once to preserve state during Hot Reload.
    final authProvider = context.read<AuthProvider>();
    final roleState = context.read<RoleState>();
    _router = createAppRouter(authProvider, roleState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sahely',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
