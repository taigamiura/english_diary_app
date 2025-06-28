import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/models/payment_model.dart';

void main() {
  group('Payment Model Tests', () {
    final testPayment = Payment(
      id: 1,
      userId: 'user123',
      subscriptionId: 1,
      amount: 9.99,
      currency: 'USD',
      paymentDate: DateTime(2024, 1, 15),
      status: 'succeeded',
      createdAt: DateTime(2024, 1, 15, 10, 0),
      updatedAt: DateTime(2024, 1, 15, 10, 0),
    );

    test('should create Payment instance with all properties', () {
      expect(testPayment.id, 1);
      expect(testPayment.userId, 'user123');
      expect(testPayment.subscriptionId, 1);
      expect(testPayment.amount, 9.99);
      expect(testPayment.currency, 'USD');
      expect(testPayment.paymentDate, DateTime(2024, 1, 15));
      expect(testPayment.status, 'succeeded');
      expect(testPayment.createdAt, DateTime(2024, 1, 15, 10, 0));
      expect(testPayment.updatedAt, DateTime(2024, 1, 15, 10, 0));
    });

    test('should create Payment from JSON', () {
      final json = {
        'id': 1,
        'user_id': 'user123',
        'subscription_id': 1,
        'amount': 9.99,
        'currency': 'USD',
        'payment_date': '2024-01-15T00:00:00.000Z',
        'status': 'succeeded',
        'created_at': '2024-01-15T10:00:00.000Z',
        'updated_at': '2024-01-15T10:00:00.000Z',
      };

      final payment = Payment.fromJson(json);

      expect(payment.id, 1);
      expect(payment.userId, 'user123');
      expect(payment.subscriptionId, 1);
      expect(payment.amount, 9.99);
      expect(payment.currency, 'USD');
      expect(payment.paymentDate, DateTime.parse('2024-01-15T00:00:00.000Z'));
      expect(payment.status, 'succeeded');
      expect(payment.createdAt, DateTime.parse('2024-01-15T10:00:00.000Z'));
      expect(payment.updatedAt, DateTime.parse('2024-01-15T10:00:00.000Z'));
    });

    test('should convert Payment to JSON', () {
      final json = testPayment.toJson();

      expect(json['user_id'], 'user123');
      expect(json['subscription_id'], 1);
      expect(json['amount'], 9.99);
      expect(json['currency'], 'USD');
      expect(json['payment_date'], testPayment.paymentDate.toIso8601String());
      expect(json['status'], 'succeeded');
      expect(json['created_at'], testPayment.createdAt.toIso8601String());
      expect(json['updated_at'], testPayment.updatedAt.toIso8601String());
      // toJson doesn't include id
      expect(json.containsKey('id'), false);
    });

    test('should handle different payment statuses', () {
      final statuses = ['succeeded', 'failed', 'pending'];

      for (final status in statuses) {
        final payment = Payment(
          id: 1,
          userId: 'user123',
          subscriptionId: 1,
          amount: 9.99,
          currency: 'USD',
          paymentDate: DateTime.now(),
          status: status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(payment.status, status);
      }
    });

    test('should handle integer amount as double', () {
      final json = {
        'id': 1,
        'user_id': 'user123',
        'subscription_id': 1,
        'amount': 10, // integer value
        'currency': 'USD',
        'payment_date': '2024-01-15T00:00:00.000Z',
        'status': 'succeeded',
        'created_at': '2024-01-15T10:00:00.000Z',
        'updated_at': '2024-01-15T10:00:00.000Z',
      };

      final payment = Payment.fromJson(json);
      expect(payment.amount, 10.0);
    });

    test('should handle different currencies', () {
      final currencies = ['USD', 'EUR', 'JPY'];

      for (final currency in currencies) {
        final payment = Payment(
          id: 1,
          userId: 'user123',
          subscriptionId: 1,
          amount: 9.99,
          currency: currency,
          paymentDate: DateTime.now(),
          status: 'succeeded',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(payment.currency, currency);
      }
    });
  });
}
