import 'package:kiwi/constants/app_colors.dart';
import 'package:kiwi/constants/app_strings.dart';
import 'package:kiwi/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiwi/providers/diary_provider.dart';

class DiaryNewPage extends ConsumerStatefulWidget {
  const DiaryNewPage({super.key});

  @override
  ConsumerState<DiaryNewPage> createState() => _DiaryNewPageState();
}

class _DiaryNewPageState extends ConsumerState<DiaryNewPage> {
  final _contentController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _saveDiary() async {
    final content = _contentController.text;
    if (content.isEmpty) {
      showErrorSnackBar(context, AppStrings.contentRequired);
      return;
    }
    try {
      await ref
          .read(diaryListProvider.notifier)
          .addDiaryFromInput(textInput: content);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      showErrorSnackBar(context, '日記の保存に失敗しました: $e');
    }
  }
  // TODO: AI校正機能の実装
  // void _aiCorrector() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text(AppStrings.aiCorrectionStart),
  //       action: SnackBarAction(
  //         label: AppStrings.yes,
  //         onPressed: () {
  //           showInfoSnackBar(context, AppStrings.aiCorrectionInProgress);
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateTime.now().toLocal().toString().split(' ')[0]),
        actions: [
          TextButton(
            onPressed: _saveDiary,
            child: Text(
              AppStrings.save,
              style: TextStyle(color: AppColors.mainColor),
            ),
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
                hintText:
                    '今の気持ちや今日の出来事を書いてみよう\nWrite about your feelings or today\'s events\n',
                hintStyle: TextStyle(color: AppColors.suportTextColor),
              ),
              maxLines: null,
              minLines: 30,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ),
        ),
      ),
      // TODO: AI校正機能の実装
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _aiCorrector,
      //   heroTag: 'aiCorrector',
      //   child: const Icon(Icons.auto_awesome, color: AppColors.secondaryColor),
      // ),
    );
  }
}
