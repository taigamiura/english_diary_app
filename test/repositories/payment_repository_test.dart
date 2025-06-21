import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/repositories/payment_repository.dart';
import 'package:english_diary_app/models/payment_model.dart';

void main() {
  group('PaymentRepository', () {
    test('PaymentRepository class exists and can be referenced', () {
      // This test verifies that the class exists and can be accessed
      expect(PaymentRepository, isNotNull);
    });
  });

  group('Payment Model', () {
    test('Payment can be created with required fields', () {
      // Test Payment creation
      final now = DateTime.now();
      final payment = Payment(
        id: 1,
        userId: 'test_user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: now,
        status: 'succeeded',
        createdAt: now,
        updatedAt: now,
      );

      expect(payment.id, equals(1));
      expect(payment.userId, equals('test_user'));
      expect(payment.subscriptionId, equals(1));
      expect(payment.amount, equals(1000.0));
      expect(payment.currency, equals('USD'));
      expect(payment.status, equals('succeeded'));
    });

    test('Payment toJson works correctly', () {
      final now = DateTime.now();
      final payment = Payment(
        id: 1,
        userId: 'test_user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: now,
        status: 'succeeded',
        createdAt: now,
        updatedAt: now,
      );

      final json = payment.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['user_id'], equals('test_user'));
      expect(json['subscription_id'], equals(1));
      expect(json['amount'], equals(1000.0));
      expect(json['currency'], equals('USD'));
      expect(json['status'], equals('succeeded'));
    });

    test('Payment fromJson works correctly', () {
      final json = {
        'id': 1,
        'user_id': 'test_user',
        'subscription_id': 1,
        'amount': 1000.0,
        'currency': 'USD',
        'payment_date': '2024-01-01T00:00:00.000Z',
        'status': 'succeeded',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final payment = Payment.fromJson(json);
      expect(payment.id, equals(1));
      expect(payment.userId, equals('test_user'));
      expect(payment.subscriptionId, equals(1));
      expect(payment.amount, equals(1000.0));
      expect(payment.currency, equals('USD'));
      expect(payment.status, equals('succeeded'));
    });

    test('Payment model supports different status values', () {
      final now = DateTime.now();
      final statuses = ['succeeded', 'failed', 'pending'];

      for (final status in statuses) {
        final payment = Payment(
          id: 1,
          userId: 'test_user',
          subscriptionId: 1,
          amount: 1000.0,
          currency: 'USD',
          paymentDate: now,
          status: status,
          createdAt: now,
          updatedAt: now,
        );

        expect(payment.status, equals(status));
      }
    });
  });
}
