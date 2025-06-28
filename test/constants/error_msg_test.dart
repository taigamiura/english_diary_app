import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/constants/error_msg.dart';

void main() {
  group('ErrorMsg Tests', () {
    test('should contain error messages', () {
      expect(ErrorMsg.codeToMessage, isNotEmpty);
      expect(ErrorMsg.codeToMessage.containsKey('INVALID_EMAIL'), isTrue);
      expect(ErrorMsg.codeToMessage['INVALID_EMAIL'], 'メールアドレスの形式が無効です。');
    });

    test('should return specific message for known error codes', () {
      expect(
        ErrorMsg.getMessage(Exception('INVALID_EMAIL')),
        'メールアドレスの形式が無効です。',
      );
      expect(
        ErrorMsg.getMessage(Exception('USER_DISABLED')),
        'このユーザーは無効化されています。',
      );
      expect(
        ErrorMsg.getMessage(Exception('Network')),
        'ネットワークに接続できません。通信環境をご確認ください。',
      );
    });

    test('should return generic message for unknown errors', () {
      final result = ErrorMsg.getMessage(
        Exception('TOTALLY_UNRECOGNIZED_CODE_12345'),
      );
      expect(result, startsWith('エラーが発生しました:'));
    });

    test('should handle various error types', () {
      expect(ErrorMsg.getMessage('INVALID_EMAIL'), 'メールアドレスの形式が無効です。');
      expect(
        ErrorMsg.getMessage(Exception('USER_DISABLED')),
        'このユーザーは無効化されています。',
      );
    });

    test('should handle all defined HTTP status codes', () {
      expect(ErrorMsg.getMessage(Exception('400')), 'リクエストが不正です。');
      expect(ErrorMsg.getMessage(Exception('401')), '認証に失敗しました。再度ログインしてください。');
      expect(ErrorMsg.getMessage(Exception('403')), '権限がありません。');
      expect(ErrorMsg.getMessage(Exception('404')), 'データが見つかりません。');
      expect(ErrorMsg.getMessage(Exception('409')), '既に登録されています。');
      expect(ErrorMsg.getMessage(Exception('422')), '入力内容に誤りがあります。');
      expect(
        ErrorMsg.getMessage(Exception('429')),
        'リクエストが多すぎます。しばらくしてから再度お試しください。',
      );
      expect(ErrorMsg.getMessage(Exception('500')), 'サーバーエラーが発生しました。');
      expect(ErrorMsg.getMessage(Exception('413')), 'ファイルサイズが大きすぎます。');
    });

    test('should handle authentication error codes', () {
      expect(
        ErrorMsg.getMessage(Exception('INVALID_EMAIL')),
        'メールアドレスの形式が無効です。',
      );
      expect(
        ErrorMsg.getMessage(Exception('USER_DISABLED')),
        'このユーザーは無効化されています。',
      );
      expect(
        ErrorMsg.getMessage(Exception('EMAIL_ALREADY_IN_USE')),
        'このメールアドレスは既に使用されています。',
      );
      expect(
        ErrorMsg.getMessage(Exception('WEAK_PASSWORD')),
        'パスワードは6文字以上である必要があります。',
      );
      expect(
        ErrorMsg.getMessage(Exception('OPERATION_NOT_ALLOWED')),
        'この操作は許可されていません。',
      );
      expect(
        ErrorMsg.getMessage(Exception('TOO_MANY_ATTEMPTS_TRY_LATER')),
        'あまりにも多くの試行が行われました。後でもう一度お試しください。',
      );
      expect(ErrorMsg.getMessage(Exception('USER_NOT_FOUND')), 'ユーザーが見つかりません。');
      expect(
        ErrorMsg.getMessage(Exception('WRONG_PASSWORD')),
        'メールアドレスまたはパスワードが間違っています。',
      );
      expect(
        ErrorMsg.getMessage(Exception('NETWORK_REQUEST_FAILED')),
        'ネットワークエラーが発生しました。',
      );
      expect(ErrorMsg.getMessage(Exception('UNKNOWN_ERROR')), '不明なエラーが発生しました。');
    });

    test('should handle specific error types', () {
      expect(ErrorMsg.getMessage(Exception('invalid_grant')), '認証情報が不正です。');
      expect(
        ErrorMsg.getMessage(Exception('invalid_request')),
        'リクエスト内容が不正です。',
      );
      expect(
        ErrorMsg.getMessage(Exception('user_already_registered')),
        'このメールアドレスは既に登録されています。',
      );
      expect(ErrorMsg.getMessage(Exception('user_not_found')), 'ユーザーが見つかりません。');
      expect(
        ErrorMsg.getMessage(Exception('invalid_email')),
        'メールアドレスの形式が正しくありません。',
      );
      expect(
        ErrorMsg.getMessage(Exception('invalid_password')),
        'パスワードが正しくありません。',
      );
      expect(
        ErrorMsg.getMessage(Exception('email_already_confirmed')),
        'メールアドレスは既に認証済みです。',
      );
      expect(
        ErrorMsg.getMessage(Exception('token_expired')),
        '認証トークンの有効期限が切れています。',
      );
      expect(ErrorMsg.getMessage(Exception('invalid_token')), '認証トークンが不正です。');
    });

    test('should handle network errors', () {
      expect(
        ErrorMsg.getMessage(Exception('Network')),
        'ネットワークに接続できません。通信環境をご確認ください。',
      );
    });

    test('should handle partial matches in error messages', () {
      expect(
        ErrorMsg.getMessage(Exception('Error: INVALID_EMAIL occurred')),
        'メールアドレスの形式が無効です。',
      );
      expect(
        ErrorMsg.getMessage(Exception('HTTP 400 Bad Request')),
        'リクエストが不正です。',
      );
      expect(
        ErrorMsg.getMessage(Exception('Network connection failed')),
        'ネットワークに接続できません。通信環境をご確認ください。',
      );
    });

    test('should handle null and empty inputs', () {
      final emptyResult = ErrorMsg.getMessage('');
      final nullResult = ErrorMsg.getMessage(null);

      // These should return generic error messages
      expect(emptyResult, startsWith('エラーが発生しました:'));
      expect(nullResult, startsWith('エラーが発生しました:'));
    });

    test('should verify all error codes are accessible', () {
      expect(ErrorMsg.codeToMessage.length, greaterThanOrEqualTo(25));

      // Verify specific categories exist
      final httpCodes = [
        '400',
        '401',
        '403',
        '404',
        '409',
        '422',
        '429',
        '500',
        '413',
      ];
      for (final code in httpCodes) {
        expect(
          ErrorMsg.codeToMessage.containsKey(code),
          isTrue,
          reason: 'HTTP code $code should exist',
        );
      }

      final authCodes = [
        'INVALID_EMAIL',
        'USER_DISABLED',
        'EMAIL_ALREADY_IN_USE',
        'WEAK_PASSWORD',
      ];
      for (final code in authCodes) {
        expect(
          ErrorMsg.codeToMessage.containsKey(code),
          isTrue,
          reason: 'Auth code $code should exist',
        );
      }
    });
  });
}
