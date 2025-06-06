import 'package:collection/collection.dart';
import 'package:english_diary_app/constants/app_colors.dart';
import 'package:english_diary_app/constants/app_strings.dart';
import 'package:english_diary_app/providers/auth_provider.dart';
import 'package:english_diary_app/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:english_diary_app/providers/diary_provider.dart';

class DiaryEditPage extends ConsumerStatefulWidget {
  final String diaryId;
  const DiaryEditPage({super.key, required this.diaryId});

  @override
  ConsumerState<DiaryEditPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends ConsumerState<DiaryEditPage> {
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();
  var _title = '';

  @override
  void initState() {
    super.initState();
    final userId = ref.read(authStateProvider).user?.id;
    final diary = ref.read(diaryListProvider).items.firstWhereOrNull((d) => d.id == widget.diaryId && d.userId == userId);
    if (diary != null) {
      _contentController.text = diary.textInput;
      _title = '${diary.createdAt!.year}年${diary.createdAt!.month}月${diary.createdAt!.day}日';
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _updateDiary() async {
    final content = _contentController.text;
    if (content.isEmpty) {
      showErrorSnackBar(context, AppStrings.contentRequired);
      return;
    }
    try {
      await ref.read(diaryListProvider.notifier).updateDiary(
        id: widget.diaryId,
        textInput: content,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      showErrorSnackBar(context, '日記の保存に失敗しました: $e');
    }
  }

  void _aiCorrector() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(AppStrings.aiCorrectionStart),
        action: SnackBarAction(
          label: AppStrings.yes,
          onPressed: () {
            showInfoSnackBar(context, AppStrings.aiCorrectionInProgress);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          TextButton(
            onPressed: _updateDiary,
            child: Text(AppStrings.save, style: TextStyle(color: AppColors.mainColor)),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta != null && details.primaryDelta! > 5) {
            _focusNode.unfocus();
          }
        },
        onTap: () {
          _focusNode.unfocus();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _contentController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                hintText: '今の気持ちや今日の出来事を書いてみよう\nWrite about your feelings or today\'s events\n',
                hintStyle: TextStyle(color: AppColors.suportTextColor),
              ),
              maxLines: null,
              minLines: 30,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _aiCorrector,
        heroTag: 'aiCorrector',
        child: const Icon(Icons.auto_awesome, color: AppColors.secondaryColor),
      ),
    );
  }
}
