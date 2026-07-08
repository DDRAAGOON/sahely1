import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes.dart';
import 'features/shared/auth/presentation/pages/splash_screen.dart';

class SahelyApp extends StatelessWidget {
  const SahelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahely',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        ...appRoutes,
      },
    );
  }
}

