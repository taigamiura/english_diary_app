import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:english_diary_app/providers/plan_provider.dart';
import 'package:english_diary_app/services/plan_service.dart';
import 'package:english_diary_app/models/plan_model.dart';

// Mock classes manually defined
class MockPlanService extends Mock implements PlanService {
  @override
  Future<List<Plan>> fetchPlans() {
    return super.noSuchMethod(
      Invocation.method(#fetchPlans, []),
      returnValue: Future<List<Plan>>.value([]),
    );
  }

  @override
  Future<Plan?> fetchPlan(int id) {
    return super.noSuchMethod(
      Invocation.method(#fetchPlan, [id]),
      returnValue: Future<Plan?>.value(null),
    );
  }

  @override
  Future<void> insertPlan(Plan plan) {
    return super.noSuchMethod(
      Invocation.method(#insertPlan, [plan]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> updatePlan(int id, Plan plan) {
    return super.noSuchMethod(
      Invocation.method(#updatePlan, [id, plan]),
      returnValue: Future<void>.value(),
    );
  }

  @override
  Future<void> deletePlan(int id) {
    return super.noSuchMethod(
      Invocation.method(#deletePlan, [id]),
      returnValue: Future<void>.value(),
    );
  }
}

void main() {
  group('PlanProvider Tests', () {
    late ProviderContainer container;
    late MockPlanService mockPlanService;

    setUp(() {
      mockPlanService = MockPlanService();
      container = ProviderContainer(
        overrides: [planServiceProvider.overrideWithValue(mockPlanService)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('PlanListState initial state', () {
      const state = PlanListState();
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('PlanListState copyWith', () {
      const state = PlanListState();
      final plan = Plan(
        id: 1,
        name: 'Premium',
        description: 'Premium plan',
        priceMonthly: 9.99,
        priceYearly: 99.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final newState = state.copyWith(
        items: [plan],
        isLoading: true,
        error: 'test error',
      );

      expect(newState.items, [plan]);
      expect(newState.isLoading, true);
      expect(newState.error, 'test error');
    });

    test('fetchPlans success', () async {
      final plan = Plan(
        id: 1,
        name: 'Premium',
        description: 'Premium plan',
        priceMonthly: 9.99,
        priceYearly: 99.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(mockPlanService.fetchPlans()).thenAnswer((_) async => [plan]);

      final notifier = container.read(planListProvider.notifier);
      await notifier.fetchPlans();

      final state = container.read(planListProvider);
      expect(state.items, [plan]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPlanService.fetchPlans()).called(1);
    });

    test('fetchPlans failure', () async {
      when(mockPlanService.fetchPlans()).thenThrow(Exception('Network error'));

      final notifier = container.read(planListProvider.notifier);
      await notifier.fetchPlans();

      final state = container.read(planListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);

      verify(mockPlanService.fetchPlans()).called(1);
    });

    test('addPlan success', () async {
      final plan = Plan(
        id: 1,
        name: 'Premium',
        description: 'Premium plan',
        priceMonthly: 9.99,
        priceYearly: 99.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      when(mockPlanService.insertPlan(plan)).thenAnswer((_) async {});

      final notifier = container.read(planListProvider.notifier);
      await notifier.addPlan(plan);

      final state = container.read(planListProvider);
      expect(state.items, [plan]);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPlanService.insertPlan(plan)).called(1);
    });

    test('updatePlan success', () async {
      final originalPlan = Plan(
        id: 1,
        name: 'Basic',
        description: 'Basic plan',
        priceMonthly: 4.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updatedPlan = Plan(
        id: 1,
        name: 'Premium',
        description: 'Premium plan',
        priceMonthly: 9.99,
        priceYearly: 99.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container.read(planListProvider.notifier).state = const PlanListState()
          .copyWith(items: [originalPlan]);

      when(mockPlanService.updatePlan(1, updatedPlan)).thenAnswer((_) async {});

      final notifier = container.read(planListProvider.notifier);
      await notifier.updatePlan(updatedPlan);

      final state = container.read(planListProvider);
      expect(state.items.length, 1);
      expect(state.items.first.name, 'Premium');
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPlanService.updatePlan(1, updatedPlan)).called(1);
    });

    test('removePlan success', () async {
      final plan = Plan(
        id: 1,
        name: 'Premium',
        description: 'Premium plan',
        priceMonthly: 9.99,
        priceYearly: 99.99,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      // Set initial state
      container.read(planListProvider.notifier).state = const PlanListState()
          .copyWith(items: [plan]);

      when(mockPlanService.deletePlan(1)).thenAnswer((_) async {});

      final notifier = container.read(planListProvider.notifier);
      await notifier.removePlan(1);

      final state = container.read(planListProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);

      verify(mockPlanService.deletePlan(1)).called(1);
    });
  });
}
