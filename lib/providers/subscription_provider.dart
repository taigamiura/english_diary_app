import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/providers/global_state_provider.dart';
import 'package:english_diary_app/models/subscription_model.dart';
import 'package:english_diary_app/services/subscription_service.dart';
import 'package:english_diary_app/repositories/subscription_repository.dart';
import 'package:english_diary_app/utils/utils.dart' as utils;

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(),
);

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return SubscriptionServiceImpl(repository);
});

class SubscriptionListState {
  final List<Subscription> items;
  final bool isLoading;
  final String? error;

  const SubscriptionListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  SubscriptionListState copyWith({
    List<Subscription>? items,
    bool? isLoading,
    String? error,
  }) {
    return SubscriptionListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final subscriptionListProvider = StateNotifierProvider.autoDispose<
  SubscriptionListNotifier,
  SubscriptionListState
>((ref) => SubscriptionListNotifier(ref));

class SubscriptionListNotifier extends StateNotifier<SubscriptionListState> {
  final Ref ref;
  SubscriptionListNotifier(this.ref) : super(const SubscriptionListState());

  Future<void> fetchSubscriptions({required String profileId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(subscriptionServiceProvider);
      final items = await service.fetchSubscriptions(profileId: profileId);
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(
        error: utils.friendlyErrorMessage(e),
        isLoading: false,
      );
    } finally {
      loading.state = false;
    }
  }

  Future<void> addSubscription(Subscription subscription) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(subscriptionServiceProvider);
      await service.insertSubscription(subscription);
      state = state.copyWith(
        items: [...state.items, subscription],
        isLoading: false,
      );
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(
        error: utils.friendlyErrorMessage(e),
        isLoading: false,
      );
    } finally {
      loading.state = false;
    }
  }

  Future<void> updateSubscription(Subscription updated) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(subscriptionServiceProvider);
      await service.updateSubscription(updated.id, updated);
      final newItems =
          state.items.map((s) => s.id == updated.id ? updated : s).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(
        error: utils.friendlyErrorMessage(e),
        isLoading: false,
      );
    } finally {
      loading.state = false;
    }
  }

  Future<void> removeSubscription(int id) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(subscriptionServiceProvider);
      await service.deleteSubscription(id);
      final newItems = state.items.where((s) => s.id != id).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(
        error: utils.friendlyErrorMessage(e),
        isLoading: false,
      );
    } finally {
      loading.state = false;
    }
  }
}
