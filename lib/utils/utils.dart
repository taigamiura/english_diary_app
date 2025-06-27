import 'package:kiwi/constants/error_msg.dart';

/// 共通エラーメッセージ変換ユーティリティ
enum ErrorDomain { auth, other }

String friendlyErrorMessage(Object e, {ErrorDomain domain = ErrorDomain.auth}) {
  final msg = e.toString();
  for (final entry in ErrorMsg.codeToMessage.entries) {
    if (msg.contains(entry.key)) {
      return entry.value;
    }
  }
  return 'エラーが発生しました: $msg';
}
