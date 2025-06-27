import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiwi/views/diaries/diary_id_page.dart';
import 'package:kiwi/models/diary_model.dart';
import 'package:kiwi/providers/diary_provider.dart';
import 'package:kiwi/providers/auth_provider.dart';
import 'package:kiwi/models/profile_model.dart';

// Mock notifier for testing
class MockDiaryListNotifier extends DiaryListNotifier {
  MockDiaryListNotifier(super.ref, DiaryListState state) {
    this.state = state;
  }
}

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(Ref ref, AuthState state) : super(ref) {
    this.state = state;
  }
}

void main() {
  // Create a mock user for tests
  final mockUser = Profile(
    id: 'user1',
    googleUid: 'google123',
    name: 'Test User',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  group('DiaryIdPage Tests', () {
    testWidgets('renders DiaryIdPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: 'test-id')),
        ),
      );

      // The page should render without throwing errors
      expect(find.byType(DiaryIdPage), findsOneWidget);
    });

    testWidgets('has app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: 'test-id')),
        ),
      );

      // Should contain an app bar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: 'test-id')),
        ),
      );

      // Should contain a scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display "日記が見つかりません" when diary does not exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) =>
                  MockDiaryListNotifier(ref, const DiaryListState(items: [])),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(
            home: DiaryIdPage(diaryId: 'non-existent-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 基本的なScaffold構造が存在する
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('日記が見つかりません'), findsOneWidget);
    });

    testWidgets('should display diary content when diary exists', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Test diary content',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 日記コンテンツが表示される
      expect(find.text('Test diary content'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display edit button in app bar when diary exists', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Test diary content',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 編集ボタンが表示される
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should display formatted date in app bar when diary exists', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Test diary content',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 日付がアプリバーに表示される
      expect(find.text('2024年1月15日'), findsOneWidget);
    });

    testWidgets('should handle multiple diaries correctly', (
      WidgetTester tester,
    ) async {
      final diaries = [
        Diary(
          id: '1',
          userId: 'user1',
          textInput: 'First diary',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        ),
        Diary(
          id: '2',
          userId: 'user1',
          textInput: 'Second diary',
          createdAt: DateTime(2024, 1, 16),
          updatedAt: DateTime(2024, 1, 16),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) =>
                  MockDiaryListNotifier(ref, DiaryListState(items: diaries)),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '2')),
        ),
      );

      await tester.pumpAndSettle();

      // 正しい日記（ID=2）のコンテンツが表示される
      expect(find.text('Second diary'), findsOneWidget);
      expect(find.text('First diary'), findsNothing);
    });

    testWidgets('should display diary with different date formats', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Diary with date',
        createdAt: DateTime(2024, 12, 25, 15, 30),
        updatedAt: DateTime(2024, 12, 25, 15, 30),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Diary with date'), findsOneWidget);
      expect(find.text('2024年12月25日'), findsOneWidget);
    });

    testWidgets('should handle empty text input', (WidgetTester tester) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: '',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 空のコンテンツでもページは正常に表示される
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle very long text input', (
      WidgetTester tester,
    ) async {
      final longText = 'This is a very long diary entry. ' * 100;
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: longText,
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 長いテキストでもページは正常に表示される
      expect(find.byType(Scaffold), findsOneWidget);
      expect(
        find.textContaining('This is a very long diary entry.'),
        findsOneWidget,
      );
    });

    testWidgets('should display diary with special characters', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Diary with special chars: @#\$%^&*()_+-=[]{}|;:,.<>?',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 特殊文字を含むテキストが正常に表示される
      expect(find.textContaining('special chars'), findsOneWidget);
    });

    testWidgets('should display diary with unicode characters', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: '今日は良い天気です。🌞 日記を書いています。',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 日本語とUnicode文字が正常に表示される
      expect(find.text('今日は良い天気です。🌞 日記を書いています。'), findsOneWidget);
    });

    testWidgets('should handle edge case with very old dates', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Old diary entry',
        createdAt: DateTime(1900, 1, 1),
        updatedAt: DateTime(1900, 1, 1),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Old diary entry'), findsOneWidget);
      expect(find.text('1900年1月1日'), findsOneWidget);
    });

    testWidgets('should handle edge case with future dates', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'user1',
        textInput: 'Future diary entry',
        createdAt: DateTime(2100, 12, 31),
        updatedAt: DateTime(2100, 12, 31),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ),
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Future diary entry'), findsOneWidget);
      expect(find.text('2100年12月31日'), findsOneWidget);
    });

    testWidgets('should handle different user IDs correctly', (
      WidgetTester tester,
    ) async {
      final testDiary = Diary(
        id: '1',
        userId: 'different-user',
        textInput: 'Different user diary',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 1, 15),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(
                ref,
                DiaryListState(items: [testDiary]),
              ),
            ),
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, AuthState(user: mockUser)),
            ), // user1
          ],
          child: const MaterialApp(home: DiaryIdPage(diaryId: '1')),
        ),
      );

      await tester.pumpAndSettle();

      // 異なるユーザーの日記は表示されない
      expect(find.text('日記が見つかりません'), findsOneWidget);
    });
  });
}
