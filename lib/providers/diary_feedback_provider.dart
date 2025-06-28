import 'package:kiwi/repositories/diary_feedback_repository.dart';
import 'package:kiwi/services/diary_feedback_service.dart';
import 'package:kiwi/models/diary_feedback_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiwi/utils/utils.dart' as utils;
import 'package:kiwi/providers/global_state_provider.dart';

// Repository Provider
final diaryFeedbackRepositoryProvider = Provider<DiaryFeedbackRepository>(
  (ref) => DiaryFeedbackRepository(),
);
// Service Provider
final diaryFeedbackServiceProvider = Provider<DiaryFeedbackService>((ref) {
  final repository = ref.read(diaryFeedbackRepositoryProvider);
  return DiaryFeedbackServiceImpl(repository);
});

class DiaryFeedbackListState {
  final List<DiaryFeedback> items;
  final bool isLoading;
  final String? error;

  const DiaryFeedbackListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  DiaryFeedbackListState copyWith({
    List<DiaryFeedback>? items,
    bool? isLoading,
    String? error,
  }) {
    return DiaryFeedbackListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final diaryFeedbackListProvider = StateNotifierProvider.autoDispose<
  DiaryFeedbackListNotifier,
  DiaryFeedbackListState
>((ref) => DiaryFeedbackListNotifier(ref));

class DiaryFeedbackListNotifier extends StateNotifier<DiaryFeedbackListState> {
  final Ref ref;
  DiaryFeedbackListNotifier(this.ref) : super(const DiaryFeedbackListState());

  Future<void> fetchDiaryFeedbacks({required String diaryEntryId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryFeedbackServiceProvider);
      final items = await service.fetchDiaryFeedbacks(
        diaryEntryId: diaryEntryId,
      );
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

  Future<void> addDiaryFeedback(DiaryFeedback feedback) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryFeedbackServiceProvider);
      await service.insertDiaryFeedback(feedback);
      state = state.copyWith(
        items: [...state.items, feedback],
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

  Future<void> updateDiaryFeedback(DiaryFeedback updated) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryFeedbackServiceProvider);
      await service.updateDiaryFeedback(updated.id, updated);
      final newItems =
          state.items.map((f) => f.id == updated.id ? updated : f).toList();
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

  Future<void> removeDiaryFeedback(String id) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryFeedbackServiceProvider);
      await service.deleteDiaryFeedback(id);
      final newItems = state.items.where((f) => f.id != id).toList();
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
