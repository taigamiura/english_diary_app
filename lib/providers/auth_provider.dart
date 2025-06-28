import 'dart:convert';
import 'package:kiwi/utils/utils.dart' as utils;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/user_service.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../models/subscription_model.dart';
import '../services/subscription_service.dart';
import 'package:kiwi/providers/global_state_provider.dart';
import '../repositories/subscription_repository.dart';

/// Repository Providers
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(),
);
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(),
);

/// Service Providers
final userServiceProvider = Provider<UserService>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UserServiceImpl(repository);
});
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return SubscriptionServiceImpl(repository);
});

class AuthState {
  final Profile? user;
  final bool isSubscribed;
  final Subscription? currentSubscription;
  final bool isSubscriptionLoading;
  final String? subscriptionError;

  const AuthState({
    this.user,
    this.isSubscribed = false,
    this.currentSubscription,
    this.isSubscriptionLoading = false,
    this.subscriptionError,
  });

  AuthState copyWith({
    Profile? user,
    bool? isSubscribed,
    Subscription? currentSubscription,
    bool? isSubscriptionLoading,
    String? subscriptionError,
  }) {
    return AuthState(
      user: user ?? this.user,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      isSubscriptionLoading:
          isSubscriptionLoading ?? this.isSubscriptionLoading,
      subscriptionError: subscriptionError,
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';
  static const _userKey = 'current_user';
  static const _expiresAtKey = 'token_expires_at';

  AuthNotifier(this.ref, [FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage(),
      super(const AuthState()) {
    // Provider初期化時には他のプロバイダーを変更せず、
    // 初期化完了後に非同期でauto loginを実行
    _scheduleAutoLogin();
  }

  /// 初期化完了後にauto loginを実行
  void _scheduleAutoLogin() {
    Future.microtask(() => tryAutoLogin());
  }

  /// ログイン処理（Google/Email自動判別）
  Future<void> login() async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      // Profileの取得例（仮: ID固定 or ストレージから取得）
      // 本来はAuthService/Repository経由で認証し、Profileを取得する
      final service = ref.read(userServiceProvider);
      final profiles = await service.fetchUsers();
      final user = profiles.isNotEmpty ? profiles.first : null;
      if (user == null) throw Exception('ユーザーが見つかりません');
      // expiresAtは仮値
      final expiresAt = (user.updatedAt.millisecondsSinceEpoch ~/ 1000 + 3600);
      await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
      await _storage.write(key: _expiresAtKey, value: expiresAt.toString());
      state = state.copyWith(user: user);
      await _fetchAndSetSubscription(user.id);
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = const AuthState();
      rethrow;
    } finally {
      loading.state = false;
    }
  }

  /// ストレージからauthState/token/有効期限を復元し、APIで最新化
  Future<void> tryAutoLogin() async {
    final loading = ref.read(globalLoadingProvider.notifier);
    final error = ref.read(globalErrorProvider.notifier);
    loading.state = true;
    error.state = null;
    try {
      final userJson = await _storage.read(key: _userKey);
      final token = await _storage.read(key: _tokenKey);
      final expiresAtStr = await _storage.read(key: _expiresAtKey);
      if (userJson != null && token != null) {
        if (expiresAtStr != null) {
          final expiresAt = int.tryParse(expiresAtStr);
          final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          if (expiresAt != null && expiresAt < now) {
            final refreshed = await _refreshToken(token);
            if (!refreshed) {
              await logout();
              return;
            }
          }
        }
        final user = Profile.fromJson(jsonDecode(userJson));
        state = state.copyWith(user: user);
        await _fetchAndSetSubscription(user.id);
        _refreshUserFromApi(token);
      } else {
        state = const AuthState();
      }
    } catch (e) {
      error.state = utils.friendlyErrorMessage(e);
      state = const AuthState();
    } finally {
      loading.state = false;
    }
  }

  /// サブスクリプション情報を取得し状態に反映
  Future<void> _fetchAndSetSubscription(String userId) async {
    state = state.copyWith(
      isSubscriptionLoading: true,
      subscriptionError: null,
    );
    try {
      final subService = ref.read(subscriptionServiceProvider);
      final subs = await subService.fetchSubscriptions(
        profileId: userId,
      ); // profileIdに修正
      final active = subs.where((s) => s.status == 'active').toList();
      if (active.isNotEmpty) {
        state = state.copyWith(
          isSubscribed: true,
          currentSubscription: active.first,
          isSubscriptionLoading: false,
          subscriptionError: null,
        );
      } else {
        state = state.copyWith(
          isSubscribed: false,
          currentSubscription: null,
          isSubscriptionLoading: false,
          subscriptionError: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSubscribed: false,
        currentSubscription: null,
        isSubscriptionLoading: false,
        subscriptionError: utils.friendlyErrorMessage(e),
      );
    }
  }

  /// APIからユーザー情報を再取得し、state/ストレージを最新化
  Future<void> _refreshUserFromApi(String token) async {
    try {
      final service = ref.read(userServiceProvider);
      // トークンでユーザー取得は未実装のため、fetchUsersで代用
      final profiles = await service.fetchUsers();
      final user = profiles.isNotEmpty ? profiles.first : null;
      if (user != null) {
        await updateUser(user);
      }
    } catch (_) {}
  }

  /// API利用前に有効期限を自動チェック＆リフレッシュ
  Future<bool> ensureValidToken() async {
    final token = await _storage.read(key: _tokenKey);
    final expiresAtStr = await _storage.read(key: _expiresAtKey);
    if (token == null || expiresAtStr == null) return false;
    final expiresAt = int.tryParse(expiresAtStr);
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (expiresAt != null && expiresAt < now) {
      final refreshed = await _refreshToken(token);
      if (!refreshed) {
        await logout();
        return false;
      }
    }
    return true;
  }

  /// トークンリフレッシュ（未実装: 必要ならAuthService/Repository経由で実装）
  Future<bool> _refreshToken(String token) async {
    // TODO: 実際のリフレッシュ処理をAuthService/Repositoryで実装
    return false;
  }

  /// authState情報を更新し、ストレージも反映
  Future<void> updateUser(Profile user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
    state = state.copyWith(user: user);
  }

  /// ログアウト
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _expiresAtKey);
    state = const AuthState();
  }
}
