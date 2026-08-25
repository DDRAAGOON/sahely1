import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/l10n/app_localizations.dart';

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
    final locale = context.watch<LocaleProvider>().locale;
    return MaterialApp.router(
      title: 'Sahely',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('es'),
        Locale('ru'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
