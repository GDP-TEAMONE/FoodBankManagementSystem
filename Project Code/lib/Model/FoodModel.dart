import 'package:flutter/cupertino.dart';

class FoodModel {
  String name;
  String category;
  TextEditingController quantity;

  FoodModel(
      {required this.name, required this.category, required this.quantity});
  Map<String, dynamic> toMapWithoutController() {
    return {
      'name': name,
      'category': category,
      'quantity': int.parse(quantity.text)
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['Name'] ?? '',
      category: map['Category'] ?? '',
      quantity: map['Quantity'] ?? 0,
    );
  }
}
