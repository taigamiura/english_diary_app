import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:kiwi/providers/diary_feedback_provider.dart';
import 'package:kiwi/services/diary_feedback_service.dart';
import 'package:kiwi/models/diary_feedback_model.dart';

// Mock classes manually defined
class MockDiaryFeedbackService extends Mock implements DiaryFeedbackService {
  @override
  Future<List<DiaryFeedback>> fetchDiaryFeedbacks({
    required String diaryEntryId,
  }) {
    return super.noSuchMethod(
      Invocation.method(#fetchDiaryFeedbacks, [], {
        #diaryEntryId: diaryEntryId,
      }),
      returnValue: Future<List<DiaryFeedback>>.value([]),
    );
  }

  @override
  Future<DiaryFeedback?> fetchDiaryFeedback(String id) {
    return super.noSuchMethod(
      Invocation.method(#fetchDiaryFeedback, [id]),
      returnValue: Future<DiaryFeedback?>.value(null),
    );
  }

  @override
  Future<void> insertDiaryFeedback(DiaryFeedback feedback) {
    return super.noSuchMethod(
      Invocation.method(#insertDiaryFeedback, [feedback]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> updateDiaryFeedback(String id, DiaryFeedback feedback) {
    return super.noSuchMethod(
      Invocation.method(#updateDiaryFeedback, [id, feedback]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> deleteDiaryFeedback(String id) {
    return super.noSuchMethod(
      Invocation.method(#deleteDiaryFeedback, [id]),
      returnValue: Future<void>.value(),
    );
  }
}

void main() {
  group('DiaryFeedbackProvider Tests', () {
    late ProviderContainer container;
    late MockDiaryFeedbackService mockDiaryFeedbackService;

    setUp(() {
      mockDiaryFeedbackService = MockDiaryFeedbackService();
      container = ProviderContainer(
        overrides: [
          diaryFeedbackServiceProvider.overrideWithValue(
            mockDiaryFeedbackService,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('DiaryFeedbackListState initial state', () {
      const state = DiaryFeedbackListState();
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('DiaryFeedbackListState copyWith', () {
      const state = DiaryFeedbackListState();
      final feedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction-1',
        userId: 'user-1',
        action: ActionType.accepted,
        createdAt: DateTime(2024, 1, 1),
      );

      final newState = state.copyWith(
        items: [feedback],
        isLoading: true,
        error: 'test error',
      );

      expect(newState.items, [feedback]);
      expect(newState.isLoading, true);
      expect(newState.error, 'test error');
    });

    test('fetchDiaryFeedbacks success', () async {
      final feedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction-1',
        userId: 'user-1',
        action: ActionType.accepted,
        createdAt: DateTime(2024, 1, 1),
      );

      when(
        mockDiaryFeedbackService.fetchDiaryFeedbacks(diaryEntryId: 'diary-1'),
      ).thenAnswer((_) async => [feedback]);

      final notifier = container.read(diaryFeedbackListProvider.notifier);
      await notifier.fetchDiaryFeedbacks(diaryEntryId: 'diary-1');

      final state = container.read(diaryFeedbackListProvider);
      expect(state.items, [feedback]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(
        mockDiaryFeedbackService.fetchDiaryFeedbacks(diaryEntryId: 'diary-1'),
      ).called(1);
    });

    test('fetchDiaryFeedbacks failure', () async {
      when(
        mockDiaryFeedbackService.fetchDiaryFeedbacks(diaryEntryId: 'diary-1'),
      ).thenThrow(Exception('Network error'));

      final notifier = container.read(diaryFeedbackListProvider.notifier);
      await notifier.fetchDiaryFeedbacks(diaryEntryId: 'diary-1');

      final state = container.read(diaryFeedbackListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);

      verify(
        mockDiaryFeedbackService.fetchDiaryFeedbacks(diaryEntryId: 'diary-1'),
      ).called(1);
    });

    test('addDiaryFeedback success', () async {
      final feedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction-1',
        userId: 'user-1',
        action: ActionType.accepted,
        createdAt: DateTime(2024, 1, 1),
      );

      when(
        mockDiaryFeedbackService.insertDiaryFeedback(feedback),
      ).thenAnswer((_) async => {});

      final notifier = container.read(diaryFeedbackListProvider.notifier);
      await notifier.addDiaryFeedback(feedback);

      final state = container.read(diaryFeedbackListProvider);
      expect(state.items, [feedback]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockDiaryFeedbackService.insertDiaryFeedback(feedback)).called(1);
    });

    test('updateDiaryFeedback success', () async {
      final originalFeedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction-1',
        userId: 'user-1',
        action: ActionType.ignored,
        createdAt: DateTime(2024, 1, 1),
      );

      final updatedFeedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction-1',
        userId: 'user-1',
        action: ActionType.accepted,
        createdAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container.read(diaryFeedbackListProvider.notifier).state =
          const DiaryFeedbackListState().copyWith(items: [originalFeedback]);

      when(
        mockDiaryFeedbackService.updateDiaryFeedback('1', updatedFeedback),
      ).thenAnswer((_) async => {});

      final notifier = container.read(diaryFeedbackListProvider.notifier);
      await notifier.updateDiaryFeedback(updatedFeedback);

      final state = container.read(diaryFeedbackListProvider);
      expect(state.items.length, 1);
      expect(state.items.first.action, ActionType.accepted);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(
        mockDiaryFeedbackService.updateDiaryFeedback('1', updatedFeedback),
      ).called(1);
    });

    test('removeDiaryFeedback success', () async {
      final feedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction-1',
        userId: 'user-1',
        action: ActionType.accepted,
        createdAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container
          .read(diaryFeedbackListProvider.notifier)
          .state = const DiaryFeedbackListState().copyWith(items: [feedback]);

      when(
        mockDiaryFeedbackService.deleteDiaryFeedback('1'),
      ).thenAnswer((_) async => {});

      final notifier = container.read(diaryFeedbackListProvider.notifier);
      await notifier.removeDiaryFeedback('1');

      final state = container.read(diaryFeedbackListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockDiaryFeedbackService.deleteDiaryFeedback('1')).called(1);
    });
  });
}
