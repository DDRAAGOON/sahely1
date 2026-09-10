// Generates TEST_REPORT.pdf from tool/api_test_results.json.
// Run: dart run tool/generate_test_report.dart
// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const resultsPath = 'tool/api_test_results.json';
const outPath = 'API_TEST_REPORT.pdf';

const _navy = PdfColor.fromInt(0xFF1B2744);
const _gold = PdfColor.fromInt(0xFFC9A84C);
const _green = PdfColor.fromInt(0xFF1B6B3A);
const _red = PdfColor.fromInt(0xFFB22222);
const _amber = PdfColor.fromInt(0xFFD2760A);
const _muted = PdfColor.fromInt(0xFF717171);

Future<void> main() async {
  final raw = await File(resultsPath).readAsString();
  final rows0 = (jsonDecode(raw) as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();

  // Stable grouping
  final groups = <String, List<Map<String, dynamic>>>{};
  for (final r in rows0) {
    groups.putIfAbsent('${r['group']}', () => []).add(r);
  }
  final passed = rows0.where((r) => r['pass'] == true).length;
  final failed = rows0.length - passed;

  final doc = pw.Document();

  // ── Cover ────────────────────────────────────────────────────────────────
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(48),
      build: (_) => pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: const pw.BoxDecoration(color: _gold),
                    child: pw.Text('SAHELY',
                        style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: _navy))),
                pw.SizedBox(height: 24),
                pw.Text('Live API Integration — Test Report',
                    style: pw.TextStyle(
                        fontSize: 26, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Flutter app ↔ NestJS backend · first end-to-end '
                    'verification before store upload',
                    style:
                        const pw.TextStyle(fontSize: 12, color: _muted)),
                pw.SizedBox(height: 30),
                _bigStat('$passed', 'PASSED', _green),
                _bigStat('$failed', 'FAILED', failed == 0 ? _muted : _red),
                _bigStat('${rows0.length}', 'TOTAL CHECKS', _navy),
                pw.SizedBox(height: 26),
                _kv('Backend under test',
                    'http://localhost:43000/api/v1 (NestJS + AWS RDS dev DB)'),
                _kv('Infrastructure',
                    'Docker Redis 7 (localhost:6379), node dist/src/main.js'),
                _kv('Test identities',
                    'renter@test.com / owner@test.com / broker@test.com · '
                        'admin@sahely.com (seeded credentials)'),
                _kv('Generated',
                    DateTime.now().toUtc().toIso8601String()),
              ])));

  // ── What was wired in the app ────────────────────────────────────────────
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _h1('1 · What the app now uses (no longer static)'),
                pw.SizedBox(height: 10),
                _bullet('Dev environment points at the live API '
                    '(lib/core/config/app_env.dart → http://localhost:43000/api/v1).'),
                _bullet('Login calls POST /auth/login and persists access/'
                    'refresh tokens in secure storage; every request carries '
                    'Bearer auth via AuthInterceptor.'),
                _bullet('Renter home/browse feed reads GET /properties '
                    '(+ NEW trending & offers rails) through RenterApiDataSource.'),
                _bullet('Bookings: create → POST /bookings, my trips → GET '
                    '/bookings/my, cancel, extend (NEW), availability check.'),
                _bullet('Reviews: list per property, create, delete own, like, '
                    'report — all hitting real endpoints.'),
                _bullet('Profile reads/updates /users/me incl. password change '
                    'and account deletion.'),
                _bullet('Wishlist collections CRUD against /wishlists.'),
                _bullet('Wallet screen data via /wallet + /wallet/transactions; '
                    'withdrawal receipts downloadable as PDF.'),
                _bullet('Rollback switch: --dart-define=SAHELY_REMOTE=false '
                    'restores the offline mock behaviour at any time.'),
                pw.SizedBox(height: 18),
                _h2('2 · Bugs found & fixed during testing'),
                pw.SizedBox(height: 6),
                _bullet('GET /admin/users|bookings/export were shadowed by the '
                    'parametric /admin/users/:id route → moved exports to '
                    '/admin/export/* and reordered controllers.'),
                _bullet('CSV exports crashed on orderBy("u.created_at") — '
                    'TypeORM needs the property name (createdAt). Fixed.'),
                _bullet('POST responses return HTTP 201 (NestJS default), not '
                    '200 — client expectations updated.'),
              ])));

  // ── Results tables per group ─────────────────────────────────────────────
  for (final entry in groups.entries) {
    final g = entry.value;
    final gPass = g.where((r) => r['pass'] == true).length;
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => [
              pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: pw.BoxDecoration(
                      color: _navy, borderRadius: pw.BorderRadius.circular(6)),
                  child: pw.Text(
                      '${entry.key}  —  $gPass/${g.length} passed',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white))),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: const ['Result', 'Check', 'HTTP', 'Note'],
                data: [
                  for (final r in g)
                    [
                      r['pass'] == true ? 'PASS' : 'FAIL',
                      '${r['name']}',
                      '${r['method']} ${r['url']}',
                      r['pass'] == true ? '' : '${r['status']}: ${r['snippet']}',
                    ]
                ],
                border: null,
                headerStyle: pw.TextStyle(
                    fontSize: 8.5,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColor.fromInt(0xFF3A4A6B)),
                cellStyle: const pw.TextStyle(fontSize: 7.6),
                cellAlignment: pw.Alignment.centerLeft,
                columnWidths: const {
                  0: pw.FixedColumnWidth(34),
                  1: pw.FlexColumnWidth(3.4),
                  2: pw.FlexColumnWidth(2.6),
                  3: pw.FlexColumnWidth(2.6),
                },
                oddRowDecoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFF7F3EC)),
              ),
            ]));
  }

  // ── Manual testing checklist ─────────────────────────────────────────────
  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => [
            _h1('3 · Requires MANUAL testing before upload'),
            pw.SizedBox(height: 6),
            pw.Text(
                'Automated checks cannot exercise third-party sandboxes, '
                'hardware or on-device UX. Verify each item below:',
                style: const pw.TextStyle(fontSize: 10, color: _muted)),
            pw.SizedBox(height: 10),
            _manual([
              ('Registration OTP flow',
                  'Phone/email OTP depends on Twilio (PHONE_OTP_TEST_MODE=true '
                  'on dev prints/short-circuits codes) — register a fresh user '
                  'through the app screens.'),
              ('Sign in with Google / Apple',
                  'Needs real device + configured GOOGLE_ANDROID/IOS_CLIENT_ID '
                  'and APPLE_BUNDLE_ID; verify account-linking 401 path too.'),
              ('Paymob payments',
                  'Card hold/charge, wallet top-up and refunds inside the '
                  'Paymob sandbox; confirm webhook HMAC updates payment status.'),
              ('KYC identity verification',
                  'Document OCR + AWS Face Liveness session end-to-end with a '
                  'real national ID.'),
              ('Smart locks (Tuya)',
                  'PIN generation 24h pre-check-in, reveal radius, emergency '
                  'access — requires a physical lock registered to a property.'),
              ('Push notifications',
                  'FCM device-token registration + a broadcast reaching the '
                  'device (Firebase project sahely-01).'),
              ('Emails',
                  'Postmark delivery of verification / password-reset / '
                  'booking emails (check spam folder + sender domain).'),
              ('File uploads',
                  'S3 pre-signed upload flow for property images and avatars '
                  '(request-url → PUT → confirm).'),
              ('Support chat & AI chatbot',
                  'Socket/gateway messaging, unread counts, n8n AI replies.'),
              ('App E2E on device',
                  'flutter run --dart-define=SAHELY_ENV=dev against this local '
                  'backend (or deploy it) — walk: browse → book → pay → check-in '
                  '→ review → withdraw.'),
            ]),
            pw.SizedBox(height: 16),
            _h2('4 · Known limitations'),
            pw.SizedBox(height: 6),
            _bullet('Admin two-factor codes are delivered by EMAIL (admin '
                'accounts have no phone column yet).'),
            _bullet('Trending/offers ranking is first-pass (book-count / price); '
                'tune scoring later.'),
            _bullet('Profile image upload throws by design until the S3 '
                'pre-signed flow is wired into the avatar UI.'),
          ]));

  await File(outPath).writeAsBytes(await doc.save());
  stdout.writeln('Wrote $outPath');
}

pw.Widget _h1(String t) => pw.Text(t,
    style: pw.TextStyle(
        fontSize: 16, fontWeight: pw.FontWeight.bold, color: _navy));

pw.Widget _h2(String t) => pw.Text(t,
    style: pw.TextStyle(
        fontSize: 12.5, fontWeight: pw.FontWeight.bold, color: _navy));

pw.Widget _bullet(String t) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 7),
    child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('•  ', style: pw.TextStyle(fontSize: 10, color: _gold)),
          pw.Expanded(
              child:
                  pw.Text(t, style: const pw.TextStyle(fontSize: 9.5))),
        ]));

pw.Widget _bigStat(String n, String label, PdfColor c) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 12),
    child: pw.Row(children: [
      pw.SizedBox(
          width: 90,
          child: pw.Text(n,
              style:
                  pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: c))),
      pw.Padding(
          padding: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(label,
              style: const pw.TextStyle(fontSize: 11, color: _muted))),
    ]));

pw.Widget _kv(String k, String v) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(k,
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: _muted)),
      pw.SizedBox(height: 2),
      pw.Text(v, style: const pw.TextStyle(fontSize: 10)),
    ]));

pw.Widget _manual(List<(String, String)> items) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      for (final (i, item) in items.indexed)
        pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColor.fromInt(0xFFE0D8CC)),
                borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                      width: 16,
                      height: 16,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: _amber, width: 1.5),
                          borderRadius: pw.BorderRadius.circular(3))),
                  pw.SizedBox(width: 10),
                  pw.Expanded(
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                        pw.Text('${i + 1}. ${item.$1}',
                            style: pw.TextStyle(
                                fontSize: 10.5,
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 3),
                        pw.Text(item.$2,
                            style: const pw.TextStyle(
                                fontSize: 9, color: _muted)),
                      ])),
                ])),
    ]);
