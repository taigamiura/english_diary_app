import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:kiwi/repositories/diary_repository.dart';
import 'package:kiwi/repositories/profile_repository.dart';
import 'package:kiwi/repositories/api_repository.dart';

// Mock classes
class MockDiaryRepository extends Mock implements DiaryRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockApiRepository extends Mock implements ApiRepository {}

/// Test helper for creating ProviderContainer with overrides
ProviderContainer createTestContainer({List<Override> overrides = const []}) {
  return ProviderContainer(overrides: overrides);
}

/// Common test data factory
class TestDataFactory {
  static Map<String, dynamic> createDiaryJson({
    String id = 'test_diary_id',
    String userId = 'test_user_id',
    String textInput = 'Test diary content',
    String? voiceInputUrl,
    String? transcription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'id': id,
      'user_id': userId,
      'text_input': textInput,
      'voice_input_url': voiceInputUrl,
      'transcription': transcription,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  static Map<String, dynamic> createProfileJson({
    String id = 'test_profile_id',
    String googleUid = 'test_google_uid',
    String? name = 'Test User',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return {
      'id': id,
      'google_uid': googleUid,
      'name': name,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  static Map<String, dynamic> createAiCorrectionJson({
    String id = 'test_correction_id',
    String diaryEntryId = 'test_diary_id',
    String originalText = 'Original text',
    String correctedText = 'Corrected text',
    String suggestionType = 'grammar',
    String? explanation = 'Test explanation',
    DateTime? createdAt,
  }) {
    return {
      'id': id,
      'diary_entry_id': diaryEntryId,
      'original_text': originalText,
      'corrected_text': correctedText,
      'suggestion_type': suggestionType,
      'explanation': explanation,
      'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }
}

/// Matcher for testing async operations
Matcher throwsAsyncException<T extends Object>() {
  return throwsA(isA<T>());
}
