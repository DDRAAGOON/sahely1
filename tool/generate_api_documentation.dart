// Regenerates sahely_backend/API_DOCUMENTATION.pdf from the NestJS source
// controllers (same "extracted from source controllers" approach as the
// original document, now including the newly added endpoints).
//
// Run:  dart run tool/generate_api_documentation.dart
import 'dart:io';
import 'dart:math';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const backendRoot = r'D:\ahmed\Sahely_fahed\sahely_backend';
const outPath =
    r'D:\ahmed\Sahely_fahed\sahely_backend\API_DOCUMENTATION.pdf';

class Endpoint {
  final String method;
  final String path;
  final String handler;
  final String summary;
  final bool isPublic;
  const Endpoint(this.method, this.path, this.handler, this.summary,
      {this.isPublic = false});
}

class ControllerDoc {
  final String file;
  final String tag;
  final String basePath;
  final List<Endpoint> endpoints;
  const ControllerDoc(this.file, this.tag, this.basePath, this.endpoints);
}

final _methodRe = RegExp(
    r"""@(Get|Post|Put|Delete|Patch)\(\s*(?:'([^']*)'|"([^"]*)")?\s*\)([\s\S]*?)\n  (?:async )?([A-Za-z0-9_]+)\(""");
final _summaryRe = RegExp(r'''summary:\s*(?:"([^"]*)"|'([^']*)')''');
final _controllerPathRe =
    RegExp(r'''@Controller\(\s*(?:'([^']*)'|"([^"]*)")?\s*\)''');
final _tagRe = RegExp(r'''@ApiTags\(\s*'([^']*)'\s*\)''');

String unquote(String raw) {
  final t = raw.trim();
  if (t.length >= 2 &&
      ((t.startsWith('"') && t.endsWith('"')) ||
          (t.startsWith("'") && t.endsWith("'")))) {
    return t.substring(1, t.length - 1);
  }
  return t;
}

String joinConcat(String s) {
  // collapse `"a" +\n   "b"` concatenations
  final parts =
      RegExp(r'"((?:[^"\\]|\\.)*)"').allMatches(s).map((m) => m.group(1)!);
  return parts.join(' ').replaceAllMapped(
      RegExp(r'\\n'), (_) => ' ');
}

List<ControllerDoc> scan() {
  final docs = <ControllerDoc>[];
  final files = Directory('$backendRoot/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.controller.ts'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final f in files) {
    final src = f.readAsStringSync();
    final baseMatch = _controllerPathRe.firstMatch(src);
    final base =
        baseMatch == null ? '' : (baseMatch.group(1) ?? baseMatch.group(2) ?? '');
    final tagMatch = _tagRe.firstMatch(src);
    final tag = tagMatch?.group(1) ??
        f.uri.pathSegments.last.replaceAll('.controller.ts', '');

    final endpoints = <Endpoint>[];
    for (final m in _methodRe.allMatches(src)) {
      final verb = m.group(1)!.toUpperCase();
      final sub = m.group(2) ?? m.group(3) ?? '';
      final between = m.group(4) ?? '';
      final handler = m.group(5)!;

      final sm = _summaryRe.firstMatch(between);
      var summary = sm == null
          ? ''
          : joinConcat(between.substring(sm.start + 'summary:'.length));
      if (summary.isEmpty) summary = handler;

      // Public when @Public() appears within ~200 chars above the decorator.
      final idx = max(0, m.start - 220);
      final isPublic =
          src.substring(idx, m.start).contains('@Public()');

      endpoints.add(Endpoint(
        verb,
        sub.isEmpty ? '/' : '/$sub',
        handler,
        summary.trim(),
        isPublic: isPublic,
      ));
    }
    docs.add(ControllerDoc(f.path, tag, base, endpoints));
  }
  return docs;
}

const _navy = PdfColor.fromInt(0xFF1B2744);
const _gold = PdfColor.fromInt(0xFFC9A84C);
const _green = PdfColor.fromInt(0xFF1B6B3A);
const _muted = PdfColor.fromInt(0xFF717171);

pw.Widget _table(List<List<String>> rows) => pw.TableHelper.fromTextArray(
      headers: const ['Method', 'Endpoint', 'Summary'],
      data: rows,
      border: null,
      headerStyle: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: _navy),
      cellStyle: const pw.TextStyle(fontSize: 7.6),
      cellAlignment: pw.Alignment.centerLeft,
      columnWidths: const {
        0: pw.FixedColumnWidth(42),
        1: pw.FlexColumnWidth(3.2),
        2: pw.FlexColumnWidth(5),
      },
      oddRowDecoration:
          const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF7F3EC)),
    );

Future<void> main() async {
  final controllers = scan();
  final counts = <String, int>{};
  var total = 0;
  for (final c in controllers) {
    for (final e in c.endpoints) {
      counts[e.method] = (counts[e.method] ?? 0) + 1;
      total++;
    }
  }

  final doc = pw.Document();

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
                pw.Text('Sahely Backend — API Documentation',
                    style: pw.TextStyle(
                        fontSize: 26, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text('Complete Endpoint Reference',
                    style:
                        const pw.TextStyle(fontSize: 13, color: _muted)),
                pw.SizedBox(height: 30),
                pw.Row(children: [
                  _stat('$total', 'TOTAL ENDPOINTS'),
                  pw.SizedBox(width: 28),
                  for (final v in ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'])
                    pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 18),
                        child: _stat('${counts[v] ?? 0}', v)),
                ]),
                pw.SizedBox(height: 24),
                pw.Text(
                  'Controllers scanned: ${controllers.length} · '
                  'Extracted directly from the NestJS source controllers '
                  '(including the Missing-Apis phase-2 additions: Apple sign-in, '
                  'trending/offers feeds, booking extension & owner calendar, '
                  'search recents, review like/report/delete, user blocking, '
                  'withdrawal receipts, and the admin P0–P3 gap endpoints).',
                  style: const pw.TextStyle(fontSize: 10, color: _muted),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Generated: ${DateTime.now().toUtc().toIso8601String()}',
                  style: const pw.TextStyle(fontSize: 9, color: _muted),
                ),
              ])));

  for (final c in controllers) {
    if (c.endpoints.isEmpty) continue;
    final rows = [
      for (final e in c.endpoints)
        [e.method, '${c.basePath == '' ? '' : c.basePath}${e.path}'.replaceFirst('//', '/'),
         '${e.isPublic ? '[public] ' : ''}${e.summary}']
    ];
    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => [
              pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: pw.BoxDecoration(
                      color: _green, borderRadius: pw.BorderRadius.circular(6)),
                  child: pw.Text('${c.tag}  (${c.endpoints.length} endpoints)',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white))),
              pw.SizedBox(height: 10),
              _table(rows),
            ]));
  }

  await File(outPath).writeAsBytes(await doc.save());
  stdout.writeln('Wrote $outPath ($total endpoints across ${controllers.length} controllers)');
}

pw.Widget _stat(String n, String label) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(n,
              style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: _green)),
          pw.Text(label,
              style: const pw.TextStyle(fontSize: 8.5, color: _muted)),
        ]);
