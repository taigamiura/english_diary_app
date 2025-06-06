import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/providers/global_state_provider.dart';
import '../models/plan_model.dart';
import '../services/plan_service.dart';
import '../repositories/plan_repository.dart';
import 'package:english_diary_app/utils/utils.dart' as utils;

final planRepositoryProvider = Provider<PlanRepository>((ref) => PlanRepository());

final planServiceProvider = Provider<PlanService>((ref) {
  final repository = ref.read(planRepositoryProvider);
  return PlanServiceImpl(repository);
});

class PlanListState {
  final List<Plan> items;
  final bool isLoading;
  final String? error;

  const PlanListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  PlanListState copyWith({
    List<Plan>? items,
    bool? isLoading,
    String? error,
  }) {
    return PlanListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final planListProvider = StateNotifierProvider.autoDispose<PlanListNotifier, PlanListState>(
  (ref) => PlanListNotifier(ref),
);

class PlanListNotifier extends StateNotifier<PlanListState> {
  final Ref ref;
  PlanListNotifier(this.ref) : super(const PlanListState());

  Future<void> fetchPlans() async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(planServiceProvider);
      final items = await service.fetchPlans();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> addPlan(Plan plan) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(planServiceProvider);
      await service.insertPlan(plan);
      state = state.copyWith(items: [...state.items, plan], isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> updatePlan(Plan updated) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(planServiceProvider);
      await service.updatePlan(updated.id, updated);
      final newItems = state.items.map((p) => p.id == updated.id ? updated : p).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> removePlan(int id) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(planServiceProvider);
      await service.deletePlan(id);
      final newItems = state.items.where((p) => p.id != id).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }
}
