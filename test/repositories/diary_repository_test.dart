import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/repositories/diary_repository.dart';
import 'package:english_diary_app/models/diary_model.dart';

void main() {
  group('DiaryRepository', () {
    test('DiaryRepository has correct table constant', () {
      expect(DiaryRepository.diaryTable, equals('diary_entries'));
    });

    test('DiaryRepository class exists and can be referenced', () {
      expect(DiaryRepository, isNotNull);
    });
  });

  group('Diary Model', () {
    test('Diary can be created with required fields', () {
      final diary = Diary(userId: 'test_user', textInput: 'Test diary entry');

      expect(diary.userId, equals('test_user'));
      expect(diary.textInput, equals('Test diary entry'));
    });

    test('Diary can be created with all fields', () {
      final now = DateTime.now();
      final diary = Diary(
        id: '1',
        userId: 'test_user',
        textInput: 'Test diary entry',
        voiceInputUrl: 'http://example.com/audio.mp3',
        transcription: 'Transcribed text',
        createdAt: now,
        updatedAt: now,
      );

      expect(diary.id, equals('1'));
      expect(diary.userId, equals('test_user'));
      expect(diary.textInput, equals('Test diary entry'));
      expect(diary.voiceInputUrl, equals('http://example.com/audio.mp3'));
      expect(diary.transcription, equals('Transcribed text'));
      expect(diary.createdAt, equals(now));
      expect(diary.updatedAt, equals(now));
    });

    test('Diary toJson works correctly', () {
      final diary = Diary(
        userId: 'test_user',
        textInput: 'Test diary entry',
        voiceInputUrl: 'http://example.com/audio.mp3',
        transcription: 'Transcribed text',
      );

      final json = diary.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['user_id'], equals('test_user'));
      expect(json['text_input'], equals('Test diary entry'));
      expect(json['voice_input_url'], equals('http://example.com/audio.mp3'));
      expect(json['transcription'], equals('Transcribed text'));
    });

    test('Diary fromJson works correctly', () {
      final json = {
        'id': 1,
        'user_id': 'test_user',
        'text_input': 'Test diary entry',
        'voice_input_url': 'http://example.com/audio.mp3',
        'transcription': 'Transcribed text',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final diary = Diary.fromJson(json);
      expect(diary.id, equals('1'));
      expect(diary.userId, equals('test_user'));
      expect(diary.textInput, equals('Test diary entry'));
      expect(diary.voiceInputUrl, equals('http://example.com/audio.mp3'));
      expect(diary.transcription, equals('Transcribed text'));
    });

    test('Diary handles null optional fields', () {
      final diary = Diary(
        userId: 'test_user',
        textInput: 'Test diary entry',
        voiceInputUrl: null,
        transcription: null,
      );

      expect(diary.voiceInputUrl, isNull);
      expect(diary.transcription, isNull);
      expect(diary.createdAt, isNull);
      expect(diary.updatedAt, isNull);
    });
  });
}
