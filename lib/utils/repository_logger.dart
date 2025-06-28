import 'package:kiwi/utils/logger_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<T> logRequestResponse<T>(
  String label,
  Future<T> Function() action, {
  String? requestDetail,
}) async {
  try {
    if (kDebugMode) {
      AppLogger.d(
        '[$label][request]${requestDetail != null ? ' $requestDetail' : ''}',
      );
    }
    final res = await action();
    if (kDebugMode) {
      AppLogger.d('[$label][response] $res');
    }
    return res;
  } catch (e, st) {
    if (kDebugMode) {
      AppLogger.e('[$label][error] $e', error: e, stackTrace: st);
    } else {
      await Sentry.captureException(e, stackTrace: st);
    }
    rethrow;
  }
}

Future<void> logRequestResponseVoid(
  String label,
  Future<void> Function() action, {
  String? requestDetail,
}) async {
  try {
    if (kDebugMode) {
      AppLogger.d(
        '[$label][request]${requestDetail != null ? ' $requestDetail' : ''}',
      );
    }
    await action();
    if (kDebugMode) {
      AppLogger.d('[$label][response] completed');
    }
  } catch (e, st) {
    if (kDebugMode) {
      AppLogger.e('[$label][error] $e', error: e, stackTrace: st);
    } else {
      await Sentry.captureException(e, stackTrace: st);
    }
    rethrow;
  }
}
