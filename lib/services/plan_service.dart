import 'package:english_diary_app/repositories/plan_repository.dart';
import 'package:english_diary_app/models/plan_model.dart';

abstract class PlanService {
  Future<List<Plan>> fetchPlans();
  Future<Plan?> fetchPlan(int id);
  Future<void> insertPlan(Plan plan);
  Future<void> updatePlan(int id, Plan plan);
  Future<void> deletePlan(int id);
}

class PlanServiceImpl implements PlanService {
  final PlanRepository repository;
  PlanServiceImpl(this.repository);

  @override
  Future<List<Plan>> fetchPlans() => repository.fetchPlans();

  @override
  Future<Plan?> fetchPlan(int id) => repository.fetchPlan(id);

  @override
  Future<void> insertPlan(Plan plan) => repository.insertPlan(plan);

  @override
  Future<void> updatePlan(int id, Plan plan) => repository.updatePlan(id, plan);

  @override
  Future<void> deletePlan(int id) => repository.deletePlan(id);
}
