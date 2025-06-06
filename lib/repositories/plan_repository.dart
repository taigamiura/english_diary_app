import 'package:english_diary_app/models/plan_model.dart';
import 'package:english_diary_app/repositories/api_repository.dart';
import 'package:english_diary_app/utils/repository_logger.dart';

class PlanRepository {
  static const String table = 'plans';
  final ApiRepository apiRepository;
  PlanRepository({ApiRepository? apiRepository}) : apiRepository = apiRepository ?? ApiRepository();

  Future<List<Plan>> fetchPlans() =>
      logRequestResponse('PlanRepository.fetchPlans',
        () async {
          var query = apiRepository.client.from(table).select();
          final result = await query;
          return List<Map<String, dynamic>>.from(result)
              .map((json) => Plan.fromJson(json))
              .toList();
        },
      );

  Future<Plan?> fetchPlan(int id) =>
      logRequestResponse('PlanRepository.fetchPlan',
        () async {
          final json = await apiRepository.fetchOne(table: table, id: id.toString());
          return json != null ? Plan.fromJson(json) : null;
        },
        requestDetail: 'id: $id',
      );

  Future<void> insertPlan(Plan plan) =>
      logRequestResponseVoid('PlanRepository.insertPlan',
        () async {
          await apiRepository.insertOne(table: table, data: plan.toJson());
        },
        requestDetail: 'id: ${plan.id}',
      );

  Future<void> updatePlan(int id, Plan plan) =>
      logRequestResponseVoid('PlanRepository.updatePlan',
        () async {
          await apiRepository.updateOne(table: table, id: id.toString(), data: plan.toJson());
        },
        requestDetail: 'id: $id',
      );

  Future<void> deletePlan(int id) =>
      logRequestResponseVoid('PlanRepository.deletePlan',
        () async {
          await apiRepository.deleteOne(table: table, id: id.toString());
        },
        requestDetail: 'id: $id',
      );
}
