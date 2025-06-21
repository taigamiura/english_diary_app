import 'package:flutter_test/flutter_test.dart';
import 'package:english_diary_app/constants/app_strings.dart';

void main() {
  group('AppStrings Tests', () {
    test('should have audio recording strings defined', () {
      expect(AppStrings.recordAudioStartPrompt, equals('音声録音を開始しますか？'));
      expect(AppStrings.recordingInProgress, equals('音声録音中...'));
      expect(AppStrings.aiVoice, equals('AI音声'));
      expect(AppStrings.recordingCheck, equals('録音確認'));
    });

    test('should have button action strings defined', () {
      expect(AppStrings.cancel, equals('CANCEL'));
      expect(AppStrings.yes, equals('YES'));
      expect(AppStrings.save, equals('保存'));
    });

    test('should have authentication strings defined', () {
      expect(AppStrings.signInWithGoogle, equals('Googleで始める'));
      expect(AppStrings.signInFailed, equals('サインインに失敗しました'));
    });

    test('should have content validation strings defined', () {
      expect(AppStrings.contentRequired, equals('Content required'));
    });

    test('should have AI correction strings defined', () {
      expect(AppStrings.aiCorrectionStart, equals('AI添削を開始しますか？'));
      expect(AppStrings.aiCorrectionInProgress, equals('AI添削を実行中...'));
    });

    test('should have error handling strings defined', () {
      expect(AppStrings.appInitFailed, equals('アプリの起動に失敗しました'));
      expect(AppStrings.restart, equals('再起動'));
    });

    test('should have diary sample text defined', () {
      expect(AppStrings.diarySampleText, isNotEmpty);
      expect(
        AppStrings.diarySampleText.contains('Today was a wonderful day'),
        isTrue,
      );
      expect(AppStrings.diarySampleText.length, greaterThan(100));
    });

    test('should have consistent string formats', () {
      // Test Japanese strings end with appropriate punctuation
      expect(AppStrings.recordAudioStartPrompt.endsWith('？'), isTrue);
      expect(AppStrings.recordingInProgress.endsWith('...'), isTrue);
      expect(AppStrings.signInFailed.endsWith('した'), isTrue);
      expect(AppStrings.aiCorrectionStart.endsWith('？'), isTrue);
      expect(AppStrings.aiCorrectionInProgress.endsWith('...'), isTrue);
      expect(AppStrings.appInitFailed.endsWith('した'), isTrue);
    });

    test('should have proper English button labels', () {
      expect(AppStrings.cancel.toUpperCase(), equals(AppStrings.cancel));
      expect(AppStrings.yes.toUpperCase(), equals(AppStrings.yes));
    });

    test('should have non-empty strings', () {
      expect(AppStrings.recordAudioStartPrompt, isNotEmpty);
      expect(AppStrings.recordingInProgress, isNotEmpty);
      expect(AppStrings.aiVoice, isNotEmpty);
      expect(AppStrings.recordingCheck, isNotEmpty);
      expect(AppStrings.cancel, isNotEmpty);
      expect(AppStrings.yes, isNotEmpty);
      expect(AppStrings.diarySampleText, isNotEmpty);
      expect(AppStrings.signInWithGoogle, isNotEmpty);
      expect(AppStrings.signInFailed, isNotEmpty);
      expect(AppStrings.save, isNotEmpty);
      expect(AppStrings.contentRequired, isNotEmpty);
      expect(AppStrings.aiCorrectionStart, isNotEmpty);
      expect(AppStrings.aiCorrectionInProgress, isNotEmpty);
      expect(AppStrings.appInitFailed, isNotEmpty);
      expect(AppStrings.restart, isNotEmpty);
    });

    test('should be accessible as static constants', () {
      // Test that they're compile-time constants
      const recordPrompt = AppStrings.recordAudioStartPrompt;
      const cancelButton = AppStrings.cancel;
      const sampleText = AppStrings.diarySampleText;

      expect(recordPrompt, equals('音声録音を開始しますか？'));
      expect(cancelButton, equals('CANCEL'));
      expect(sampleText, isNotEmpty);
    });

    test('should maintain immutability', () {
      final firstAccess = AppStrings.recordAudioStartPrompt;
      final secondAccess = AppStrings.recordAudioStartPrompt;
      expect(firstAccess, equals(secondAccess));
      expect(identical(firstAccess, secondAccess), isTrue);
    });

    test('should have proper UI text formatting', () {
      // Check for consistent spacing and formatting
      expect(
        AppStrings.recordAudioStartPrompt.trim(),
        equals(AppStrings.recordAudioStartPrompt),
      );
      expect(
        AppStrings.signInWithGoogle.trim(),
        equals(AppStrings.signInWithGoogle),
      );
      expect(
        AppStrings.aiCorrectionStart.trim(),
        equals(AppStrings.aiCorrectionStart),
      );
    });

    test('should have appropriate text lengths for UI', () {
      // Ensure button text isn't too long
      expect(AppStrings.cancel.length, lessThan(20));
      expect(AppStrings.yes.length, lessThan(20));
      expect(AppStrings.save.length, lessThan(20));
      expect(AppStrings.restart.length, lessThan(20));

      // Ensure prompts are reasonable length
      expect(AppStrings.recordAudioStartPrompt.length, lessThan(100));
      expect(AppStrings.aiCorrectionStart.length, lessThan(100));
    });

    test('should have consistent language usage', () {
      // Japanese strings should contain Japanese characters
      final japaneseStrings = [
        AppStrings.recordAudioStartPrompt,
        AppStrings.recordingInProgress,
        AppStrings.aiVoice,
        AppStrings.recordingCheck,
        AppStrings.signInWithGoogle,
        AppStrings.signInFailed,
        AppStrings.save,
        AppStrings.aiCorrectionStart,
        AppStrings.aiCorrectionInProgress,
        AppStrings.appInitFailed,
        AppStrings.restart,
      ];

      for (final str in japaneseStrings) {
        // Check if string contains Japanese characters (Hiragana, Katakana, or Kanji)
        final hasJapanese = RegExp(
          r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]',
        ).hasMatch(str);
        expect(
          hasJapanese,
          isTrue,
          reason: 'String "$str" should contain Japanese characters',
        );
      }
    });
  });
}
