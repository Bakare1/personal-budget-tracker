class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String defaultCurrency;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.defaultCurrency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      defaultCurrency: json['defaultCurrency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'defaultCurrency': defaultCurrency,
    };
  }
}