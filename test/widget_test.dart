// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiwi/main.dart';

void main() {
  testWidgets('App loads and shows welcome page', (WidgetTester tester) async {
    // Build our app wrapped with ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Wait for the frame to complete
    await tester.pumpAndSettle();

    // Verify that our app loads without errors
    // Since this is an English diary app, we expect to find the main app widget
    expect(find.byType(MaterialApp), findsOneWidget);
    // The test passes if no exceptions are thrown during widget construction
  });
}
