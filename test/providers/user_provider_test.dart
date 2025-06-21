import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:english_diary_app/providers/user_provider.dart';
import 'package:english_diary_app/services/user_service.dart';
import 'package:english_diary_app/models/profile_model.dart';

import 'user_provider_test.mocks.dart';

@GenerateMocks([UserService])
void main() {
  group('UserProvider', () {
    late MockUserService mockService;
    late ProviderContainer container;

    setUp(() {
      mockService = MockUserService();
      container = ProviderContainer(
        overrides: [userServiceProvider.overrideWithValue(mockService)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('UserListState', () {
      test('should create default state', () {
        const state = UserListState();
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNull);
      });

      test('should create state with copyWith', () {
        const originalState = UserListState(items: [], isLoading: false);

        final testProfile = Profile(
          id: '1',
          googleUid: 'google123',
          name: 'Test User',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        final newState = originalState.copyWith(
          items: [testProfile],
          isLoading: true,
          error: 'Test error',
        );

        expect(newState.items, [testProfile]);
        expect(newState.isLoading, true);
        expect(newState.error, 'Test error');
      });
    });

    group('UserListNotifier', () {
      test('should fetch users successfully', () async {
        // Arrange
        final expectedUsers = [
          Profile(
            id: '1',
            googleUid: 'google123',
            name: 'Test User 1',
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
          Profile(
            id: '2',
            googleUid: 'google456',
            name: 'Test User 2',
            createdAt: DateTime(2024, 1, 16),
            updatedAt: DateTime(2024, 1, 16),
          ),
        ];

        when(mockService.fetchUsers()).thenAnswer((_) async => expectedUsers);

        final notifier = container.read(userListProvider.notifier);

        // Act
        await notifier.fetchUsers();

        // Assert
        final state = container.read(userListProvider);
        expect(state.items, equals(expectedUsers));
        expect(state.isLoading, false);
        expect(state.error, isNull);
        verify(mockService.fetchUsers()).called(1);
      });

      test('should handle fetch users error', () async {
        // Arrange
        when(mockService.fetchUsers()).thenThrow(Exception('Network error'));

        final notifier = container.read(userListProvider.notifier);

        // Act
        await notifier.fetchUsers();

        // Assert
        final state = container.read(userListProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, contains('ネットワークに接続できません'));
        verify(mockService.fetchUsers()).called(1);
      });

      test('should set loading state during fetch', () async {
        // Arrange
        when(mockService.fetchUsers()).thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 100));
          return [];
        });

        final notifier = container.read(userListProvider.notifier);

        // Act & Assert
        final fetchFuture = notifier.fetchUsers();

        // Check loading state immediately after calling fetch
        expect(container.read(userListProvider).isLoading, true);

        await fetchFuture;

        // Check final state
        expect(container.read(userListProvider).isLoading, false);
      });
    });
  });
}
