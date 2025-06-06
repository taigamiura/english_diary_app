import 'package:logger/logger.dart';

/// --- AppLogger活用例・ベストプラクティス ---
/// 
/// 1. ログレベルの使い分け
///   AppLogger.d('デバッグ情報'); // 開発時の詳細なデバッグ
///   AppLogger.i('通常の情報');   // 通常の操作や進行状況
///   AppLogger.w('警告');         // 潜在的な問題や非推奨操作
///   AppLogger.e('エラー', error: e, stackTrace: st); // 例外や致命的なエラー
///
/// 2. 主要なユーザー操作やイベントの記録
///   AppLogger.i('ユーザーが日記を投稿しました', error: null);
///
/// 3. 例外キャッチ時の詳細記録
///   try {
///     // ...処理...
///   } catch (e, st) {
///     AppLogger.e('処理名でエラー: $e', error: e, stackTrace: st);
///     throw ApiException('ユーザー向けエラーメッセージ', error: e, stackTrace: st);
///   }
///
/// 4. API通信や外部サービス連携のログ
///   AppLogger.d('APIリクエスト送信: $params');
///   AppLogger.i('APIレスポンス受信: $response');
///
/// 5. 本番環境でのログ出力制御
///   logger_utils.dartのLogger初期化時にlevelを切り替え可能
///   例: Logger(level: kDebugMode ? Level.debug : Level.warning, ...)
///
/// 6. print/debugPrintは使わずAppLoggerに統一
///   すべてのログ出力をAppLogger経由にすることで、出力先やフォーマットを一元管理できます。

/// AppLogger
///
/// Flutterアプリ全体で利用するロギングユーティリティ。
/// loggerパッケージのPrettyPrinterを利用し、
/// ログレベルごとに色分け・メソッド名・エラーtraceも出力。
/// print/debugPrintの代わりに本クラスを利用することで、
/// ログ出力の一元管理・本番/開発での出力制御・拡張が容易。
///
/// - d: デバッグ用 (開発時の詳細な情報)
/// - i: 情報 (通常の進行状況やイベント)
/// - w: 警告 (非推奨・潜在的な問題)
/// - e: エラー (例外・致命的な障害)
/// - log: 任意レベルでの出力
///
/// 活用例・ベストプラクティスはファイル冒頭コメント参照。
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void log(dynamic message, {Level level = Level.info, dynamic error, StackTrace? stackTrace}) {
    _logger.log(level, message, error: error, stackTrace: stackTrace);
  }
}
