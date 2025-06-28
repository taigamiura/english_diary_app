import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kiwi/services/user_service.dart';
import 'package:kiwi/repositories/profile_repository.dart';
import 'package:kiwi/models/profile_model.dart';

import 'user_service_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  group('UserService Tests', () {
    late MockProfileRepository mockRepository;
    late UserService userService;

    setUp(() {
      mockRepository = MockProfileRepository();
      userService = UserServiceImpl(mockRepository);
    });

    group('fetchUser', () {
      test('should return Profile when repository returns data', () async {
        // Arrange
        const userId = 'test_user_id';
        final expectedProfile = Profile(
          id: userId,
          googleUid: 'google_123',
          name: 'Test User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        when(
          mockRepository.fetchProfile(userId),
        ).thenAnswer((_) async => expectedProfile);

        // Act
        final result = await userService.fetchUser(userId);

        // Assert
        expect(result, equals(expectedProfile));
        verify(mockRepository.fetchProfile(userId)).called(1);
      });

      test('should return null when repository returns null', () async {
        // Arrange
        const userId = 'non_existent_user';
        when(mockRepository.fetchProfile(userId)).thenAnswer((_) async => null);

        // Act
        final result = await userService.fetchUser(userId);

        // Assert
        expect(result, isNull);
        verify(mockRepository.fetchProfile(userId)).called(1);
      });

      test('should throw exception when repository throws', () async {
        // Arrange
        const userId = 'error_user';
        when(
          mockRepository.fetchProfile(userId),
        ).thenThrow(Exception('Database error'));

        // Act & Assert
        expect(() => userService.fetchUser(userId), throwsA(isA<Exception>()));
        verify(mockRepository.fetchProfile(userId)).called(1);
      });
    });

    group('fetchUsers', () {
      test('should return list of Profiles', () async {
        // Arrange
        final expectedProfiles = [
          Profile(
            id: 'user1',
            googleUid: 'google_1',
            name: 'User 1',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Profile(
            id: 'user2',
            googleUid: 'google_2',
            name: 'User 2',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
        when(
          mockRepository.fetchProfiles(),
        ).thenAnswer((_) async => expectedProfiles);

        // Act
        final result = await userService.fetchUsers();

        // Assert
        expect(result, equals(expectedProfiles));
        expect(result.length, equals(2));
        verify(mockRepository.fetchProfiles()).called(1);
      });

      test('should return empty list when no users exist', () async {
        // Arrange
        when(mockRepository.fetchProfiles()).thenAnswer((_) async => []);

        // Act
        final result = await userService.fetchUsers();

        // Assert
        expect(result, isEmpty);
        verify(mockRepository.fetchProfiles()).called(1);
      });
    });

    group('insertUser', () {
      test('should call repository insertProfile method', () async {
        // Arrange
        final profile = Profile(
          id: 'new_user',
          googleUid: 'google_new',
          name: 'New User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        when(mockRepository.insertProfile(profile)).thenAnswer((_) async => {});

        // Act
        await userService.insertUser(profile);

        // Assert
        verify(mockRepository.insertProfile(profile)).called(1);
      });

      test('should propagate exception from repository', () async {
        // Arrange
        final profile = Profile(
          id: 'error_user',
          googleUid: 'google_error',
          name: 'Error User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        when(
          mockRepository.insertProfile(profile),
        ).thenThrow(Exception('Insert failed'));

        // Act & Assert
        expect(
          () => userService.insertUser(profile),
          throwsA(isA<Exception>()),
        );
        verify(mockRepository.insertProfile(profile)).called(1);
      });
    });

    group('updateUser', () {
      test('should call repository updateProfile method', () async {
        // Arrange
        const userId = 'update_user';
        final profile = Profile(
          id: userId,
          googleUid: 'google_update',
          name: 'Updated User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        when(
          mockRepository.updateProfile(userId, profile),
        ).thenAnswer((_) async => {});

        // Act
        await userService.updateUser(userId, profile);

        // Assert
        verify(mockRepository.updateProfile(userId, profile)).called(1);
      });
    });

    group('deleteUser', () {
      test('should call repository deleteProfile method', () async {
        // Arrange
        const userId = 'delete_user';
        when(mockRepository.deleteProfile(userId)).thenAnswer((_) async => {});

        // Act
        await userService.deleteUser(userId);

        // Assert
        verify(mockRepository.deleteProfile(userId)).called(1);
      });
    });

    group('Error Handling', () {
      test('should propagate exception from fetchUsers', () async {
        // Arrange
        when(
          mockRepository.fetchProfiles(),
        ).thenThrow(Exception('Database connection failed'));

        // Act & Assert
        expect(() => userService.fetchUsers(), throwsA(isA<Exception>()));
      });

      test('should propagate exception from updateUser', () async {
        // Arrange
        const userId = 'error_user';
        final profile = Profile(
          id: userId,
          googleUid: 'google_error',
          name: 'Error User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        when(
          mockRepository.updateProfile(userId, profile),
        ).thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => userService.updateUser(userId, profile),
          throwsA(isA<Exception>()),
        );
      });

      test('should propagate exception from deleteUser', () async {
        // Arrange
        const userId = 'delete_error_user';
        when(
          mockRepository.deleteProfile(userId),
        ).thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(() => userService.deleteUser(userId), throwsA(isA<Exception>()));
      });
    });
  });
}
