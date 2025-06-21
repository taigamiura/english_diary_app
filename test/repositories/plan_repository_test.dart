import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/repositories/plan_repository.dart';
import 'package:english_diary_app/models/plan_model.dart';

void main() {
  group('PlanRepository Tests', () {
    test('should have correct table name constant', () {
      expect(PlanRepository.table, equals('plans'));
    });

    test('PlanRepository class exists and can be referenced', () {
      expect(PlanRepository, isNotNull);
    });
  });

  group('Plan Model Tests', () {
    test('should create Plan from JSON', () {
      final json = {
        'id': 1,
        'name': 'Basic Plan',
        'description': 'Basic features',
        'price_monthly': 9.99,
        'price_yearly': 99.99,
        'created_at': '2023-06-01T10:00:00.000Z',
        'updated_at': '2023-06-01T11:00:00.000Z',
      };

      final plan = Plan.fromJson(json);
      expect(plan.id, equals(1));
      expect(plan.name, equals('Basic Plan'));
      expect(plan.description, equals('Basic features'));
      expect(plan.priceMonthly, equals(9.99));
      expect(plan.priceYearly, equals(99.99));
    });

    test('should convert Plan to JSON', () {
      final plan = Plan(
        id: 2,
        name: 'Premium Plan',
        description: 'Premium features',
        priceMonthly: 19.99,
        priceYearly: 199.99,
        createdAt: DateTime.parse('2023-06-02T12:00:00.000Z'),
        updatedAt: DateTime.parse('2023-06-02T12:30:00.000Z'),
      );

      final json = plan.toJson();
      expect(json['name'], equals('Premium Plan'));
      expect(json['description'], equals('Premium features'));
      expect(json['price_monthly'], equals(19.99));
      expect(json['price_yearly'], equals(199.99));
    });

    test('should handle null values in JSON', () {
      final json = {
        'id': 3,
        'name': 'Free Plan',
        'description': null,
        'price_monthly': 0.0,
        'price_yearly': null,
        'created_at': '2023-06-03T08:00:00.000Z',
        'updated_at': '2023-06-03T08:00:00.000Z',
      };

      final plan = Plan.fromJson(json);
      expect(plan.id, equals(3));
      expect(plan.name, equals('Free Plan'));
      expect(plan.description, isNull);
      expect(plan.priceMonthly, equals(0.0));
      expect(plan.priceYearly, isNull);
    });
  });
}
