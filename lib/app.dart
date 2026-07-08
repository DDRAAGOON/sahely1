import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'routes.dart';
import 'features/auth/auth_screens.dart';

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

