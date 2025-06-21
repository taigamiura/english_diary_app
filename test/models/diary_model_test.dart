import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/models/diary_model.dart';

void main() {
  group('Diary Model Tests', () {
    late Map<String, dynamic> sampleJson;
    late Diary sampleDiary;

    setUp(() {
      sampleJson = {
        'id': '1',
        'user_id': 'user123',
        'text_input': 'Today was a great day!',
        'voice_input_url': 'https://example.com/audio.mp3',
        'transcription': 'Today was a great day',
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      sampleDiary = Diary(
        id: '1',
        userId: 'user123',
        textInput: 'Today was a great day!',
        voiceInputUrl: 'https://example.com/audio.mp3',
        transcription: 'Today was a great day',
        createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
        updatedAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
      );
    });

    test('should create Diary from JSON correctly', () {
      final diary = Diary.fromJson(sampleJson);

      expect(diary.id, equals('1'));
      expect(diary.userId, equals('user123'));
      expect(diary.textInput, equals('Today was a great day!'));
      expect(diary.voiceInputUrl, equals('https://example.com/audio.mp3'));
      expect(diary.transcription, equals('Today was a great day'));
      expect(
        diary.createdAt,
        equals(DateTime.parse('2024-01-15T10:30:00.000Z')),
      );
      expect(
        diary.updatedAt,
        equals(DateTime.parse('2024-01-15T10:30:00.000Z')),
      );
    });

    test('should convert Diary to JSON correctly', () {
      final json = sampleDiary.toJson();

      expect(json['user_id'], equals('user123'));
      expect(json['text_input'], equals('Today was a great day!'));
      expect(json['voice_input_url'], equals('https://example.com/audio.mp3'));
      expect(json['transcription'], equals('Today was a great day'));
      expect(json.containsKey('id'), isFalse); // toJson() should not include id
    });

    test('should handle null optional fields', () {
      final jsonWithoutOptionals = {
        'id': '2',
        'user_id': 'user456',
        'text_input': 'Simple diary entry',
        'voice_input_url': null,
        'transcription': null,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final diary = Diary.fromJson(jsonWithoutOptionals);

      expect(diary.id, equals('2'));
      expect(diary.userId, equals('user456'));
      expect(diary.textInput, equals('Simple diary entry'));
      expect(diary.voiceInputUrl, isNull);
      expect(diary.transcription, isNull);
    });

    test('should create Diary without optional fields', () {
      final diary = Diary(userId: 'user789', textInput: 'Another entry');

      expect(diary.id, isNull);
      expect(diary.userId, equals('user789'));
      expect(diary.textInput, equals('Another entry'));
      expect(diary.voiceInputUrl, isNull);
      expect(diary.transcription, isNull);
      expect(diary.createdAt, isNull);
      expect(diary.updatedAt, isNull);

      final json = diary.toJson();
      expect(json['voice_input_url'], isNull);
      expect(json['transcription'], isNull);
    });
  });
}
