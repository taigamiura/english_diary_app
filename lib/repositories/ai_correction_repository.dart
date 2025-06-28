import 'package:kiwi/models/ai_correction_model.dart';
import 'package:kiwi/repositories/api_repository.dart';
import 'package:kiwi/utils/repository_logger.dart';

class AiCorrectionRepository {
  static const String table = 'ai_corrections';
  final ApiRepository apiRepository;
  AiCorrectionRepository({ApiRepository? apiRepository})
    : apiRepository = apiRepository ?? ApiRepository();

  Future<List<AiCorrection>> fetchAiCorrections({
    required String diaryEntryId,
  }) => logRequestResponse(
    'AiCorrectionRepository.fetchAiCorrections',
    () async {
      var query = apiRepository.client.from(table).select();
      query = query.eq('diary_entry_id', diaryEntryId);
      final result = await query;
      return List<Map<String, dynamic>>.from(
        result,
      ).map((json) => AiCorrection.fromJson(json)).toList();
    },
    requestDetail: 'diaryEntryId: $diaryEntryId',
  );

  Future<AiCorrection?> fetchAiCorrection(String id) =>
      logRequestResponse('AiCorrectionRepository.fetchAiCorrection', () async {
        final json = await apiRepository.fetchOne(table: table, id: id);
        return json != null ? AiCorrection.fromJson(json) : null;
      }, requestDetail: 'id: $id');

  Future<void> insertAiCorrection(AiCorrection correction) =>
      logRequestResponseVoid(
        'AiCorrectionRepository.insertAiCorrection',
        () async {
          await apiRepository.insertOne(
            table: table,
            data: correction.toJson(),
          );
        },
        requestDetail: 'id: ${correction.id}',
      );

  Future<void> updateAiCorrection(String id, AiCorrection correction) =>
      logRequestResponseVoid(
        'AiCorrectionRepository.updateAiCorrection',
        () async {
          await apiRepository.updateOne(
            table: table,
            id: id,
            data: correction.toJson(),
          );
        },
        requestDetail: 'id: $id',
      );

  Future<void> deleteAiCorrection(String id) => logRequestResponseVoid(
    'AiCorrectionRepository.deleteAiCorrection',
    () async {
      await apiRepository.deleteOne(table: table, id: id);
    },
    requestDetail: 'id: $id',
  );
}
