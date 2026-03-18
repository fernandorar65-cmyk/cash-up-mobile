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
    final dynamic amountRaw = json['totalAmount'] ??
        json['total_amount'] ??
        json['amount'] ??
        json['installmentAmount'];

    num? amount;
    if (amountRaw is num) {
      amount = amountRaw;
    } else {
      amount = num.tryParse('$amountRaw');
    }

    return Installment(
      number: json['number'] is int ? json['number'] as int : int.tryParse('${json['number']}'),
      amount: amount,
      dueDate: json['dueDate']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

