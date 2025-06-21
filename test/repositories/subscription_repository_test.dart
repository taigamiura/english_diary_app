import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/repositories/subscription_repository.dart';
import 'package:english_diary_app/models/subscription_model.dart';

void main() {
  group('SubscriptionRepository Tests', () {
    group('Constants', () {
      test('should have correct table name', () {
        expect(SubscriptionRepository.table, equals('subscriptions'));
      });
    });

    group('Class structure', () {
      test('should have SubscriptionRepository class', () {
        expect(SubscriptionRepository, isA<Type>());
      });

      test('should have Subscription model class', () {
        expect(Subscription, isA<Type>());
      });
    });

    group('Subscription model', () {
      test('should create subscription with all required fields', () {
        final subscription = Subscription(
          id: 1,
          userId: 'user123',
          planId: 2,
          status: 'active',
          startDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
          createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        );

        expect(subscription.id, equals(1));
        expect(subscription.userId, equals('user123'));
        expect(subscription.planId, equals(2));
        expect(subscription.status, equals('active'));
        expect(subscription.endDate, isNull);
      });

      test('should convert to JSON correctly', () {
        final subscription = Subscription(
          id: 1,
          userId: 'user123',
          planId: 2,
          status: 'active',
          startDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
          createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        );

        final json = subscription.toJson();

        expect(json['user_id'], equals('user123'));
        expect(json['plan_id'], equals(2));
        expect(json['status'], equals('active'));
        expect(json['start_date'], equals('2023-01-01T00:00:00.000Z'));
        expect(json['end_date'], isNull);
      });

      test('should create from JSON correctly', () {
        final json = {
          'id': 1,
          'user_id': 'user123',
          'plan_id': 2,
          'status': 'active',
          'start_date': '2023-01-01T00:00:00.000Z',
          'end_date': null,
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-01T00:00:00.000Z',
        };

        final subscription = Subscription.fromJson(json);

        expect(subscription.id, equals(1));
        expect(subscription.userId, equals('user123'));
        expect(subscription.planId, equals(2));
        expect(subscription.status, equals('active'));
        expect(subscription.endDate, isNull);
      });

      test('should create from JSON with end date', () {
        final json = {
          'id': 1,
          'user_id': 'user123',
          'plan_id': 2,
          'status': 'expired',
          'start_date': '2023-01-01T00:00:00.000Z',
          'end_date': '2023-12-31T23:59:59.000Z',
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-12-31T23:59:59.000Z',
        };

        final subscription = Subscription.fromJson(json);

        expect(subscription.endDate, isNotNull);
        expect(subscription.endDate?.year, equals(2023));
        expect(subscription.endDate?.month, equals(12));
        expect(subscription.endDate?.day, equals(31));
      });
    });
  });
}
