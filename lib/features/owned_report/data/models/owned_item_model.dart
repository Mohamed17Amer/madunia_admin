import 'package:cloud_firestore/cloud_firestore.dart';

class OwnedItem {
  final String id;
  final String recordName;
  final double recordMoneyValue;
  final String status;
  final DateTime? createdAt; // Changed to DateTime for proper sorting
  final Map<String, dynamic>? additionalFields;

  OwnedItem({
    required this.id,
    required this.recordName,
    required this.recordMoneyValue,
    required this.status,
    this.createdAt, // Made optional since it can be null initially
    this.additionalFields,
  });

  /// Create OwnedItem from Firestore document
  factory OwnedItem.fromMap(Map<String, dynamic> map, String documentId) {
    return OwnedItem(
      id: documentId,
      recordName: map['recordName'] ?? '',
      recordMoneyValue: (map['recordMoneyValue'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: _parseTimestamp(map['createdAt']), // Safe timestamp parsing
      additionalFields: map['additionalFields'] != null 
          ? Map<String, dynamic>.from(map['additionalFields'])
          : null,
    );
  }

  /// Convert OwnedItem to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'recordName': recordName,
      'recordMoneyValue': recordMoneyValue,
      'status': status,
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(), // Use server timestamp if null
      if (additionalFields != null) 'additionalFields': additionalFields,
    };
  }

  /// Copy with method for updates
  OwnedItem copyWith({
    String? id,
    String? recordName,
    double? recordMoneyValue,
    String? status,
    DateTime? createdAt,
    Map<String, dynamic>? additionalFields,
  }) {
    return OwnedItem(
      id: id ?? this.id,
      recordName: recordName ?? this.recordName,
      recordMoneyValue: recordMoneyValue ?? this.recordMoneyValue,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      additionalFields: additionalFields ?? this.additionalFields,
    );
  }

  /// Helper method to safely parse Firestore timestamp
  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    
    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is DateTime) {
        return timestamp;
      } else if (timestamp is String) {
        return DateTime.parse(timestamp);
      } else if (timestamp is int) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      // If parsing fails, return null
      return null;
    }
    
    return null;
  }

  /// Get formatted date string
  String get formattedDate {
    if (createdAt == null) return 'Unknown date';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays == 0) {
      return 'Today ${_formatTime(createdAt!)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${_formatTime(createdAt!)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
    }
  }

  /// Helper to format time
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  String toString() {
    return 'OwnedItem(id: $id, recordName: $recordName, recordMoneyValue: $recordMoneyValue, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is OwnedItem &&
        other.id == id &&
        other.recordName == recordName &&
        other.recordMoneyValue == recordMoneyValue &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        recordName.hashCode ^
        recordMoneyValue.hashCode ^
        status.hashCode ^
        createdAt.hashCode;
  }
}