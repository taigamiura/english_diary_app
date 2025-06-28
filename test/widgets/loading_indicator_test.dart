import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/widgets/loading_indicator.dart';

void main() {
  group('LoadingIndicator Widget Tests', () {
    testWidgets('LoadingIndicator should display CircularProgressIndicator', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingIndicator())),
      );

      // Verify that CircularProgressIndicator is present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify that it's centered
      expect(find.byType(Center), findsOneWidget);

      // Verify that it has padding
      expect(find.byType(Padding), findsOneWidget);
    });

    testWidgets('LoadingIndicator should have correct padding', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingIndicator())),
      );

      // Find the Padding widget
      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsOneWidget);

      // Get the Padding widget and check its properties
      final paddingWidget = tester.widget<Padding>(paddingFinder);
      expect(paddingWidget.padding, equals(const EdgeInsets.all(16.0)));
    });

    testWidgets('LoadingIndicator should be reusable', (
      WidgetTester tester,
    ) async {
      // Test with multiple LoadingIndicator widgets
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(children: [LoadingIndicator(), LoadingIndicator()]),
          ),
        ),
      );

      // Should find two instances
      expect(find.byType(LoadingIndicator), findsNWidgets(2));
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('LoadingIndicator should work in different containers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: const LoadingIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(LoadingIndicator), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
