import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/repositories/api_repository.dart';

void main() {
  group('ApiRepository Tests', () {
    group('ApiException', () {
      test('should create exception with message and status code', () {
        // Act
        final exception = ApiException('Test error', statusCode: 400);

        // Assert
        expect(exception.message, equals('Test error'));
        expect(exception.statusCode, equals(400));
        expect(exception.toString(), contains('Test error'));
        expect(exception.toString(), contains('400'));
      });

      test('should create exception with message only', () {
        // Act
        final exception = ApiException('Test error');

        // Assert
        expect(exception.message, equals('Test error'));
        expect(exception.statusCode, isNull);
        expect(exception.toString(), contains('Test error'));
      });
    });

    group('Repository class', () {
      test('should have ApiRepository class', () {
        expect(ApiRepository, isA<Type>());
      });
    });
  });
}
