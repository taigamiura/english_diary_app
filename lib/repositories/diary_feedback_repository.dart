import 'package:kiwi/models/diary_feedback_model.dart';
import 'package:kiwi/repositories/api_repository.dart';
import 'package:kiwi/utils/repository_logger.dart';

class DiaryFeedbackRepository {
  static const String table = 'diary_feedbacks';
  final ApiRepository apiRepository;
  DiaryFeedbackRepository({ApiRepository? apiRepository})
    : apiRepository = apiRepository ?? ApiRepository();

  Future<List<DiaryFeedback>> fetchDiaryFeedbacks({
    required String diaryEntryId,
  }) => logRequestResponse(
    'DiaryFeedbackRepository.fetchDiaryFeedbacks',
    () async {
      var query = apiRepository.client.from(table).select();
      query = query.eq('diary_entry_id', diaryEntryId);
      final result = await query;
      return List<Map<String, dynamic>>.from(
        result,
      ).map((json) => DiaryFeedback.fromJson(json)).toList();
    },
    requestDetail: 'diaryEntryId: $diaryEntryId',
  );

  Future<DiaryFeedback?> fetchDiaryFeedback(String id) => logRequestResponse(
    'DiaryFeedbackRepository.fetchDiaryFeedback',
    () async {
      final json = await apiRepository.fetchOne(table: table, id: id);
      return json != null ? DiaryFeedback.fromJson(json) : null;
    },
    requestDetail: 'id: $id',
  );

  Future<void> insertDiaryFeedback(DiaryFeedback feedback) =>
      logRequestResponseVoid(
        'DiaryFeedbackRepository.insertDiaryFeedback',
        () async {
          await apiRepository.insertOne(table: table, data: feedback.toJson());
        },
        requestDetail: 'id: ${feedback.id}',
      );

  Future<void> updateDiaryFeedback(String id, DiaryFeedback feedback) =>
      logRequestResponseVoid(
        'DiaryFeedbackRepository.updateDiaryFeedback',
        () async {
          await apiRepository.updateOne(
            table: table,
            id: id,
            data: feedback.toJson(),
          );
        },
        requestDetail: 'id: $id',
      );

  Future<void> deleteDiaryFeedback(String id) => logRequestResponseVoid(
    'DiaryFeedbackRepository.deleteDiaryFeedback',
    () async {
      await apiRepository.deleteOne(table: table, id: id);
    },
    requestDetail: 'id: $id',
  );
}
