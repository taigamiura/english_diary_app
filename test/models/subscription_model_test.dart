import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/models/subscription_model.dart';

void main() {
  group('Subscription Model Tests', () {
    final testSubscription = Subscription(
      id: 1,
      userId: 'user123',
      planId: 1,
      status: 'active',
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2024, 12, 31),
      createdAt: DateTime(2024, 1, 1, 10, 0),
      updatedAt: DateTime(2024, 1, 1, 10, 0),
    );

    test('should create Subscription instance with all properties', () {
      expect(testSubscription.id, 1);
      expect(testSubscription.userId, 'user123');
      expect(testSubscription.planId, 1);
      expect(testSubscription.status, 'active');
      expect(testSubscription.startDate, DateTime(2024, 1, 1));
      expect(testSubscription.endDate, DateTime(2024, 12, 31));
      expect(testSubscription.createdAt, DateTime(2024, 1, 1, 10, 0));
      expect(testSubscription.updatedAt, DateTime(2024, 1, 1, 10, 0));
    });

    test('should create Subscription instance with nullable endDate', () {
      final subscriptionWithoutEndDate = Subscription(
        id: 2,
        userId: 'user456',
        planId: 2,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1, 10, 0),
        updatedAt: DateTime(2024, 1, 1, 10, 0),
      );

      expect(subscriptionWithoutEndDate.id, 2);
      expect(subscriptionWithoutEndDate.userId, 'user456');
      expect(subscriptionWithoutEndDate.planId, 2);
      expect(subscriptionWithoutEndDate.status, 'active');
      expect(subscriptionWithoutEndDate.startDate, DateTime(2024, 1, 1));
      expect(subscriptionWithoutEndDate.endDate, null);
    });

    test('should create Subscription from JSON with all fields', () {
      final json = {
        'id': 1,
        'user_id': 'user123',
        'plan_id': 1,
        'status': 'active',
        'start_date': '2024-01-01T00:00:00.000Z',
        'end_date': '2024-12-31T00:00:00.000Z',
        'created_at': '2024-01-01T10:00:00.000Z',
        'updated_at': '2024-01-01T10:00:00.000Z',
      };

      final subscription = Subscription.fromJson(json);

      expect(subscription.id, 1);
      expect(subscription.userId, 'user123');
      expect(subscription.planId, 1);
      expect(subscription.status, 'active');
      expect(
        subscription.startDate,
        DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
      expect(subscription.endDate, DateTime.parse('2024-12-31T00:00:00.000Z'));
      expect(
        subscription.createdAt,
        DateTime.parse('2024-01-01T10:00:00.000Z'),
      );
      expect(
        subscription.updatedAt,
        DateTime.parse('2024-01-01T10:00:00.000Z'),
      );
    });

    test('should create Subscription from JSON with null endDate', () {
      final json = {
        'id': 2,
        'user_id': 'user456',
        'plan_id': 2,
        'status': 'active',
        'start_date': '2024-01-01T00:00:00.000Z',
        'end_date': null,
        'created_at': '2024-01-01T10:00:00.000Z',
        'updated_at': '2024-01-01T10:00:00.000Z',
      };

      final subscription = Subscription.fromJson(json);

      expect(subscription.id, 2);
      expect(subscription.userId, 'user456');
      expect(subscription.planId, 2);
      expect(subscription.status, 'active');
      expect(
        subscription.startDate,
        DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
      expect(subscription.endDate, null);
    });

    test('should convert Subscription to JSON', () {
      final json = testSubscription.toJson();

      expect(json['user_id'], 'user123');
      expect(json['plan_id'], 1);
      expect(json['status'], 'active');
      expect(json['start_date'], testSubscription.startDate.toIso8601String());
      expect(json['end_date'], testSubscription.endDate?.toIso8601String());
      expect(json['created_at'], testSubscription.createdAt.toIso8601String());
      expect(json['updated_at'], testSubscription.updatedAt.toIso8601String());
      // toJson doesn't include id
      expect(json.containsKey('id'), false);
    });

    test('should convert Subscription with null endDate to JSON', () {
      final subscriptionWithNullEndDate = Subscription(
        id: 2,
        userId: 'user456',
        planId: 2,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        createdAt: DateTime(2024, 1, 1, 10, 0),
        updatedAt: DateTime(2024, 1, 1, 10, 0),
      );

      final json = subscriptionWithNullEndDate.toJson();

      expect(json['user_id'], 'user456');
      expect(json['plan_id'], 2);
      expect(json['status'], 'active');
      expect(
        json['start_date'],
        subscriptionWithNullEndDate.startDate.toIso8601String(),
      );
      expect(json['end_date'], null);
    });

    test('should handle different subscription statuses', () {
      final statuses = ['active', 'canceled', 'past_due'];

      for (final status in statuses) {
        final subscription = Subscription(
          id: 1,
          userId: 'user123',
          planId: 1,
          status: status,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(subscription.status, status);
      }
    });

    test('should handle subscription lifecycle', () {
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 12, 31);

      // Active subscription
      final activeSubscription = Subscription(
        id: 1,
        userId: 'user123',
        planId: 1,
        status: 'active',
        startDate: startDate,
        endDate: endDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(activeSubscription.status, 'active');
      expect(activeSubscription.startDate, startDate);
      expect(activeSubscription.endDate, endDate);

      // Canceled subscription
      final canceledSubscription = Subscription(
        id: 2,
        userId: 'user123',
        planId: 1,
        status: 'canceled',
        startDate: startDate,
        endDate: DateTime(2024, 6, 30), // Canceled early
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(canceledSubscription.status, 'canceled');
      expect(canceledSubscription.endDate!.isBefore(endDate), true);
    });
  });
}
