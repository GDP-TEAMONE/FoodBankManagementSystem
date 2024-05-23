import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String name, phone, email, id, type, pass, address;
  bool sts;
  bool seen;

  Users({
    required this.name,
    required this.phone,
    required this.id,
    required this.sts,
    required this.pass,
    required this.email,
    required this.address,
    required this.type,
    this.seen = false,
  });
  Users copyWith({bool? seen}) {
    return Users(
      name: this.name,
      phone: this.phone,
      email: this.email,
      id: this.id,
      type: this.type,
      pass: this.pass,
      address: this.address,
      sts: this.sts,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Phone': phone,
        'ID': id,
        'Password': pass,
        'Address': address,
        'Status': sts,
        'Email': email,
        'Type': type,
      };

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['Name'] ?? '',
      phone: json['Phone'] ?? '',
      id: json['ID'] ?? '',
      sts: json['Status'] ?? false,
      pass: json['Password'] ?? '',
      email: json['Email'] ?? '',
      address: json['Address'] ?? '',
      type: json['Type'] ?? '',
    );
  }

  Future<List<Map<String, dynamic>>> fetchChats() async {
    List<Map<String, dynamic>> chats = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ChatsAdmin')
          .where('userId', isEqualTo: id)
          .orderBy('timestamp', descending: true)
          .get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> chat = {
          'message': doc['message'],
          'timestamp': doc['timestamp'],
          'isSelf': doc['isSelf'],
          'seen': doc['seen'],
        };
        chats.add(chat);
      });

      return chats;
    } catch (e) {
      print('Error fetching chats: $e');
      return [];
    }
  }
}
