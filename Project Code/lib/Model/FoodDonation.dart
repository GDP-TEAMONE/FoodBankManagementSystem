import 'package:cloud_firestore/cloud_firestore.dart';

class FoodDonation {
  List<dynamic> items;
  DateTime expirationDate;
  String pickupDeliveryTime;
  String description;
  String donationType;
  String deliveryOption;
  String address;
  String contactInfo;
  String status;
  DateTime requesteddate;
  String requestedBy;
  String additionalNotes;

  FoodDonation({
    required this.items,
    required this.expirationDate,
    required this.requesteddate,
    required this.pickupDeliveryTime,
    required this.description,
    required this.donationType,
    required this.deliveryOption,
    required this.address,
    required this.contactInfo,
    required this.status,
    required this.requestedBy,
    required this.additionalNotes,
  });

  factory FoodDonation.fromMap(Map<String, dynamic> map) {
    return FoodDonation(
      items: map['foods'] ?? [],
      expirationDate: map['expirationDate'].toDate(),
      requesteddate: map['requested date'].toDate(),
      pickupDeliveryTime: map['pickupDeliveryTime'] ?? '',
      description: map['description'] ?? '',
      donationType: map['donationType'] ?? '',
      deliveryOption: map['deliveryOption'] ?? '',
      address: map['address'] ?? '',
      contactInfo: map['contactInfo'] ?? '',
      status: map['status'] ?? '',
      requestedBy: map['requested by'] ?? '',
      additionalNotes: map['additionalNotes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foods': items,
      'expirationDate': expirationDate,
      'pickupDeliveryTime': pickupDeliveryTime,
      'description': description,
      'donationType': donationType,
      'deliveryOption': deliveryOption,
      'address': address,
      'requested date': requesteddate,
      'contactInfo': contactInfo,
      'status': status,
      'requestedBy': requestedBy,
      'additionalNotes': additionalNotes,
    };
  }
}
