import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/models/year_month.dart';

void main() {
  group('YearMonth Model Tests', () {
    test('should create YearMonth with year and month', () {
      final yearMonth = YearMonth(2024, 12);

      expect(yearMonth.year, equals(2024));
      expect(yearMonth.month, equals(12));
    });

    test('should create YearMonth from DateTime', () {
      final dateTime = DateTime(2024, 3, 15);
      final yearMonth = YearMonth.fromDateTime(dateTime);

      expect(yearMonth.year, equals(2024));
      expect(yearMonth.month, equals(3));
    });

    test('should parse YearMonth from dash-separated string', () {
      final yearMonth = YearMonth.parse('2024-07');

      expect(yearMonth.year, equals(2024));
      expect(yearMonth.month, equals(7));
    });

    test('should parse YearMonth from ISO8601 string', () {
      final yearMonth = YearMonth.parse('2024-05-15T10:30:00.000Z');

      expect(yearMonth.year, equals(2024));
      expect(yearMonth.month, equals(5));
    });

    test('should create YearMonth from string using fromString', () {
      final yearMonth = YearMonth.fromString('2024-11');

      expect(yearMonth.year, equals(2024));
      expect(yearMonth.month, equals(11));
    });

    test('should throw FormatException for invalid format', () {
      expect(() => YearMonth.parse('invalid-format'), throwsFormatException);
      expect(() => YearMonth.parse('2024'), throwsFormatException);
      expect(() => YearMonth.parse(''), throwsFormatException);
    });

    test('should implement equality correctly', () {
      final yearMonth1 = YearMonth(2024, 6);
      final yearMonth2 = YearMonth(2024, 6);
      final yearMonth3 = YearMonth(2024, 7);
      final yearMonth4 = YearMonth(2023, 6);

      expect(yearMonth1 == yearMonth2, isTrue);
      expect(yearMonth1 == yearMonth3, isFalse);
      expect(yearMonth1 == yearMonth4, isFalse);
    });

    test('should implement hashCode correctly', () {
      final yearMonth1 = YearMonth(2024, 6);
      final yearMonth2 = YearMonth(2024, 6);

      expect(yearMonth1.hashCode, equals(yearMonth2.hashCode));
    });

    test('should implement toString correctly', () {
      final yearMonth = YearMonth(2024, 9);

      expect(yearMonth.toString(), equals('2024-9'));
    });

    test('should compare YearMonth objects correctly', () {
      final ym1 = YearMonth(2024, 6);
      final ym2 = YearMonth(2024, 7);
      final ym3 = YearMonth(2025, 1);
      final ym4 = YearMonth(2023, 12);

      // Same year, different month
      expect(ym1.compareTo(ym2), lessThan(0));
      expect(ym2.compareTo(ym1), greaterThan(0));

      // Different year
      expect(ym1.compareTo(ym3), lessThan(0));
      expect(ym3.compareTo(ym1), greaterThan(0));

      expect(ym1.compareTo(ym4), greaterThan(0));
      expect(ym4.compareTo(ym1), lessThan(0));

      // Same year and month
      final ym5 = YearMonth(2024, 6);
      expect(ym1.compareTo(ym5), equals(0));
    });

    test('should handle edge cases for month values', () {
      final january = YearMonth(2024, 1);
      final december = YearMonth(2024, 12);

      expect(january.month, equals(1));
      expect(december.month, equals(12));

      expect(january.toString(), equals('2024-1'));
      expect(december.toString(), equals('2024-12'));
    });

    test('should parse various date string formats', () {
      // Dash-separated format
      expect(YearMonth.parse('2024-03').toString(), equals('2024-3'));

      // ISO8601 with time
      expect(
        YearMonth.parse('2024-08-15T14:30:00Z').toString(),
        equals('2024-8'),
      );

      // ISO8601 without time
      expect(YearMonth.parse('2024-12-01').toString(), equals('2024-12'));
    });

    test('should handle parse errors for invalid date formats', () {
      // Invalid format that can't be parsed by DateTime.tryParse
      expect(() => YearMonth.parse('not-a-date'), throwsFormatException);
      expect(() => YearMonth.parse('2024-13-45'), throwsFormatException);
      expect(() => YearMonth.parse('invalid'), throwsFormatException);

      // Test the specific case where DateTime.tryParse returns null
      expect(() => YearMonth.parse('2024-99-99'), throwsFormatException);
    });
  });
}
