class AiCorrection {
  final String id;
  final String diaryEntryId;
  final String originalText;
  final String correctedText;
  final String suggestionType; // 'grammar', 'expression', 'spelling'
  final String? explanation;
  final DateTime createdAt;

  const AiCorrection({
    required this.id,
    required this.diaryEntryId,
    required this.originalText,
    required this.correctedText,
    required this.suggestionType,
    this.explanation,
    required this.createdAt,
  });

  factory AiCorrection.fromJson(Map<String, dynamic> json) {
    return AiCorrection(
      id: json['id'] as String,
      diaryEntryId: json['diary_entry_id'] as String,
      originalText: json['original_text'] as String,
      correctedText: json['corrected_text'] as String,
      suggestionType: json['suggestion_type'] as String,
      explanation: json['explanation'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diary_entry_id': diaryEntryId,
      'original_text': originalText,
      'corrected_text': correctedText,
      'suggestion_type': suggestionType,
      'explanation': explanation,
      'created_at': createdAt.toIso8601String(),
    };
  }
}