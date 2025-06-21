import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:english_diary_app/services/subscription_service.dart';
import 'package:english_diary_app/repositories/subscription_repository.dart';
import 'package:english_diary_app/models/subscription_model.dart';

import 'subscription_service_test.mocks.dart';

@GenerateMocks([SubscriptionRepository])
void main() {
  group('SubscriptionServiceImpl', () {
    late SubscriptionServiceImpl service;
    late MockSubscriptionRepository mockRepository;

    setUp(() {
      mockRepository = MockSubscriptionRepository();
      service = SubscriptionServiceImpl(mockRepository);
    });

    group('fetchSubscriptions', () {
      test('should return subscriptions from repository', () async {
        // Arrange
        const profileId = 'profile1';
        final expectedSubscriptions = [
          Subscription(
            id: 1,
            userId: 'user1',
            planId: 1,
            status: 'active',
            startDate: DateTime(2024, 1, 15),
            endDate: DateTime(2024, 2, 15),
            createdAt: DateTime(2024, 1, 15),
            updatedAt: DateTime(2024, 1, 15),
          ),
        ];
        when(
          mockRepository.fetchSubscriptions(profileId: profileId),
        ).thenAnswer((_) async => expectedSubscriptions);

        // Act
        final result = await service.fetchSubscriptions(profileId: profileId);

        // Assert
        expect(result, equals(expectedSubscriptions));
        verify(
          mockRepository.fetchSubscriptions(profileId: profileId),
        ).called(1);
      });
    });

    group('fetchSubscription', () {
      test('should return subscription from repository', () async {
        // Arrange
        const subscriptionId = 1;
        final expectedSubscription = Subscription(
          id: subscriptionId,
          userId: 'user1',
          planId: 1,
          status: 'active',
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.fetchSubscription(subscriptionId),
        ).thenAnswer((_) async => expectedSubscription);

        // Act
        final result = await service.fetchSubscription(subscriptionId);

        // Assert
        expect(result, equals(expectedSubscription));
        verify(mockRepository.fetchSubscription(subscriptionId)).called(1);
      });

      test('should return null when subscription not found', () async {
        // Arrange
        const subscriptionId = 999;
        when(
          mockRepository.fetchSubscription(subscriptionId),
        ).thenAnswer((_) async => null);

        // Act
        final result = await service.fetchSubscription(subscriptionId);

        // Assert
        expect(result, isNull);
        verify(mockRepository.fetchSubscription(subscriptionId)).called(1);
      });
    });

    group('insertSubscription', () {
      test('should insert subscription via repository', () async {
        // Arrange
        final subscription = Subscription(
          id: 1,
          userId: 'user1',
          planId: 1,
          status: 'active',
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertSubscription(subscription),
        ).thenAnswer((_) async => {});

        // Act
        await service.insertSubscription(subscription);

        // Assert
        verify(mockRepository.insertSubscription(subscription)).called(1);
      });
    });

    group('updateSubscription', () {
      test('should update subscription via repository', () async {
        // Arrange
        const subscriptionId = 1;
        final subscription = Subscription(
          id: subscriptionId,
          userId: 'user1',
          planId: 1,
          status: 'active',
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updateSubscription(subscriptionId, subscription),
        ).thenAnswer((_) async => {});

        // Act
        await service.updateSubscription(subscriptionId, subscription);

        // Assert
        verify(
          mockRepository.updateSubscription(subscriptionId, subscription),
        ).called(1);
      });
    });

    group('deleteSubscription', () {
      test('should delete subscription via repository', () async {
        // Arrange
        const subscriptionId = 1;
        when(
          mockRepository.deleteSubscription(subscriptionId),
        ).thenAnswer((_) async => {});

        // Act
        await service.deleteSubscription(subscriptionId);

        // Assert
        verify(mockRepository.deleteSubscription(subscriptionId)).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exception from fetchSubscriptions', () async {
        // Arrange
        const profileId = 'profile1';
        when(
          mockRepository.fetchSubscriptions(profileId: profileId),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(
          () => service.fetchSubscriptions(profileId: profileId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from fetchSubscription', () async {
        // Arrange
        const subscriptionId = 1;
        when(
          mockRepository.fetchSubscription(subscriptionId),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => service.fetchSubscription(subscriptionId),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from insertSubscription', () async {
        // Arrange
        final subscription = Subscription(
          id: 1,
          userId: 'user1',
          planId: 1,
          status: 'active',
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.insertSubscription(subscription),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(
          () => service.insertSubscription(subscription),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from updateSubscription', () async {
        // Arrange
        const subscriptionId = 1;
        final subscription = Subscription(
          id: subscriptionId,
          userId: 'user1',
          planId: 1,
          status: 'active',
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );
        when(
          mockRepository.updateSubscription(subscriptionId, subscription),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => service.updateSubscription(subscriptionId, subscription),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from deleteSubscription', () async {
        // Arrange
        const subscriptionId = 1;
        when(
          mockRepository.deleteSubscription(subscriptionId),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => service.deleteSubscription(subscriptionId),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
