import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:english_diary_app/services/payment_service.dart';
import 'package:english_diary_app/repositories/payment_repository.dart';
import 'package:english_diary_app/models/payment_model.dart';

import 'payment_service_test.mocks.dart';

@GenerateMocks([PaymentRepository])
void main() {
  group('PaymentServiceImpl', () {
    late PaymentServiceImpl service;
    late MockPaymentRepository mockRepository;

    setUp(() {
      mockRepository = MockPaymentRepository();
      service = PaymentServiceImpl(mockRepository);
    });

    group('fetchPayments', () {
      test('should return payments from repository', () async {
        // Arrange
        const profileId = 'profile1';
        final expectedPayments = [
          Payment(
            id: 1,
            userId: 'user1',
            subscriptionId: 1,
            amount: 1000.0,
            currency: 'JPY',
            paymentDate: DateTime(2024, 1, 15),
            status: 'succeeded',
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
        ];
        when(
          mockRepository.fetchPayments(profileId: profileId),
        ).thenAnswer((_) async => expectedPayments);

        // Act
        final result = await service.fetchPayments(profileId: profileId);

        // Assert
        expect(result, equals(expectedPayments));
        verify(mockRepository.fetchPayments(profileId: profileId)).called(1);
      });
    });

    group('fetchPayment', () {
      test('should return payment from repository', () async {
        // Arrange
        const paymentId = 1;
        final expectedPayment = Payment(
          id: paymentId,
          userId: 'user1',
          subscriptionId: 1,
          amount: 1000.0,
          currency: 'JPY',
          paymentDate: DateTime(2024, 1, 15),
          status: 'succeeded',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.fetchPayment(paymentId),
        ).thenAnswer((_) async => expectedPayment);

        // Act
        final result = await service.fetchPayment(paymentId);

        // Assert
        expect(result, equals(expectedPayment));
        verify(mockRepository.fetchPayment(paymentId)).called(1);
      });

      test('should return null when payment not found', () async {
        // Arrange
        const paymentId = 999;
        when(
          mockRepository.fetchPayment(paymentId),
        ).thenAnswer((_) async => null);

        // Act
        final result = await service.fetchPayment(paymentId);

        // Assert
        expect(result, isNull);
        verify(mockRepository.fetchPayment(paymentId)).called(1);
      });
    });

    group('insertPayment', () {
      test('should insert payment via repository', () async {
        // Arrange
        final payment = Payment(
          id: 1,
          userId: 'user1',
          subscriptionId: 1,
          amount: 1000.0,
          currency: 'JPY',
          paymentDate: DateTime(2024, 1, 15),
          status: 'succeeded',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(mockRepository.insertPayment(payment)).thenAnswer((_) async => {});

        // Act
        await service.insertPayment(payment);

        // Assert
        verify(mockRepository.insertPayment(payment)).called(1);
      });
    });

    group('updatePayment', () {
      test('should update payment via repository', () async {
        // Arrange
        const paymentId = 1;
        final payment = Payment(
          id: paymentId,
          userId: 'user1',
          subscriptionId: 1,
          amount: 1000.0,
          currency: 'JPY',
          paymentDate: DateTime(2024, 1, 15),
          status: 'succeeded',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updatePayment(paymentId, payment),
        ).thenAnswer((_) async => {});

        // Act
        await service.updatePayment(paymentId, payment);

        // Assert
        verify(mockRepository.updatePayment(paymentId, payment)).called(1);
      });
    });

    group('deletePayment', () {
      test('should delete payment via repository', () async {
        // Arrange
        const paymentId = 1;
        when(
          mockRepository.deletePayment(paymentId),
        ).thenAnswer((_) async => {});

        // Act
        await service.deletePayment(paymentId);

        // Assert
        verify(mockRepository.deletePayment(paymentId)).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exception from fetchPayments', () async {
        // Arrange
        const profileId = 'profile1';
        when(
          mockRepository.fetchPayments(profileId: profileId),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => service.fetchPayments(profileId: profileId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from fetchPayment', () async {
        // Arrange
        const paymentId = 1;
        when(
          mockRepository.fetchPayment(paymentId),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => service.fetchPayment(paymentId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from insertPayment', () async {
        // Arrange
        final payment = Payment(
          id: 1,
          userId: 'user1',
          subscriptionId: 1,
          amount: 1000.0,
          currency: 'JPY',
          paymentDate: DateTime(2024, 1, 15),
          status: 'succeeded',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertPayment(payment),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(() => service.insertPayment(payment), throwsA(isA<Exception>()));
      });

      test('should propagate exception from updatePayment', () async {
        // Arrange
        const paymentId = 1;
        final payment = Payment(
          id: paymentId,
          userId: 'user1',
          subscriptionId: 1,
          amount: 1000.0,
          currency: 'JPY',
          paymentDate: DateTime(2024, 1, 15),
          status: 'succeeded',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updatePayment(paymentId, payment),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => service.updatePayment(paymentId, payment),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from deletePayment', () async {
        // Arrange
        const paymentId = 1;
        when(
          mockRepository.deletePayment(paymentId),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => service.deletePayment(paymentId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
