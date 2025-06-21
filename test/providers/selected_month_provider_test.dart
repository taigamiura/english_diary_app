import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/providers/selected_month_provider.dart';

void main() {
  group('Selected Month Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'selectedMonthProvider should have initial value as current month',
      () {
        final selectedMonth = container.read(selectedMonthProvider);
        final now = DateTime.now();
        final expectedMonth = DateTime(now.year, now.month);

        expect(selectedMonth.year, equals(expectedMonth.year));
        expect(selectedMonth.month, equals(expectedMonth.month));
        expect(
          selectedMonth.day,
          equals(1),
        ); // Should be the first day of the month
      },
    );

    test('selectedMonthProvider should update state', () {
      final notifier = container.read(selectedMonthProvider.notifier);
      final testDate = DateTime(2024, 6, 15);

      // Update to a specific month
      notifier.state = testDate;
      final updatedMonth = container.read(selectedMonthProvider);

      expect(updatedMonth.year, equals(2024));
      expect(updatedMonth.month, equals(6));
      expect(updatedMonth.day, equals(15));
    });

    test('selectedMonthProvider should handle different months', () {
      final notifier = container.read(selectedMonthProvider.notifier);

      // Test January
      notifier.state = DateTime(2024, 1, 1);
      expect(container.read(selectedMonthProvider).month, equals(1));

      // Test December
      notifier.state = DateTime(2024, 12, 31);
      expect(container.read(selectedMonthProvider).month, equals(12));

      // Test leap year February
      notifier.state = DateTime(2024, 2, 29);
      expect(container.read(selectedMonthProvider).month, equals(2));
      expect(container.read(selectedMonthProvider).day, equals(29));
    });

    test('selectedMonthProvider should handle year changes', () {
      final notifier = container.read(selectedMonthProvider.notifier);

      // Change to previous year
      notifier.state = DateTime(2023, 12, 1);
      expect(container.read(selectedMonthProvider).year, equals(2023));

      // Change to future year
      notifier.state = DateTime(2025, 1, 1);
      expect(container.read(selectedMonthProvider).year, equals(2025));
    });
  });
}
