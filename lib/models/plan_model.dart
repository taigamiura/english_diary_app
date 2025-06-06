class Plan {
  final int id;
  final String name;
  final String? description;
  final double priceMonthly;
  final double? priceYearly;
  final DateTime createdAt;
  final DateTime updatedAt;

  Plan({
    required this.id,
    required this.name,
    this.description,
    required this.priceMonthly,
    this.priceYearly,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      priceMonthly: (json['price_monthly'] as num).toDouble(),
      priceYearly: json['price_yearly'] != null ? (json['price_yearly'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price_monthly': priceMonthly,
      'price_yearly': priceYearly,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}