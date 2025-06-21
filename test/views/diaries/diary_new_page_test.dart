import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/constants/app_strings.dart';

import 'package:english_diary_app/views/diaries/diary_new_page.dart';

void main() {
  group('DiaryNewPage Tests', () {
    testWidgets('renders DiaryNewPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );

      // The page should render without throwing errors
      expect(find.byType(DiaryNewPage), findsOneWidget);
    });

    testWidgets('has scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );

      // Should contain a scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );

      // Should contain an app bar
      expect(find.byType(AppBar), findsAtLeastNWidgets(1));
    });

    testWidgets('has text field and floating action button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.text(AppStrings.save), findsOneWidget);
    });

    testWidgets('shows hint text in text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          '今の気持ちや今日の出来事を書いてみよう\nWrite about your feelings or today\'s events\n',
        ),
        findsOneWidget,
      );
    });

    testWidgets('can enter text in text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test diary entry');
      await tester.pump();

      expect(find.text('Test diary entry'), findsOneWidget);
    });
  });

  group('DiaryNewPage 分岐・副作用テスト', () {
    testWidgets('空欄で保存ボタンを押すとSnackBarが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DiaryNewPage(),
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
            home: DiaryNewPage(),
            builder: (context, child) => ScaffoldMessenger(child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pump();

      expect(find.text(AppStrings.aiCorrectionStart), findsOneWidget);
    });

    testWidgets('has proper text field configuration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, isNull);
      expect(textField.minLines, equals(30));
      expect(textField.keyboardType, equals(TextInputType.multiline));
      expect(textField.textInputAction, equals(TextInputAction.newline));
    });

    testWidgets('has scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('has gesture detector for unfocus behavior', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiaryNewPage())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsWidgets);
      final gestureDetectors = tester.widgetList<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetectors.length, greaterThan(0));
    });
  });
}
