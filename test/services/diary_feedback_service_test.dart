import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:english_diary_app/services/diary_feedback_service.dart';
import 'package:english_diary_app/repositories/diary_feedback_repository.dart';
import 'package:english_diary_app/models/diary_feedback_model.dart';

import 'diary_feedback_service_test.mocks.dart';

@GenerateMocks([DiaryFeedbackRepository])
void main() {
  group('DiaryFeedbackServiceImpl', () {
    late DiaryFeedbackServiceImpl service;
    late MockDiaryFeedbackRepository mockRepository;

    setUp(() {
      mockRepository = MockDiaryFeedbackRepository();
      service = DiaryFeedbackServiceImpl(mockRepository);
    });

    group('fetchDiaryFeedbacks', () {
      test('should return diary feedbacks from repository', () async {
        // Arrange
        const diaryEntryId = 'diary1';
        final expectedFeedbacks = [
          DiaryFeedback(
            id: '1',
            aiCorrectionId: 'correction1',
            userId: 'user1',
            action: ActionType.accepted,
            createdAt: DateTime(2024, 1, 15),
          ),
        ];
        when(
          mockRepository.fetchDiaryFeedbacks(diaryEntryId: diaryEntryId),
        ).thenAnswer((_) async => expectedFeedbacks);

        // Act
        final result = await service.fetchDiaryFeedbacks(
          diaryEntryId: diaryEntryId,
        );

        // Assert
        expect(result, equals(expectedFeedbacks));
        verify(
          mockRepository.fetchDiaryFeedbacks(diaryEntryId: diaryEntryId),
        ).called(1);
      });
    });

    group('fetchDiaryFeedback', () {
      test('should return diary feedback from repository', () async {
        // Arrange
        const feedbackId = '1';
        final expectedFeedback = DiaryFeedback(
          id: feedbackId,
          aiCorrectionId: 'correction1',
          userId: 'user1',
          action: ActionType.accepted,
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.fetchDiaryFeedback(feedbackId),
        ).thenAnswer((_) async => expectedFeedback);

        // Act
        final result = await service.fetchDiaryFeedback(feedbackId);

        // Assert
        expect(result, equals(expectedFeedback));
        verify(mockRepository.fetchDiaryFeedback(feedbackId)).called(1);
      });

      test('should return null when feedback not found', () async {
        // Arrange
        const feedbackId = 'nonexistent';
        when(
          mockRepository.fetchDiaryFeedback(feedbackId),
        ).thenAnswer((_) async => null);

        // Act
        final result = await service.fetchDiaryFeedback(feedbackId);

        // Assert
        expect(result, isNull);
        verify(mockRepository.fetchDiaryFeedback(feedbackId)).called(1);
      });
    });

    group('insertDiaryFeedback', () {
      test('should insert diary feedback via repository', () async {
        // Arrange
        final feedback = DiaryFeedback(
          id: '1',
          aiCorrectionId: 'correction1',
          userId: 'user1',
          action: ActionType.accepted,
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertDiaryFeedback(feedback),
        ).thenAnswer((_) async => {});

        // Act
        await service.insertDiaryFeedback(feedback);

        // Assert
        verify(mockRepository.insertDiaryFeedback(feedback)).called(1);
      });
    });

    group('updateDiaryFeedback', () {
      test('should update diary feedback via repository', () async {
        // Arrange
        const feedbackId = '1';
        final feedback = DiaryFeedback(
          id: feedbackId,
          aiCorrectionId: 'correction1',
          userId: 'user1',
          action: ActionType.accepted,
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updateDiaryFeedback(feedbackId, feedback),
        ).thenAnswer((_) async => {});

        // Act
        await service.updateDiaryFeedback(feedbackId, feedback);

        // Assert
        verify(
          mockRepository.updateDiaryFeedback(feedbackId, feedback),
        ).called(1);
      });
    });

    group('deleteDiaryFeedback', () {
      test('should delete diary feedback via repository', () async {
        // Arrange
        const feedbackId = '1';
        when(
          mockRepository.deleteDiaryFeedback(feedbackId),
        ).thenAnswer((_) async => {});

        // Act
        await service.deleteDiaryFeedback(feedbackId);

        // Assert
        verify(mockRepository.deleteDiaryFeedback(feedbackId)).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exception from fetchDiaryFeedbacks', () async {
        // Arrange
        const diaryEntryId = 'diary1';
        when(
          mockRepository.fetchDiaryFeedbacks(diaryEntryId: diaryEntryId),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => service.fetchDiaryFeedbacks(diaryEntryId: diaryEntryId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from fetchDiaryFeedback', () async {
        // Arrange
        const feedbackId = '1';
        when(
          mockRepository.fetchDiaryFeedback(feedbackId),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => service.fetchDiaryFeedback(feedbackId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from insertDiaryFeedback', () async {
        // Arrange
        final feedback = DiaryFeedback(
          id: '1',
          aiCorrectionId: 'correction1',
          userId: 'user1',
          action: ActionType.accepted,
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertDiaryFeedback(feedback),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(
          () => service.insertDiaryFeedback(feedback),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from updateDiaryFeedback', () async {
        // Arrange
        const feedbackId = '1';
        final feedback = DiaryFeedback(
          id: feedbackId,
          aiCorrectionId: 'correction1',
          userId: 'user1',
          action: ActionType.accepted,
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updateDiaryFeedback(feedbackId, feedback),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => service.updateDiaryFeedback(feedbackId, feedback),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from deleteDiaryFeedback', () async {
        // Arrange
        const feedbackId = '1';
        when(
          mockRepository.deleteDiaryFeedback(feedbackId),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => service.deleteDiaryFeedback(feedbackId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
