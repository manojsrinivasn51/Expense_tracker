import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/main.dart';

void main() {
  testWidgets('Spendly app renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SpendlyApp());
    // The Home tab should be visible with Manoj greeting
    expect(find.textContaining('Manoj'), findsWidgets);
    expect(find.text('Home'), findsWidgets);
  });
}
