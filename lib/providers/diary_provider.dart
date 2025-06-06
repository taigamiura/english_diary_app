import '../repositories/diary_repository.dart';
import '../services/diary_service.dart';
import '../models/diary_model.dart';
import '../models/year_month.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/utils/utils.dart' as utils;
import 'package:english_diary_app/providers/global_state_provider.dart';
import 'package:english_diary_app/providers/auth_provider.dart';

// Repository Provider
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) => DiaryRepository());

// Service Provider
final diaryServiceProvider = Provider<DiaryService>((ref) {
  final repository = ref.read(diaryRepositoryProvider);
  return DiaryServiceImpl(repository);
});

class DiaryListState {
  final List<Diary> items;
  final List<YearMonth> months;
  final int averageTextInput;
  final bool hasTodayDiary;
  final bool isLoading;
  final String? error;

  const DiaryListState({
    this.items = const [],
    this.months = const [],
    this.averageTextInput = 0,
    this.isLoading = false,
    this.hasTodayDiary = false,
    this.error,
  });

  DiaryListState copyWith({
    List<Diary>? items,
    List<YearMonth>? months,
    int? averageTextInput,
    bool? isLoading,
    bool? hasTodayDiary,
    String? error,
  }) {
    return DiaryListState(
      items: items ?? this.items,
      months: months ?? this.months,
      averageTextInput: averageTextInput ?? this.averageTextInput,
      isLoading: isLoading ?? this.isLoading,
      hasTodayDiary: hasTodayDiary ?? this.hasTodayDiary,
      error: error,
    );
  }
}

final diaryListProvider = StateNotifierProvider.autoDispose<DiaryListNotifier, DiaryListState>(
  (ref) => DiaryListNotifier(ref),
);

class DiaryListNotifier extends StateNotifier<DiaryListState> {
  final Ref ref;
  DiaryListNotifier(this.ref) : super(const DiaryListState());

  Future<void> fetchDiaries({required String userId, DateTime? from, DateTime? to, required int limit}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryServiceProvider);
      final items = await service.fetchDiaries(
        userId: userId,
        from: from ?? DateTime(2000, 1, 1), // 2000年1月1日をデフォルト開始日とする
        to: to ?? DateTime.now(),           // デフォルト終了日は現在日時
        limit: limit,                 // デフォルトは30件
      );
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }
  Future<void> fetchDateDiary({required String userId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryServiceProvider);
      final today = DateTime.now();
      final item = await service.fetchDiaries(userId: userId, from: today, to: today, limit: 1);
      final hasTodayDiary = item.isNotEmpty;
      state = state.copyWith(
        items: item,
        hasTodayDiary: hasTodayDiary,
        isLoading: false,
      );
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }
  Future<void> fetchPostedMonths({required String userId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryServiceProvider);
      final months = await service.fetchPostedMonths(userId: userId);
      final uniqueSortedMonths = months.toSet().toList()
        ..sort((a, b) => b.compareTo(a));
      state = state.copyWith(months: uniqueSortedMonths, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> fetchAverageTextInput({required String userId}) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryServiceProvider);
      final average = await service.fetchAverageTextInput(userId: userId);
      state = state.copyWith(averageTextInput: average, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> addDiaryFromInput({
    required String textInput,
    String? voiceInputUrl,
    String? transcription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final userId = ref.read(authStateProvider).user?.id;
      if (userId == null) throw Exception('ユーザー情報が取得できません');
      createdAt ??= DateTime.now();
      updatedAt ??= createdAt;
      final diary = Diary(
        userId: userId,
        textInput: textInput,
        voiceInputUrl: voiceInputUrl,
        transcription: transcription,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final service = ref.read(diaryServiceProvider);
      await service.insertDiary(diary);
      state = state.copyWith(items: [...state.items, diary], isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> updateDiary({
    required String id,
    required String textInput,
    String? voiceInputUrl,
    String? transcription,
  }) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final userId = ref.read(authStateProvider).user?.id;
      if (userId == null) throw Exception('ユーザー情報が取得できません');
      final oldDiary = state.items.firstWhere(
        (d) => d.id == id && d.userId == userId,
        orElse: () => throw Exception('該当の日記が見つかりません'),
      );
      final diary = Diary(
        id: oldDiary.id,
        userId: oldDiary.userId,
        textInput: textInput,
        voiceInputUrl: voiceInputUrl ?? oldDiary.voiceInputUrl,
        transcription: transcription ?? oldDiary.transcription,
        createdAt: oldDiary.createdAt,
      );
      final service = ref.read(diaryServiceProvider);
      await service.updateDiary(id, diary);
      final newItems = state.items.map((d) => d.id == id ? diary : d).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }

  Future<void> removeDiary(String id) async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final service = ref.read(diaryServiceProvider);
      await service.deleteDiary(id);
      final newItems = state.items.where((d) => d.id != id).toList();
      state = state.copyWith(items: newItems, isLoading: false);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = state.copyWith(error: utils.friendlyErrorMessage(e), isLoading: false);
    } finally {
      loading.state = false;
    }
  }
}
