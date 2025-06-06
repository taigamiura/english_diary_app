import 'package:english_diary_app/models/subscription_model.dart';
import 'package:english_diary_app/repositories/api_repository.dart';
import 'package:english_diary_app/utils/repository_logger.dart';

class SubscriptionRepository {
  static const String table = 'subscriptions';
  final ApiRepository apiRepository;
  SubscriptionRepository({ApiRepository? apiRepository}) : apiRepository = apiRepository ?? ApiRepository();

  Future<List<Subscription>> fetchSubscriptions({required String profileId}) =>
      logRequestResponse('SubscriptionRepository.fetchSubscriptions',
        () async {
          var query = apiRepository.client.from(table).select();
          query = query.eq('user_id', profileId);
          final result = await query;
          return List<Map<String, dynamic>>.from(result)
              .map((json) => Subscription.fromJson(json))
              .toList();
        },
        requestDetail: 'profileId: $profileId',
      );

  Future<Subscription?> fetchSubscription(int id) =>
      logRequestResponse('SubscriptionRepository.fetchSubscription',
        () async {
          final json = await apiRepository.fetchOne(table: table, id: id.toString());
          return json != null ? Subscription.fromJson(json) : null;
        },
        requestDetail: 'id: $id',
      );

  Future<void> insertSubscription(Subscription subscription) =>
      logRequestResponseVoid('SubscriptionRepository.insertSubscription',
        () async {
          await apiRepository.insertOne(table: table, data: subscription.toJson());
        },
        requestDetail: 'id: ${subscription.id}',
      );

  Future<void> updateSubscription(int id, Subscription subscription) =>
      logRequestResponseVoid('SubscriptionRepository.updateSubscription',
        () async {
          await apiRepository.updateOne(table: table, id: id.toString(), data: subscription.toJson());
        },
        requestDetail: 'id: $id',
      );

  Future<void> deleteSubscription(int id) =>
      logRequestResponseVoid('SubscriptionRepository.deleteSubscription',
        () async {
          await apiRepository.deleteOne(table: table, id: id.toString());
        },
        requestDetail: 'id: $id',
      );
}
