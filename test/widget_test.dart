import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:airbnb_mobile/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AirbnbApp());

    // Verify the app renders without crashing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
