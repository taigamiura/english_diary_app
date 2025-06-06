import 'package:english_diary_app/models/payment_model.dart';
import 'package:english_diary_app/repositories/api_repository.dart';
import 'package:english_diary_app/utils/repository_logger.dart';

class PaymentRepository {
  static const String table = 'payments';
  final ApiRepository apiRepository;
  PaymentRepository({ApiRepository? apiRepository}) : apiRepository = apiRepository ?? ApiRepository();

  Future<List<Payment>> fetchPayments({required String profileId}) =>
      logRequestResponse('PaymentRepository.fetchPayments',
        () async {
          var query = apiRepository.client.from(table).select();
          query = query.eq('user_id', profileId);
          final result = await query;
          return List<Map<String, dynamic>>.from(result)
              .map((json) => Payment.fromJson(json))
              .toList();
        },
        requestDetail: 'profileId: $profileId',
      );

  Future<Payment?> fetchPayment(int id) =>
      logRequestResponse('PaymentRepository.fetchPayment',
        () async {
          final json = await apiRepository.fetchOne(table: table, id: id.toString());
          return json != null ? Payment.fromJson(json) : null;
        },
        requestDetail: 'id: $id',
      );

  Future<void> insertPayment(Payment payment) =>
      logRequestResponseVoid('PaymentRepository.insertPayment',
        () async {
          await apiRepository.insertOne(table: table, data: payment.toJson());
        },
        requestDetail: 'id: ${payment.id}',
      );

  Future<void> updatePayment(int id, Payment payment) =>
      logRequestResponseVoid('PaymentRepository.updatePayment',
        () async {
          await apiRepository.updateOne(table: table, id: id.toString(), data: payment.toJson());
        },
        requestDetail: 'id: $id',
      );

  Future<void> deletePayment(int id) =>
      logRequestResponseVoid('PaymentRepository.deletePayment',
        () async {
          await apiRepository.deleteOne(table: table, id: id.toString());
        },
        requestDetail: 'id: $id',
      );
}
