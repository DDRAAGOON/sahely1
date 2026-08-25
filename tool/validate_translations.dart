import 'dart:convert';
import 'dart:io';

void main() {
  var allOk = true;
  for (final code in ['en', 'ar', 'fr', 'de', 'it', 'es', 'ru']) {
    try {
      final raw = File('assets/translations/$code.json').readAsStringSync();
      final data = json.decode(raw) as Map<String, dynamic>;
      final tagline = data['welcomeTagline'] as String;
      stdout.writeln('$code OK (${data.length} keys) tagline-lines: ${tagline.split('\n').length}');
    } catch (e) {
      allOk = false;
      stdout.writeln('$code FAILED: $e');
    }
  }
  stdout.writeln(allOk ? 'ALL VALID' : 'ERRORS FOUND');
}