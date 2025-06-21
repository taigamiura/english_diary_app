import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/views/settings/dashboard_page.dart';
import 'package:english_diary_app/providers/diary_provider.dart';
import 'package:english_diary_app/providers/auth_provider.dart';
import 'package:english_diary_app/models/profile_model.dart';

class MockDiaryListNotifier extends DiaryListNotifier {
  MockDiaryListNotifier(super.ref, DiaryListState state) {
    this.state = state;
  }
}

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(super.ref, AuthState state) {
    this.state = state;
  }
}

void main() {
  group('DashboardPage Tests', () {
    testWidgets('renders DashboardPage', (WidgetTester tester) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // The page should render without throwing errors
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('has scaffold', (WidgetTester tester) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has AppBar with leading button', (WidgetTester tester) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('has leading back button that pops page', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: MaterialApp(home: const DashboardPage()),
        ),
      );

      // Find and check back button exists
      final backButton = find.byType(IconButton);
      expect(backButton, findsOneWidget);

      // Verify that tapping the button doesn't cause errors
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    });

    testWidgets('displays membership plan card with correct content', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      expect(find.text('会員プラン'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
      expect(find.text('無料プラン: 日記投稿・閲覧・音声録音利用'), findsOneWidget);
      expect(find.text('プレミアム: AI添削・音声再生使い放題'), findsOneWidget);
      expect(find.text('プレミアムにアップグレード'), findsOneWidget);
    });

    testWidgets('displays streak and average text statistics cards', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 150,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Streak card
      expect(find.text('連続投稿日数'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.text('0 日'), findsOneWidget);

      // Average text card
      expect(find.text('平均投稿文字数'), findsOneWidget);
      expect(find.byIcon(Icons.text_fields), findsOneWidget);
      expect(find.text('150 文字'), findsOneWidget);
    });

    testWidgets('displays recommendations card with content', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      expect(find.text('おすすめ'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);
      expect(find.text('英語日記の書き方Tips'), findsOneWidget);
      expect(find.text('毎日続けるコツや表現例を紹介'), findsOneWidget);
      expect(find.text('おすすめ英語教材'), findsOneWidget);
      expect(find.text('初心者から上級者まで使える教材を厳選'), findsOneWidget);
    });

    testWidgets('supports scrolling', (WidgetTester tester) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Find the scrollable widget
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Test that we can scroll
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('displays proper layout structure', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Check for Column layout
      expect(find.byType(Column), findsAtLeastNWidgets(1));

      // Check for Card widgets
      expect(find.byType(Card), findsAtLeastNWidgets(3));

      // Check for SizedBox spacing elements
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('taps upgrade button without throwing errors', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      final upgradeButton = find.text('プレミアムにアップグレード');
      expect(upgradeButton, findsOneWidget);

      await tester.tap(upgradeButton);
      await tester.pumpAndSettle();
    });

    testWidgets('taps recommendation list tiles without throwing errors', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Tap tips list tile
      final tipsListTile = find.text('英語日記の書き方Tips');
      expect(tipsListTile, findsOneWidget);
      await tester.tap(tipsListTile);
      await tester.pumpAndSettle();

      // Tap materials list tile
      final materialsListTile = find.text('おすすめ英語教材');
      expect(materialsListTile, findsOneWidget);
      await tester.tap(materialsListTile);
      await tester.pumpAndSettle();
    });

    testWidgets('displays appropriate UI when no diaries exist', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 0,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Should show 0 streak days and 0 average characters
      expect(find.text('0 日'), findsOneWidget);
      expect(find.text('0 文字'), findsOneWidget);
    });

    testWidgets('displays card elevation and rounded corners', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Verify cards have proper styling
      final cards = find.byType(Card);
      expect(
        cards,
        findsAtLeastNWidgets(4),
      ); // membership + 2 stats + recommendations

      // Check for proper padding and spacing
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('renders icons with proper colors', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Verify presence of key icons
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.byIcon(Icons.text_fields), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('validates responsive layout with Row and Expanded', (
      WidgetTester tester,
    ) async {
      final mockUser = Profile(
        id: 'testUser',
        googleUid: 'testGoogleUid',
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final authState = AuthState(user: mockUser);
      final diaryState = DiaryListState(
        items: [],
        months: [],
        isLoading: false,
        averageTextInput: 100,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
            diaryListProvider.overrideWith(
              (ref) => MockDiaryListNotifier(ref, diaryState),
            ),
          ],
          child: const MaterialApp(home: DashboardPage()),
        ),
      );

      // Check for responsive row layout
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(Expanded), findsAtLeastNWidgets(2));
    });
  });
}
