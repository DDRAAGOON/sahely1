import 'package:flutter_test/flutter_test.dart';
import 'package:sahely/app.dart';

void main() {
  testWidgets('Design index renders and lists sections', (tester) async {
    await tester.pumpWidget(const SahelyApp());
    await tester.pump();

    // The launcher shows the brand wordmark, intro CTA, and first section.
    expect(find.text('SAHELY'), findsWidgets);
    expect(find.text('Start the full flow'), findsOneWidget);
    expect(find.text('Authentication'), findsOneWidget);
  });
}
