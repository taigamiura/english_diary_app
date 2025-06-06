class Payment {
  final int id;
  final String userId;
  final int subscriptionId;
  final double amount;
  final String currency;
  final DateTime paymentDate;
  final String status; // 'succeeded', 'failed', 'pending'
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.amount,
    required this.currency,
    required this.paymentDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      userId: json['user_id'],
      subscriptionId: json['subscription_id'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      paymentDate: DateTime.parse(json['payment_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'subscription_id': subscriptionId,
      'amount': amount,
      'currency': currency,
      'payment_date': paymentDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}