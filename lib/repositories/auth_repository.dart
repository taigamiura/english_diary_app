import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:english_diary_app/utils/repository_logger.dart';

/// Supabase Auth（認証）専用のサービス
class AuthRepository {
  final SupabaseClient client;
  AuthRepository({SupabaseClient? client}) : client = client ?? Supabase.instance.client;

  Future<AuthResponse> signUpWithEmail() =>
      logRequestResponse('AuthRepository.signUpWithEmail',
        () async {
          final email = dotenv.env['DEV_USER_EMAIL']!;
          final password = dotenv.env['DEV_USER_PASSWORD']!;
          return await client.auth.signUp(email: email, password: password);
        },
        requestDetail: 'email: \\${dotenv.env['DEV_USER_EMAIL']}',
      );

  Future<AuthResponse> signInWithEmail() =>
      logRequestResponse('AuthRepository.signInWithEmail',
        () async {
          final email = dotenv.env['DEV_USER_EMAIL']!;
          final password = dotenv.env['DEV_USER_PASSWORD']!;
          return await client.auth.signInWithPassword(email: email, password: password);
        },
        requestDetail: 'email: \\${dotenv.env['DEV_USER_EMAIL']}',
      );

  Future<AuthResponse> signInWithGoogle() =>
      logRequestResponse('AuthRepository.signInWithGoogle',
        () async {
          final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
          final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
          if (iosClientId == null || webClientId == null) {
            throw Exception('Google認証用のクライアントIDが環境変数に設定されていません。');
          }
          final GoogleSignIn googleSignIn = GoogleSignIn(
            clientId: iosClientId,
            serverClientId: webClientId,
          );
          final googleUser = await googleSignIn.signIn();
          if (googleUser == null) {
            throw Exception('Google Sign-In failed. ユーザーがキャンセルしたか認証に失敗しました。');
          }
          final googleAuth = await googleUser.authentication;
          final accessToken = googleAuth.accessToken;
          final idToken = googleAuth.idToken;
          if (accessToken == null) {
            throw Exception('Google認証: Access Tokenが取得できませんでした。');
          }
          if (idToken == null) {
            throw Exception('Google認証: ID Tokenが取得できませんでした。');
          }
          return await client.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );
        },
      );

  Future<void> signOut() =>
      logRequestResponseVoid('AuthRepository.signOut',
        () async {
          await client.auth.signOut();
        },
      );
}
