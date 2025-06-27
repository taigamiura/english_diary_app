import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/views/diaries/diary_edit_page.dart';
import 'package:kiwi/constants/app_strings.dart';

void main() {
  group('DiaryEditPage Tests', () {
    testWidgets('should display diary edit page', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(AppStrings.save), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should have proper text field configuration', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, isNull);
      expect(textField.minLines, equals(30));
      expect(textField.keyboardType, equals(TextInputType.multiline));
      expect(textField.textInputAction, equals(TextInputAction.newline));
    });

    testWidgets('should show hint text in text field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text(
          '今の気持ちや今日の出来事を書いてみよう\nWrite about your feelings or today\'s events\n',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have scrollable content', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('should have proper app bar configuration', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text(AppStrings.save), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should have floating action button with correct properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.heroTag, equals('aiCorrector'));
    });

    testWidgets('should handle text input', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextField), 'Test diary content');
      await tester.pump();

      // Assert
      expect(find.text('Test diary content'), findsOneWidget);
    });

    testWidgets('should have proper gesture detection', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(GestureDetector), findsWidgets);
      final gestureDetectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetectors.length, greaterThan(0));

      // Find the specific gesture detector that handles the tap behavior
      final mainGestureDetector = gestureDetectors.firstWhere(
        (gd) => gd.behavior == HitTestBehavior.translucent,
        orElse: () => gestureDetectors.first,
      );
      expect(mainGestureDetector.behavior, equals(HitTestBehavior.translucent));
    });

    testWidgets('should have proper scaffold structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DiaryEditPage(diaryId: 'test-diary-id')),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });
  });

  group('DiaryEditPage 分岐・副作用テスト', () {
    testWidgets('空欄で保存ボタンを押すとSnackBarが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DiaryEditPage(diaryId: 'test-diary-id'),
            builder: (context, child) => ScaffoldMessenger(child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.save));
      await tester.pump();
      expect(find.text(AppStrings.contentRequired), findsOneWidget);
    });

    testWidgets('AIコレクターボタン押下でSnackBarが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DiaryEditPage(diaryId: 'test-diary-id'),
            builder: (context, child) => ScaffoldMessenger(child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pump();
      expect(find.text(AppStrings.aiCorrectionStart), findsOneWidget);
    });

    // 保存失敗時のSnackBar表示やNavigator.popのテストは、
    // ProviderのoverrideやNavigatorObserverのモックが必要なため、
    // 実装に応じて追加可能です。
  });
}
