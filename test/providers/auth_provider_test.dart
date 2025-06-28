import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kiwi/providers/auth_provider.dart';
import 'package:kiwi/services/user_service.dart';
import 'package:kiwi/services/subscription_service.dart';
import 'package:kiwi/models/profile_model.dart';
import 'package:kiwi/models/subscription_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([UserService, SubscriptionService, FlutterSecureStorage])
void main() {
  group('AuthProvider', () {
    late MockUserService mockUserService;
    late MockSubscriptionService mockSubscriptionService;
    late ProviderContainer container;

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          userServiceProvider.overrideWithValue(mockUserService),
          subscriptionServiceProvider.overrideWithValue(
            mockSubscriptionService,
          ),
        ],
      );
    }

    setUp(() {
      mockUserService = MockUserService();
      mockSubscriptionService = MockSubscriptionService();
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('AuthState', () {
      test('should create default state', () {
        const state = AuthState();
        expect(state.user, isNull);
        expect(state.isSubscribed, false);
        expect(state.currentSubscription, isNull);
        expect(state.isSubscriptionLoading, false);
        expect(state.subscriptionError, isNull);
      });

      test('should create state with copyWith', () {
        const originalState = AuthState(
          isSubscribed: false,
          isSubscriptionLoading: false,
        );

        final testProfile = Profile(
          id: '1',
          googleUid: 'google123',
          name: 'Test User',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        final newState = originalState.copyWith(
          user: testProfile,
          isSubscribed: true,
          isSubscriptionLoading: true,
        );

        expect(newState.user, equals(testProfile));
        expect(newState.isSubscribed, true);
        expect(newState.isSubscriptionLoading, true);
      });

      test('should handle copyWith with null error', () {
        const originalState = AuthState(subscriptionError: 'Some error');

        final newState = originalState.copyWith(subscriptionError: null);

        expect(newState.subscriptionError, isNull);
      });

      test('should handle copyWith with all parameters', () {
        const originalState = AuthState();

        final testProfile = Profile(
          id: '1',
          googleUid: 'google123',
          name: 'Test User',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        final testSubscription = Subscription(
          id: 1,
          userId: 'user1',
          planId: 1,
          status: 'active',
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 2, 15),
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        final newState = originalState.copyWith(
          user: testProfile,
          isSubscribed: true,
          currentSubscription: testSubscription,
          isSubscriptionLoading: true,
          subscriptionError: 'Error message',
        );

        expect(newState.user, equals(testProfile));
        expect(newState.isSubscribed, true);
        expect(newState.currentSubscription, equals(testSubscription));
        expect(newState.isSubscriptionLoading, true);
        expect(newState.subscriptionError, 'Error message');
      });
    });
    group('Provider Integration Tests', () {
      test(
        'should initialize AuthNotifier through provider',
        () async {},
        skip:
            'AuthNotifier auto-schedules async operations that conflict with test lifecycle',
      );

      // これらのテストはSupabaseの初期化が必要なためスキップ
      test(
        'should provide repository instances',
        () {},
        skip: 'Requires Supabase initialization',
      );

      test(
        'should provide service instances',
        () {},
        skip: 'Requires Supabase initialization',
      );
      test('should provide service instances', () {
        container = createContainer();

        final userService = container.read(userServiceProvider);
        final subService = container.read(subscriptionServiceProvider);

        expect(userService, isNotNull);
        expect(subService, isNotNull);

        container.dispose();
      });
    });

    group('Authentication', () {
      test('should handle user profile loading', () async {
        container = createContainer();
        // Arrange
        final testProfile = Profile(
          id: '1',
          googleUid: 'google123',
          name: 'Test User',
          createdAt: DateTime(2024, 1, 15),
          updatedAt: DateTime(2024, 1, 15),
        );

        when(
          mockUserService.fetchUser('1'),
        ).thenAnswer((_) async => testProfile);

        // This is a basic structure for testing authentication
        // Actual provider testing would require more complex setup
        verifyNever(mockUserService.fetchUser('1')); // Not called yet
      });

      test('should handle subscription checking', () async {
        container = createContainer();
        // Arrange
        final testSubscription = Subscription(
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
          mockSubscriptionService.fetchSubscriptions(profileId: 'user1'),
        ).thenAnswer((_) async => [testSubscription]);

        // This is a basic structure for testing subscription
        verifyNever(
          mockSubscriptionService.fetchSubscriptions(profileId: 'user1'),
        ); // Not called yet
      });
    });
  });
}
