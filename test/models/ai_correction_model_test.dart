import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/models/ai_correction_model.dart';

void main() {
  group('AiCorrection Model Tests', () {
    late Map<String, dynamic> sampleJson;
    late AiCorrection sampleCorrection;

    setUp(() {
      sampleJson = {
        'id': 'correction_123',
        'diary_entry_id': 'diary_456',
        'original_text': 'I have went to school',
        'corrected_text': 'I went to school',
        'suggestion_type': 'grammar',
        'explanation': 'Use simple past tense instead of present perfect',
        'created_at': '2024-01-15T10:30:00.000Z',
      };

      sampleCorrection = AiCorrection(
        id: 'correction_123',
        diaryEntryId: 'diary_456',
        originalText: 'I have went to school',
        correctedText: 'I went to school',
        suggestionType: 'grammar',
        explanation: 'Use simple past tense instead of present perfect',
        createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
      );
    });

    test('should create AiCorrection from JSON correctly', () {
      final correction = AiCorrection.fromJson(sampleJson);

      expect(correction.id, equals('correction_123'));
      expect(correction.diaryEntryId, equals('diary_456'));
      expect(correction.originalText, equals('I have went to school'));
      expect(correction.correctedText, equals('I went to school'));
      expect(correction.suggestionType, equals('grammar'));
      expect(
        correction.explanation,
        equals('Use simple past tense instead of present perfect'),
      );
      expect(
        correction.createdAt,
        equals(DateTime.parse('2024-01-15T10:30:00.000Z')),
      );
    });

    test('should convert AiCorrection to JSON correctly', () {
      final json = sampleCorrection.toJson();

      expect(json['diary_entry_id'], equals('diary_456'));
      expect(json['original_text'], equals('I have went to school'));
      expect(json['corrected_text'], equals('I went to school'));
      expect(json['suggestion_type'], equals('grammar'));
      expect(
        json['explanation'],
        equals('Use simple past tense instead of present perfect'),
      );
      expect(json['created_at'], equals('2024-01-15T10:30:00.000Z'));
      expect(json.containsKey('id'), isFalse); // toJson() should not include id
    });

    test('should handle null explanation', () {
      final jsonWithoutExplanation = {
        'id': 'correction_789',
        'diary_entry_id': 'diary_101',
        'original_text': 'colour',
        'corrected_text': 'color',
        'suggestion_type': 'spelling',
        'explanation': null,
        'created_at': '2024-01-15T10:30:00.000Z',
      };

      final correction = AiCorrection.fromJson(jsonWithoutExplanation);

      expect(correction.id, equals('correction_789'));
      expect(correction.explanation, isNull);
      expect(correction.suggestionType, equals('spelling'));
    });

    test('should create AiCorrection without explanation', () {
      final correction = AiCorrection(
        id: 'correction_999',
        diaryEntryId: 'diary_888',
        originalText: 'realise',
        correctedText: 'realize',
        suggestionType: 'spelling',
        explanation: null,
        createdAt: DateTime.now(),
      );

      expect(correction.explanation, isNull);

      final json = correction.toJson();
      expect(json['explanation'], isNull);
    });

    test('should handle different suggestion types', () {
      const suggestionTypes = ['grammar', 'expression', 'spelling'];

      for (final type in suggestionTypes) {
        final correction = AiCorrection(
          id: 'test_id',
          diaryEntryId: 'test_diary',
          originalText: 'test original',
          correctedText: 'test corrected',
          suggestionType: type,
          createdAt: DateTime.now(),
        );

        expect(correction.suggestionType, equals(type));
      }
    });

    test('should create AiCorrection with const constructor', () {
      final testDate = DateTime.parse('2024-01-15T10:30:00.000Z');
      final correction = AiCorrection(
        id: 'const_test',
        diaryEntryId: 'diary_const',
        originalText: 'original const',
        correctedText: 'corrected const',
        suggestionType: 'grammar',
        createdAt: testDate,
      );

      expect(correction.id, equals('const_test'));
      expect(correction.diaryEntryId, equals('diary_const'));
      expect(correction.createdAt, equals(testDate));
    });

    test('should parse DateTime string correctly', () {
      final jsonWithDifferentDateFormat = {
        'id': 'date_test',
        'diary_entry_id': 'diary_date',
        'original_text': 'test',
        'corrected_text': 'test',
        'suggestion_type': 'grammar',
        'explanation': null,
        'created_at': '2024-12-25T15:45:30.123456Z',
      };

      final correction = AiCorrection.fromJson(jsonWithDifferentDateFormat);

      expect(correction.createdAt.year, equals(2024));
      expect(correction.createdAt.month, equals(12));
      expect(correction.createdAt.day, equals(25));
      expect(correction.createdAt.hour, equals(15));
      expect(correction.createdAt.minute, equals(45));
    });
  });
}
