class Diary {
  final String? id;
  final String userId;
  final String textInput;
  final String? voiceInputUrl;
  final String? transcription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Diary({
    this.id,
    required this.userId,
    required this.textInput,
    this.voiceInputUrl,
    this.transcription,
    this.createdAt,
    this.updatedAt,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      textInput: json['text_input'],
      voiceInputUrl: json['voice_input_url'],
      transcription: json['transcription'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'text_input': textInput,
      'voice_input_url': voiceInputUrl,
      'transcription': transcription,
    };
  }
}

