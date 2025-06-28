import 'package:kiwi/repositories/auth_repository.dart';
import 'package:kiwi/repositories/profile_repository.dart';
import 'package:kiwi/models/profile_model.dart' as app_model;
import 'package:kiwi/utils/repository_logger.dart';

class UserRepository {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  UserRepository({
    AuthRepository? authRepository,
    ProfileRepository? profileRepository,
  }) : authRepository = authRepository ?? AuthRepository(),
       profileRepository = profileRepository ?? ProfileRepository();

  // 認証系
  Future<dynamic> signUpWithEmail() => logRequestResponse(
    'UserRepository.signUpWithEmail',
    () => authRepository.signUpWithEmail(),
    requestDetail: 'email: debug email',
  );

  Future<dynamic> signInWithEmail() => logRequestResponse(
    'UserRepository.signInWithEmail',
    () => authRepository.signInWithEmail(),
    requestDetail: 'email: debug email',
  );

  Future<dynamic> signInWithGoogle() => logRequestResponse(
    'UserRepository.signInWithGoogle',
    () => authRepository.signInWithGoogle(),
  );

  Future<void> signOut() => logRequestResponseVoid(
    'UserRepository.signOut',
    () => authRepository.signOut(),
  );

  // プロフィール系
  Future<List<app_model.Profile>> fetchUsers() => logRequestResponse(
    'UserRepository.fetchUsers',
    () => profileRepository.fetchProfiles(),
  );

  Future<app_model.Profile?> fetchUser(String id) => logRequestResponse(
    'UserRepository.fetchUser',
    () => profileRepository.fetchProfile(id),
    requestDetail: 'id: $id',
  );

  Future<void> insertUser(app_model.Profile profile) => logRequestResponseVoid(
    'UserRepository.insertUser',
    () => profileRepository.insertProfile(profile),
    requestDetail: 'id: ${profile.id}',
  );

  Future<void> updateUser(String id, app_model.Profile profile) =>
      logRequestResponseVoid(
        'UserRepository.updateUser',
        () => profileRepository.updateProfile(id, profile),
        requestDetail: 'id: $id',
      );

  Future<void> deleteUser(String id) => logRequestResponseVoid(
    'UserRepository.deleteUser',
    () => profileRepository.deleteProfile(id),
    requestDetail: 'id: $id',
  );
}
