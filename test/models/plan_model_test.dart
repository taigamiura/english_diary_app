import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/models/plan_model.dart';

void main() {
  group('Plan Model Tests', () {
    final testPlan = Plan(
      id: 1,
      name: 'Premium Plan',
      description: 'Full access to all features',
      priceMonthly: 9.99,
      priceYearly: 99.99,
      createdAt: DateTime(2024, 1, 1, 10, 0),
      updatedAt: DateTime(2024, 1, 1, 10, 0),
    );

    test('should create Plan instance with all properties', () {
      expect(testPlan.id, 1);
      expect(testPlan.name, 'Premium Plan');
      expect(testPlan.description, 'Full access to all features');
      expect(testPlan.priceMonthly, 9.99);
      expect(testPlan.priceYearly, 99.99);
      expect(testPlan.createdAt, DateTime(2024, 1, 1, 10, 0));
      expect(testPlan.updatedAt, DateTime(2024, 1, 1, 10, 0));
    });

    test('should create Plan instance with nullable description', () {
      final planWithoutDescription = Plan(
        id: 2,
        name: 'Basic Plan',
        priceMonthly: 4.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(planWithoutDescription.id, 2);
      expect(planWithoutDescription.name, 'Basic Plan');
      expect(planWithoutDescription.description, null);
      expect(planWithoutDescription.priceMonthly, 4.99);
      expect(planWithoutDescription.priceYearly, null);
    });

    test('should create Plan from JSON with all fields', () {
      final json = {
        'id': 1,
        'name': 'Premium Plan',
        'description': 'Full access to all features',
        'price_monthly': 9.99,
        'price_yearly': 99.99,
        'created_at': '2024-01-01T10:00:00.000Z',
        'updated_at': '2024-01-01T10:00:00.000Z',
      };

      final plan = Plan.fromJson(json);

      expect(plan.id, 1);
      expect(plan.name, 'Premium Plan');
      expect(plan.description, 'Full access to all features');
      expect(plan.priceMonthly, 9.99);
      expect(plan.priceYearly, 99.99);
      expect(plan.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
      expect(plan.updatedAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
    });

    test('should create Plan from JSON with null fields', () {
      final json = {
        'id': 2,
        'name': 'Basic Plan',
        'description': null,
        'price_monthly': 4.99,
        'price_yearly': null,
        'created_at': '2024-01-01T10:00:00.000Z',
        'updated_at': '2024-01-01T10:00:00.000Z',
      };

      final plan = Plan.fromJson(json);

      expect(plan.id, 2);
      expect(plan.name, 'Basic Plan');
      expect(plan.description, null);
      expect(plan.priceMonthly, 4.99);
      expect(plan.priceYearly, null);
      expect(plan.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
      expect(plan.updatedAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
    });

    test('should convert Plan to JSON', () {
      final json = testPlan.toJson();

      expect(json['name'], 'Premium Plan');
      expect(json['description'], 'Full access to all features');
      expect(json['price_monthly'], 9.99);
      expect(json['price_yearly'], 99.99);
      expect(json['created_at'], testPlan.createdAt.toIso8601String());
      expect(json['updated_at'], testPlan.updatedAt.toIso8601String());
      // toJson doesn't include id
      expect(json.containsKey('id'), false);
    });

    test('should convert Plan with null values to JSON', () {
      final planWithNulls = Plan(
        id: 2,
        name: 'Basic Plan',
        priceMonthly: 4.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final json = planWithNulls.toJson();

      expect(json['name'], 'Basic Plan');
      expect(json['description'], null);
      expect(json['price_monthly'], 4.99);
      expect(json['price_yearly'], null);
      expect(json['created_at'], planWithNulls.createdAt.toIso8601String());
      expect(json['updated_at'], planWithNulls.updatedAt.toIso8601String());
    });

    test('should handle integer prices as double', () {
      final json = {
        'id': 1,
        'name': 'Premium Plan',
        'description': 'Full access to all features',
        'price_monthly': 10, // integer value
        'price_yearly': 100, // integer value
        'created_at': '2024-01-01T10:00:00.000Z',
        'updated_at': '2024-01-01T10:00:00.000Z',
      };

      final plan = Plan.fromJson(json);
      expect(plan.priceMonthly, 10.0);
      expect(plan.priceYearly, 100.0);
    });

    test('should handle different plan types', () {
      final planTypes = [
        'Basic Plan',
        'Premium Plan',
        'Pro Plan',
        'Enterprise Plan',
      ];

      for (final planType in planTypes) {
        final plan = Plan(
          id: 1,
          name: planType,
          priceMonthly: 9.99,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(plan.name, planType);
      }
    });
  });
}
