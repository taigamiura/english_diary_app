import 'dart:io';

import 'package:kiwi/providers/auth_provider.dart';
import 'package:kiwi/providers/global_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // アプリの初期化完了後にスプラッシュスクリーンを削除
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(globalLoadingProvider);
    final isMobile = Platform.isIOS || Platform.isAndroid;
    return Scaffold(
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // メインアイコン
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/app-logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    // サブタイトル
                    const Text(
                      '英語で自分を語る、毎日の習慣。',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C757D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // ログインボタン
                    if (isMobile)
                      Container(
                        width: 280,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed:
                              isMobile
                                  ? () async {
                                    await ref
                                        .read(authStateProvider.notifier)
                                        .login();
                                    if (context.mounted) {
                                      // ログイン後に日記一覧ページへ遷移（履歴からWelcomeを消す）
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushReplacementNamed('/diaryList');
                                    }
                                  }
                                  : null,
                          icon: Image.asset(
                            'assets/google-web-light-rd-na@4x.png',
                            height: 24,
                          ),
                          label: const Text(
                            'Googleで始める',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}
