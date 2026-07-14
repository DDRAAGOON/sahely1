import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/navigation/app_router.dart';
import 'package:sahely/features/auth/screens/sign_in_screen.dart';
import 'package:sahely/features/renter/presentation/verification/data/repositories/verification_repository.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';

void main() {
  testWidgets('unauthenticated user redirected to SignIn when accessing protected route', (tester) async {
    final auth = AuthProvider(); // not authenticated by default
    final repo = VerificationRepository();
    final cubit = VerificationCubit(repo);

    final router = createAppRouter(auth, cubit, initialLocation: '/signin');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
          Provider<VerificationCubit>.value(value: cubit),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    // Try to navigate to a protected route
    router.go('/renter/home');
    await tester.pumpAndSettle();

    // Expect SignInScreen to be shown (redirected)
    expect(find.byType(SignInScreen), findsOneWidget);
  });
}
