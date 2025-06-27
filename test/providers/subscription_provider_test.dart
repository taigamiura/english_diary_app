import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:kiwi/providers/subscription_provider.dart';
import 'package:kiwi/services/subscription_service.dart';
import 'package:kiwi/models/subscription_model.dart';

// Mock classes manually defined
class MockSubscriptionService extends Mock implements SubscriptionService {
  @override
  Future<List<Subscription>> fetchSubscriptions({required String profileId}) {
    return super.noSuchMethod(
      Invocation.method(#fetchSubscriptions, [], {#profileId: profileId}),
      returnValue: Future<List<Subscription>>.value([]),
    );
  }

  @override
  Future<Subscription?> fetchSubscription(int id) {
    return super.noSuchMethod(
      Invocation.method(#fetchSubscription, [id]),
      returnValue: Future<Subscription?>.value(null),
    );
  }

  @override
  Future<void> insertSubscription(Subscription subscription) {
    return super.noSuchMethod(
      Invocation.method(#insertSubscription, [subscription]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> updateSubscription(int id, Subscription subscription) {
    return super.noSuchMethod(
      Invocation.method(#updateSubscription, [id, subscription]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> deleteSubscription(int id) {
    return super.noSuchMethod(
      Invocation.method(#deleteSubscription, [id]),
      returnValue: Future<void>.value(),
    );
  }
}

void main() {
  group('SubscriptionProvider Tests', () {
    late ProviderContainer container;
    late MockSubscriptionService mockSubscriptionService;

    setUp(() {
      mockSubscriptionService = MockSubscriptionService();
      container = ProviderContainer(
        overrides: [
          subscriptionServiceProvider.overrideWithValue(
            mockSubscriptionService,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('SubscriptionListState initial state', () {
      const state = SubscriptionListState();
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('SubscriptionListState copyWith', () {
      const state = SubscriptionListState();
      final subscription = Subscription(
        id: 1,
        userId: 'test-user',
        planId: 1,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final newState = state.copyWith(
        items: [subscription],
        isLoading: true,
        error: 'test error',
      );

      expect(newState.items, [subscription]);
      expect(newState.isLoading, true);
      expect(newState.error, 'test error');
    });

    test('fetchSubscriptions success', () async {
      final subscription = Subscription(
        id: 1,
        userId: 'test-user',
        planId: 1,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(
        mockSubscriptionService.fetchSubscriptions(profileId: 'test-profile'),
      ).thenAnswer((_) async => [subscription]);

      final notifier = container.read(subscriptionListProvider.notifier);
      await notifier.fetchSubscriptions(profileId: 'test-profile');

      final state = container.read(subscriptionListProvider);
      expect(state.items, [subscription]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(
        mockSubscriptionService.fetchSubscriptions(profileId: 'test-profile'),
      ).called(1);
    });

    test('fetchSubscriptions failure', () async {
      when(
        mockSubscriptionService.fetchSubscriptions(profileId: 'test-profile'),
      ).thenThrow(Exception('Network error'));

      final notifier = container.read(subscriptionListProvider.notifier);
      await notifier.fetchSubscriptions(profileId: 'test-profile');

      final state = container.read(subscriptionListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);

      verify(
        mockSubscriptionService.fetchSubscriptions(profileId: 'test-profile'),
      ).called(1);
    });

    test('addSubscription success', () async {
      final subscription = Subscription(
        id: 1,
        userId: 'test-user',
        planId: 1,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(
        mockSubscriptionService.insertSubscription(subscription),
      ).thenAnswer((_) async => {});

      final notifier = container.read(subscriptionListProvider.notifier);
      await notifier.addSubscription(subscription);

      final state = container.read(subscriptionListProvider);
      expect(state.items, [subscription]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(
        mockSubscriptionService.insertSubscription(subscription),
      ).called(1);
    });

    test('updateSubscription success', () async {
      final originalSubscription = Subscription(
        id: 1,
        userId: 'test-user',
        planId: 1,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 6, 30),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updatedSubscription = Subscription(
        id: 1,
        userId: 'test-user',
        planId: 1,
        status: 'canceled',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 6, 30),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 6, 1),
      );

      // Set initial state
      container.read(subscriptionListProvider.notifier).state =
          const SubscriptionListState().copyWith(items: [originalSubscription]);

      when(
        mockSubscriptionService.updateSubscription(1, updatedSubscription),
      ).thenAnswer((_) async => {});

      final notifier = container.read(subscriptionListProvider.notifier);
      await notifier.updateSubscription(updatedSubscription);

      final state = container.read(subscriptionListProvider);
      expect(state.items.length, 1);
      expect(state.items.first.status, 'canceled');
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(
        mockSubscriptionService.updateSubscription(1, updatedSubscription),
      ).called(1);
    });

    test('removeSubscription success', () async {
      final subscription = Subscription(
        id: 1,
        userId: 'test-user',
        planId: 1,
        status: 'active',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container.read(subscriptionListProvider.notifier).state =
          const SubscriptionListState().copyWith(items: [subscription]);

      when(
        mockSubscriptionService.deleteSubscription(1),
      ).thenAnswer((_) async => {});

      final notifier = container.read(subscriptionListProvider.notifier);
      await notifier.removeSubscription(1);

      final state = container.read(subscriptionListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockSubscriptionService.deleteSubscription(1)).called(1);
    });
  });
}
