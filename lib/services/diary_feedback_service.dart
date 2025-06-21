import 'package:english_diary_app/repositories/diary_feedback_repository.dart';
import 'package:english_diary_app/models/diary_feedback_model.dart';

abstract class DiaryFeedbackService {
  Future<List<DiaryFeedback>> fetchDiaryFeedbacks({
    required String diaryEntryId,
  });
  Future<DiaryFeedback?> fetchDiaryFeedback(String id);
  Future<void> insertDiaryFeedback(DiaryFeedback feedback);
  Future<void> updateDiaryFeedback(String id, DiaryFeedback feedback);
  Future<void> deleteDiaryFeedback(String id);
}

class DiaryFeedbackServiceImpl implements DiaryFeedbackService {
  final DiaryFeedbackRepository service;
  DiaryFeedbackServiceImpl(this.service);

  @override
  Future<List<DiaryFeedback>> fetchDiaryFeedbacks({
    required String diaryEntryId,
  }) => service.fetchDiaryFeedbacks(diaryEntryId: diaryEntryId);

  @override
  Future<DiaryFeedback?> fetchDiaryFeedback(String id) =>
      service.fetchDiaryFeedback(id);

  @override
  Future<void> insertDiaryFeedback(DiaryFeedback feedback) =>
      service.insertDiaryFeedback(feedback);

  @override
  Future<void> updateDiaryFeedback(String id, DiaryFeedback feedback) =>
      service.updateDiaryFeedback(id, feedback);

  @override
  Future<void> deleteDiaryFeedback(String id) =>
      service.deleteDiaryFeedback(id);
}
