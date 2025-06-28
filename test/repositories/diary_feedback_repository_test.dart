import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/repositories/diary_feedback_repository.dart';
import 'package:kiwi/models/diary_feedback_model.dart';

void main() {
  group('DiaryFeedbackRepository', () {
    test('DiaryFeedbackRepository has correct table constant', () {
      expect(DiaryFeedbackRepository.table, equals('diary_feedbacks'));
    });

    test('DiaryFeedbackRepository class exists and can be referenced', () {
      expect(DiaryFeedbackRepository, isNotNull);
    });
  });

  group('DiaryFeedback Model', () {
    test('DiaryFeedback can be created with required fields', () {
      final now = DateTime.now();
      final feedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction_1',
        userId: 'user_1',
        action: ActionType.accepted,
        createdAt: now,
      );

      expect(feedback.id, equals('1'));
      expect(feedback.aiCorrectionId, equals('correction_1'));
      expect(feedback.userId, equals('user_1'));
      expect(feedback.action, equals(ActionType.accepted));
      expect(feedback.createdAt, equals(now));
    });

    test('DiaryFeedback toJson works correctly', () {
      final now = DateTime.now();
      final feedback = DiaryFeedback(
        id: '1',
        aiCorrectionId: 'correction_1',
        userId: 'user_1',
        action: ActionType.accepted,
        createdAt: now,
      );

      final json = feedback.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['ai_correction_id'], equals('correction_1'));
      expect(json['user_id'], equals('user_1'));
      expect(json['action'], equals(ActionType.accepted));
      expect(json['created_at'], equals(now.toIso8601String()));
    });

    test('DiaryFeedback fromJson works correctly', () {
      final json = {
        'id': 1,
        'ai_correction_id': 2,
        'user_id': 'user_1',
        'action': 'accepted',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final feedback = DiaryFeedback.fromJson(json);
      expect(feedback.id, equals('1'));
      expect(feedback.aiCorrectionId, equals('2'));
      expect(feedback.userId, equals('user_1'));
      expect(feedback.action, equals(ActionType.accepted));
    });

    test('ActionType enum parsing works correctly', () {
      final acceptedJson = {
        'id': 1,
        'ai_correction_id': 2,
        'user_id': 'user_1',
        'action': 'accepted',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final ignoredJson = {
        'id': 1,
        'ai_correction_id': 2,
        'user_id': 'user_1',
        'action': 'ignored',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final acceptedFeedback = DiaryFeedback.fromJson(acceptedJson);
      final ignoredFeedback = DiaryFeedback.fromJson(ignoredJson);

      expect(acceptedFeedback.action, equals(ActionType.accepted));
      expect(ignoredFeedback.action, equals(ActionType.ignored));
    });

    test('ActionType values are correct', () {
      expect(ActionType.accepted.toString(), equals('ActionType.accepted'));
      expect(ActionType.ignored.toString(), equals('ActionType.ignored'));
    });
  });
}
