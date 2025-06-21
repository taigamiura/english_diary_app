import 'package:english_diary_app/repositories/payment_repository.dart';
import 'package:english_diary_app/services/payment_service.dart';
import 'package:english_diary_app/models/payment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/utils/utils.dart' as utils;
import 'package:english_diary_app/providers/global_state_provider.dart';

// Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepository(),
);
// Service Provider
final paymentServiceProvider = Provider<PaymentService>((ref) {
  final repository = ref.read(paymentRepositoryProvider);
  return PaymentServiceImpl(repository);
});

class PaymentListState {
  final List<Payment> items;
  final bool isLoading;
  final String? error;

  const PaymentListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  PaymentListState copyWith({
    List<Payment>? items,
    bool? isLoading,
    String? error,
  }) {
    return PaymentListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final paymentListProvider =
    StateNotifierProvider.autoDispose<PaymentListNotifier, PaymentListState>(
      (ref) => PaymentListNotifier(ref),
    );

class PaymentListNotifier extends StateNotifier<PaymentListState> {
  final Ref ref;
  PaymentListNotifier(this.ref) : super(const PaymentListState());

  Future<void> fetchPayments({required String profileId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(paymentServiceProvider);
      final items = await service.fetchPayments(profileId: profileId);
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

  Future<void> addPayment(Payment payment) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(paymentServiceProvider);
      await service.insertPayment(payment);
      state = state.copyWith(
        items: [...state.items, payment],
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

  Future<void> updatePayment(Payment updated) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(paymentServiceProvider);
      await service.updatePayment(updated.id, updated);
      final newItems =
          state.items.map((p) => p.id == updated.id ? updated : p).toList();
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

  Future<void> removePayment(int id) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(paymentServiceProvider);
      await service.deletePayment(id);
      final newItems = state.items.where((p) => p.id != id).toList();
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
