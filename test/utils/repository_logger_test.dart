import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/utils/repository_logger.dart';

void main() {
  group('Repository Logger Tests', () {
    group('logRequestResponse', () {
      test('should execute action and return result successfully', () async {
        const expectedResult = 'test result';

        final result = await logRequestResponse(
          'TestOperation',
          () async => expectedResult,
        );

        expect(result, equals(expectedResult));
      });

      test('should execute action with request detail', () async {
        const expectedResult = 42;
        const requestDetail = 'param1=value1, param2=value2';

        final result = await logRequestResponse(
          'TestOperationWithDetail',
          () async => expectedResult,
          requestDetail: requestDetail,
        );

        expect(result, equals(expectedResult));
      });

      test('should handle and rethrow exceptions', () async {
        const errorMessage = 'Test error';

        expect(
          () => logRequestResponse(
            'FailingOperation',
            () async => throw Exception(errorMessage),
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle different return types', () async {
        // String
        final stringResult = await logRequestResponse(
          'StringOperation',
          () async => 'hello',
        );
        expect(stringResult, equals('hello'));

        // List
        final listResult = await logRequestResponse(
          'ListOperation',
          () async => [1, 2, 3],
        );
        expect(listResult, equals([1, 2, 3]));

        // Map
        final mapResult = await logRequestResponse(
          'MapOperation',
          () async => {'key': 'value'},
        );
        expect(mapResult, equals({'key': 'value'}));

        // null
        final nullResult = await logRequestResponse(
          'NullOperation',
          () async => null,
        );
        expect(nullResult, isNull);
      });

      test('should handle async operations with delay', () async {
        const expectedResult = 'delayed result';

        final result = await logRequestResponse('DelayedOperation', () async {
          await Future.delayed(const Duration(milliseconds: 10));
          return expectedResult;
        });

        expect(result, equals(expectedResult));
      });

      test('should handle nested function calls', () async {
        final result = await logRequestResponse('NestedOperation', () async {
          return await logRequestResponse(
            'InnerOperation',
            () async => 'nested result',
          );
        });

        expect(result, equals('nested result'));
      });
    });

    group('logRequestResponseVoid', () {
      test('should execute void action successfully', () async {
        var executed = false;

        await logRequestResponseVoid('VoidOperation', () async {
          executed = true;
        });

        expect(executed, isTrue);
      });

      test('should execute void action with request detail', () async {
        var executed = false;
        const requestDetail = 'operation details';

        await logRequestResponseVoid('VoidOperationWithDetail', () async {
          executed = true;
        }, requestDetail: requestDetail);

        expect(executed, isTrue);
      });

      test('should handle and rethrow exceptions in void actions', () async {
        const errorMessage = 'Void operation error';

        expect(
          () => logRequestResponseVoid(
            'FailingVoidOperation',
            () async => throw Exception(errorMessage),
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle async void operations with delay', () async {
        var executed = false;

        await logRequestResponseVoid('DelayedVoidOperation', () async {
          await Future.delayed(const Duration(milliseconds: 10));
          executed = true;
        });

        expect(executed, isTrue);
      });

      test(
        'should handle void operations that throw different exception types',
        () async {
          // Test different exception types
          expect(
            () => logRequestResponseVoid(
              'ArgumentErrorOperation',
              () async => throw ArgumentError('Invalid argument'),
            ),
            throwsA(isA<ArgumentError>()),
          );

          expect(
            () => logRequestResponseVoid(
              'FormatExceptionOperation',
              () async => throw FormatException('Invalid format'),
            ),
            throwsA(isA<FormatException>()),
          );

          expect(
            () => logRequestResponseVoid(
              'StateErrorOperation',
              () async => throw StateError('Invalid state'),
            ),
            throwsA(isA<StateError>()),
          );
        },
      );

      test('should handle nested void function calls', () async {
        var outerExecuted = false;
        var innerExecuted = false;

        await logRequestResponseVoid('OuterVoidOperation', () async {
          outerExecuted = true;
          await logRequestResponseVoid('InnerVoidOperation', () async {
            innerExecuted = true;
          });
        });

        expect(outerExecuted, isTrue);
        expect(innerExecuted, isTrue);
      });
    });

    group('Error handling scenarios', () {
      test('should handle null request detail gracefully', () async {
        final result = await logRequestResponse(
          'OperationWithNullDetail',
          () async => 'success',
          requestDetail: null,
        );

        expect(result, equals('success'));
      });

      test('should handle empty request detail', () async {
        final result = await logRequestResponse(
          'OperationWithEmptyDetail',
          () async => 'success',
          requestDetail: '',
        );

        expect(result, equals('success'));
      });

      test('should handle very long request details', () async {
        final longDetail = 'param=' + 'x' * 1000;

        final result = await logRequestResponse(
          'OperationWithLongDetail',
          () async => 'success',
          requestDetail: longDetail,
        );

        expect(result, equals('success'));
      });
    });
  });
}
