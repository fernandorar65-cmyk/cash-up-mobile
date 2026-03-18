class Installment {
  Installment({
    required this.number,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  final int? number;
  final num? amount;
  final String? dueDate;
  final String? status;

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      number: json['number'] is int ? json['number'] as int : int.tryParse('${json['number']}'),
      amount: json['amount'] is num ? json['amount'] as num : json['installmentAmount'] as num?,
      dueDate: json['dueDate']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

