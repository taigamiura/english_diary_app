enum ActionType { accepted, ignored }

class DiaryFeedback {
  final String id;
  final String aiCorrectionId;
  final String userId;
  final ActionType action;
  final DateTime createdAt;

  DiaryFeedback({
    required this.id,
    required this.aiCorrectionId,
    required this.userId,
    required this.action,
    required this.createdAt,
  });

  factory DiaryFeedback.fromJson(Map<String, dynamic> json) {
    return DiaryFeedback(
      id: json['id'].toString(),
      aiCorrectionId: json['ai_correction_id'].toString(),
      userId: json['user_id'],
      action: _parseActionType(json['action']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static ActionType _parseActionType(dynamic value) {
    if (value is ActionType) {
      return value;
    }
    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'accepted':
        return ActionType.accepted;
      case 'ignored':
        return ActionType.ignored;
      default:
        throw ArgumentError('Unknown ActionType: $value');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ai_correction_id': aiCorrectionId,
      'user_id': userId,
      'action': action,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
