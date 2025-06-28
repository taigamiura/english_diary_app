import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/constants/app_constants.dart';

void main() {
  group('AppConstants Tests', () {
    test('should have app name defined', () {
      expect(AppConstants.appName, equals('KIWI'));
      expect(AppConstants.appName, isNotEmpty);
    });

    test('should have consistent app name', () {
      expect(AppConstants.appName, isA<String>());
      expect(AppConstants.appName.trim(), equals(AppConstants.appName));
    });
    test('should be accessible as static constant', () {
      // Test that it's a compile-time constant
      const appName = AppConstants.appName;
      expect(appName, equals('KIWI'));
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
