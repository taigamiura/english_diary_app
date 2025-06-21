import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/constants/app_constants.dart';

void main() {
  group('AppConstants Tests', () {
    test('should have app name defined', () {
      expect(AppConstants.appName, equals('English Diary App'));
      expect(AppConstants.appName, isNotEmpty);
    });

    test('should have consistent app name', () {
      expect(AppConstants.appName, isA<String>());
      expect(AppConstants.appName.trim(), equals(AppConstants.appName));
    });

    test('should have proper app name format', () {
      expect(AppConstants.appName.length, greaterThan(0));
      expect(AppConstants.appName.contains('English'), isTrue);
      expect(AppConstants.appName.contains('Diary'), isTrue);
      expect(AppConstants.appName.contains('App'), isTrue);
    });

    test('should be accessible as static constant', () {
      // Test that it's a compile-time constant
      const appName = AppConstants.appName;
      expect(appName, equals('English Diary App'));
    });

    test('should maintain immutability', () {
      // Verify the constant doesn't change
      final firstAccess = AppConstants.appName;
      final secondAccess = AppConstants.appName;
      expect(firstAccess, equals(secondAccess));
      expect(identical(firstAccess, secondAccess), isTrue);
    });
  });
}
