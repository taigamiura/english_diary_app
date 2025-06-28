import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kiwi/providers/ai_correction_provider.dart';
import 'package:kiwi/services/ai_correction_service.dart';
import 'package:kiwi/models/ai_correction_model.dart';

import 'ai_correction_provider_test.mocks.dart';

@GenerateMocks([AiCorrectionService])
void main() {
  group('AiCorrectionProvider', () {
    late MockAiCorrectionService mockService;
    late ProviderContainer container;

    setUp(() {
      mockService = MockAiCorrectionService();
      container = ProviderContainer(
        overrides: [aiCorrectionServiceProvider.overrideWithValue(mockService)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('AiCorrectionListState', () {
      test('should create default state', () {
        const state = AiCorrectionListState();
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNull);
      });

      test('should create state with copyWith', () {
        const originalState = AiCorrectionListState(
          items: [],
          isLoading: false,
        );

        final testCorrection = AiCorrection(
          id: '1',
          diaryEntryId: 'diary1',
          originalText: 'Hello world',
          correctedText: 'Hello, world!',
          suggestionType: 'grammar',
          explanation: 'Added comma',
          createdAt: DateTime(2024, 1, 15),
        );

        final newState = originalState.copyWith(
          items: [testCorrection],
          isLoading: true,
          error: 'Test error',
        );

        expect(newState.items, [testCorrection]);
        expect(newState.isLoading, true);
        expect(newState.error, 'Test error');
      });
    });

    group('AiCorrectionListNotifier', () {
      test('should fetch ai corrections successfully', () async {
        // Arrange
        const diaryEntryId = 'diary1';
        final expectedCorrections = [
          AiCorrection(
            id: '1',
            diaryEntryId: diaryEntryId,
            originalText: 'Hello world',
            correctedText: 'Hello, world!',
            suggestionType: 'grammar',
            explanation: 'Added comma',
            createdAt: DateTime(2024, 1, 15),
          ),
          AiCorrection(
            id: '2',
            diaryEntryId: diaryEntryId,
            originalText: 'I are happy',
            correctedText: 'I am happy',
            suggestionType: 'grammar',
            explanation: 'Subject-verb agreement',
            createdAt: DateTime(2024, 1, 15),
          ),
        ];

        when(
          mockService.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).thenAnswer((_) async => expectedCorrections);

        final notifier = container.read(aiCorrectionListProvider.notifier);

        // Act
        await notifier.fetchAiCorrections(diaryEntryId: diaryEntryId);

        // Assert
        final state = container.read(aiCorrectionListProvider);
        expect(state.items, equals(expectedCorrections));
        expect(state.isLoading, false);
        expect(state.error, isNull);
        verify(
          mockService.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).called(1);
      });

      test('should handle fetch error', () async {
        // Arrange
        const diaryEntryId = 'diary1';
        when(
          mockService.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).thenThrow(Exception('API error'));

        final notifier = container.read(aiCorrectionListProvider.notifier);

        // Act
        await notifier.fetchAiCorrections(diaryEntryId: diaryEntryId);

        // Assert
        final state = container.read(aiCorrectionListProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, contains('API error'));
        verify(
          mockService.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).called(1);
      });

      test('should handle empty corrections list', () async {
        // Arrange
        const diaryEntryId = 'diary1';
        when(
          mockService.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).thenAnswer((_) async => []);

        final notifier = container.read(aiCorrectionListProvider.notifier);

        // Act
        await notifier.fetchAiCorrections(diaryEntryId: diaryEntryId);

        // Assert
        final state = container.read(aiCorrectionListProvider);
        expect(state.items, isEmpty);
        expect(state.isLoading, false);
        expect(state.error, isNull);
        verify(
          mockService.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).called(1);
      });

      group('CRUD Operations', () {
        test('should add ai correction successfully', () async {
          // Arrange
          final newCorrection = AiCorrection(
            id: '3',
            diaryEntryId: 'diary1',
            originalText: 'New text',
            correctedText: 'Corrected text',
            suggestionType: 'grammar',
            explanation: 'Grammar fix',
            createdAt: DateTime(2024, 1, 15),
          );

          when(
            mockService.insertAiCorrection(newCorrection),
          ).thenAnswer((_) async {});

          final notifier = container.read(aiCorrectionListProvider.notifier);

          // Act
          await notifier.addAiCorrection(newCorrection);

          // Assert
          final state = container.read(aiCorrectionListProvider);
          expect(state.items, contains(newCorrection));
          expect(state.isLoading, false);
          expect(state.error, isNull);
          verify(mockService.insertAiCorrection(newCorrection)).called(1);
        });

        test('should handle add ai correction error', () async {
          // Arrange
          final newCorrection = AiCorrection(
            id: '3',
            diaryEntryId: 'diary1',
            originalText: 'New text',
            correctedText: 'Corrected text',
            suggestionType: 'grammar',
            explanation: 'Grammar fix',
            createdAt: DateTime(2024, 1, 15),
          );

          when(
            mockService.insertAiCorrection(newCorrection),
          ).thenThrow(Exception('Insert error'));

          final notifier = container.read(aiCorrectionListProvider.notifier);

          // Act
          await notifier.addAiCorrection(newCorrection);

          // Assert
          final state = container.read(aiCorrectionListProvider);
          expect(state.items, isNot(contains(newCorrection)));
          expect(state.isLoading, false);
          expect(state.error, contains('Insert error'));
        });

        test('should update ai correction successfully', () async {
          // Arrange
          final originalCorrection = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Original text',
            correctedText: 'Corrected text',
            suggestionType: 'grammar',
            explanation: 'Original explanation',
            createdAt: DateTime(2024, 1, 15),
          );

          final updatedCorrection = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Original text',
            correctedText: 'Better corrected text',
            suggestionType: 'grammar',
            explanation: 'Updated explanation',
            createdAt: DateTime(2024, 1, 15),
          );

          when(
            mockService.updateAiCorrection('1', updatedCorrection),
          ).thenAnswer((_) async {});

          final notifier = container.read(aiCorrectionListProvider.notifier);
          // Set initial state with original correction
          notifier.state = notifier.state.copyWith(items: [originalCorrection]);

          // Act
          await notifier.updateAiCorrection(updatedCorrection);

          // Assert
          final state = container.read(aiCorrectionListProvider);
          expect(state.items, contains(updatedCorrection));
          expect(state.items, isNot(contains(originalCorrection)));
          expect(state.isLoading, false);
          expect(state.error, isNull);
          verify(
            mockService.updateAiCorrection('1', updatedCorrection),
          ).called(1);
        });

        test('should handle update ai correction error', () async {
          // Arrange
          final originalCorrection = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Original text',
            correctedText: 'Corrected text',
            suggestionType: 'grammar',
            explanation: 'Original explanation',
            createdAt: DateTime(2024, 1, 15),
          );

          final updatedCorrection = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Original text',
            correctedText: 'Better corrected text',
            suggestionType: 'grammar',
            explanation: 'Updated explanation',
            createdAt: DateTime(2024, 1, 15),
          );

          when(
            mockService.updateAiCorrection('1', updatedCorrection),
          ).thenThrow(Exception('Update error'));

          final notifier = container.read(aiCorrectionListProvider.notifier);
          // Set initial state with original correction
          notifier.state = notifier.state.copyWith(items: [originalCorrection]);

          // Act
          await notifier.updateAiCorrection(updatedCorrection);

          // Assert
          final state = container.read(aiCorrectionListProvider);
          expect(state.items, contains(originalCorrection));
          expect(state.isLoading, false);
          expect(state.error, contains('Update error'));
        });

        test('should remove ai correction successfully', () async {
          // Arrange
          final correction1 = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Text 1',
            correctedText: 'Corrected 1',
            suggestionType: 'grammar',
            explanation: 'Explanation 1',
            createdAt: DateTime(2024, 1, 15),
          );

          final correction2 = AiCorrection(
            id: '2',
            diaryEntryId: 'diary1',
            originalText: 'Text 2',
            correctedText: 'Corrected 2',
            suggestionType: 'grammar',
            explanation: 'Explanation 2',
            createdAt: DateTime(2024, 1, 15),
          );

          when(mockService.deleteAiCorrection('1')).thenAnswer((_) async {});

          final notifier = container.read(aiCorrectionListProvider.notifier);
          // Set initial state with both corrections
          notifier.state = notifier.state.copyWith(
            items: [correction1, correction2],
          );

          // Act
          await notifier.removeAiCorrection('1');

          // Assert
          final state = container.read(aiCorrectionListProvider);
          expect(state.items, isNot(contains(correction1)));
          expect(state.items, contains(correction2));
          expect(state.isLoading, false);
          expect(state.error, isNull);
          verify(mockService.deleteAiCorrection('1')).called(1);
        });

        test('should handle remove ai correction error', () async {
          // Arrange
          final correction = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Text',
            correctedText: 'Corrected',
            suggestionType: 'grammar',
            explanation: 'Explanation',
            createdAt: DateTime(2024, 1, 15),
          );

          when(
            mockService.deleteAiCorrection('1'),
          ).thenThrow(Exception('Delete error'));

          final notifier = container.read(aiCorrectionListProvider.notifier);
          // Set initial state with correction
          notifier.state = notifier.state.copyWith(items: [correction]);

          // Act
          await notifier.removeAiCorrection('1');

          // Assert
          final state = container.read(aiCorrectionListProvider);
          expect(state.items, contains(correction));
          expect(state.isLoading, false);
          expect(state.error, contains('Delete error'));
        });
      });

      group('State Management', () {
        test('should handle copyWith with null error', () {
          const originalState = AiCorrectionListState(error: 'Some error');

          // copyWithメソッドは現在、nullの場合は元の値を保持する仕様
          final newState = originalState.copyWith();

          expect(newState.error, equals('Some error')); // 元の値が保持される
        });

        test('should preserve state when copyWith called with null values', () {
          final correction = AiCorrection(
            id: '1',
            diaryEntryId: 'diary1',
            originalText: 'Text',
            correctedText: 'Corrected',
            suggestionType: 'grammar',
            explanation: 'Explanation',
            createdAt: DateTime(2024, 1, 15),
          );

          final originalState = AiCorrectionListState(
            items: [correction],
            isLoading: true,
            error: 'Error',
          );

          final newState = originalState.copyWith();

          expect(newState.items, equals(originalState.items));
          expect(newState.isLoading, equals(originalState.isLoading));
          expect(newState.error, equals(originalState.error));
        });

        test('should handle provider disposal', () {
          // Test that provider can be disposed without issues
          final localContainer = ProviderContainer(
            overrides: [
              aiCorrectionServiceProvider.overrideWithValue(mockService),
            ],
          );

          final notifier = localContainer.read(
            aiCorrectionListProvider.notifier,
          );
          expect(notifier.state.items, isEmpty);

          localContainer.dispose(); // Should complete without error
        });
      });
    });

    group('Provider Integration', () {
      test(
        'should provide ai correction repository',
        () {},
        skip: 'Requires Supabase initialization',
      );

      test('should provide ai correction service', () {
        final service = container.read(aiCorrectionServiceProvider);
        expect(service, isNotNull);
      });
    });
  });
}
