class AccountModel {
  final int id;
  final String name;
  final String type;
  final double balance;
  final String currency;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? 'CHECKING',
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'currency': currency,
    };
  }
}