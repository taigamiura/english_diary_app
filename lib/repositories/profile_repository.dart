import 'package:english_diary_app/models/profile_model.dart' as app_model;
import 'package:english_diary_app/repositories/api_repository.dart';
import 'package:english_diary_app/utils/repository_logger.dart';

class ProfileRepository {
  static const String table = 'profiles';
  final ApiRepository apiRepository;
  ProfileRepository({ApiRepository? apiRepository}) : apiRepository = apiRepository ?? ApiRepository();

  Future<List<app_model.Profile>> fetchProfiles() =>
      logRequestResponse('ProfileRepository.fetchProfiles',
        () async {
          var query = apiRepository.client.from(table).select();
          final result = await query;
          return List<Map<String, dynamic>>.from(result)
              .map((json) => app_model.Profile.fromJson(json))
              .toList();
        },
      );

  Future<app_model.Profile?> fetchProfile(String id) =>
      logRequestResponse('ProfileRepository.fetchProfile',
        () async {
          final json = await apiRepository.fetchOne(table: table, id: id);
          return json != null ? app_model.Profile.fromJson(json) : null;
        },
        requestDetail: 'id: $id',
      );

  Future<void> insertProfile(app_model.Profile profile) =>
      logRequestResponseVoid('ProfileRepository.insertProfile',
        () async {
          await apiRepository.insertOne(table: table, data: profile.toJson());
        },
        requestDetail: 'id: ${profile.id}',
      );

  Future<void> updateProfile(String id, app_model.Profile profile) =>
      logRequestResponseVoid('ProfileRepository.updateProfile',
        () async {
          await apiRepository.updateOne(table: table, id: id, data: profile.toJson());
        },
        requestDetail: 'id: $id',
      );

  Future<void> deleteProfile(String id) =>
      logRequestResponseVoid('ProfileRepository.deleteProfile',
        () async {
          await apiRepository.deleteOne(table: table, id: id);
        },
        requestDetail: 'id: $id',
      );
}
