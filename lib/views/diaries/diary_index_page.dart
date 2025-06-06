import 'package:english_diary_app/constants/app_colors.dart';
import '../../widgets/loading_indicator.dart';
import 'diary_id_page.dart';
import 'diary_new_page.dart';
import '../settings/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/providers/diary_provider.dart';
import 'package:english_diary_app/providers/auth_provider.dart';
import 'package:english_diary_app/providers/selected_month_provider.dart';
import 'package:intl/intl.dart';

class DiaryIndexPage extends ConsumerStatefulWidget {
  const DiaryIndexPage({super.key});

  @override
  ConsumerState<DiaryIndexPage> createState() => _DiaryIndexPageState();
}

class _DiaryIndexPageState extends ConsumerState<DiaryIndexPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authStateProvider).user?.id;
      final selectedMonth = ref.read(selectedMonthProvider);
      if (userId != null) {
        ref.read(diaryListProvider.notifier).fetchDiaries(
          userId: userId,
          from: DateTime(selectedMonth.year, selectedMonth.month, 1),
          to: DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59, 999),
          limit: 31,
        );
        ref.read(diaryListProvider.notifier).fetchPostedMonths(userId: userId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaryState = ref.watch(diaryListProvider);
    final diaries = diaryState.items;
    final postedMonths = diaryState.months;
    final authState = ref.watch(authStateProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState.user == null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    });
    final isLoading = diaryState.isLoading;
    final error = diaryState.error;
    final userId = ref.watch(authStateProvider).user?.id;
    final selectedMonth = ref.watch(selectedMonthProvider);

    final sortedDiaries = [...diaries]..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await showModalBottomSheet<DateTime>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return SizedBox(
                        height: 320,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              '月を選択',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Expanded(
                              child: postedMonths.isEmpty
                                  ? const Center(child: Text('投稿した月がありません'))
                                  : ListView.builder(
                                      itemCount: postedMonths.length,
                                      itemBuilder: (context, idx) {
                                        final ym = postedMonths[idx];
                                        final isSelected = (selectedMonth.year == ym.year && selectedMonth.month == ym.month);
                                        return ListTile(
                                          leading: Icon(
                                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                                            color: AppColors.mainColor,
                                          ),
                                          title: Text('${ym.year}年 ${ym.month}月'),
                                          onTap: () {
                                            Navigator.pop(context, DateTime(ym.year, ym.month));
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  if (picked != null) {
                    ref.read(selectedMonthProvider.notifier).state = picked;
                    if (userId != null) {
                      final from = DateTime(picked.year, picked.month, 1);
                      final to = DateTime(picked.year, picked.month + 1, 0, 23, 59, 59, 999);
                      ref.read(diaryListProvider.notifier).fetchDiaries(
                        userId: userId,
                        from: from,
                        to: to,
                        limit: 31,
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withAlpha((0.08 * 255).toInt()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${selectedMonth.month}月',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.mainColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: AppColors.mainColor),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      // dashboard設定画面へ遷移
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardPage()),
                      );
                      if (!mounted) return;
                      // 設定画面から戻ったら、再度日記を取得
                      final userId = ref.read(authStateProvider).user?.id;
                      if (userId != null) {
                        final selectedMonth = ref.read(selectedMonthProvider);
                        ref.read(diaryListProvider.notifier).fetchDiaries(
                          userId: userId,
                          from: DateTime(selectedMonth.year, selectedMonth.month, 1),
                          to: DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59, 999),
                          limit: 31,
                        );
                      }
                      ref.read(diaryListProvider.notifier).fetchPostedMonths(userId: userId!);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withAlpha((0.08 * 255).toInt()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.settings, color: AppColors.mainColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: error != null
            ? Center(child: Text('日記の取得に失敗しました: $error'))
            : isLoading
                ? const Center(child: LoadingIndicator())
                : diaries.isEmpty
                    ? const Center(
                        child: Text(
                          '今月はまだ日記がありません\n「日記を書いてみよう！」',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: diaries.length,
                        itemBuilder: (context, index) {
                          // 新しい順に表示するために逆順アクセス
                          final diary = sortedDiaries[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiaryIdPage(diaryId: diary.id!),
                                ),
                              );
                            },
                            child: Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            '${diary.createdAt!.month}/${diary.createdAt!.day}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.mainColor,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            DateFormat('E', 'en').format(diary.createdAt!),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.mainColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Text(
                                      diary.textInput,
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis, // 内容が長い場合は省略
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var userId = ref.read(authStateProvider).user?.id;
            final now = DateTime.now();
            ref.read(selectedMonthProvider.notifier).state = now;
            final from = DateTime(now.year, now.month, 1);
            final to = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
            await ref.read(diaryListProvider.notifier).fetchDiaries(
              userId: userId.toString(),
              from: from,
              to: to,
              limit: 1,
            );

            if (!mounted) return;

            // dairiesを取得して、今日の日記があるか確認
            final diaries = ref.read(diaryListProvider).items;
            final today = DateTime.now();
            final todayDiaryList = diaries.where(
              (d) => d.createdAt!.year == today.year && d.createdAt!.month == today.month && d.createdAt!.day == today.day,
            );
            if (todayDiaryList.isNotEmpty) {
              final todayDiary = todayDiaryList.first;
              if (context.mounted) {
                // 今日の日記がない場合は新規作成画面へ遷移
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiaryIdPage(diaryId: todayDiary.id!)));
              }
              if (!mounted) return;
              return;
            } else {
              if (context.mounted) {
                  // 今日の日記がない場合は新規作成画面へ遷移
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiaryNewPage()),
                );
              }
            }
            userId = ref.read(authStateProvider).user?.id;
            if (userId != null) {
              final selectedMonth = ref.read(selectedMonthProvider);
              ref.read(diaryListProvider.notifier).fetchDiaries(
                userId: userId,
                from: DateTime(selectedMonth.year, selectedMonth.month, 1),
                to: DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59, 999),
                limit: 31,
              );
            }
          },
          shape: const CircleBorder(),
          child: Icon(Icons.edit, color: AppColors.secondaryColor),
        ),
      ),
    );
  }
}