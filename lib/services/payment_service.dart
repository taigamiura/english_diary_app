import 'package:kiwi/repositories/payment_repository.dart';
import 'package:kiwi/models/payment_model.dart';

abstract class PaymentService {
  Future<List<Payment>> fetchPayments({required String profileId});
  Future<Payment?> fetchPayment(int id);
  Future<void> insertPayment(Payment payment);
  Future<void> updatePayment(int id, Payment payment);
  Future<void> deletePayment(int id);
}

class PaymentServiceImpl implements PaymentService {
  final PaymentRepository repository;
  PaymentServiceImpl(this.repository);

  @override
  Future<List<Payment>> fetchPayments({required String profileId}) =>
      repository.fetchPayments(profileId: profileId);

  @override
  Future<Payment?> fetchPayment(int id) => repository.fetchPayment(id);

  @override
  Future<void> insertPayment(Payment payment) =>
      repository.insertPayment(payment);

  @override
  Future<void> updatePayment(int id, Payment payment) =>
      repository.updatePayment(id, payment);

  @override
  Future<void> deletePayment(int id) => repository.deletePayment(id);
}
