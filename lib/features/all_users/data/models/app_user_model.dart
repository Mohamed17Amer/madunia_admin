import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';

class AppUser {
  final String id;
  final String uniqueName;
  final String phoneNumber;
  final double totalDebitMoney;
  final double totalMoneyOwed;
  final double totalOwnedMoney; // ✅ NEW FIELD ADDED
  final List<DebitItem> debitItems;

  AppUser({
    required this.id,
    required this.uniqueName,
    required this.phoneNumber,
    required this.totalDebitMoney,
    required this.totalMoneyOwed,
    required this.totalOwnedMoney, // ✅ NEW FIELD ADDED
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
      totalOwnedMoney: (map['totalOwnedMoney'] ?? 0.0).toDouble(), // ✅ NEW FIELD ADDED
      debitItems: debitItems,
    );
  }

  Map<String, dynamic> toMap({bool includeDebitItems = false}) {
    final map = {
      'uniqueName': uniqueName,
      'phoneNumber': phoneNumber,
      'totalDebitMoney': totalDebitMoney,
      'totalMoneyOwed': totalMoneyOwed,
      'totalOwnedMoney': totalOwnedMoney, // ✅ NEW FIELD ADDED
    };

    if (includeDebitItems) {
      map['debitItems'] = debitItems.map((item) => item.toMap()).toList();
    }

    return map;
  }

  // ✅ OPTIONAL: Add copyWith method for easier updates
  AppUser copyWith({
    String? id,
    String? uniqueName,
    String? phoneNumber,
    double? totalDebitMoney,
    double? totalMoneyOwed,
    double? totalOwnedMoney,
    List<DebitItem>? debitItems,
  }) {
    return AppUser(
      id: id ?? this.id,
      uniqueName: uniqueName ?? this.uniqueName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalDebitMoney: totalDebitMoney ?? this.totalDebitMoney,
      totalMoneyOwed: totalMoneyOwed ?? this.totalMoneyOwed,
      totalOwnedMoney: totalOwnedMoney ?? this.totalOwnedMoney,
      debitItems: debitItems ?? this.debitItems,
    );
  }

  // ✅ OPTIONAL: Add toString for debugging
  @override
  String toString() {
    return 'AppUser(id: $id, uniqueName: $uniqueName, phoneNumber: $phoneNumber, '
           'totalDebitMoney: $totalDebitMoney, totalMoneyOwed: $totalMoneyOwed, '
           'totalOwnedMoney: $totalOwnedMoney, debitItems: ${debitItems.length})';
  }
}