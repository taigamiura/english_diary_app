import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/utils/utils.dart' as utils;
import 'package:kiwi/constants/error_msg.dart';

void main() {
  group('Utils Tests', () {
    group('friendlyErrorMessage', () {
      test('should return error messages with prefix', () {
        // Test basic error formatting
        final result = utils.friendlyErrorMessage(Exception('Test error'));
        expect(result, startsWith('エラーが発生しました:'));
        expect(result, contains('Test error'));
      });

      test('should handle string errors', () {
        final result = utils.friendlyErrorMessage('Simple error message');
        expect(result, startsWith('エラーが発生しました:'));
        expect(result, contains('Simple error message'));
      });

      test('should handle different error types', () {
        // FormatException
        final formatResult = utils.friendlyErrorMessage(
          FormatException('Invalid format'),
        );
        expect(formatResult, startsWith('エラーが発生しました:'));
        expect(formatResult, contains('Invalid format'));

        // ArgumentError
        final argResult = utils.friendlyErrorMessage(
          ArgumentError('Invalid argument'),
        );
        expect(argResult, startsWith('エラーが発生しました:'));
        expect(argResult, contains('Invalid argument'));
      });

      test('should handle network-related errors', () {
        final networkError = utils.friendlyErrorMessage(
          Exception('Failed host lookup'),
        );
        expect(networkError, startsWith('エラーが発生しました:'));
        expect(networkError, contains('Failed host lookup'));
      });

      test('should work with ErrorDomain parameter', () {
        final authError = utils.friendlyErrorMessage(
          Exception('Auth error'),
          domain: utils.ErrorDomain.auth,
        );
        expect(authError, startsWith('エラーが発生しました:'));

        final otherError = utils.friendlyErrorMessage(
          Exception('Other error'),
          domain: utils.ErrorDomain.other,
        );
        expect(otherError, startsWith('エラーが発生しました:'));
      });

      test('should convert known error codes to friendly messages', () {
        // Test HTTP status codes
        final badRequestError = utils.friendlyErrorMessage(
          Exception('400 Bad Request'),
        );
        expect(badRequestError, equals(ErrorMsg.codeToMessage['400']));

        final unauthorizedError = utils.friendlyErrorMessage(
          Exception('401 Unauthorized'),
        );
        expect(unauthorizedError, equals(ErrorMsg.codeToMessage['401']));

        final notFoundError = utils.friendlyErrorMessage(
          Exception('404 Not Found'),
        );
        expect(notFoundError, equals(ErrorMsg.codeToMessage['404']));

        final serverError = utils.friendlyErrorMessage(
          Exception('500 Internal Server Error'),
        );
        expect(serverError, equals(ErrorMsg.codeToMessage['500']));
      });

      test('should convert authentication error codes', () {
        final invalidEmailError = utils.friendlyErrorMessage(
          Exception('INVALID_EMAIL'),
        );
        expect(
          invalidEmailError,
          equals(ErrorMsg.codeToMessage['INVALID_EMAIL']),
        );

        final userNotFoundError = utils.friendlyErrorMessage(
          Exception('USER_NOT_FOUND'),
        );
        expect(
          userNotFoundError,
          equals(ErrorMsg.codeToMessage['USER_NOT_FOUND']),
        );

        final wrongPasswordError = utils.friendlyErrorMessage(
          Exception('WRONG_PASSWORD'),
        );
        expect(
          wrongPasswordError,
          equals(ErrorMsg.codeToMessage['WRONG_PASSWORD']),
        );

        final weakPasswordError = utils.friendlyErrorMessage(
          Exception('WEAK_PASSWORD'),
        );
        expect(
          weakPasswordError,
          equals(ErrorMsg.codeToMessage['WEAK_PASSWORD']),
        );
      });

      test('should convert network error codes', () {
        final networkError = utils.friendlyErrorMessage(
          Exception('NETWORK_REQUEST_FAILED'),
        );
        expect(
          networkError,
          equals(ErrorMsg.codeToMessage['NETWORK_REQUEST_FAILED']),
        );

        final networkGenericError = utils.friendlyErrorMessage(
          Exception('Network connection failed'),
        );
        expect(networkGenericError, equals(ErrorMsg.codeToMessage['Network']));
      });

      test('should handle partial matches in error messages', () {
        // Test that partial matches work
        final complexError = utils.friendlyErrorMessage(
          Exception('Error occurred: invalid_email verification failed'),
        );
        expect(complexError, equals(ErrorMsg.codeToMessage['invalid_email']));

        final httpError = utils.friendlyErrorMessage(
          Exception('HTTP 429 Too Many Requests - rate limit exceeded'),
        );
        expect(httpError, equals(ErrorMsg.codeToMessage['429']));
      });

      test('should handle case sensitivity', () {
        // Test case insensitive matching
        final upperCaseError = utils.friendlyErrorMessage(
          Exception('INVALID_EMAIL'),
        );
        final lowerCaseError = utils.friendlyErrorMessage(
          Exception('invalid_email'),
        );

        expect(upperCaseError, equals(ErrorMsg.codeToMessage['INVALID_EMAIL']));
        expect(lowerCaseError, equals(ErrorMsg.codeToMessage['invalid_email']));
      });

      test('should return default message for unknown errors', () {
        final unknownError = utils.friendlyErrorMessage(
          Exception('Some completely unknown error'),
        );
        expect(unknownError, startsWith('エラーが発生しました:'));
        expect(unknownError, contains('Some completely unknown error'));
      });

      test('should handle empty errors', () {
        final emptyError = utils.friendlyErrorMessage('');
        expect(emptyError, startsWith('エラーが発生しました:'));
      });

      test('should work with different ErrorDomain values', () {
        final authDomainError = utils.friendlyErrorMessage(
          Exception('Test error'),
          domain: utils.ErrorDomain.auth,
        );
        expect(authDomainError, startsWith('エラーが発生しました:'));

        final otherDomainError = utils.friendlyErrorMessage(
          Exception('Test error'),
          domain: utils.ErrorDomain.other,
        );
        expect(otherDomainError, startsWith('エラーが発生しました:'));
      });

      test('should handle complex error objects', () {
        // Test with custom exception
        final customException = FormatException(
          'Invalid JSON format',
          'source',
        );
        final result = utils.friendlyErrorMessage(customException);
        expect(result, startsWith('エラーが発生しました:'));
        expect(result, contains('Invalid JSON format'));

        // Test with StateError
        final stateError = StateError('Invalid state');
        final stateResult = utils.friendlyErrorMessage(stateError);
        expect(stateResult, startsWith('エラーが発生しました:'));
        expect(stateResult, contains('Invalid state'));
      });
    });

    group('ErrorDomain enum', () {
      test('should have correct enum values', () {
        expect(utils.ErrorDomain.auth, isA<utils.ErrorDomain>());
        expect(utils.ErrorDomain.other, isA<utils.ErrorDomain>());
        expect(utils.ErrorDomain.values, hasLength(2));
        expect(utils.ErrorDomain.values, contains(utils.ErrorDomain.auth));
        expect(utils.ErrorDomain.values, contains(utils.ErrorDomain.other));
      });

      test('should have proper string representation', () {
        expect(utils.ErrorDomain.auth.toString(), contains('auth'));
        expect(utils.ErrorDomain.other.toString(), contains('other'));
      });
    });
  });
}
