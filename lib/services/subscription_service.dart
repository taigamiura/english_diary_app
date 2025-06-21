import 'package:english_diary_app/repositories/subscription_repository.dart';
import 'package:english_diary_app/models/subscription_model.dart';

abstract class SubscriptionService {
  Future<List<Subscription>> fetchSubscriptions({required String profileId});
  Future<Subscription?> fetchSubscription(int id);
  Future<void> insertSubscription(Subscription subscription);
  Future<void> updateSubscription(int id, Subscription subscription);
  Future<void> deleteSubscription(int id);
}

class SubscriptionServiceImpl implements SubscriptionService {
  final SubscriptionRepository repository;
  SubscriptionServiceImpl(this.repository);

  @override
  Future<List<Subscription>> fetchSubscriptions({required String profileId}) =>
      repository.fetchSubscriptions(profileId: profileId);

  @override
  Future<Subscription?> fetchSubscription(int id) =>
      repository.fetchSubscription(id);

  @override
  Future<void> insertSubscription(Subscription subscription) =>
      repository.insertSubscription(subscription);

  @override
  Future<void> updateSubscription(int id, Subscription subscription) =>
      repository.updateSubscription(id, subscription);

  @override
  Future<void> deleteSubscription(int id) => repository.deleteSubscription(id);
}
