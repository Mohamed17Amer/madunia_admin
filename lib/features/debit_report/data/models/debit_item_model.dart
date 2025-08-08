class DebitItem {
  final String id;
  final String recordName;
  final double recordMoneyValue;
  final String status;
  final Map<String, dynamic>? additionalFields;

  DebitItem({
    required this.id,
    required this.recordName,
    required this.recordMoneyValue,
    required this.status,
    this.additionalFields,
  });

  factory DebitItem.fromMap(Map<String, dynamic> map, String documentId) {
    return DebitItem(
      id: documentId,
      recordName: map['recordName'] ?? '',
      recordMoneyValue: (map['recordMoneyValue'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      additionalFields: Map<String, dynamic>.from(map['additionalFields'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recordName': recordName,
      'recordMoneyValue': recordMoneyValue,
      'status': status,
      'additionalFields': additionalFields ?? {},
    };
  }
}