import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryReceive {
  final List<Map<String, dynamic>> items;
  final String address;
  final String status;
  final DateTime requestedDate;
  final String requestedBy;

  InventoryReceive({
    required this.items,
    required this.address,
    required this.status,
    required this.requestedDate,
    required this.requestedBy,
  });

  factory InventoryReceive.fromMap(Map<String, dynamic> map) {
    return InventoryReceive(
      items: List<Map<String, dynamic>>.from(map['Items'] ?? []),
      address: map['Address'] ?? '',
      status: map['status'] ?? '',
      requestedDate: (map['requested date'] as Timestamp).toDate(),
      requestedBy: map['requested by'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Items': items,
      'Address': address,
      'status': status,
      'requested date': requestedDate,
      'requested by': requestedBy,
    };
  }
}
