import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/utils/snackbar_utils.dart';
import 'package:kiwi/constants/app_colors.dart';

void main() {
  group('SnackBar Utils Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(home: Scaffold(body: child));
    }

    testWidgets('showErrorSnackBar should display error snackbar', (
      WidgetTester tester,
    ) async {
      const testMessage = 'Test error message';

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showErrorSnackBar(context, testMessage),
                child: const Text('Show Error'),
              );
            },
          ),
        ),
      );

      // Tap button to show snackbar
      await tester.tap(find.text('Show Error'));
      await tester.pump();

      // Verify snackbar appears with correct message and color
      expect(find.text(testMessage), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(AppColors.errorColor));
    });

    testWidgets('showWarningSnackBar should display warning snackbar', (
      WidgetTester tester,
    ) async {
      const testMessage = 'Test warning message';

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showWarningSnackBar(context, testMessage),
                child: const Text('Show Warning'),
              );
            },
          ),
        ),
      );

      // Tap button to show snackbar
      await tester.tap(find.text('Show Warning'));
      await tester.pump();

      // Verify snackbar appears with correct message and color
      expect(find.text(testMessage), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(AppColors.warningColor));
    });

    testWidgets('showInfoSnackBar should display info snackbar', (
      WidgetTester tester,
    ) async {
      const testMessage = 'Test info message';

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showInfoSnackBar(context, testMessage),
                child: const Text('Show Info'),
              );
            },
          ),
        ),
      );

      // Tap button to show snackbar
      await tester.tap(find.text('Show Info'));
      await tester.pump();

      // Verify snackbar appears with correct message and color
      expect(find.text(testMessage), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(AppColors.infoColor));
    });

    testWidgets('should clear previous snackbars before showing new ones', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed:
                        () => showErrorSnackBar(context, 'First message'),
                    child: const Text('Show First'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => showInfoSnackBar(context, 'Second message'),
                    child: const Text('Show Second'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Show first snackbar
      await tester.tap(find.text('Show First'));
      await tester.pump();
      expect(find.text('First message'), findsOneWidget);

      // Show second snackbar - should clear first
      await tester.tap(find.text('Show Second'));
      await tester.pump();

      expect(find.text('First message'), findsNothing);
      expect(find.text('Second message'), findsOneWidget);
    });

    testWidgets('should handle empty messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showErrorSnackBar(context, ''),
                child: const Text('Show Empty'),
              );
            },
          ),
        ),
      );

      // Tap button to show snackbar with empty message
      await tester.tap(find.text('Show Empty'));
      await tester.pump();

      // Verify snackbar appears even with empty message
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should handle long messages', (WidgetTester tester) async {
      const longMessage =
          'This is a very long error message that should still be displayed correctly in the snackbar even though it contains many characters and might wrap to multiple lines';

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showErrorSnackBar(context, longMessage),
                child: const Text('Show Long'),
              );
            },
          ),
        ),
      );

      // Tap button to show snackbar
      await tester.tap(find.text('Show Long'));
      await tester.pump();

      // Verify snackbar appears with long message
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('should handle special characters in messages', (
      WidgetTester tester,
    ) async {
      const specialMessage = 'エラー: 特殊文字 @#\$%^&*()_+ 日本語';

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showWarningSnackBar(context, specialMessage),
                child: const Text('Show Special'),
              );
            },
          ),
        ),
      );

      // Tap button to show snackbar
      await tester.tap(find.text('Show Special'));
      await tester.pump();

      // Verify snackbar appears with special characters
      expect(find.text(specialMessage), findsOneWidget);
    });

    testWidgets('multiple snackbar types should work independently', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed:
                        () => showErrorSnackBar(context, 'Error message'),
                    child: const Text('Show Error'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => showWarningSnackBar(context, 'Warning message'),
                    child: const Text('Show Warning'),
                  ),
                  ElevatedButton(
                    onPressed: () => showInfoSnackBar(context, 'Info message'),
                    child: const Text('Show Info'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Test that each type can be shown
      await tester.tap(find.text('Show Error'));
      await tester.pump();
      expect(find.text('Error message'), findsOneWidget);

      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      expect(find.text('Warning message'), findsOneWidget);

      await tester.tap(find.text('Show Info'));
      await tester.pump();
      expect(find.text('Info message'), findsOneWidget);
    });
  });
}
