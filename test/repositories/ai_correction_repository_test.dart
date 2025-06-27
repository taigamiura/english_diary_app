import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/repositories/ai_correction_repository.dart';
import 'package:kiwi/models/ai_correction_model.dart';

void main() {
  group('AiCorrectionRepository', () {
    test('AiCorrectionRepository has correct table constant', () {
      expect(AiCorrectionRepository.table, equals('ai_corrections'));
    });

    test('AiCorrectionRepository class exists and can be referenced', () {
      expect(AiCorrectionRepository, isNotNull);
    });
  });

  group('AiCorrection Model', () {
    test('AiCorrection can be created with required fields', () {
      final now = DateTime.now();
      final correction = AiCorrection(
        id: '1',
        diaryEntryId: 'diary_1',
        originalText: 'I have went to school.',
        correctedText: 'I went to school.',
        suggestionType: 'grammar',
        createdAt: now,
      );

      expect(correction.id, equals('1'));
      expect(correction.diaryEntryId, equals('diary_1'));
      expect(correction.originalText, equals('I have went to school.'));
      expect(correction.correctedText, equals('I went to school.'));
      expect(correction.suggestionType, equals('grammar'));
      expect(correction.createdAt, equals(now));
    });

    test('AiCorrection can be created with explanation', () {
      final now = DateTime.now();
      final correction = AiCorrection(
        id: '1',
        diaryEntryId: 'diary_1',
        originalText: 'I have went to school.',
        correctedText: 'I went to school.',
        suggestionType: 'grammar',
        explanation: 'Use simple past tense instead of present perfect.',
        createdAt: now,
      );

      expect(
        correction.explanation,
        equals('Use simple past tense instead of present perfect.'),
      );
    });

    test('AiCorrection toJson works correctly', () {
      final now = DateTime.now();
      final correction = AiCorrection(
        id: '1',
        diaryEntryId: 'diary_1',
        originalText: 'I have went to school.',
        correctedText: 'I went to school.',
        suggestionType: 'grammar',
        explanation: 'Use simple past tense instead of present perfect.',
        createdAt: now,
      );

      final json = correction.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['diary_entry_id'], equals('diary_1'));
      expect(json['original_text'], equals('I have went to school.'));
      expect(json['corrected_text'], equals('I went to school.'));
      expect(json['suggestion_type'], equals('grammar'));
      expect(
        json['explanation'],
        equals('Use simple past tense instead of present perfect.'),
      );
      expect(json['created_at'], equals(now.toIso8601String()));
    });

    test('AiCorrection fromJson works correctly', () {
      final json = {
        'id': '1',
        'diary_entry_id': 'diary_1',
        'original_text': 'I have went to school.',
        'corrected_text': 'I went to school.',
        'suggestion_type': 'grammar',
        'explanation': 'Use simple past tense instead of present perfect.',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final correction = AiCorrection.fromJson(json);
      expect(correction.id, equals('1'));
      expect(correction.diaryEntryId, equals('diary_1'));
      expect(correction.originalText, equals('I have went to school.'));
      expect(correction.correctedText, equals('I went to school.'));
      expect(correction.suggestionType, equals('grammar'));
      expect(
        correction.explanation,
        equals('Use simple past tense instead of present perfect.'),
      );
    });

    test('AiCorrection handles null explanation', () {
      final now = DateTime.now();
      final correction = AiCorrection(
        id: '1',
        diaryEntryId: 'diary_1',
        originalText: 'I have went to school.',
        correctedText: 'I went to school.',
        suggestionType: 'grammar',
        explanation: null,
        createdAt: now,
      );

      expect(correction.explanation, isNull);
    });

    test('AiCorrection supports different suggestion types', () {
      final now = DateTime.now();
      final suggestionTypes = ['grammar', 'expression', 'spelling'];

      for (final type in suggestionTypes) {
        final correction = AiCorrection(
          id: '1',
          diaryEntryId: 'diary_1',
          originalText: 'Test text',
          correctedText: 'Corrected text',
          suggestionType: type,
          createdAt: now,
        );

        expect(correction.suggestionType, equals(type));
      }
    });
  });
}
