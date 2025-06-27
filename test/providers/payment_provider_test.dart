import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:kiwi/providers/payment_provider.dart';
import 'package:kiwi/services/payment_service.dart';
import 'package:kiwi/models/payment_model.dart';

// Mock classes manually defined
class MockPaymentService extends Mock implements PaymentService {
  @override
  Future<List<Payment>> fetchPayments({required String profileId}) {
    return super.noSuchMethod(
      Invocation.method(#fetchPayments, [], {#profileId: profileId}),
      returnValue: Future<List<Payment>>.value([]),
    );
  }

  @override
  Future<Payment?> fetchPayment(int id) {
    return super.noSuchMethod(
      Invocation.method(#fetchPayment, [id]),
      returnValue: Future<Payment?>.value(null),
    );
  }

  @override
  Future<void> insertPayment(Payment payment) {
    return super.noSuchMethod(
      Invocation.method(#insertPayment, [payment]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> updatePayment(int id, Payment payment) {
    return super.noSuchMethod(
      Invocation.method(#updatePayment, [id, payment]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> deletePayment(int id) {
    return super.noSuchMethod(
      Invocation.method(#deletePayment, [id]),
      returnValue: Future<void>.value(),
    );
  }
}

void main() {
  group('PaymentProvider Tests', () {
    late ProviderContainer container;
    late MockPaymentService mockPaymentService;

    setUp(() {
      mockPaymentService = MockPaymentService();
      container = ProviderContainer(
        overrides: [
          paymentServiceProvider.overrideWithValue(mockPaymentService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('PaymentListState initial state', () {
      const state = PaymentListState();
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('PaymentListState copyWith', () {
      const state = PaymentListState();
      final payment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'succeeded',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final newState = state.copyWith(
        items: [payment],
        isLoading: true,
        error: 'test error',
      );

      expect(newState.items, [payment]);
      expect(newState.isLoading, true);
      expect(newState.error, 'test error');
    });

    test('fetchPayments success', () async {
      final payment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'succeeded',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(
        mockPaymentService.fetchPayments(profileId: 'test-profile'),
      ).thenAnswer((_) async => [payment]);

      final notifier = container.read(paymentListProvider.notifier);
      await notifier.fetchPayments(profileId: 'test-profile');

      final state = container.read(paymentListProvider);
      expect(state.items, [payment]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(
        mockPaymentService.fetchPayments(profileId: 'test-profile'),
      ).called(1);
    });

    test('fetchPayments failure', () async {
      when(
        mockPaymentService.fetchPayments(profileId: 'test-profile'),
      ).thenThrow(Exception('Network error'));

      final notifier = container.read(paymentListProvider.notifier);
      await notifier.fetchPayments(profileId: 'test-profile');

      final state = container.read(paymentListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);

      verify(
        mockPaymentService.fetchPayments(profileId: 'test-profile'),
      ).called(1);
    });

    test('addPayment success', () async {
      final payment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'succeeded',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(
        mockPaymentService.insertPayment(payment),
      ).thenAnswer((_) async => {});

      final notifier = container.read(paymentListProvider.notifier);
      await notifier.addPayment(payment);

      final state = container.read(paymentListProvider);
      expect(state.items, [payment]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPaymentService.insertPayment(payment)).called(1);
    });

    test('addPayment failure', () async {
      final payment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'succeeded',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(
        mockPaymentService.insertPayment(payment),
      ).thenThrow(Exception('Database error'));

      final notifier = container.read(paymentListProvider.notifier);
      await notifier.addPayment(payment);

      final state = container.read(paymentListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);

      verify(mockPaymentService.insertPayment(payment)).called(1);
    });

    test('updatePayment success', () async {
      final originalPayment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'pending',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updatedPayment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'succeeded',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container
          .read(paymentListProvider.notifier)
          .state = const PaymentListState().copyWith(items: [originalPayment]);

      when(
        mockPaymentService.updatePayment(1, updatedPayment),
      ).thenAnswer((_) async => {});

      final notifier = container.read(paymentListProvider.notifier);
      await notifier.updatePayment(updatedPayment);

      final state = container.read(paymentListProvider);
      expect(state.items.length, 1);
      expect(state.items.first.status, 'succeeded');
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPaymentService.updatePayment(1, updatedPayment)).called(1);
    });

    test('removePayment success', () async {
      final payment = Payment(
        id: 1,
        userId: 'test-user',
        subscriptionId: 1,
        amount: 1000.0,
        currency: 'USD',
        paymentDate: DateTime(2024, 1, 1),
        status: 'succeeded',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container
          .read(paymentListProvider.notifier)
          .state = const PaymentListState().copyWith(items: [payment]);

      when(mockPaymentService.deletePayment(1)).thenAnswer((_) async => {});

      final notifier = container.read(paymentListProvider.notifier);
      await notifier.removePayment(1);

      final state = container.read(paymentListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPaymentService.deletePayment(1)).called(1);
    });
  });
}
