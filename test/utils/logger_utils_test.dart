import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:english_diary_app/utils/logger_utils.dart';

void main() {
  group('AppLogger Tests', () {
    test('AppLogger should have static methods available', () {
      // Test that all static methods exist and can be called
      expect(AppLogger.d, isA<Function>());
      expect(AppLogger.i, isA<Function>());
      expect(AppLogger.w, isA<Function>());
      expect(AppLogger.e, isA<Function>());
      expect(AppLogger.log, isA<Function>());
    });

    test('AppLogger.d should accept message and optional parameters', () {
      // Test debug logging - should not throw
      expect(() => AppLogger.d('Debug message'), returnsNormally);
      expect(
        () => AppLogger.d('Debug with error', error: 'test error'),
        returnsNormally,
      );
      expect(
        () => AppLogger.d('Debug with stack', stackTrace: StackTrace.current),
        returnsNormally,
      );
    });

    test('AppLogger.i should accept message and optional parameters', () {
      // Test info logging - should not throw
      expect(() => AppLogger.i('Info message'), returnsNormally);
      expect(
        () => AppLogger.i('Info with error', error: 'test error'),
        returnsNormally,
      );
      expect(
        () => AppLogger.i('Info with stack', stackTrace: StackTrace.current),
        returnsNormally,
      );
    });

    test('AppLogger.w should accept message and optional parameters', () {
      // Test warning logging - should not throw
      expect(() => AppLogger.w('Warning message'), returnsNormally);
      expect(
        () => AppLogger.w('Warning with error', error: 'test error'),
        returnsNormally,
      );
      expect(
        () => AppLogger.w('Warning with stack', stackTrace: StackTrace.current),
        returnsNormally,
      );
    });

    test('AppLogger.e should accept message and optional parameters', () {
      // Test error logging - should not throw
      expect(() => AppLogger.e('Error message'), returnsNormally);
      expect(
        () => AppLogger.e('Error with error', error: 'test error'),
        returnsNormally,
      );
      expect(
        () => AppLogger.e('Error with stack', stackTrace: StackTrace.current),
        returnsNormally,
      );
    });

    test('AppLogger.log should accept message with custom level', () {
      // Test custom level logging - should not throw
      expect(() => AppLogger.log('Custom message'), returnsNormally);
      expect(
        () => AppLogger.log('Custom debug', level: Level.debug),
        returnsNormally,
      );
      expect(
        () => AppLogger.log('Custom warning', level: Level.warning),
        returnsNormally,
      );
      expect(
        () => AppLogger.log('Custom error', level: Level.error),
        returnsNormally,
      );
      expect(
        () => AppLogger.log('Custom with error', error: 'test error'),
        returnsNormally,
      );
      expect(
        () =>
            AppLogger.log('Custom with stack', stackTrace: StackTrace.current),
        returnsNormally,
      );
    });

    test('AppLogger should handle different message types', () {
      // Test different message types - should not throw
      expect(() => AppLogger.i('String message'), returnsNormally);
      expect(() => AppLogger.i(123), returnsNormally);
      expect(() => AppLogger.i(['list', 'message']), returnsNormally);
      expect(() => AppLogger.i({'key': 'value'}), returnsNormally);
      expect(() => AppLogger.i(null), returnsNormally);
    });

    test('AppLogger should handle exceptions as errors', () {
      // Test logging with actual exceptions - should not throw
      final exception = Exception('Test exception');
      final stack = StackTrace.current;

      expect(
        () => AppLogger.e('Exception occurred', error: exception),
        returnsNormally,
      );
      expect(
        () => AppLogger.e(
          'Exception with stack',
          error: exception,
          stackTrace: stack,
        ),
        returnsNormally,
      );
    });

    test('AppLogger should handle all log levels', () {
      // Test all available log levels
      expect(() => AppLogger.log('Trace', level: Level.trace), returnsNormally);
      expect(() => AppLogger.log('Debug', level: Level.debug), returnsNormally);
      expect(() => AppLogger.log('Info', level: Level.info), returnsNormally);
      expect(
        () => AppLogger.log('Warning', level: Level.warning),
        returnsNormally,
      );
      expect(() => AppLogger.log('Error', level: Level.error), returnsNormally);
      expect(() => AppLogger.log('Fatal', level: Level.fatal), returnsNormally);
    });
  });
}
