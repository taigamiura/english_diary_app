import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiwi/providers/global_state_provider.dart';

void main() {
  group('Global State Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('globalLoadingProvider should have initial value false', () {
      final loading = container.read(globalLoadingProvider);
      expect(loading, isFalse);
    });

    test('globalLoadingProvider should update state', () {
      final notifier = container.read(globalLoadingProvider.notifier);

      // Set to true
      notifier.state = true;
      expect(container.read(globalLoadingProvider), isTrue);

      // Set back to false
      notifier.state = false;
      expect(container.read(globalLoadingProvider), isFalse);
    });

    test('globalErrorProvider should have initial value null', () {
      final error = container.read(globalErrorProvider);
      expect(error, isNull);
    });

    test('globalErrorProvider should update state', () {
      final notifier = container.read(globalErrorProvider.notifier);

      // Set error message
      notifier.state = 'Test error message';
      expect(container.read(globalErrorProvider), equals('Test error message'));

      // Clear error
      notifier.state = null;
      expect(container.read(globalErrorProvider), isNull);
    });

    test('both providers should work independently', () {
      final loadingNotifier = container.read(globalLoadingProvider.notifier);
      final errorNotifier = container.read(globalErrorProvider.notifier);

      // Set loading and error independently
      loadingNotifier.state = true;
      errorNotifier.state = 'Some error';

      expect(container.read(globalLoadingProvider), isTrue);
      expect(container.read(globalErrorProvider), equals('Some error'));

      // Clear error but keep loading
      errorNotifier.state = null;

      expect(container.read(globalLoadingProvider), isTrue);
      expect(container.read(globalErrorProvider), isNull);
    });
  });
}
