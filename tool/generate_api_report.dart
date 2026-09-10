// Generates API_COVERAGE_REPORT.pdf:
//  - Existing mobile-relevant backend APIs (from API_DOCUMENTATION.pdf source)
//  - APIs MISSING for the Sahely Flutter application (with proposed specs)
// Run:  dart run tool/generate_api_report.dart
// ignore_for_file: avoid_print, prefer_const_constructors
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Ep {
  final String method, path, note;
  const Ep(this.method, this.path, [this.note = '']);
}

class Group {
  final String name;
  final List<Ep> endpoints;
  const Group(this.name, this.endpoints);
}

const _green = PdfColor.fromInt(0xFF1B6B3A);
const _navy = PdfColor.fromInt(0xFF1B2744);
const _gold = PdfColor.fromInt(0xFFC9A84C);
const _muted = PdfColor.fromInt(0xFF717171);

// ---------------------------------------------------------------------------
// EXISTING mobile-relevant endpoints (extracted from API_DOCUMENTATION.pdf,
// generated 2026-08-23 from the NestJS controllers).
// ---------------------------------------------------------------------------
const existing = <Group>[
  Group('Auth', [
    Ep('GET', '/auth/google', 'Initiate Google OAuth'),
    Ep('GET', '/auth/google/callback', 'OAuth callback'),
    Ep('POST', '/auth/google/mobile', 'ID-token login (android|ios)'),
    Ep('POST', '/auth/login'),
    Ep('POST', '/auth/logout'),
    Ep('POST', '/auth/logout/all'),
    Ep('POST', '/auth/refresh'),
    Ep('POST', '/auth/otp/send', 'channel: sms|email + purpose'),
    Ep('POST', '/auth/otp/verify', 'code + purpose'),
    Ep('POST', '/auth/register/step1', 'role selection'),
    Ep('POST', '/auth/register/step2',
        'name/email/phone/DOB/password/terms'),
    Ep('POST', '/auth/register/step3/verify', 'email OTP'),
    Ep('POST', '/auth/register/step4/send-phone-otp', 'required'),
    Ep('POST', '/auth/register/step4/verify-phone'),
    Ep('POST', '/auth/password/reset-request'),
    Ep('POST', '/auth/password/reset', 'email + code + new_password'),
    Ep('POST', '/auth/password/change'),
    Ep('POST', '/auth/send-otp-on-phone-number'),
    Ep('POST', '/auth/verify-otp-on-phone-number'),
  ]),
  Group('Identity verification (KYC)', [
    Ep('POST', '/verification/start', 'registration_session_id'),
    Ep('POST', '/verification/documents', 'OCR + face compare + decision'),
    Ep('POST', '/verification/liveness/start', 'AWS Face Liveness session'),
    Ep('POST', '/verification/liveness/submit'),
    Ep('POST', '/verification/qr/scan', 'desktop QR hand-off'),
    Ep('POST', '/verification/request-review', 'manual-review fallback'),
    Ep('GET', '/verification/status/:id', 'poll by session id'),
    Ep('POST', '/auth/verification/card', 'save payment card post-login'),
    Ep('POST', '/auth/verification/identity', 'profile-settings variant'),
    Ep('GET', '/auth/verification/status'),
  ]),
  Group('User profile', [
    Ep('GET', '/users/me'),
    Ep('PUT', '/users/me',
        'names/phone(+otp)/about/socials/preferred_currency'),
    Ep('DELETE', '/users/me'),
    Ep('POST', '/users/me/avatar', 'DEPRECATED — use files/upload'),
    Ep('DELETE', '/users/me/avatar'),
    Ep('PUT', '/users/me/fcm-token'),
    Ep('PUT', '/users/me/email/change-request'),
    Ep('PUT', '/users/me/email/confirm'),
    Ep('POST', '/users/me/broker-invitation', 'link broker via code'),
    Ep('GET', '/users/me/referral'),
    Ep('GET', '/users/:id', 'public profile'),
  ]),
  Group('Files (uploads)', [
    Ep('POST', '/files/upload/request-url', 'pre-signed S3 URL'),
    Ep('POST', '/files/upload/confirm', 'store object key'),
  ]),
  Group('Properties', [
    Ep('GET', '/properties/', 'search with filters'),
    Ep('GET', '/properties/featured'),
    Ep('GET', '/properties/:id'),
    Ep('POST', '/properties/addProperty', 'requires KYC approval'),
    Ep('PATCH', '/properties/:id', 'full update DTO'),
    Ep('DELETE', '/properties/:id', 'soft-delete (owner)'),
    Ep('POST', '/properties/:id/submit', 'send to team review'),
    Ep('POST', '/properties/:id/unlist'),
    Ep('POST', '/properties/:id/relist'),
    Ep('GET', '/properties/mine'),
    Ep('GET', '/properties/mine/calendar'),
    Ep('GET', '/properties/mine/earnings'),
    Ep('GET', '/properties/mine/portfolio/dashboard'),
    Ep('GET', '/properties/mine/renters'),
    Ep('GET', '/properties/:id/availability'),
    Ep('POST', '/properties/:id/availability/block'),
    Ep('DELETE', '/properties/:id/availability/block'),
    Ep('GET', '/properties/:id/quote', 'price quote for N nights'),
    Ep('POST', '/properties/:id/images', 'DEPRECATED — use files'),
    Ep('DELETE', '/properties/:id/images/:imgId'),
    Ep('PUT', '/properties/:id/images/:imgId/cover'),
    Ep('POST', '/properties/:id/photography/request'),
    Ep('GET', '/properties/:id/photography/status'),
    Ep('GET', '/properties/:id/checklist/pre-listing'),
    Ep('POST', '/properties/:id/checklist/pre-listing'),
  ]),
  Group('Search & discovery', [
    Ep('GET', '/search/properties', 'advanced filters'),
    Ep('GET', '/search/suggestions', 'compound/location suggestions'),
    Ep('GET', '/search/map', 'map pins'),
  ]),
  Group('Bookings', [
    Ep('POST', '/bookings/', 'create booking request'),
    Ep('GET', '/bookings/', 'list (scoped)'),
    Ep('GET', '/bookings/my'),
    Ep('GET', '/bookings/:id'),
    Ep('POST', '/bookings/calculate', 'pricing before create'),
    Ep('POST', '/bookings/:id/approve'),
    Ep('POST', '/bookings/:id/reject'),
    Ep('POST', '/bookings/:id/cancel', 'reason?'),
    Ep('POST', '/bookings/:id/check-in'),
    Ep('POST', '/bookings/:id/check-out'),
    Ep('POST', '/bookings/:id/no-show'),
    Ep('POST', '/bookings/:id/dispute', 'reason'),
    Ep('POST', '/bookings/:id/late-checkout-charge'),
    Ep('GET', '/bookings/:id/receipt'),
    Ep('GET', '/bookings/:id/lock/pin', 'smart-lock passcode'),
    Ep('GET', '/bookings/owner/bookings'),
    Ep('GET', '/bookings/owner/requests'),
    Ep('GET', '/bookings/pending-approval'),
    Ep('POST', '/bookings/:id/admin-check-in'),
  ]),
  Group('Payments (Paymob)', [
    Ep('POST', '/payments/initiate', 'intention for a booking'),
    Ep('POST', '/payments/intents', 'generic intent'),
    Ep('GET', '/payments/:id'),
    Ep('GET', '/payments/:id/status'),
    Ep('POST', '/payments/wallet-pay', 'pay booking from wallet'),
    Ep('POST', '/payments/top-up', 'wallet funding intent'),
    Ep('GET', '/payments/top-up/:id'),
    Ep('GET', '/payments/cards'),
    Ep('POST', '/payments/cards', 'save card token'),
    Ep('DELETE', '/payments/cards/:cardId'),
    Ep('PATCH', '/payments/cards/:cardId/default'),
    Ep('GET', '/payments/currency/rates'),
    Ep('POST', '/payments/security-deposit/release', 'admin'),
    Ep('POST', '/payments/security-deposit/claim', 'admin'),
    Ep('POST', '/payments/admin/holds', 'admin'),
    Ep('POST', '/payments/admin/holds/:id/release', 'admin'),
    Ep('POST', '/payments/callback', '+GET variant'),
    Ep('POST', '/payments/webhook', '+GET variant'),
  ]),
  Group('Wallets', [
    Ep('GET', '/wallet/', 'renter wallet'),
    Ep('GET', '/wallet/transactions'),
    Ep('POST', '/wallet/withdraw'),
    Ep('GET', '/wallet/withdraw/:id', 'withdrawal status'),
    Ep('GET', '/wallets/me', 'owner wallet'),
    Ep('GET', '/wallets/me/dashboard'),
    Ep('GET', '/wallets/me/transactions'),
    Ep('POST', '/wallets/me/withdrawals'),
  ]),
  Group('Reviews', [
    Ep('POST', '/reviews/', 'property or guest review'),
    Ep('GET', '/reviews/'),
    Ep('GET', '/reviews/:id'),
    Ep('POST', '/reviews/:id/response', 'owner response'),
    Ep('GET', '/reviews/pending'),
    Ep('GET', '/reviews/summary', 'by propertyId'),
  ]),
  Group('Wishlists (collections)', [
    Ep('GET', '/wishlists/'),
    Ep('POST', '/wishlists/'),
    Ep('GET', '/wishlists/:id'),
    Ep('PUT', '/wishlists/:id', 'rename'),
    Ep('DELETE', '/wishlists/:id'),
    Ep('GET', '/wishlists/:id/compare'),
    Ep('POST', '/wishlists/:id/properties'),
    Ep('DELETE', '/wishlists/:id/properties/:propId'),
    Ep('GET', '/wishlists/:id/members'),
    Ep('DELETE', '/wishlists/:id/members/:userId'),
    Ep('POST', '/wishlists/:id/members/:userId/reinstate'),
    Ep('POST', '/wishlists/:id/leave'),
    Ep('POST', '/wishlists/:id/messages'),
    Ep('GET', '/wishlists/:id/messages'),
    Ep('DELETE', '/wishlists/:id/messages/:messageId'),
    Ep('POST', '/wishlists/:id/messages/read'),
    Ep('GET', '/wishlists/:id/messages/unread-count'),
    Ep('POST', '/wishlists/:id/reports/'),
    Ep('POST', '/wishlists/:id/share-link'),
    Ep('GET', '/wishlists/:id/share-status'),
    Ep('POST', '/wishlists/:id/share/revoke'),
    Ep('POST', '/wishlists/:id/share/rotate'),
    Ep('POST', '/wishlists/join', 'redeem share token'),
  ]),
  Group('Support chat', [
    Ep('POST', '/chat/conversations'),
    Ep('GET', '/chat/conversations'),
    Ep('GET', '/chat/conversations/:id'),
    Ep('POST', '/chat/conversations/:id/close'),
    Ep('GET', '/chat/conversations/:id/messages'),
    Ep('POST', '/chat/conversations/:id/messages'),
    Ep('PUT', '/chat/conversations/:id/read'),
    Ep('GET', '/chat/unread-count'),
    Ep('GET', '/chat/search'),
    Ep('DELETE', '/chat/messages/:id'),
    Ep('POST', '/chat/sos', 'urgent ticket around check-in/out window'),
  ]),
  Group('AI chatbot', [
    Ep('POST', '/chatbot/conversations'),
    Ep('GET', '/chatbot/conversations'),
    Ep('GET', '/chatbot/conversations/:id'),
    Ep('GET', '/chatbot/conversations/:id/messages'),
    Ep('POST', '/chatbot/conversations/:id/messages'),
    Ep('PUT', '/chatbot/conversations/:id/read'),
    Ep('POST', '/chatbot/conversations/:id/close'),
    Ep('GET', '/chatbot/unread-count'),
  ]),
  Group('Notifications', [
    Ep('GET', '/notifications/'),
    Ep('DELETE', '/notifications/:id'),
    Ep('PUT', '/notifications/:id/read'),
    Ep('PUT', '/notifications/read-all'),
    Ep('POST', '/notifications/device-token', 'FCM'),
    Ep('GET', '/notifications/preferences'),
    Ep('PUT', '/notifications/preferences'),
  ]),
  Group('AL MAWSEM (loyalty)', [
    Ep('GET', '/mawsem/me'),
    Ep('GET', '/mawsem/levels'),
    Ep('GET', '/mawsem/perks'),
    Ep('POST', '/mawsem/perks/free-cleaning/use', 'Level 5+'),
    Ep('GET', '/mawsem/tokens'),
    Ep('POST', '/mawsem/tokens/use'),
    Ep('GET', '/mawsem/leaderboard'),
    Ep('GET', '/mawsem/history'),
    Ep('GET', '/mawsem/level-history'),
    Ep('GET', '/mawsem/season/current'),
  ]),
  Group('Broker', [
    Ep('GET', '/broker/dashboard'),
    Ep('GET', '/broker/profile'),
    Ep('PUT', '/broker/profile'),
    Ep('GET', '/broker/properties', 'portfolio'),
    Ep('GET', '/broker/tier'),
    Ep('GET', '/broker/commissions'),
    Ep('GET', '/broker/earning-windows'),
    Ep('GET', '/broker/perks'),
    Ep('POST', '/broker/perks/redeem-stay'),
    Ep('POST', '/broker/referral-link'),
    Ep('GET', '/broker/referral-link/stats'),
    Ep('POST', '/broker/withdraw'),
  ]),
  Group('Referrals', [
    Ep('GET', '/referrals/code'),
    Ep('GET', '/referrals/me'),
    Ep('GET', '/referrals/resolve', 'public'),
    Ep('GET', '/referrals/stats'),
  ]),
  Group('Concierge', [
    Ep('GET', '/concierge/services'),
    Ep('GET', '/concierge/services/:id'),
    Ep('POST', '/concierge/bookings'),
    Ep('GET', '/concierge/bookings'),
    Ep('GET', '/concierge/bookings/:id'),
    Ep('POST', '/concierge/bookings/:id/cancel'),
  ]),
  Group('Checklists & compound', [
    Ep('POST', '/arrival/renter'),
    Ep('GET', '/arrival/renter'),
    Ep('POST', '/arrival/owner'),
    Ep('POST', '/departure/renter'),
    Ep('POST', '/departure/owner'),
    Ep('GET', '/departure/owner'),
    Ep('POST', '/bookings/:bookingId/compound/security-check'),
    Ep('GET', '/bookings/:bookingId/compound/security-check'),
    Ep('POST', '/properties/:propertyId/cleaning/confirm'),
    Ep('GET', '/properties/:propertyId/cleaning/log'),
  ]),
  Group('Smart locks & violations', [
    Ep('GET', '/locks/:ref/status', '(via /admin/locks health variants)'),
    Ep('POST', '/locks/hardware-callback', 'device webhook'),
    Ep('POST', '/locks/tuya', 'Tuya webhook'),
    Ep('GET', '/properties/:id/smart-lock/access-log'),
    Ep('POST', '/properties/:id/smart-lock/emergency-access'),
    Ep('GET', '/properties/:id/smart-lock/online-status'),
    Ep('POST', '/properties/:id/smart-lock/register'),
    Ep('DELETE', '/properties/:id/smart-lock'),
    Ep('POST', '/violations/report'),
    Ep('POST', '/violations/compound'),
    Ep('GET', '/violations/mine'),
  ]),
];

// ---------------------------------------------------------------------------
// MISSING — needed by the Flutter application, absent from the backend docs.
// ---------------------------------------------------------------------------
class Missing {
  final String method, path, title, why, spec, priority;
  const Missing(this.priority, this.method, this.path, this.title, this.why,
      [this.spec = '']);
}

const missing = <Missing>[
  Missing(
    'HIGH',
    'POST',
    '/auth/apple/mobile',
    'Sign in with Apple',
    'Screen 06 has a "Continue with Apple" button (App Store requirement when '
        'Google login exists). Only Google mobile auth exists.',
    'Body: { identityToken: string, platform: "ios", fullName?: {given?, '
        'family?} } → same session payload as /auth/google/mobile.'),
  Missing(
    'HIGH',
    'GET',
    '/properties/trending',
    'Trending properties feed',
    'Renter home shows a TRENDING NOW rail; today it is fed from mock data.',
    'Query: ?limit=10&governorate= → ranked by recent bookings/views.'),
  Missing(
    'HIGH',
    'GET',
    '/properties/offers',
    'Best-offers / deals feed',
    'Renter home BEST OFFERS rail needs discounted listings '
        '(-15%/-20% badges in the design).',
    'Query: ?limit=10 → active price cuts or promo campaigns.'),
  Missing(
    'HIGH',
    'GET',
    '/bookings/owner/calendar',
    'Owner bookings calendar feed',
    'Owner Manage tab renders a availability calendar of arrivals/departures; '
        'only /properties/mine/calendar (dates) exists, without guest names.',
    'Query: ?month=YYYY-MM → [{property_id, check_in, check_out, guest, '
        'status}].'),
  Missing(
    'MEDIUM',
    'POST',
    '/bookings/:id/extend',
    'Extend a stay',
    'App has an extend-booking use case and late-checkout charge exists, but '
        'no endpoint extends checkout date of an active booking.',
    'Body: { new_check_out: string } → repriced diff charged via Paymob/'
        'wallet hold.'),
  Missing(
    'MEDIUM',
    'GET',
    '/search/recent',
    'Recent searches',
    'Search screen stores recents locally only; use cases '
        '(save/clear recent searches) expect server sync.',
    'POST /search/recent {query}, DELETE /search/recent (clear), max 10.'),
  Missing(
    'MEDIUM',
    'POST',
    '/reviews/:id/like',
    'Mark review helpful',
    'Reviews UI has a helpful counter; no endpoint toggles it.',
    'Toggle semantics; returns {likes}.'),
  Missing(
    'MEDIUM',
    'POST',
    '/reviews/:id/report',
    'Report a review',
    'Long-press report flow exists in UI; backend only allows admins to '
        'delete reviews.',
    'Body: { reason: enum, details?: string } → moderation queue.'),
  Missing(
    'LOW',
    'DELETE',
    '/reviews/:id',
    'Delete own review',
    '"My Reviews" allows removing a review you wrote.',
    'Author-only soft delete within edit window.'),
  Missing(
    'MEDIUM',
    'POST',
    '/users/:id/block',
    'Block a guest',
    'Owner requests screen offers "Block this Renter"; nothing prevents the '
        'blocked user from booking again.',
    'Body: { reason?: string }; add DELETE /users/me/blocked/{userId}.'),
  Missing(
    'LOW',
    'GET',
    '/wallet/withdraw/:id/receipt',
    'Withdrawal receipt (PDF)',
    'Screen 38 has "Download receipt"; today only status JSON exists.',
    'Returns application/pdf of the payout confirmation.'),
  Missing(
    'LOW',
    'GET',
    '/properties/mine/earnings/export',
    'Earnings statement export',
    'Owner wallet header has "Export PDF" (screen 29).',
    'Query: ?period=month|quarter|year → CSV/PDF statement.'),
  Missing(
    'MEDIUM',
    'GET',
    '/properties/mine/violations',
    'Owner violations list',
    'Owner wallet shows a Violations summary card; /violations/mine covers '
        'the accused party only, not property-linked summaries.',
    '?property_id= filter with counts by status.'),
];

// ---------------------------------------------------------------------------
// Integration corrections — app stubs that point at paths that do not exist.
// ---------------------------------------------------------------------------
const corrections = <Ep>[
  Ep('lib/core/network/api_endpoints.dart', '', ''),
  Ep('APP', '/auth/register', 'backend uses /auth/register/step1..4'),
  Ep('APP', '/auth/verify-email', 'backend uses /auth/register/step3/verify'),
  Ep('APP', '/auth/logout', 'exists, but requires refresh_token body'),
  Ep('APP', '/user/profile', 'backend path is /users/me'),
  Ep('APP', '/user/update', 'backend path is PUT /users/me'),
  Ep('APP', '/properties', 'backend search path is GET /properties/'),
  Ep('APP', '/bookings', 'backend create path is POST /bookings/'),
];

pw.Widget _table(List<Ep> rows) => pw.TableHelper.fromTextArray(
      headers: ['Method', 'Endpoint', 'Notes'],
      data: rows.map((e) => [e.method, e.path, e.note]).toList(),
      border: null,
      headerStyle: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: _navy),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: const {
        0: pw.FixedColumnWidth(46),
        1: pw.FlexColumnWidth(5),
        2: pw.FlexColumnWidth(4),
      },
      oddRowDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF7F3EC)),
    );

pw.Document _build() {
  final doc = pw.Document();
  final totalExisting =
      existing.fold<int>(0, (n, g) => n + g.endpoints.length);

  // ---- Cover ----
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
                pw.SizedBox(height: 26),
                pw.Text('API Coverage Report',
                    style: pw.TextStyle(
                        fontSize: 30, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                    'Existing backend endpoints vs. what the Flutter '
                    'application needs — and the gaps to close.',
                    style: const pw.TextStyle(fontSize: 13, color: _muted)),
                pw.SizedBox(height: 36),
                _stat('$totalExisting',
                    'mobile-relevant endpoints already implemented'),
                _stat('${missing.length}',
                    'missing endpoints proposed in this report'),
                _stat('${corrections.length - 1}',
                    'client path corrections (stubs → real routes)'),
                pw.SizedBox(height: 36),
                pw.Text(
                    'Sources: sahely_backend/API_DOCUMENTATION.pdf '
                    '(28 controllers · 352 total endpoints, generated '
                    '2026-08-23) cross-checked against the Flutter app '
                    '(screens, use-cases and mock data-sources).',
                    style: const pw.TextStyle(fontSize: 9, color: _muted)),
              ])));

  // ---- Summary of what is missing ----
  doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _h1('1 · Missing APIs'),
                pw.SizedBox(height: 6),
                pw.Text(
                    'Features visible in the app (or required by store rules) '
                    'with no backing endpoint:',
                    style: const pw.TextStyle(fontSize: 10, color: _muted)),
                pw.SizedBox(height: 12),
                pw.TableHelper.fromTextArray(
                  headers: ['#', 'Prio', 'Method', 'Proposed endpoint'],
                  data: missing
                      .asMap()
                      .entries
                      .map((e) => [
                            '${e.key + 1}',
                            e.value.priority,
                            e.value.method,
                            '${e.value.path}  —  ${e.value.title}',
                          ])
                      .toList(),
                  border: null,
                  headerStyle: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: _green),
                  cellStyle: const pw.TextStyle(fontSize: 8.5),
                  cellAlignment: pw.Alignment.centerLeft,
                  columnWidths: const {
                    0: pw.FixedColumnWidth(18),
                    1: pw.FixedColumnWidth(38),
                    2: pw.FixedColumnWidth(44),
                    3: pw.FlexColumnWidth(),
                  },
                  oddRowDecoration:
                      const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF7F3EC)),
                ),
                pw.SizedBox(height: 16),
                _h2('Client path corrections'),
                pw.SizedBox(height: 6),
                pw.Text(
                    'The Flutter ApiEndpoints stubs target routes that do not '
                    'exist on the NestJS backend:',
                    style: const pw.TextStyle(fontSize: 9, color: _muted)),
                pw.SizedBox(height: 8),
                _table(corrections.skip(1).toList()),
              ])));

  // ---- Detailed missing specs ----
  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => [
            _h1('2 · Proposed specifications'),
            ...missing.map((m) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromInt(0xFFE0D8CC)),
                    borderRadius: pw.BorderRadius.circular(8)),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        _prio(m.priority),
                        pw.SizedBox(width: 8),
                        pw.Expanded(
                            child: pw.Text('${m.method}  ${m.path}',
                                style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold))),
                      ]),
                      pw.SizedBox(height: 4),
                      pw.Text(m.title,
                          style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: _navy)),
                      pw.SizedBox(height: 4),
                      pw.Text(m.why,
                          style:
                              const pw.TextStyle(fontSize: 9, color: _muted)),
                      if (m.spec.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text('Spec: ${m.spec}',
                            style: pw.TextStyle(
                                fontSize: 9, color: _green, fontStyle: pw.FontStyle.italic)),
                      ],
                    ])))
          ]));

  // ---- Existing endpoints ----
  for (final g in existing) {
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => [
              _h1('3 · Existing APIs — ${g.name}'),
              pw.SizedBox(height: 4),
              pw.Text('${g.endpoints.length} endpoints',
                  style: const pw.TextStyle(fontSize: 9, color: _muted)),
              pw.SizedBox(height: 8),
              _table(g.endpoints),
            ]));
  }

  return doc;
}

pw.Widget _h1(String t) => pw.Text(t,
    style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold, color: _navy));
pw.Widget _h2(String t) => pw.Text(t,
    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _navy));

pw.Widget _stat(String n, String label) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 10),
    child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.SizedBox(
          width: 70,
          child: pw.Text(n,
              style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: _green))),
      pw.Expanded(
          child: pw.Padding(
              padding: const pw.EdgeInsets.only(top: 8),
              child: pw.Text(label,
                  style: const pw.TextStyle(fontSize: 11, color: _muted)))),
    ]));

pw.Widget _prio(String p) {
  final c = switch (p) {
    'HIGH' => PdfColor.fromInt(0xFFB22222),
    'MEDIUM' => PdfColor.fromInt(0xFFD2760A),
    _ => PdfColor.fromInt(0xFF717171),
  };
  return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
          color: c, borderRadius: pw.BorderRadius.circular(4)),
      child: pw.Text(p,
          style: pw.TextStyle(
              fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.white)));
}

Future<void> main() async {
  final doc = _build();
  final bytes = await doc.save();
  final file = File('API_COVERAGE_REPORT.pdf');
  await file.writeAsBytes(bytes);
  print('Wrote ${file.absolute.path} (${bytes.length ~/ 1024} KB)');
}
