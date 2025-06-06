import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:english_diary_app/utils/repository_logger.dart';
import 'package:english_diary_app/utils/logger_utils.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode, dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      AppLogger.e(message, error: error ?? this, stackTrace: stackTrace);
    } else {
      // Sentryに例外を送信
      Sentry.captureException(error ?? this, stackTrace: stackTrace);
    }
  }

  @override
  String toString() => 'ApiException: $message (statusCode: $statusCode)';
}

class ApiRepository {
  final SupabaseClient client;

  ApiRepository({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  /// 一覧取得
  Future<List<Map<String, dynamic>>> fetchList({
    required String table,
    Map<String, dynamic>? filters,
    int? limit,
    String? orderBy,
    bool ascending = true,
  }) =>
      logRequestResponse('ApiRepository.fetchList',
        () async {
          dynamic query = client.from(table).select();
          filters?.forEach((key, value) {
            query = query.eq(key, value);
          });
          if (orderBy != null) {
            query = query.order(orderBy, ascending: ascending);
          }
          if (limit != null) {
            query = query.limit(limit);
          }
          final result = await query;
          return List<Map<String, dynamic>>.from(result);
        },
        requestDetail: 'table: $table, filters: \\${filters?.toString() ?? ''}',
      );

  /// 1件取得
  Future<Map<String, dynamic>?> fetchOne({
    required String table,
    required String id,
    String idColumn = 'id',
  }) =>
      logRequestResponse('ApiRepository.fetchOne',
        () async {
          final result = await client.from(table).select().eq(idColumn, id).limit(1);
          if (result.isNotEmpty) {
            return Map<String, dynamic>.from(result.first);
          }
          return null;
        },
        requestDetail: 'table: $table, id: $id',
      );

  /// 複数INSERT
  Future<void> insertMany({
    required String table,
    required List<Map<String, dynamic>> data,
  }) =>
      logRequestResponseVoid('ApiRepository.insertMany',
        () async {
          await client.from(table).insert(data);
        },
        requestDetail: 'table: $table, count: \\${data.length}',
      );

  /// 1件INSERT
  Future<void> insertOne({
    required String table,
    required Map<String, dynamic> data,
  }) =>
      logRequestResponseVoid('ApiRepository.insertOne',
        () async {
          await client.from(table).insert(data);
        },
        requestDetail: 'table: $table',
      );

  /// 複数UPDATE
  Future<void> updateMany({
    required String table,
    required List<Map<String, dynamic>> data,
    required String idColumn,
  }) =>
      logRequestResponseVoid('ApiRepository.updateMany',
        () async {
          for (final item in data) {
            final id = item[idColumn];
            if (id != null) {
              await client.from(table).update(item).eq(idColumn, id);
            }
          }
        },
        requestDetail: 'table: $table, count: \\${data.length}',
      );

  /// 1件UPDATE
  Future<void> updateOne({
    required String table,
    required String id,
    required Map<String, dynamic> data,
    String idColumn = 'id',
  }) =>
      logRequestResponseVoid('ApiRepository.updateOne',
        () async {
          await client.from(table).update(data).eq(idColumn, id);
        },
        requestDetail: 'table: $table, id: $id',
      );

  /// 複数DELETE
  Future<void> deleteMany({
    required String table,
    required List<String> ids,
    String idColumn = 'id',
  }) =>
      logRequestResponseVoid('ApiRepository.deleteMany',
        () async {
          await client.from(table).delete().inFilter(idColumn, ids);
        },
        requestDetail: 'table: $table, count: \\${ids.length}',
      );

  /// 1件DELETE
  Future<void> deleteOne({
    required String table,
    required String id,
    String idColumn = 'id',
  }) =>
      logRequestResponseVoid('ApiRepository.deleteOne',
        () async {
          await client.from(table).delete().eq(idColumn, id);
        },
        requestDetail: 'table: $table, id: $id',
      );

  /// ユーザーのログイン
  Future<void> login() =>
      logRequestResponseVoid('ApiRepository.login',
        () async {
          if (kDebugMode) {
            await _signInWithEmail();
          } else {
            await _signInWithGoogle();
          }
        },
      );

  Future<void> _signInWithGoogle() =>
      logRequestResponseVoid('ApiRepository._signInWithGoogle',
        () async {
          final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID']!;
          final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
          final GoogleSignIn googleSignIn = GoogleSignIn(
            clientId: iosClientId,
            serverClientId: webClientId,
          );
          final googleUser = await googleSignIn.signIn();
          if (googleUser == null) {
            throw 'Google Sign-In failed.';
          }
          final googleAuth = await googleUser.authentication;
          final accessToken = googleAuth.accessToken;
          final idToken = googleAuth.idToken;
          if (accessToken == null) {
            throw 'No Access Token found.';
          }
          if (idToken == null) {
            throw 'No ID Token found.';
          }
          await client.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );
        },
      );

  Future<void> _signInWithEmail() =>
      logRequestResponseVoid('ApiRepository._signInWithEmail',
        () async {
          await client.auth.signInWithPassword(
            email: dotenv.env['DEV_USER_EMAIL']!,
            password: dotenv.env['DEV_USER_PASSWORD']!,
          );
        },
      );
}