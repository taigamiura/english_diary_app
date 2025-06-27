import 'dart:async';
import 'package:collection/collection.dart';
import 'package:kiwi/constants/app_colors.dart';
import 'package:kiwi/constants/app_strings.dart';
import 'package:kiwi/providers/auth_provider.dart';
import 'package:kiwi/utils/snackbar_utils.dart';
import 'package:kiwi/views/diaries/diary_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiwi/providers/diary_provider.dart';

class DiaryIdPage extends ConsumerStatefulWidget {
  final String diaryId;
  const DiaryIdPage({super.key, required this.diaryId});

  @override
  ConsumerState<DiaryIdPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends ConsumerState<DiaryIdPage> {
  bool _isAiVoiceSelected = false;
  bool _isRecordingSelected = true;
  bool _isRecording = false;
  bool _isPlaying = false;
  Timer? _timer;
  Duration _currentDuration = Duration.zero;
  final Duration _totalDuration = const Duration(minutes: 3);

  void _togglePlayback() {
    setState(() {
      if (_isPlaying) {
        _isPlaying = false;
        _timer?.cancel();
      } else {
        _isPlaying = true;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_currentDuration < _totalDuration) {
              _currentDuration += const Duration(seconds: 1);
            } else {
              _timer?.cancel();
              _isPlaying = false;
            }
          });
        });
      }
    });
  }

  void _resetPlayback() {
    setState(() {
      _isPlaying = false;
      _timer?.cancel();
      _currentDuration = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _recordAudio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: SizedBox(
            height: 70,
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.mic, size: 48, color: AppColors.mainColor),
                  Text(AppStrings.recordAudioStartPrompt),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                // TODO: 録音開始ロジックを実装
                setState(() {
                  _isRecording = true;
                });
                Navigator.of(dialogContext).pop();
                showInfoSnackBar(context, AppStrings.recordingInProgress);
              },
              child: Text(AppStrings.yes),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authStateProvider).user?.id;
    final diaryState = ref.watch(diaryListProvider);
    final diary = diaryState.items.firstWhereOrNull(
      (d) => d.id == widget.diaryId && d.userId == userId,
    );
    if (diary == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('日記が見つかりません')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${diary.createdAt!.year}年${diary.createdAt!.month}月${diary.createdAt!.day}日',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryEditPage(diaryId: widget.diaryId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(diary.textInput, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton:
          _isRecording
              ? null
              : FloatingActionButton(
                onPressed: () => _recordAudio(context),
                shape: const CircleBorder(),
                child: Icon(Icons.mic, color: AppColors.secondaryColor),
              ),
      bottomNavigationBar:
          _isRecording
              ? null
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                // TODO: AI音声の再生ロジックを実装
                                if (!_isAiVoiceSelected) {
                                  _resetPlayback();
                                }
                                _isAiVoiceSelected = true;
                                _isRecordingSelected = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _isAiVoiceSelected
                                      ? AppColors.mainColor
                                      : AppColors.secondaryColor,
                            ),
                            icon: Icon(
                              Icons.volume_up,
                              color:
                                  _isAiVoiceSelected
                                      ? AppColors.secondaryColor
                                      : AppColors.mainColor,
                            ),
                            label: Text(
                              AppStrings.aiVoice,
                              style: TextStyle(
                                color:
                                    _isAiVoiceSelected
                                        ? AppColors.secondaryColor
                                        : AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: 録音の再生ロジックを実装
                              setState(() {
                                if (!_isRecordingSelected) {
                                  _resetPlayback();
                                }
                                _isAiVoiceSelected = false;
                                _isRecordingSelected = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _isRecordingSelected
                                      ? AppColors.mainColor
                                      : AppColors.secondaryColor,
                            ),
                            icon: Icon(
                              Icons.mic,
                              color:
                                  _isRecordingSelected
                                      ? AppColors.secondaryColor
                                      : AppColors.mainColor,
                            ),
                            label: Text(
                              AppStrings.recordingCheck,
                              style: TextStyle(
                                color:
                                    _isRecordingSelected
                                        ? AppColors.secondaryColor
                                        : AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            _formatDuration(_currentDuration),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _currentDuration.inSeconds.toDouble(),
                            min: 0,
                            max: _totalDuration.inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _currentDuration = Duration(
                                  seconds: value.toInt(),
                                );
                              });
                            },
                            activeColor: AppColors.mainColor,
                            inactiveColor: AppColors.secondaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _formatDuration(_totalDuration),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_5),
                          onPressed: () {
                            setState(() {
                              _currentDuration -= const Duration(seconds: 5);
                              if (_currentDuration < Duration.zero) {
                                _currentDuration = Duration.zero;
                              }
                            });
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isPlaying
                                    ? AppColors.mainColor
                                    : AppColors.secondaryColor,
                          ),
                          child: IconButton(
                            iconSize: 36.0,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color:
                                  _isPlaying
                                      ? AppColors.secondaryColor
                                      : AppColors.mainColor,
                            ),
                            onPressed: _togglePlayback,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_5),
                          onPressed: () {
                            setState(() {
                              _currentDuration += const Duration(seconds: 5);
                              if (_currentDuration > _totalDuration) {
                                _currentDuration = _totalDuration;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
