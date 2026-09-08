class TransactionModel {
  final int id;
  final int accountId;
  final String? accountName;
  final int? categoryId;
  final String? categoryName;
  final double amount;
  final String type; // INCOME or EXPENSE
  final String? note;
  final DateTime transactionDate;

  TransactionModel({
    required this.id,
    required this.accountId,
    this.accountName,
    this.categoryId,
    this.categoryName,
    required this.amount,
    required this.type,
    this.note,
    required this.transactionDate,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      accountId: json['accountId'],
      accountName: json['accountName'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] ?? 'EXPENSE',
      note: json['note'],
      transactionDate: DateTime.parse(json['transactionDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'categoryId': categoryId,
      'amount': amount,
      'type': type,
      'note': note,
      'transactionDate': transactionDate.toIso8601String(),
    };
  }
}