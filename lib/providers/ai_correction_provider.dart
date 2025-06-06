import '../repositories/ai_correction_repository.dart';
import '../services/ai_correction_service.dart';
import '../models/ai_correction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/utils/utils.dart' as utils;
import 'package:english_diary_app/providers/global_state_provider.dart';

// Repository Provider
final aiCorrectionRepositoryProvider = Provider<AiCorrectionRepository>((ref) => AiCorrectionRepository());

// Service Provider
final aiCorrectionServiceProvider = Provider<AiCorrectionService>((ref) {
  final repository = ref.read(aiCorrectionRepositoryProvider);
  return AiCorrectionServiceImpl(repository);
});

class AiCorrectionListState {
  final List<AiCorrection> items;
  final bool isLoading;
  final String? error;

  const AiCorrectionListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  AiCorrectionListState copyWith({
    List<AiCorrection>? items,
    bool? isLoading,
    String? error,
  }) {
    return AiCorrectionListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final aiCorrectionListProvider = StateNotifierProvider.autoDispose<AiCorrectionListNotifier, AiCorrectionListState>(
  (ref) => AiCorrectionListNotifier(ref),
);

class AiCorrectionListNotifier extends StateNotifier<AiCorrectionListState> {
  final Ref ref;
  AiCorrectionListNotifier(this.ref) : super(const AiCorrectionListState());

  Future<void> fetchAiCorrections({required String diaryEntryId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(aiCorrectionServiceProvider);
      final items = await service.fetchAiCorrections(diaryEntryId: diaryEntryId);
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> addAiCorrection(AiCorrection correction) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(aiCorrectionServiceProvider);
      await service.insertAiCorrection(correction);
      state = state.copyWith(items: [...state.items, correction], isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> updateAiCorrection(AiCorrection updated) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(aiCorrectionServiceProvider);
      await service.updateAiCorrection(updated.id, updated);
      final newItems = state.items.map((a) => a.id == updated.id ? updated : a).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> removeAiCorrection(String id) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(aiCorrectionServiceProvider);
      await service.deleteAiCorrection(id);
      final newItems = state.items.where((a) => a.id != id).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }
}
