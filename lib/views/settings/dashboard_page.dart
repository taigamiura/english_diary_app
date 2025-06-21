import 'package:english_diary_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:english_diary_app/constants/app_colors.dart';
import 'package:english_diary_app/providers/diary_provider.dart';
import 'package:english_diary_app/providers/selected_month_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // 初期化時に日記データを取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authStateProvider).user?.id;
      ref
          .read(diaryListProvider.notifier)
          .fetchDiaries(userId: userId.toString(), limit: 0);
      ref
          .read(diaryListProvider.notifier)
          .fetchAverageTextInput(userId: userId.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    // ログインしていなければWelcomePageにリダイレクト
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    });
    final userId = ref.watch(authStateProvider).user?.id;
    final selectedMonth = ref.watch(selectedMonthProvider);
    final diaryState = ref.watch(diaryListProvider);
    final diaries = diaryState.items;
    final averageTextInput = diaryState.averageTextInput;
    final postedDates = diaries.map((d) => d.createdAt!).toList();
    final streak = _calcStreak(postedDates);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (userId != null) {
                ref
                    .read(diaryListProvider.notifier)
                    .fetchDiaries(
                      userId: userId,
                      from: DateTime(
                        selectedMonth.year,
                        selectedMonth.month,
                        1,
                      ),
                      to: DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                        0,
                        23,
                        59,
                        59,
                        999,
                      ),
                      limit: 31,
                    );
                ref
                    .read(diaryListProvider.notifier)
                    .fetchPostedMonths(userId: userId);
              }
            });
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 会員プランカード
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: Colors.amber[800],
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '会員プラン',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '無料プラン: 日記投稿・閲覧・音声録音利用',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'プレミアム: AI添削・音声再生使い放題',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: プランアップグレード画面へ遷移
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('プレミアムにアップグレード'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 連続投稿日数・平均投稿文字数 横並び（常にRow+Expandedでレスポンシブ対応）
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: _buildStreakCard(streak),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: _buildAvgLengthCard(diaries, averageTextInput),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // おすすめコンテンツ例
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'おすすめ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(
                          Icons.lightbulb,
                          color: AppColors.mainColor,
                        ),
                        title: const Text('英語日記の書き方Tips'),
                        subtitle: const Text('毎日続けるコツや表現例を紹介'),
                        onTap: () {
                          // TODO: Tipsページへ遷移
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.book,
                          color: AppColors.mainColor,
                        ),
                        title: const Text('おすすめ英語教材'),
                        subtitle: const Text('初心者から上級者まで使える教材を厳選'),
                        onTap: () {
                          // TODO: 教材紹介ページへ遷移
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 連続投稿日数を計算するヘルパーメソッド
  int _calcStreak(List<DateTime> postedDates) {
    if (postedDates.isEmpty) return 0;
    // 日付を「年月日」単位で重複排除し、昇順にソート
    final uniqueDates =
        postedDates
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet()
            .toList()
          ..sort((a, b) => a.compareTo(b));

    int streak = 0;
    DateTime day = DateTime.now();

    // 今日から過去に向かって連続している日数をカウント
    while (uniqueDates.isNotEmpty &&
        uniqueDates.last == DateTime(day.year, day.month, day.day)) {
      streak++;
      uniqueDates.removeLast();
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Widget _buildStreakCard(int streak) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.local_fire_department,
              color: Colors.orange[700],
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      '連続投稿日数',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '$streak 日',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvgLengthCard(List diaries, int averageTextInput) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.text_fields, color: Colors.blue[700], size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      '平均投稿文字数',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '$averageTextInput 文字',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
