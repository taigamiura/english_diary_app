import 'dart:io';

import 'package:english_diary_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/providers/global_state_provider.dart';
import 'package:english_diary_app/providers/auth_provider.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingProvider);
    final isMobile = Platform.isIOS || Platform.isAndroid;
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isMobile)
                    ElevatedButton.icon(
                      onPressed: isMobile
                          ? () async {
                              await ref.read(authStateProvider.notifier).login();
                              if (context.mounted) {
                                // ログイン後に日記一覧ページへ遷移（履歴からWelcomeを消す）
                                Navigator.of(context, rootNavigator: true).pushReplacementNamed('/diaryList');
                              }
                            }
                          : null,
                      icon: const Icon(Icons.login),
                      label: const Text('Googleで始める'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}