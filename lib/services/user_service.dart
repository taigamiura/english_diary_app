import 'package:english_diary_app/repositories/profile_repository.dart';

import '../models/profile_model.dart';

abstract class UserService {
  Future<Profile?> fetchUser(String id);
  Future<List<Profile>> fetchUsers();
  Future<void> insertUser(Profile profile);
  Future<void> updateUser(String id, Profile profile);
  Future<void> deleteUser(String id);
}

class UserServiceImpl implements UserService {
  final ProfileRepository repository;
  UserServiceImpl(this.repository);

  @override
  Future<Profile?> fetchUser(String id) async {
    return repository.fetchProfile(id);
  }

  @override
  Future<List<Profile>> fetchUsers() async {
    return repository.fetchProfiles();
  }

  @override
  Future<void> insertUser(Profile profile) async {
    return repository.insertProfile(profile);
  }

  @override
  Future<void> updateUser(String id, Profile profile) async {
    return repository.updateProfile(id, profile);
  }

  @override
  Future<void> deleteUser(String id) async {
    return repository.deleteProfile(id);
  }
}
