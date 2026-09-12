import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahely/core/utils/countries.dart';
import 'package:sahely/features/shared/widgets/booking_screen_widgets.dart';
import 'package:sahely/l10n/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

Future<void> pumpCalendar(WidgetTester tester,
    {required void Function(DateTime? s, DateTime? e) onDates}) async {
  await tester.pumpWidget(_wrap(BookingCalendarCard(onDatesChanged: onDates)));
  await tester.pumpAndSettle();
}

void main() {
  group('BookingCalendarCard', () {
    testWidgets('tapping today starts a range', (tester) async {
      var calls = 0;
      DateTime? start;
      DateTime? end;

      await pumpCalendar(tester, onDates: (s, e) {
        calls++;
        start = s;
        end = e;
      });

      final today = DateTime.now().day;
      // The current day number can appear twice in the grid (leading
      // previous-month cells); take the last match = focused month.
      await tester.tap(find.text('$today').last);
      await tester.pumpAndSettle();

      expect(calls, 1, reason: 'onDatesChanged must fire on tap');
      expect(start, isNotNull);
      expect(end, isNull);
    });

    testWidgets('second later tap completes the range', (tester) async {
      var calls = 0;
      DateTime? start;
      DateTime? end;

      await pumpCalendar(tester, onDates: (s, e) {
        calls++;
        start = s;
        end = e;
      });

      final now = DateTime.now();
      final dayA = now.day;

      // Pick check-out 3 nights later; if it spills into next month, use
      // the next-month day number (rendered in this grid's trailing row).
      final lastOfThisMonth = DateTime(now.year, now.month + 1, 0).day;
      var dayB = now.day + 3;
      if (dayB > lastOfThisMonth) dayB -= lastOfThisMonth;
      expect(dayB, greaterThan(0));

      await tester.tap(find.text('$dayA').last);
      await tester.pumpAndSettle();

      // `.last` targets the latest matching cell (focused/current-month or
      // trailing next-month), never the disabled previous-month lead-ins.
      await tester.tap(find.text('$dayB').last);
      await tester.pumpAndSettle();

      expect(calls, 2);
      expect(end, isNotNull, reason: 'check-out must be set');
      expect(end!.isAfter(start!), true);
    });

    testWidgets('tapping a PAST day gives visible guidance', (tester) async {
      await pumpCalendar(tester, onDates: (_, __) {});

      final now = DateTime.now();
      final pastDay = now.day >= 20 ? 10 : now.day - 1;

      await tester.tap(find.text('$pastDay').first, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget,
          reason: 'disabled-day tap must not be silently ignored');
    });
  });

  group('Countries data', () {
    test('has no duplicate ISO codes', () {
      final codes = Countries.all.map((c) => c.code).toSet();
      expect(codes.length, Countries.all.length);
    });

    test('every entry has name + E.164 dial code', () {
      for (final c in Countries.all) {
        expect(c.name.isNotEmpty, true, reason: '${c.code} missing name');
        expect(RegExp(r'^\+\d{1,4}$').hasMatch(c.dialCode), true,
            reason: '${c.code} bad dial code ${c.dialCode}');
      }
    });

    test('flag emoji derives from ISO code', () {
      expect(Countries.egypt.flag, '🇪🇬');
      expect(Countries.egypt.dialCode, '+20');
      expect(Countries.all.length, greaterThan(190));
    });
  });
}
