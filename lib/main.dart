import 'package:english_diary_app/constants/app_constants.dart';
import 'package:english_diary_app/constants/app_colors.dart';
import 'package:english_diary_app/views/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/welcome_page.dart';
import 'views/diaries/diary_index_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeDateFormatting('en');
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    await SentryFlutter.init(
      (options) {
        options.dsn = dotenv.env['SENTRY_DSN']!;
        // リクエストヘッダーやIPアドレスなどの個人情報を送信します。
        options.sendDefaultPii = true;
        // tracesSampleRateを1.0に設定すると、全てのトランザクションをトレースします。
        // 本番環境ではこの値を調整することを推奨します。
        options.tracesSampleRate = 0.2;
        // プロファイリングのサンプリングレートはtracesSampleRateに依存します。
        // 1.0に設定すると、全てのサンプリングされたトランザクションをプロファイルします。
        options.profilesSampleRate = 1.0;
        // 自動セッション追跡を有効化
        options.enableAutoSessionTracking = true;
        // デバッグログを有効化（開発時のみ推奨）
        options.debug = false;
        // アプリのリリースバージョンを設定
        options.release = 'english_diary_app@${dotenv.env['APP_VERSION'] ?? 'unknown'}';
        // アプリの環境（例: production, staging, development）
        options.environment = dotenv.env['APP_ENV'] ?? 'development';
        // ユーザーのフィードバックを有効化
        options.enableUserInteractionBreadcrumbs = true;
        // パフォーマンス監視のための最大イベント数
        options.maxBreadcrumbs = 100;
      },
      appRunner: () => runApp(
        ProviderScope(
          child: SentryWidget(
            child: MyApp(),
          ),
        ),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    if (dotenv.env['SENTRY_DSN'] != null && dotenv.env['SENTRY_DSN']!.isNotEmpty) {
      await Sentry.captureException(e, stackTrace: stackTrace);
    }
    runApp(ErrorPage(error: e, stackTrace: stackTrace));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainColor,
          secondary: AppColors.secondaryColor,
        ),
        appBarTheme: AppBarTheme(
          foregroundColor: AppColors.mainColor,
          backgroundColor: AppColors.secondaryColor,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ja', 'JP'),
      ],
      home: WelcomePage(),
      routes: {
        '/diaryList': (context) => const DiaryIndexPage(),
      },
    );
  }
}
