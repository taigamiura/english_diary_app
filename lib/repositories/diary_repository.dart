import 'package:kiwi/models/diary_model.dart';
import 'package:kiwi/repositories/api_repository.dart';
import 'package:kiwi/utils/repository_logger.dart';

class DiaryRepository {
  static const String diaryTable = 'diary_entries';

  final ApiRepository apiRepository;

  DiaryRepository({ApiRepository? apiRepository})
    : apiRepository = apiRepository ?? ApiRepository();

  // 一覧取得
  Future<List<Diary>> fetchDiaries({
    required String userId,
    required DateTime from,
    required DateTime to,
    required int limit,
  }) {
    final String orderBy = 'created_at';
    final bool ascending = false;
    return logRequestResponse(
      'DiaryRepository.fetchDiaries',
      () async {
        var query = apiRepository.client.from(diaryTable).select();
        query = query.eq('user_id', userId);
        query = query.gte('created_at', from.toIso8601String());
        query = query.lte('created_at', to.toIso8601String());
        query.order(orderBy, ascending: ascending);
        if (limit != 0) query.limit(limit);
        final result = await query;
        return List<Map<String, dynamic>>.from(
          result,
        ).map((json) => Diary.fromJson(json)).toList();
      },
      requestDetail: 'userId: $userId, from: $from, to: $to, limit: $limit',
    );
  }

  // 特定日の日記取得
  Future<List<Diary>> fetchDateDiary({
    required String userId,
    required DateTime date,
  }) => logRequestResponse(
    'DiaryRepository.fetchDateDiary',
    () async {
      final query = apiRepository.client
          .from(diaryTable)
          .select()
          .eq('user_id', userId)
          .filter(
            'created_at',
            'eq',
            date.toIso8601String().substring(0, 10),
          ) // 'YYYY-MM-DD'
          .limit(1);
      final result = await query;
      return List<Map<String, dynamic>>.from(
        result,
      ).map((json) => Diary.fromJson(json)).toList();
    },
    requestDetail: 'userId: $userId, date: $date',
  );

  // 投稿済み月一覧取得
  Future<List<String>> fetchPostedMonths(String userId) =>
      logRequestResponse('DiaryRepository.fetchPostedMonths', () async {
        final result = await apiRepository.client.rpc(
          'get_posted_months',
          params: {'user_id_param': userId},
        );

        return (result as List)
            .map((row) => row['year_month'] as String)
            .toList();
      }, requestDetail: 'userId: $userId');

  // 1件取得
  Future<Diary?> fetchDiary(String id) =>
      logRequestResponse('DiaryRepository.fetchDiary', () async {
        final json = await apiRepository.fetchOne(table: diaryTable, id: id);
        return json != null ? Diary.fromJson(json) : null;
      }, requestDetail: 'id: $id');

  Future<int> fetchAverageTextInput({required String userId}) =>
      logRequestResponse('DiaryRepository.fetchAverageTextInput', () async {
        final result = await apiRepository.client.rpc(
          'avg_text_length',
          params: {'user_id_param': userId},
        );

        final avg = result is int ? result : 0;
        return avg;
      }, requestDetail: 'userId: $userId');

  // 1件INSERT
  Future<void> insertDiary(Diary diary) =>
      logRequestResponseVoid('DiaryRepository.insertDiary', () async {
        await apiRepository.insertOne(table: diaryTable, data: diary.toJson());
      }, requestDetail: 'diary: ${diary.toJson()}');

  // 複数INSERT
  Future<void> insertDiaries(List<Diary> diaries) =>
      logRequestResponseVoid('DiaryRepository.insertDiaries', () async {
        await apiRepository.insertMany(
          table: diaryTable,
          data: diaries.map((d) => d.toJson()).toList(),
        );
      }, requestDetail: 'count: ${diaries.length}');

  // 1件UPDATE
  Future<void> updateDiary(Diary diary) =>
      logRequestResponseVoid('DiaryRepository.updateDiary', () async {
        await apiRepository.updateOne(
          table: diaryTable,
          id: diary.id.toString(),
          data: diary.toJson(),
        );
      }, requestDetail: 'id: $diary.id.toString()');

  // 複数UPDATE
  Future<void> updateDiaries(List<Diary> diaries, {String idColumn = 'id'}) =>
      logRequestResponseVoid('DiaryRepository.updateDiaries', () async {
        await apiRepository.updateMany(
          table: diaryTable,
          data: diaries.map((d) => d.toJson()).toList(),
          idColumn: idColumn,
        );
      }, requestDetail: 'count: ${diaries.length}');

  // 1件DELETE
  Future<void> deleteDiary(String id) =>
      logRequestResponseVoid('DiaryRepository.deleteDiary', () async {
        await apiRepository.deleteOne(table: diaryTable, id: id);
      }, requestDetail: 'id: $id');

  // 複数DELETE
  Future<void> deleteDiaries(List<String> ids, {String idColumn = 'id'}) =>
      logRequestResponseVoid('DiaryRepository.deleteDiaries', () async {
        await apiRepository.deleteMany(
          table: diaryTable,
          ids: ids,
          idColumn: idColumn,
        );
      }, requestDetail: 'count: ${ids.length}');
}
