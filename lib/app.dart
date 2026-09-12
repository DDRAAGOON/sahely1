import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/theme/system_ui.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/providers/locale_provider.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/l10n/app_localizations.dart';

class SahelyApp extends StatefulWidget {
  const SahelyApp({super.key});

  @override
  State<SahelyApp> createState() => _SahelyAppState();
}

class _SahelyAppState extends State<SahelyApp> {
  late final GoRouter _router;
  late final AuthProvider _auth;
  late final ProfileProvider _profile;

  /// The authentication state the profile currently mirrors.
  bool _profileSyncedAuth = false;

  @override
  void initState() {
    super.initState();
    // Initialize the router once to preserve state during Hot Reload.
    _auth = context.read<AuthProvider>();
    _profile = context.read<ProfileProvider>();
    final roleState = context.read<RoleState>();
    _router = createAppRouter(_auth, roleState);

    // Keep the profile in step with the session for the whole app: every
    // screen that shows the user's name reads it from [ProfileProvider], so
    // loading it only where one of them asks leaves the others blank.
    _auth.addListener(_syncProfile);
    _syncProfile();
  }

  @override
  void dispose() {
    _auth.removeListener(_syncProfile);
    super.dispose();
  }

  /// Loads the profile once a session exists (app start with a saved token,
  /// or any sign-in) and clears it on sign-out so the next account never sees
  /// the previous one's name.
  void _syncProfile() {
    final authenticated = _auth.isAuthenticated;
    if (authenticated == _profileSyncedAuth) return;
    _profileSyncedAuth = authenticated;
    // Deferred: the auth state can change while a frame is being built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _profileSyncedAuth != authenticated) return;
      if (authenticated) {
        _profile.fetchProfileData(force: true);
      } else {
        _profile.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return MaterialApp.router(
      title: 'Sahely',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      // App-wide status-bar default: dark icons over the cream screens.
      // Screens with a navy or photo top override it with LightStatusBar.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUi.darkIcons,
        child: child ?? const SizedBox.shrink(),
      ),
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
      localeListResolutionCallback: (locales, supportedLocales) {
        if (locales == null || locales.isEmpty) {
          return const Locale('en'); // Fallback to English
        }
        for (final locale in locales) {
          for (final supportedLocale in supportedLocales) {
            if (locale.languageCode == supportedLocale.languageCode) {
              return locale;
            }
          }
        }
        return const Locale('en'); // Fallback to English
      },
    );
  }
}
