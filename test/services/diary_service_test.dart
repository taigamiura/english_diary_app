import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:english_diary_app/services/diary_service.dart';
import 'package:english_diary_app/models/diary_model.dart';
import 'package:english_diary_app/models/year_month.dart';
import '../mocks/mock_annotations.mocks.dart';

void main() {
  group('DiaryService Tests', () {
    late DiaryService diaryService;
    late MockDiaryRepository mockDiaryRepository;

    setUp(() {
      mockDiaryRepository = MockDiaryRepository();
      diaryService = DiaryServiceImpl(mockDiaryRepository);
    });

    group('fetchDiaries', () {
      test('should return list of diaries from repository', () async {
        // Arrange
        final mockDiaries = [
          Diary(
            id: '1',
            userId: 'user123',
            textInput: 'First diary entry',
            createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
            updatedAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
          ),
          Diary(
            id: '2',
            userId: 'user123',
            textInput: 'Second diary entry',
            createdAt: DateTime.parse('2024-01-16T10:30:00.000Z'),
            updatedAt: DateTime.parse('2024-01-16T10:30:00.000Z'),
          ),
        ];

        when(
          mockDiaryRepository.fetchDiaries(
            userId: anyNamed('userId'),
            from: anyNamed('from'),
            to: anyNamed('to'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => mockDiaries);

        // Act
        final result = await diaryService.fetchDiaries(
          userId: 'user123',
          from: DateTime(2024, 1, 15),
          to: DateTime(2024, 1, 16),
          limit: 10,
        );

        // Assert
        expect(result, equals(mockDiaries));
        expect(result.length, equals(2));
        verify(
          mockDiaryRepository.fetchDiaries(
            userId: 'user123',
            from: DateTime(2024, 1, 15),
            to: DateTime(2024, 1, 16),
            limit: 10,
          ),
        ).called(1);
      });
    });

    group('fetchDateDiary', () {
      test('should return diaries for specific date', () async {
        // Arrange
        final specificDate = DateTime(2024, 1, 15);
        final mockDiaries = [
          Diary(
            id: '1',
            userId: 'user123',
            textInput: 'Diary for today',
            createdAt: specificDate,
            updatedAt: specificDate,
          ),
        ];

        when(
          mockDiaryRepository.fetchDateDiary(
            userId: anyNamed('userId'),
            date: anyNamed('date'),
          ),
        ).thenAnswer((_) async => mockDiaries);

        // Act
        final result = await diaryService.fetchDateDiary(
          userId: 'user123',
          date: specificDate,
        );

        // Assert
        expect(result, equals(mockDiaries));
        verify(
          mockDiaryRepository.fetchDateDiary(
            userId: 'user123',
            date: specificDate,
          ),
        ).called(1);
      });
    });

    group('fetchPostedMonths', () {
      test('should return sorted list of YearMonth objects', () async {
        // Arrange
        final mockMonths = ['2024-03', '2024-01', '2024-02'];

        when(
          mockDiaryRepository.fetchPostedMonths(any),
        ).thenAnswer((_) async => mockMonths);

        // Act
        final result = await diaryService.fetchPostedMonths(userId: 'user123');

        // Assert
        expect(result, isA<List<YearMonth>>());
        expect(result.length, equals(3));

        // Should be sorted in descending order (newest first)
        expect(result[0].toString(), equals('2024-3'));
        expect(result[1].toString(), equals('2024-2'));
        expect(result[2].toString(), equals('2024-1'));

        verify(mockDiaryRepository.fetchPostedMonths('user123')).called(1);
      });

      test('should handle empty list from repository', () async {
        // Arrange
        when(
          mockDiaryRepository.fetchPostedMonths(any),
        ).thenAnswer((_) async => []);

        // Act
        final result = await diaryService.fetchPostedMonths(userId: 'user123');

        // Assert
        expect(result, isEmpty);
      });
    });

    group('fetchDiary', () {
      test('should return diary when found', () async {
        // Arrange
        final mockDiary = Diary(
          id: '1',
          userId: 'user123',
          textInput: 'Test diary entry',
          createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
          updatedAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
        );

        when(
          mockDiaryRepository.fetchDiary(any),
        ).thenAnswer((_) async => mockDiary);

        // Act
        final result = await diaryService.fetchDiary('1');

        // Assert
        expect(result, equals(mockDiary));
        verify(mockDiaryRepository.fetchDiary('1')).called(1);
      });

      test('should return null when diary not found', () async {
        // Arrange
        when(mockDiaryRepository.fetchDiary(any)).thenAnswer((_) async => null);

        // Act
        final result = await diaryService.fetchDiary('999');

        // Assert
        expect(result, isNull);
      });
    });

    group('fetchAverageTextInput', () {
      test('should return average from repository', () async {
        // Arrange
        when(
          mockDiaryRepository.fetchAverageTextInput(userId: anyNamed('userId')),
        ).thenAnswer((_) async => 150);

        // Act
        final result = await diaryService.fetchAverageTextInput(
          userId: 'user123',
        );

        // Assert
        expect(result, equals(150));
        verify(
          mockDiaryRepository.fetchAverageTextInput(userId: 'user123'),
        ).called(1);
      });
    });

    group('insertDiary', () {
      test('should call repository insert method', () async {
        // Arrange
        final diary = Diary(userId: 'user123', textInput: 'New diary entry');

        when(mockDiaryRepository.insertDiary(any)).thenAnswer((_) async => {});

        // Act
        await diaryService.insertDiary(diary);

        // Assert
        verify(mockDiaryRepository.insertDiary(diary)).called(1);
      });
    });

    group('updateDiary', () {
      test('should call repository update method', () async {
        // Arrange
        final diary = Diary(
          id: '1',
          userId: 'user123',
          textInput: 'Updated diary entry',
        );

        when(mockDiaryRepository.updateDiary(any)).thenAnswer((_) async => {});

        // Act
        await diaryService.updateDiary('1', diary);

        // Assert
        verify(mockDiaryRepository.updateDiary(diary)).called(1);
      });
    });

    group('deleteDiary', () {
      test('should call repository delete method', () async {
        // Arrange
        when(mockDiaryRepository.deleteDiary(any)).thenAnswer((_) async => {});

        // Act
        await diaryService.deleteDiary('1');

        // Assert
        verify(mockDiaryRepository.deleteDiary('1')).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exceptions from repository', () async {
        // Arrange
        when(
          mockDiaryRepository.fetchDiary(any),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(() async => await diaryService.fetchDiary('1'), throwsException);
      });

      test('should handle invalid month string format', () async {
        // Arrange
        final invalidMonths = ['invalid-format', '2024-13']; // Invalid month

        when(
          mockDiaryRepository.fetchPostedMonths(any),
        ).thenAnswer((_) async => invalidMonths);

        // Act & Assert
        expect(
          () async => await diaryService.fetchPostedMonths(userId: 'user123'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
