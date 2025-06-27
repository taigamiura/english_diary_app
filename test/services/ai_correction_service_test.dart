import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kiwi/services/ai_correction_service.dart';
import 'package:kiwi/repositories/ai_correction_repository.dart';
import 'package:kiwi/models/ai_correction_model.dart';

import 'ai_correction_service_test.mocks.dart';

@GenerateMocks([AiCorrectionRepository])
void main() {
  group('AiCorrectionServiceImpl', () {
    late AiCorrectionServiceImpl service;
    late MockAiCorrectionRepository mockRepository;

    setUp(() {
      mockRepository = MockAiCorrectionRepository();
      service = AiCorrectionServiceImpl(mockRepository);
    });

    group('fetchAiCorrections', () {
      test('should return ai corrections from repository', () async {
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
        ];
        when(
          mockRepository.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).thenAnswer((_) async => expectedCorrections);

        // Act
        final result = await service.fetchAiCorrections(
          diaryEntryId: diaryEntryId,
        );

        // Assert
        expect(result, equals(expectedCorrections));
        verify(
          mockRepository.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).called(1);
      });
    });

    group('fetchAiCorrection', () {
      test('should return ai correction from repository', () async {
        // Arrange
        const correctionId = '1';
        final expectedCorrection = AiCorrection(
          id: correctionId,
          diaryEntryId: 'diary1',
          originalText: 'Hello world',
          correctedText: 'Hello, world!',
          suggestionType: 'grammar',
          explanation: 'Added comma',
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.fetchAiCorrection(correctionId),
        ).thenAnswer((_) async => expectedCorrection);

        // Act
        final result = await service.fetchAiCorrection(correctionId);

        // Assert
        expect(result, equals(expectedCorrection));
        verify(mockRepository.fetchAiCorrection(correctionId)).called(1);
      });

      test('should return null when correction not found', () async {
        // Arrange
        const correctionId = 'nonexistent';
        when(
          mockRepository.fetchAiCorrection(correctionId),
        ).thenAnswer((_) async => null);

        // Act
        final result = await service.fetchAiCorrection(correctionId);

        // Assert
        expect(result, isNull);
        verify(mockRepository.fetchAiCorrection(correctionId)).called(1);
      });
    });

    group('insertAiCorrection', () {
      test('should insert ai correction via repository', () async {
        // Arrange
        final correction = AiCorrection(
          id: '1',
          diaryEntryId: 'diary1',
          originalText: 'Hello world',
          correctedText: 'Hello, world!',
          suggestionType: 'grammar',
          explanation: 'Added comma',
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertAiCorrection(correction),
        ).thenAnswer((_) async => {});

        // Act
        await service.insertAiCorrection(correction);

        // Assert
        verify(mockRepository.insertAiCorrection(correction)).called(1);
      });
    });

    group('updateAiCorrection', () {
      test('should update ai correction via repository', () async {
        // Arrange
        const correctionId = '1';
        final correction = AiCorrection(
          id: correctionId,
          diaryEntryId: 'diary1',
          originalText: 'Hello world',
          correctedText: 'Hello, world!',
          suggestionType: 'grammar',
          explanation: 'Added comma',
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updateAiCorrection(correctionId, correction),
        ).thenAnswer((_) async => {});

        // Act
        await service.updateAiCorrection(correctionId, correction);

        // Assert
        verify(
          mockRepository.updateAiCorrection(correctionId, correction),
        ).called(1);
      });
    });

    group('deleteAiCorrection', () {
      test('should delete ai correction via repository', () async {
        // Arrange
        const correctionId = '1';
        when(
          mockRepository.deleteAiCorrection(correctionId),
        ).thenAnswer((_) async => {});

        // Act
        await service.deleteAiCorrection(correctionId);

        // Assert
        verify(mockRepository.deleteAiCorrection(correctionId)).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exception from fetchAiCorrections', () async {
        // Arrange
        const diaryEntryId = 'diary1';
        when(
          mockRepository.fetchAiCorrections(diaryEntryId: diaryEntryId),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => service.fetchAiCorrections(diaryEntryId: diaryEntryId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from fetchAiCorrection', () async {
        // Arrange
        const correctionId = '1';
        when(
          mockRepository.fetchAiCorrection(correctionId),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => service.fetchAiCorrection(correctionId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from insertAiCorrection', () async {
        // Arrange
        final correction = AiCorrection(
          id: '1',
          diaryEntryId: 'diary1',
          originalText: 'Hello world',
          correctedText: 'Hello, world!',
          suggestionType: 'grammar',
          explanation: 'Added comma',
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertAiCorrection(correction),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(
          () => service.insertAiCorrection(correction),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from updateAiCorrection', () async {
        // Arrange
        const correctionId = '1';
        final correction = AiCorrection(
          id: correctionId,
          diaryEntryId: 'diary1',
          originalText: 'Hello world',
          correctedText: 'Hello, world!',
          suggestionType: 'grammar',
          explanation: 'Added comma',
          createdAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updateAiCorrection(correctionId, correction),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => service.updateAiCorrection(correctionId, correction),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from deleteAiCorrection', () async {
        // Arrange
        const correctionId = '1';
        when(
          mockRepository.deleteAiCorrection(correctionId),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => service.deleteAiCorrection(correctionId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
