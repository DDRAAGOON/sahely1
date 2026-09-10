import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/features/shared/screens/booking_screen.dart';
import 'package:sahely/features/shared/widgets/booking_screen_widgets.dart';
import 'package:sahely/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BookingsProvider())],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales:
            AppLocalizations.supportedLanguages.map((c) => Locale(c)).toList(),
        home: Scaffold(body: child),
      ),
    );

/// Smoke tests for screen 19 · Booking — Dates & Guests.
void main() {
  Future<void> useTallSurface(WidgetTester tester) {
    // Tall surface so the whole lazy ListView builds without scrolling
    // (drags would otherwise be captured by the calendar's PageView).
    return tester.binding.setSurfaceSize(const Size(800, 2200));
  }

  testWidgets('booking screen renders property, calendar and pricing',
      (tester) async {
    await useTallSurface(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const BookingScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Plan Your Stay'), findsOneWidget);
    expect(find.byType(BookingCalendarCard), findsOneWidget);
    expect(find.text('Confirm & Pay'), findsOneWidget);
    expect(find.text('Adults'), findsOneWidget);
    expect(find.text('Children'), findsOneWidget);
    expect(find.text('Infants'), findsOneWidget);
  });

  testWidgets('guest steppers update counts', (tester) async {
    await useTallSurface(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_wrap(const BookingScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    expect(find.text('3'), findsWidgets); // adults bumped 2 → 3
  });
}
