class AppUser {
  final String id;
  final String uniqueName;
  final String phoneNumber;
  final double totalDebitMoney;
  final double totalMoneyOwed;

  AppUser({
    required this.id,
    required this.uniqueName,
    required this.phoneNumber,
    required this.totalDebitMoney,
    required this.totalMoneyOwed,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String documentId) {
    return AppUser(
      id: documentId,
      uniqueName: map['uniqueName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      totalDebitMoney: (map['totalDebitMoney'] ?? 0.0).toDouble(),
      totalMoneyOwed: (map['totalMoneyOwed'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uniqueName': uniqueName,
      'phoneNumber': phoneNumber,
      'totalDebitMoney': totalDebitMoney,
      'totalMoneyOwed': totalMoneyOwed,
    };
  }
}
