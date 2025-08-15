import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';


class AppUser {
  final String id;
  final String uniqueName;
  final String phoneNumber;
  final double totalDebitMoney;
  final double totalMoneyOwed;
  final List<DebitItem> debitItems; // New attribute

  AppUser({
    required this.id,
    required this.uniqueName,
    required this.phoneNumber,
    required this.totalDebitMoney,
    required this.totalMoneyOwed,
    required this.debitItems,
  });

  factory AppUser.fromMap(
    Map<String, dynamic> map,
    String documentId, {
    List<DebitItem> debitItems = const [],
  }) {
    return AppUser(
      id: documentId,
      uniqueName: map['uniqueName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      totalDebitMoney: (map['totalDebitMoney'] ?? 0.0).toDouble(),
      totalMoneyOwed: (map['totalMoneyOwed'] ?? 0.0).toDouble(),
      debitItems: debitItems,
    );
  }

  Map<String, dynamic> toMap({bool includeDebitItems = false}) {
    final map = {
      'uniqueName': uniqueName,
      'phoneNumber': phoneNumber,
      'totalDebitMoney': totalDebitMoney,
      'totalMoneyOwed': totalMoneyOwed,
    };

    if (includeDebitItems) {
      map['debitItems'] = debitItems.map((item) => item.toMap()).toList();
    }

    return map;
  }
}
