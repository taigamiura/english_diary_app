import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/models/profile_model.dart';

void main() {
  group('Profile Model Tests', () {
    late Map<String, dynamic> sampleJson;
    late Profile sampleProfile;

    setUp(() {
      sampleJson = {
        'id': '123',
        'google_uid': 'google_user_123',
        'name': 'John Doe',
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      sampleProfile = Profile(
        id: '123',
        googleUid: 'google_user_123',
        name: 'John Doe',
        createdAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
        updatedAt: DateTime.parse('2024-01-15T10:30:00.000Z'),
      );
    });

    test('should create Profile from JSON correctly', () {
      final profile = Profile.fromJson(sampleJson);

      expect(profile.id, equals('123'));
      expect(profile.googleUid, equals('google_user_123'));
      expect(profile.name, equals('John Doe'));
      expect(
        profile.createdAt,
        equals(DateTime.parse('2024-01-15T10:30:00.000Z')),
      );
      expect(
        profile.updatedAt,
        equals(DateTime.parse('2024-01-15T10:30:00.000Z')),
      );
    });

    test('should convert Profile to JSON correctly', () {
      final json = sampleProfile.toJson();

      expect(json['google_uid'], equals('google_user_123'));
      expect(json['name'], equals('John Doe'));
      expect(json['created_at'], equals('2024-01-15T10:30:00.000Z'));
      expect(json['updated_at'], equals('2024-01-15T10:30:00.000Z'));
      expect(json.containsKey('id'), isFalse); // toJson() should not include id
    });

    test('should handle null name correctly', () {
      final jsonWithoutName = {
        'id': '456',
        'google_uid': 'google_user_456',
        'name': null,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final profile = Profile.fromJson(jsonWithoutName);

      expect(profile.id, equals('456'));
      expect(profile.googleUid, equals('google_user_456'));
      expect(profile.name, isNull);
    });

    test('should create Profile with null name', () {
      final profile = Profile(
        id: '789',
        googleUid: 'google_user_789',
        name: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(profile.name, isNull);

      final json = profile.toJson();
      expect(json['name'], isNull);
    });

    test('should handle string conversion for id fields', () {
      final jsonWithIntId = {
        'id': 123, // integer instead of string
        'google_uid': 456, // integer instead of string
        'name': 'Test User',
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-01-15T10:30:00.000Z',
      };

      final profile = Profile.fromJson(jsonWithIntId);

      expect(profile.id, equals('123')); // should be converted to string
      expect(profile.googleUid, equals('456')); // should be converted to string
    });
  });
}
