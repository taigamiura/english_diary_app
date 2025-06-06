// このファイルは今後、他ドメイン用エラーや共通エラーのみに用途を限定してください。
// 認証系はauth_error_msg.dartに移動済みです。

/// エラーメッセージ定義クラス
class ErrorMsg {
  static const Map<String, String> codeToMessage = {
    // 共通・他ドメイン用エラー
    'INVALID_EMAIL': 'メールアドレスの形式が無効です。',
    'USER_DISABLED': 'このユーザーは無効化されています。',
    'EMAIL_ALREADY_IN_USE': 'このメールアドレスは既に使用されています。',
    'WEAK_PASSWORD': 'パスワードは6文字以上である必要があります。',
    'OPERATION_NOT_ALLOWED': 'この操作は許可されていません。',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'あまりにも多くの試行が行われました。後でもう一度お試しください。',
    'USER_NOT_FOUND': 'ユーザーが見つかりません。',
    'WRONG_PASSWORD': 'メールアドレスまたはパスワードが間違っています。',
    'NETWORK_REQUEST_FAILED': 'ネットワークエラーが発生しました。',
    'UNKNOWN_ERROR': '不明なエラーが発生しました。',
    // 認証・認可系エラー
    '400': 'リクエストが不正です。',
    '401': '認証に失敗しました。再度ログインしてください。',
    '403': '権限がありません。',
    '404': 'データが見つかりません。',
    '409': '既に登録されています。',
    '422': '入力内容に誤りがあります。',
    '429': 'リクエストが多すぎます。しばらくしてから再度お試しください。',
    '500': 'サーバーエラーが発生しました。',
    'invalid_grant': '認証情報が不正です。',
    'invalid_request': 'リクエスト内容が不正です。',
    'user_already_registered': 'このメールアドレスは既に登録されています。',
    'user_not_found': 'ユーザーが見つかりません。',
    'invalid_email': 'メールアドレスの形式が正しくありません。',
    'invalid_password': 'パスワードが正しくありません。',
    'email_already_confirmed': 'メールアドレスは既に認証済みです。',
    'token_expired': '認証トークンの有効期限が切れています。',
    'invalid_token': '認証トークンが不正です。',
    // Storage/PostgREST系
    '413': 'ファイルサイズが大きすぎます。',
    // その他
    'Network': 'ネットワークに接続できません。通信環境をご確認ください。',
  };

  /// エラーコードやエラー名からユーザー向けメッセージを取得
  static String getMessage(dynamic error) {
    final msg = error.toString();
    for (final entry in codeToMessage.entries) {
      if (msg.contains(entry.key)) {
        return entry.value;
      }
    }
    return 'エラーが発生しました: $msg';
  }
}