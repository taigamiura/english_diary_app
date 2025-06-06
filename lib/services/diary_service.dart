import 'package:english_diary_app/repositories/diary_repository.dart';

import '../models/diary_model.dart';
import '../models/year_month.dart';

abstract class DiaryService {
  Future<List<Diary>> fetchDiaries({required String userId, required DateTime from, required DateTime to, required int limit});
  Future<List<Diary>> fetchDateDiary({required String userId, required DateTime date});
  Future<List<YearMonth>> fetchPostedMonths({required String userId});
  Future<Diary?> fetchDiary(String id);
  Future<int> fetchAverageTextInput({required String userId});
  Future<void> insertDiary(Diary diary);
  Future<void> updateDiary(String id, Diary diary);
  Future<void> deleteDiary(String id);
}

class DiaryServiceImpl implements DiaryService {
  final DiaryRepository repository;
  DiaryServiceImpl(this.repository);

  @override
  Future<List<Diary>> fetchDiaries({required String userId, required DateTime from, required DateTime to, required int limit}) => repository.fetchDiaries(userId: userId, from: from, to: to, limit: limit);

  @override
  Future<List<Diary>> fetchDateDiary({required String userId, required DateTime date}) =>
      repository.fetchDateDiary(userId: userId, date: date);

  @override
  Future<List<YearMonth>> fetchPostedMonths({required String userId}) async {
    final months = await repository.fetchPostedMonths(userId);
    return months
      .map((e) => YearMonth.fromString(e))
      .toList()
      ..sort((a, b) => b.compareTo(a));
  }

  @override
  Future<Diary?> fetchDiary(String id) => repository.fetchDiary(id);

  @override
  Future<int> fetchAverageTextInput({required String userId}) => repository.fetchAverageTextInput(userId: userId); 

  @override
  Future<void> insertDiary(Diary diary) => repository.insertDiary(diary);

  @override
  Future<void> updateDiary(String id, Diary diary) => repository.updateDiary(diary);

  @override
  Future<void> deleteDiary(String id) => repository.deleteDiary(id);
}
