import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:english_diary_app/providers/diary_provider.dart';
import 'package:english_diary_app/providers/auth_provider.dart';
import 'package:english_diary_app/services/diary_service.dart';
import 'package:english_diary_app/models/diary_model.dart';
import 'package:english_diary_app/models/year_month.dart';
import 'package:english_diary_app/models/profile_model.dart';

import '../mocks/mock_annotations.mocks.dart';

@GenerateMocks([DiaryService])
void main() {
  group('DiaryProvider', () {
    late MockDiaryService mockService;
    late ProviderContainer container;
    late Profile testUser;

    setUp(() {
      mockService = MockDiaryService();
      testUser = Profile(
        id: 'user123',
        googleUid: 'google123',
        name: 'Test User',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      container = ProviderContainer(
        overrides: [diaryServiceProvider.overrideWithValue(mockService)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('DiaryListState', () {
      test('should create default state', () {
        const state = DiaryListState();
        expect(state.items, isEmpty);
        expect(state.months, isEmpty);
        expect(state.averageTextInput, 0);
        expect(state.isLoading, false);
        expect(state.hasTodayDiary, false);
        expect(state.error, isNull);
      });

      test('should create state with copyWith', () {
        const originalState = DiaryListState(items: [], isLoading: false);

        final newState = originalState.copyWith(
          isLoading: true,
          error: 'Test error',
        );

        expect(newState.isLoading, true);
        expect(newState.error, 'Test error');
        expect(newState.items, originalState.items);
      });

      test('should handle copyWith with null error', () {
        const originalState = DiaryListState(error: 'Previous error');
        final newState = originalState.copyWith(error: null);
        expect(newState.error, isNull);
      });

      test('should handle copyWith with all parameters', () {
        const originalState = DiaryListState();
        final testDiaries = [
          Diary(
            id: '1',
            userId: 'user1',
            textInput: 'Test diary',
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
        ];
        final testMonths = [YearMonth(2024, 1)];

        final newState = originalState.copyWith(
          items: testDiaries,
          months: testMonths,
          averageTextInput: 100,
          isLoading: true,
          hasTodayDiary: true,
          error: 'Test error',
        );

        expect(newState.items, testDiaries);
        expect(newState.months, testMonths);
        expect(newState.averageTextInput, 100);
        expect(newState.isLoading, true);
        expect(newState.hasTodayDiary, true);
        expect(newState.error, 'Test error');
      });
    });

    group('DiaryListNotifier', () {
      test('fetchDiaries should fetch diaries successfully', () async {
        // Arrange
        final expectedDiaries = [
          Diary(
            id: '1',
            userId: 'user123',
            textInput: 'Test diary entry',
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
        ];

        when(
          mockService.fetchDiaries(
            userId: anyNamed('userId'),
            from: anyNamed('from'),
            to: anyNamed('to'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => expectedDiaries);

        // Act
        final notifier = container.read(diaryListProvider.notifier);
        await notifier.fetchDiaries(
          userId: 'user123',
          from: DateTime(2024, 1, 1),
          to: DateTime(2024, 1, 31),
          limit: 30,
        );

        // Assert
        final state = container.read(diaryListProvider);
        expect(state.items, expectedDiaries);
        expect(state.isLoading, false);
        expect(state.error, isNull);

        verify(
          mockService.fetchDiaries(
            userId: 'user123',
            from: DateTime(2024, 1, 1),
            to: DateTime(2024, 1, 31),
            limit: 30,
          ),
        ).called(1);
      });

      test('fetchDiaries should handle errors', () async {
        // Arrange
        when(
          mockService.fetchDiaries(
            userId: anyNamed('userId'),
            from: anyNamed('from'),
            to: anyNamed('to'),
            limit: anyNamed('limit'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act
        final notifier = container.read(diaryListProvider.notifier);
        await notifier.fetchDiaries(
          userId: 'user123',
          from: DateTime(2024, 1, 1),
          to: DateTime(2024, 1, 31),
          limit: 30,
        );

        // Assert
        final state = container.read(diaryListProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNotNull);
      });

      group('fetchDiaries edge cases', () {
        test('should handle default date parameters', () async {
          // Arrange
          when(
            mockService.fetchDiaries(
              userId: anyNamed('userId'),
              from: anyNamed('from'),
              to: anyNamed('to'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => []);

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchDiaries(userId: 'user123', limit: 30); // Assert
          verify(
            mockService.fetchDiaries(
              userId: 'user123',
              from: DateTime(2000, 1, 1),
              to: anyNamed('to'),
              limit: 30,
            ),
          ).called(1);
        });

        test('should handle errors gracefully', () async {
          // Arrange
          when(
            mockService.fetchDiaries(
              userId: anyNamed('userId'),
              from: anyNamed('from'),
              to: anyNamed('to'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(Exception('Network error'));

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchDiaries(
            userId: 'user123',
            from: DateTime(2024, 1, 1),
            to: DateTime(2024, 1, 31),
            limit: 30,
          );

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.error, isNotNull);
          expect(state.isLoading, false);
        });
      });

      group('fetchDateDiary', () {
        test('should fetch today diary successfully', () async {
          // Arrange
          final expectedDiary = [
            Diary(
              id: '1',
              userId: 'user123',
              textInput: 'Today diary',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ];

          when(
            mockService.fetchDiaries(
              userId: anyNamed('userId'),
              from: anyNamed('from'),
              to: anyNamed('to'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => expectedDiary);

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchDateDiary(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.items, expectedDiary);
          expect(state.hasTodayDiary, true);
          expect(state.isLoading, false);
          expect(state.error, isNull);
        });

        test('should handle no diary found for today', () async {
          // Arrange
          when(
            mockService.fetchDiaries(
              userId: anyNamed('userId'),
              from: anyNamed('from'),
              to: anyNamed('to'),
              limit: anyNamed('limit'),
            ),
          ).thenAnswer((_) async => []);

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchDateDiary(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.items, isEmpty);
          expect(state.hasTodayDiary, false);
          expect(state.isLoading, false);
          expect(state.error, isNull);
        });

        test('should handle errors gracefully', () async {
          // Arrange
          when(
            mockService.fetchDiaries(
              userId: anyNamed('userId'),
              from: anyNamed('from'),
              to: anyNamed('to'),
              limit: anyNamed('limit'),
            ),
          ).thenThrow(Exception('Network error'));

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchDateDiary(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.error, isNotNull);
          expect(state.isLoading, false);
        });
      });

      group('fetchPostedMonths', () {
        test('should fetch and sort months', () async {
          // Arrange
          final testMonths = [
            YearMonth(2024, 3),
            YearMonth(2024, 1),
            YearMonth(2024, 2),
            YearMonth(2024, 1), // Duplicate
          ];

          when(
            mockService.fetchPostedMonths(userId: anyNamed('userId')),
          ).thenAnswer((_) async => testMonths);

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchPostedMonths(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.months.length, 3); // Should remove duplicates
          expect(state.months[0], YearMonth(2024, 3)); // Should be sorted desc
          expect(state.months[1], YearMonth(2024, 2));
          expect(state.months[2], YearMonth(2024, 1));
          expect(state.isLoading, false);
          expect(state.error, isNull);
        });

        test('should handle errors gracefully', () async {
          // Arrange
          when(
            mockService.fetchPostedMonths(userId: anyNamed('userId')),
          ).thenThrow(Exception('Network error'));

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchPostedMonths(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.error, isNotNull);
          expect(state.isLoading, false);
        });
      });

      group('fetchAverageTextInput', () {
        test('should fetch average successfully', () async {
          // Arrange
          when(
            mockService.fetchAverageTextInput(userId: anyNamed('userId')),
          ).thenAnswer((_) async => 150);

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchAverageTextInput(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.averageTextInput, 150);
          expect(state.isLoading, false);
          expect(state.error, isNull);
        });

        test('should handle errors gracefully', () async {
          // Arrange
          when(
            mockService.fetchAverageTextInput(userId: anyNamed('userId')),
          ).thenThrow(Exception('Network error'));

          // Act
          final notifier = container.read(diaryListProvider.notifier);
          await notifier.fetchAverageTextInput(userId: 'user123');

          // Assert
          final state = container.read(diaryListProvider);
          expect(state.error, isNotNull);
          expect(state.isLoading, false);
        });
      });
    });

    group('DiaryListNotifier - CRUD Operations', () {
      late ProviderContainer containerWithAuth;

      setUp(() {
        containerWithAuth = ProviderContainer(
          overrides: [
            diaryServiceProvider.overrideWithValue(mockService),
            authStateProvider.overrideWith((ref) {
              return AuthNotifier(ref);
            }),
          ],
        );

        // Set up auth state manually
        containerWithAuth.read(authStateProvider.notifier).state = AuthState(
          user: testUser,
        );
      });

      tearDown(() {
        containerWithAuth.dispose();
      });

      test('addDiaryFromInput should add diary successfully', () async {
        // Arrange
        when(mockService.insertDiary(any)).thenAnswer((_) async {});

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.addDiaryFromInput(
          textInput: 'New diary entry',
          voiceInputUrl: 'https://example.com/audio.mp3',
          transcription: 'Audio transcription',
        );

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items.length, 1);
        expect(state.items[0].textInput, 'New diary entry');
        expect(state.items[0].voiceInputUrl, 'https://example.com/audio.mp3');
        expect(state.items[0].transcription, 'Audio transcription');
        expect(state.items[0].userId, 'user123');
        expect(state.isLoading, false);
        expect(state.error, isNull);

        verify(mockService.insertDiary(any)).called(1);
      });

      test('addDiaryFromInput should handle missing user', () async {
        // Arrange
        containerWithAuth
            .read(authStateProvider.notifier)
            .state = const AuthState(user: null);

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.addDiaryFromInput(textInput: 'New diary entry');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, contains('ユーザー情報が取得できません'));

        verifyNever(mockService.insertDiary(any));
      });

      test('addDiaryFromInput should handle service errors', () async {
        // Arrange
        when(
          mockService.insertDiary(any),
        ).thenThrow(Exception('Database error'));

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.addDiaryFromInput(textInput: 'New diary entry');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNotNull);
      });

      test('addDiaryFromInput should use provided dates', () async {
        // Arrange
        when(mockService.insertDiary(any)).thenAnswer((_) async {});
        final customCreatedAt = DateTime(2024, 1, 15, 10, 30);
        final customUpdatedAt = DateTime(2024, 1, 15, 11, 30);

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.addDiaryFromInput(
          textInput: 'New diary entry',
          createdAt: customCreatedAt,
          updatedAt: customUpdatedAt,
        );

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items[0].createdAt, customCreatedAt);
        expect(state.items[0].updatedAt, customUpdatedAt);
      });

      test('updateDiary should update existing diary successfully', () async {
        // Arrange
        final existingDiary = Diary(
          id: '1',
          userId: 'user123',
          textInput: 'Original text',
          voiceInputUrl: 'original-audio.mp3',
          transcription: 'Original transcription',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        containerWithAuth
            .read(diaryListProvider.notifier)
            .state = containerWithAuth
            .read(diaryListProvider)
            .copyWith(items: [existingDiary]);

        when(mockService.updateDiary(any, any)).thenAnswer((_) async {});

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.updateDiary(
          id: '1',
          textInput: 'Updated text',
          voiceInputUrl: 'updated-audio.mp3',
          transcription: 'Updated transcription',
        );

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items.length, 1);
        expect(state.items[0].textInput, 'Updated text');
        expect(state.items[0].voiceInputUrl, 'updated-audio.mp3');
        expect(state.items[0].transcription, 'Updated transcription');
        expect(
          state.items[0].createdAt,
          existingDiary.createdAt,
        ); // Should preserve
        expect(state.isLoading, false);
        expect(state.error, isNull);

        verify(mockService.updateDiary('1', any)).called(1);
      });

      test('updateDiary should handle missing user', () async {
        // Arrange
        containerWithAuth
            .read(authStateProvider.notifier)
            .state = const AuthState(user: null);

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.updateDiary(id: '1', textInput: 'Updated text');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.isLoading, false);
        expect(state.error, contains('ユーザー情報が取得できません'));

        verifyNever(mockService.updateDiary(any, any));
      });

      test('updateDiary should handle diary not found', () async {
        // Arrange - Empty diary list
        containerWithAuth.read(diaryListProvider.notifier).state =
            containerWithAuth.read(diaryListProvider).copyWith(items: []);

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.updateDiary(id: '999', textInput: 'Updated text');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.isLoading, false);
        expect(state.error, contains('該当の日記が見つかりません'));

        verifyNever(mockService.updateDiary(any, any));
      });

      test('updateDiary should handle service errors', () async {
        // Arrange
        final existingDiary = Diary(
          id: '1',
          userId: 'user123',
          textInput: 'Original text',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        containerWithAuth
            .read(diaryListProvider.notifier)
            .state = containerWithAuth
            .read(diaryListProvider)
            .copyWith(items: [existingDiary]);

        when(
          mockService.updateDiary(any, any),
        ).thenThrow(Exception('Database error'));

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.updateDiary(id: '1', textInput: 'Updated text');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.isLoading, false);
        expect(state.error, isNotNull);
      });

      test(
        'updateDiary should preserve original fields when not provided',
        () async {
          // Arrange
          final existingDiary = Diary(
            id: '1',
            userId: 'user123',
            textInput: 'Original text',
            voiceInputUrl: 'original-audio.mp3',
            transcription: 'Original transcription',
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          );

          containerWithAuth
              .read(diaryListProvider.notifier)
              .state = containerWithAuth
              .read(diaryListProvider)
              .copyWith(items: [existingDiary]);

          when(mockService.updateDiary(any, any)).thenAnswer((_) async {});

          // Act - Only update textInput
          final notifier = containerWithAuth.read(diaryListProvider.notifier);
          await notifier.updateDiary(id: '1', textInput: 'Updated text');

          // Assert
          final state = containerWithAuth.read(diaryListProvider);
          expect(state.items[0].textInput, 'Updated text');
          expect(
            state.items[0].voiceInputUrl,
            'original-audio.mp3',
          ); // Preserved
          expect(
            state.items[0].transcription,
            'Original transcription',
          ); // Preserved
        },
      );

      test('removeDiary should remove diary successfully', () async {
        // Arrange
        final existingDiaries = [
          Diary(
            id: '1',
            userId: 'user123',
            textInput: 'Diary 1',
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
          Diary(
            id: '2',
            userId: 'user123',
            textInput: 'Diary 2',
            createdAt: DateTime(2024, 1, 16),
            updatedAt: DateTime(2024, 1, 16),
          ),
        ];

        containerWithAuth
            .read(diaryListProvider.notifier)
            .state = containerWithAuth
            .read(diaryListProvider)
            .copyWith(items: existingDiaries);

        when(mockService.deleteDiary(any)).thenAnswer((_) async {});

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.removeDiary('1');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items.length, 1);
        expect(state.items[0].id, '2');
        expect(state.isLoading, false);
        expect(state.error, isNull);

        verify(mockService.deleteDiary('1')).called(1);
      });

      test('removeDiary should handle service errors', () async {
        // Arrange
        final existingDiary = Diary(
          id: '1',
          userId: 'user123',
          textInput: 'Diary 1',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        containerWithAuth
            .read(diaryListProvider.notifier)
            .state = containerWithAuth
            .read(diaryListProvider)
            .copyWith(items: [existingDiary]);

        when(
          mockService.deleteDiary(any),
        ).thenThrow(Exception('Database error'));

        // Act
        final notifier = containerWithAuth.read(diaryListProvider.notifier);
        await notifier.removeDiary('1');

        // Assert
        final state = containerWithAuth.read(diaryListProvider);
        expect(state.items.length, 1); // Should remain unchanged
        expect(state.isLoading, false);
        expect(state.error, isNotNull);
      });
    });
  });
}
