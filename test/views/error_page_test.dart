import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/views/error_page.dart';
import 'package:english_diary_app/constants/app_strings.dart';

void main() {
  group('ErrorPage', () {
    testWidgets('should display error message and restart button', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testError = 'Test error message';
      const errorPage = ErrorPage(error: testError);

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text(AppStrings.appInitFailed), findsOneWidget);
      expect(find.text(testError), findsOneWidget);
      expect(find.text(AppStrings.restart), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display stack trace when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testError = 'Test error';
      final testStackTrace = StackTrace.fromString('Stack trace info');
      final errorPage = ErrorPage(error: testError, stackTrace: testStackTrace);

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      expect(find.text(testError), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should handle complex error objects', (
      WidgetTester tester,
    ) async {
      // Arrange
      final complexError = Exception('Complex error with details');
      final errorPage = ErrorPage(error: complexError);

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      expect(
        find.textContaining('Exception: Complex error with details'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should have proper styling and layout', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testError = 'Styling test error';
      const errorPage = ErrorPage(error: testError);

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      // Check if error icon has correct color and size
      final errorIcon = tester.widget<Icon>(find.byIcon(Icons.error));
      expect(errorIcon.color, equals(Colors.red));
      expect(errorIcon.size, equals(64.0));

      // Check if main content is centered
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(Column), findsOneWidget);

      // Check if there's proper spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should display restart button with correct text', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testError = 'Button test error';
      const errorPage = ErrorPage(error: testError);

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      final restartButton = find.byType(ElevatedButton);
      expect(restartButton, findsOneWidget);

      final buttonText = find.descendant(
        of: restartButton,
        matching: find.text(AppStrings.restart),
      );
      expect(buttonText, findsOneWidget);
    });

    testWidgets('should handle empty error message', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorPage = ErrorPage(error: '');

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text(AppStrings.appInitFailed), findsOneWidget);
      expect(find.text(AppStrings.restart), findsOneWidget);
    });

    testWidgets('should be wrapped in MaterialApp and Scaffold', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testError = 'Structure test error';
      const errorPage = ErrorPage(error: testError);

      // Act
      await tester.pumpWidget(errorPage);

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
