import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/repositories/profile_repository.dart';
import 'package:kiwi/models/profile_model.dart';

void main() {
  group('ProfileRepository', () {
    test('ProfileRepository has correct table constant', () {
      expect(ProfileRepository.table, equals('profiles'));
    });

    test('ProfileRepository class exists and can be referenced', () {
      expect(ProfileRepository, isNotNull);
    });
  });

  group('Profile Model', () {
    test('Profile can be created with required fields', () {
      final now = DateTime.now();
      final profile = Profile(
        id: '1',
        googleUid: 'google_123',
        createdAt: now,
        updatedAt: now,
      );

      expect(profile.id, equals('1'));
      expect(profile.googleUid, equals('google_123'));
      expect(profile.createdAt, equals(now));
      expect(profile.updatedAt, equals(now));
    });

    test('Profile can be created with name', () {
      final now = DateTime.now();
      final profile = Profile(
        id: '1',
        googleUid: 'google_123',
        name: 'Test User',
        createdAt: now,
        updatedAt: now,
      );

      expect(profile.name, equals('Test User'));
    });

    test('Profile toJson works correctly', () {
      final now = DateTime.now();
      final profile = Profile(
        id: '1',
        googleUid: 'google_123',
        name: 'Test User',
        createdAt: now,
        updatedAt: now,
      );

      final json = profile.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['google_uid'], equals('google_123'));
      expect(json['name'], equals('Test User'));
      expect(json['created_at'], equals(now.toIso8601String()));
      expect(json['updated_at'], equals(now.toIso8601String()));
    });

    test('Profile fromJson works correctly', () {
      final json = {
        'id': 1,
        'google_uid': 456,
        'name': 'Test User',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final profile = Profile.fromJson(json);
      expect(profile.id, equals('1'));
      expect(profile.googleUid, equals('456'));
      expect(profile.name, equals('Test User'));
    });

    test('Profile handles null name', () {
      final now = DateTime.now();
      final profile = Profile(
        id: '1',
        googleUid: 'google_123',
        name: null,
        createdAt: now,
        updatedAt: now,
      );

      expect(profile.name, isNull);
    });

    test('Profile fromJson handles null name', () {
      final json = {
        'id': 1,
        'google_uid': 456,
        'name': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final profile = Profile.fromJson(json);
      expect(profile.name, isNull);
    });
  });
}
