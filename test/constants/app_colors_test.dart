import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/constants/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    test('should have main color defined', () {
      expect(AppColors.mainColor, equals(const Color(0xFF81D8D0)));
      expect(AppColors.mainColor.value, equals(0xFF81D8D0));
    });

    test('should have secondary color defined', () {
      expect(AppColors.secondaryColor, equals(Colors.white));
      expect(AppColors.secondaryColor.value, equals(Colors.white.value));
    });

    test('should have support text color defined', () {
      expect(AppColors.suportTextColor, equals(Colors.grey));
      expect(AppColors.suportTextColor.value, equals(Colors.grey.value));
    });

    test('should have error color defined', () {
      expect(AppColors.errorColor, equals(const Color(0xFFD32F2F)));
      expect(AppColors.errorColor.value, equals(0xFFD32F2F));
    });

    test('should have warning color defined', () {
      expect(AppColors.warningColor, equals(const Color(0xFFFFA000)));
      expect(AppColors.warningColor.value, equals(0xFFFFA000));
    });

    test('should have info color defined', () {
      expect(AppColors.infoColor, equals(AppColors.mainColor));
      expect(AppColors.infoColor.value, equals(AppColors.mainColor.value));
    });

    test('should have consistent color definitions', () {
      // Test that colors are static constants
      expect(AppColors.mainColor, isA<Color>());
      expect(AppColors.secondaryColor, isA<Color>());
      expect(AppColors.suportTextColor, isA<Color>());
      expect(AppColors.errorColor, isA<Color>());
      expect(AppColors.warningColor, isA<Color>());
      expect(AppColors.infoColor, isA<Color>());
    });

    test('should have proper color values for UI themes', () {
      // Verify colors are suitable for UI
      expect(AppColors.mainColor.alpha, equals(255));
      expect(AppColors.secondaryColor.alpha, equals(255));
      expect(AppColors.errorColor.alpha, equals(255));
      expect(AppColors.warningColor.alpha, equals(255));
      expect(AppColors.infoColor.alpha, equals(255));
    });

    test('should have different colors for error, warning, and info', () {
      // Ensure colors are distinct
      expect(AppColors.errorColor, isNot(equals(AppColors.warningColor)));
      expect(AppColors.errorColor, isNot(equals(AppColors.mainColor)));
      expect(AppColors.warningColor, isNot(equals(AppColors.mainColor)));

      // Info color should be same as main color
      expect(AppColors.infoColor, equals(AppColors.mainColor));
    });

    test('should have proper contrast colors', () {
      // Test that we have both light and dark colors for contrast
      expect(AppColors.secondaryColor, equals(Colors.white));
      expect(AppColors.suportTextColor, equals(Colors.grey));
    });

    test('should maintain color accessibility', () {
      // Verify error color is a proper red shade
      expect(AppColors.errorColor.red, greaterThan(200));
      expect(AppColors.errorColor.green, lessThan(100));
      expect(AppColors.errorColor.blue, lessThan(100));

      // Verify warning color is a proper amber/orange shade
      expect(AppColors.warningColor.red, greaterThan(200));
      expect(AppColors.warningColor.green, greaterThan(150));
      expect(AppColors.warningColor.blue, lessThan(50));

      // Verify main color is in the teal range
      expect(AppColors.mainColor.red, lessThan(150));
      expect(AppColors.mainColor.green, greaterThan(200));
      expect(AppColors.mainColor.blue, greaterThan(200));
    });
  });
}
