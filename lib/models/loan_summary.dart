class LoanSummary {
  LoanSummary({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
  });

  final String id;
  final num? amount;
  final String? currency;
  final String? status;

  factory LoanSummary.fromJson(Map<String, dynamic> json) {
    return LoanSummary(
      id: json['id']?.toString() ?? '',
      amount: json['amount'] is num ? json['amount'] as num : json['principal'] as num?,
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

