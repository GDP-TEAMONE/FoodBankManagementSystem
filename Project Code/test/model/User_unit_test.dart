import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbankmanagementsystem/Model/User.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Users', () {
    test('toJson should convert User object to JSON', () {
      
      final user = Users(
        name: 'John Doe',
        phone: '1234567890',
        id: '123456',
        sts: true,
        pass: 'password',
        email: 'john@example.com',
        address: '123 Main St',
        type: 'Admin',
      );

      
      final json = user.toJson();

      
      expect(json['Name'], 'John Doe');
      expect(json['Phone'], '1234567890');
      expect(json['ID'], '123456');
      expect(json['Status'], true);
      expect(json['Password'], 'password');
      expect(json['Email'], 'john@example.com');
      expect(json['Address'], '123 Main St');
      expect(json['Type'], 'Admin');
    });

    test('fromJson should convert JSON to User object', () {
      
      final json = {
        'Name': 'John Doe',
        'Phone': '1234567890',
        'ID': '123456',
        'Status': true,
        'Password': 'password',
        'Email': 'john@example.com',
        'Address': '123 Main St',
        'Type': 'Admin',
      };

      
      final user = Users.fromJson(json);

      expect(user.name, 'John Doe');
      expect(user.phone, '1234567890');
      expect(user.id, '123456');
      expect(user.sts, true);
      expect(user.pass, 'password');
      expect(user.email, 'john@example.com');
      expect(user.address, '123 Main St');
      expect(user.type, 'Admin');
    });
  });
}