import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class BaseNotifier<T> extends StateNotifier<List<T>> {
  BaseNotifier() : super([]);

  String? _error;
  String? get error => _error;
  bool _loading = false;
  bool get loading => _loading;

  void setItems(List<T> items) => state = items;
  void addItem(T item) => state = [...state, item];
  void updateItem(T updated, bool Function(T, T) isSame) {
    state = [for (final item in state) isSame(item, updated) ? updated : item];
  }
  void removeItem(dynamic id, bool Function(T, dynamic) hasId) {
    state = state.where((item) => !hasId(item, id)).toList();
  }

  void setLoading(bool value) {
    _loading = value;
    state = [...state]; // UIに通知
  }

  void setError(String? message, {dynamic exception, StackTrace? stackTrace}) {
    _error = message;
    if (exception != null && kDebugMode) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
    state = [...state]; // UIに通知
  }

  void clearError() => setError(null);
}
