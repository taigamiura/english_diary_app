import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kiwi/services/plan_service.dart';
import 'package:kiwi/repositories/plan_repository.dart';
import 'package:kiwi/models/plan_model.dart';

import 'plan_service_test.mocks.dart';

@GenerateMocks([PlanRepository])
void main() {
  group('PlanServiceImpl', () {
    late PlanServiceImpl service;
    late MockPlanRepository mockRepository;

    setUp(() {
      mockRepository = MockPlanRepository();
      service = PlanServiceImpl(mockRepository);
    });

    group('fetchPlans', () {
      test('should return plans from repository', () async {
        // Arrange
        final expectedPlans = [
          Plan(
            id: 1,
            name: 'Basic Plan',
            description: 'Basic features for beginners',
            priceMonthly: 500.0,
            priceYearly: 5000.0,
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
        ];
        when(
          mockRepository.fetchPlans(),
        ).thenAnswer((_) async => expectedPlans);

        // Act
        final result = await service.fetchPlans();

        // Assert
        expect(result, equals(expectedPlans));
        verify(mockRepository.fetchPlans()).called(1);
      });
    });

    group('fetchPlan', () {
      test('should return plan from repository', () async {
        // Arrange
        const planId = 1;
        final expectedPlan = Plan(
          id: planId,
          name: 'Basic Plan',
          description: 'Basic features for beginners',
          priceMonthly: 500.0,
          priceYearly: 5000.0,
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.fetchPlan(planId),
        ).thenAnswer((_) async => expectedPlan);

        // Act
        final result = await service.fetchPlan(planId);

        // Assert
        expect(result, equals(expectedPlan));
        verify(mockRepository.fetchPlan(planId)).called(1);
      });

      test('should return null when plan not found', () async {
        // Arrange
        const planId = 999;
        when(mockRepository.fetchPlan(planId)).thenAnswer((_) async => null);

        // Act
        final result = await service.fetchPlan(planId);

        // Assert
        expect(result, isNull);
        verify(mockRepository.fetchPlan(planId)).called(1);
      });
    });

    group('insertPlan', () {
      test('should insert plan via repository', () async {
        // Arrange
        final plan = Plan(
          id: 1,
          name: 'Basic Plan',
          description: 'Basic features for beginners',
          priceMonthly: 500.0,
          priceYearly: 5000.0,
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(mockRepository.insertPlan(plan)).thenAnswer((_) async => {});

        // Act
        await service.insertPlan(plan);

        // Assert
        verify(mockRepository.insertPlan(plan)).called(1);
      });
    });

    group('updatePlan', () {
      test('should update plan via repository', () async {
        // Arrange
        const planId = 1;
        final plan = Plan(
          id: planId,
          name: 'Basic Plan',
          description: 'Basic features for beginners',
          priceMonthly: 500.0,
          priceYearly: 5000.0,
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updatePlan(planId, plan),
        ).thenAnswer((_) async => {});

        // Act
        await service.updatePlan(planId, plan);

        // Assert
        verify(mockRepository.updatePlan(planId, plan)).called(1);
      });
    });

    group('deletePlan', () {
      test('should delete plan via repository', () async {
        // Arrange
        const planId = 1;
        when(mockRepository.deletePlan(planId)).thenAnswer((_) async => {});

        // Act
        await service.deletePlan(planId);

        // Assert
        verify(mockRepository.deletePlan(planId)).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exception from fetchPlans', () async {
        // Arrange
        when(
          mockRepository.fetchPlans(),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(() => service.fetchPlans(), throwsA(isA<Exception>()));
      });

      test('should propagate exception from fetchPlan', () async {
        // Arrange
        const planId = 1;
        when(
          mockRepository.fetchPlan(planId),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => service.fetchPlan(planId), throwsA(isA<Exception>()));
      });

      test('should propagate exception from insertPlan', () async {
        // Arrange
        final plan = Plan(
          id: 1,
          name: 'Premium Plan',
          description: 'Advanced features for professionals',
          priceMonthly: 1000.0,
          priceYearly: 10000.0,
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertPlan(plan),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(() => service.insertPlan(plan), throwsA(isA<Exception>()));
      });

      test('should propagate exception from updatePlan', () async {
        // Arrange
        const planId = 1;
        final plan = Plan(
          id: planId,
          name: 'Basic Plan',
          description: 'Basic features for beginners',
          priceMonthly: 500.0,
          priceYearly: 5000.0,
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updatePlan(planId, plan),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => service.updatePlan(planId, plan),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from deletePlan', () async {
        // Arrange
        const planId = 1;
        when(
          mockRepository.deletePlan(planId),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(() => service.deletePlan(planId), throwsA(isA<Exception>()));
      });
    });
  });
}
