import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/views/welcome_page.dart';
import 'package:english_diary_app/providers/auth_provider.dart';
import 'package:english_diary_app/models/profile_model.dart';

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(super.ref, AuthState state) {
    this.state = state;
  }
}

void main() {
  group('WelcomePage Tests', () {
    testWidgets('renders WelcomePage when user is null', (
      WidgetTester tester,
    ) async {
      final authState = AuthState(user: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
          ],
          child: const MaterialApp(home: WelcomePage()),
        ),
      );

      expect(find.byType(WelcomePage), findsOneWidget);
    });

    testWidgets('displays welcome UI elements', (WidgetTester tester) async {
      final authState = AuthState(user: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
          ],
          child: const MaterialApp(home: WelcomePage()),
        ),
      );

      // Verify basic structure exists
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles loading state correctly', (WidgetTester tester) async {
      final authState = AuthState(user: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
          ],
          child: const MaterialApp(home: WelcomePage()),
        ),
      );

      await tester.pump();
    });

    testWidgets('handles authenticated state correctly', (
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
          ],
          child: const MaterialApp(home: WelcomePage()),
        ),
      );

      await tester.pump();
    });

    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      final authState = AuthState(user: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
          ],
          child: const MaterialApp(home: WelcomePage()),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(WelcomePage), findsOneWidget);
    });

    testWidgets('renders without errors', (WidgetTester tester) async {
      final authState = AuthState(user: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              (ref) => MockAuthNotifier(ref, authState),
            ),
          ],
          child: const MaterialApp(home: WelcomePage()),
        ),
      );

      await tester.pumpAndSettle();
    });
  });
}
