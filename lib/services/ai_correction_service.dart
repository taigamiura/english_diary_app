import 'package:kiwi/repositories/ai_correction_repository.dart';

import '../models/ai_correction_model.dart';

abstract class AiCorrectionService {
  Future<List<AiCorrection>> fetchAiCorrections({required String diaryEntryId});
  Future<AiCorrection?> fetchAiCorrection(String id);
  Future<void> insertAiCorrection(AiCorrection correction);
  Future<void> updateAiCorrection(String id, AiCorrection correction);
  Future<void> deleteAiCorrection(String id);
}

class AiCorrectionServiceImpl implements AiCorrectionService {
  final AiCorrectionRepository repository;
  AiCorrectionServiceImpl(this.repository);

  @override
  Future<List<AiCorrection>> fetchAiCorrections({
    required String diaryEntryId,
  }) => repository.fetchAiCorrections(diaryEntryId: diaryEntryId);

  @override
  Future<AiCorrection?> fetchAiCorrection(String id) =>
      repository.fetchAiCorrection(id);

  @override
  Future<void> insertAiCorrection(AiCorrection correction) =>
      repository.insertAiCorrection(correction);

  @override
  Future<void> updateAiCorrection(String id, AiCorrection correction) =>
      repository.updateAiCorrection(id, correction);

  @override
  Future<void> deleteAiCorrection(String id) =>
      repository.deleteAiCorrection(id);
}
