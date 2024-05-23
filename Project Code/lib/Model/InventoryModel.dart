import 'package:flutter/cupertino.dart';

class InventoryModel {
  String name;
  String category;
  int quantity;
  DateTime expire;
  int maxquantity;

  InventoryModel(
      {required this.expire,
      required this.name,
      required this.category,
      required this.quantity,
      required this.maxquantity});
  Map<String, dynamic> toMapWithoutController() {
    return {
      'name': name,
      'category': category,
      'expiredate': expire,
      'quantity': quantity,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      name: map['Name'] ?? '',
      category: map['Category'] ?? '',
      expire: map['expiredate'].toDate() ?? DateTime.now(),
      quantity: map['Quantity'] ?? 0,
      maxquantity: map['Quantity'] ?? 0,
    );
  }
}
