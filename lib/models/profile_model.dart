class Profile {
  final String id;
  final String googleUid;
  final String? name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.googleUid,
    this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'].toString(),
      googleUid: json['google_uid'].toString(),
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'google_uid': googleUid,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}