import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/models/diary_feedback_model.dart';

void main() {
  group('DiaryFeedback Model Tests', () {
    final testFeedback = DiaryFeedback(
      id: 'feedback123',
      aiCorrectionId: 'correction456',
      userId: 'user789',
      action: ActionType.accepted,
      createdAt: DateTime(2024, 1, 15, 10, 30),
    );

    group('DiaryFeedback', () {
      test('should create DiaryFeedback instance with all properties', () {
        expect(testFeedback.id, 'feedback123');
        expect(testFeedback.aiCorrectionId, 'correction456');
        expect(testFeedback.userId, 'user789');
        expect(testFeedback.action, ActionType.accepted);
        expect(testFeedback.createdAt, DateTime(2024, 1, 15, 10, 30));
      });

      test('should create DiaryFeedback with ignored action', () {
        final ignoredFeedback = DiaryFeedback(
          id: 'feedback456',
          aiCorrectionId: 'correction789',
          userId: 'user123',
          action: ActionType.ignored,
          createdAt: DateTime(2024, 1, 16, 14, 45),
        );

        expect(ignoredFeedback.action, ActionType.ignored);
      });

      test('should create DiaryFeedback from JSON', () {
        final json = {
          'id': 123,
          'ai_correction_id': 456,
          'user_id': 'user789',
          'action': ActionType.accepted,
          'created_at': '2024-01-15T10:30:00.000Z',
        };

        final feedback = DiaryFeedback.fromJson(json);

        expect(feedback.id, '123');
        expect(feedback.aiCorrectionId, '456');
        expect(feedback.userId, 'user789');
        expect(feedback.action, ActionType.accepted);
        expect(feedback.createdAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
      });

      test('should create DiaryFeedback from JSON with string IDs', () {
        final json = {
          'id': 'feedback123',
          'ai_correction_id': 'correction456',
          'user_id': 'user789',
          'action': ActionType.ignored,
          'created_at': '2024-01-15T10:30:00.000Z',
        };

        final feedback = DiaryFeedback.fromJson(json);

        expect(feedback.id, 'feedback123');
        expect(feedback.aiCorrectionId, 'correction456');
        expect(feedback.userId, 'user789');
        expect(feedback.action, ActionType.ignored);
        expect(feedback.createdAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
      });

      test('should convert DiaryFeedback to JSON', () {
        final json = testFeedback.toJson();

        expect(json['ai_correction_id'], 'correction456');
        expect(json['user_id'], 'user789');
        expect(json['action'], ActionType.accepted);
        expect(json['created_at'], testFeedback.createdAt.toIso8601String());
        // toJson doesn't include id
        expect(json.containsKey('id'), false);
      });

      test('should convert DiaryFeedback with ignored action to JSON', () {
        final ignoredFeedback = DiaryFeedback(
          id: 'feedback456',
          aiCorrectionId: 'correction789',
          userId: 'user123',
          action: ActionType.ignored,
          createdAt: DateTime(2024, 1, 16, 14, 45),
        );

        final json = ignoredFeedback.toJson();

        expect(json['ai_correction_id'], 'correction789');
        expect(json['user_id'], 'user123');
        expect(json['action'], ActionType.ignored);
        expect(json['created_at'], ignoredFeedback.createdAt.toIso8601String());
      });
    });

    group('ActionType Enum', () {
      test('should have correct enum values', () {
        expect(ActionType.values.length, 2);
        expect(ActionType.values.contains(ActionType.accepted), true);
        expect(ActionType.values.contains(ActionType.ignored), true);
      });

      test('should be able to compare ActionType values', () {
        expect(ActionType.accepted == ActionType.accepted, true);
        expect(ActionType.accepted == ActionType.ignored, false);
        expect(ActionType.ignored == ActionType.ignored, true);
        expect(ActionType.ignored == ActionType.accepted, false);
      });

      test('should be able to switch on ActionType', () {
        String getActionDescription(ActionType action) {
          switch (action) {
            case ActionType.accepted:
              return 'Correction was accepted';
            case ActionType.ignored:
              return 'Correction was ignored';
          }
        }

        expect(
          getActionDescription(ActionType.accepted),
          'Correction was accepted',
        );
        expect(
          getActionDescription(ActionType.ignored),
          'Correction was ignored',
        );
      });
    });

    group('Edge Cases', () {
      test('should handle numeric IDs converted to strings', () {
        final json = {
          'id': 999,
          'ai_correction_id': 888,
          'user_id': 'user999',
          'action': ActionType.accepted,
          'created_at': '2024-01-15T10:30:00.000Z',
        };

        final feedback = DiaryFeedback.fromJson(json);

        expect(feedback.id, '999');
        expect(feedback.aiCorrectionId, '888');
      });

      test('should handle different user ID formats', () {
        final userIds = [
          'user123',
          'uuid-1234-5678',
          '999',
          'email@example.com',
        ];

        for (final userId in userIds) {
          final feedback = DiaryFeedback(
            id: 'feedback123',
            aiCorrectionId: 'correction456',
            userId: userId,
            action: ActionType.accepted,
            createdAt: DateTime.now(),
          );

          expect(feedback.userId, userId);
        }
      });
    });
  });
}
