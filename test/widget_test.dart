import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:converter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.textContaining('0'), findsOneWidget);
    expect(find.textContaining('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.textContaining('0'), findsNothing);
    expect(find.textContaining('1'), findsOneWidget);
  });
}
