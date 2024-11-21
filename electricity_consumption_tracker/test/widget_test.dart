import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:electricity_consumption_tracker/main.dart';

void main() {
  testWidgets('Add Data button test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ElectricityConsumptionApp());

    // Verify that the "Add Data" button is present.
    expect(find.text('Add Data'), findsOneWidget);

    // Verify that the "+" icon is present in the button.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the "Add Data" button and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // You can add further logic here to verify what happens after tapping
    // the button, for example navigating to a new screen or opening a form.
    // For now, we simply verify that the button is tappable.
    expect(find.text('Add Data'), findsOneWidget); // Still present after tap.
  });
}
