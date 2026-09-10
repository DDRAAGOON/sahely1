import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahely/core/widgets/success_check.dart';
import 'package:sahely/features/auth/screens/create_account_screen.dart';
import 'package:sahely/features/auth/widgets/auth_success_badge.dart';
import 'package:sahely/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales:
          AppLocalizations.supportedLanguages.map((c) => Locale(c)).toList(),
      home: Scaffold(body: child),
    );

void main() {
  group('Create Account screen', () {
    testWidgets('empty submit shows required-field errors',
        (tester) async {
      await tester.pumpWidget(_wrap(const CreateAccountScreen(role: 'Renter')));
      await tester.pumpAndSettle();

      final submit = find.text('Create Account').last;
      await tester.ensureVisible(submit);
      await tester.pumpAndSettle();
      await tester.tap(submit);
      await tester.pumpAndSettle();

      // "This field is required" appears under name + DOB groups at minimum.
      expect(find.text('This field is required'), findsWidgets);
      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Please enter a valid phone number'), findsOneWidget);
      expect(
          find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('country picker lists all countries and updates code',
        (tester) async {
      await tester.pumpWidget(_wrap(const CreateAccountScreen(role: 'Renter')));
      await tester.pumpAndSettle();

      // Open the picker (country selector is the first dropdown on screen).
      final selector = find.byIcon(Icons.keyboard_arrow_down).first;
      await tester.ensureVisible(selector);
      await tester.pumpAndSettle();
      await tester.tap(selector);
      await tester.pumpAndSettle();

      expect(find.text('Select Country'), findsOneWidget);

      // Search for Egypt — the sheet's search field is the last TextField
      // mounted on screen.
      await tester.enterText(find.byType(TextField).last, 'egypt');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Egypt'));
      await tester.pumpAndSettle();

      // The phone prefix now shows the Egyptian flag + dial code.
      expect(find.text('+20'), findsOneWidget);
      expect(find.text('🇪🇬'), findsOneWidget);
    });
  });

  group('Success animations build & progress', () {
    /// Pumps frame-by-frame through the first second — this covers the pop
    /// overshoot region that previously crashed TweenSequence (t > 1).
    Future<void> pumpThrough(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(_wrap(Center(child: child)));
      for (var ms = 0; ms <= 1200; ms += 50) {
        await tester.pump(Duration(milliseconds: ms == 0 ? 16 : 50));
        if (tester.takeException() != null) {
          fail('exception at ${ms}ms into the animation');
        }
      }
      // A couple of ring-loop cycles.
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    }

    testWidgets('SuccessCheck green (screens 28/38) scrubs clean',
        (tester) => pumpThrough(tester, const SuccessCheck()));

    testWidgets('SuccessCheck gold radial (screen 20) scrubs clean',
        (tester) => pumpThrough(tester, const SuccessCheck(gold: true)));

    testWidgets('SuccessCheck gold linear+glow+navy (screen 27) scrubs clean',
        (tester) => pumpThrough(
            tester,
            const SuccessCheck(
                gold: true,
                size: 118,
                linearGradient: true,
                glow: true,
                checkColor:
                    Color(0xFF1B2744))));

    testWidgets('AuthSuccessBadge navy (screen 12) scrubs clean',
        (tester) =>
            pumpThrough(tester, const AuthSuccessBadge(navy: true)));
  });
}
