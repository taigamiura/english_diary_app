import 'package:english_diary_app/constants/app_constants.dart';
import 'package:english_diary_app/constants/app_colors.dart';
import 'package:english_diary_app/views/error_page.dart';
import 'package:flutter/foundation.dart';
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
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || anonKey == null) {
      throw Exception('SUPABASE_URL or SUPABASE_ANON_KEY is not set in .env');
    }
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
    if (!kDebugMode) {
      final sentryDsn = dotenv.env['SENTRY_DSN'];
      if (sentryDsn == null || sentryDsn.isEmpty) {
        throw Exception('SENTRY_DSN is not set in .env');
      }
      await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.sendDefaultPii = true;
        options.tracesSampleRate = 0.2;
        options.profilesSampleRate = 1.0;
        options.enableAutoSessionTracking = true;
        options.debug = false;
        options.release = 'english_diary_app@${dotenv.env['APP_VERSION'] ?? 'unknown'}';
        options.environment = dotenv.env['APP_ENV'] ?? 'development';
        options.enableUserInteractionBreadcrumbs = true;
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
    } else {
      runApp(
      ProviderScope(
        child: MyApp(),
      ),
      );
    }
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
