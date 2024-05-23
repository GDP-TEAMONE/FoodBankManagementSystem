import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Model/availableModel.dart';

void main() {
  group('AvailableModel', () {
    test('constructor initializes object correctly', () {
      // Create test data
      final id = '1';
      final name = 'Test Name';
      final start = DateTime(2022, 1, 1);
      final longitude = 10.0;
      final latitude = 20.0;
      final end = DateTime(2022, 1, 2);
      final uid = 'user123';

      // Create an instance of AvailableModel
      final availableModel = AvailableModel(
        id: id,
        name: name,
        start: start,
        longitude: longitude,
        latitude: latitude,
        end: end,
        uid: uid,
      );

      // Verify that the object properties are initialized correctly
      expect(availableModel.id, id);
      expect(availableModel.name, name);
      expect(availableModel.start, start);
      expect(availableModel.longitude, longitude);
      expect(availableModel.latitude, latitude);
      expect(availableModel.end, end);
      expect(availableModel.uid, uid);
    });

    test('object properties are accessible', () {
      // Create test data
      final id = '2';
      final name = 'Another Name';
      final start = DateTime(2022, 2, 1);
      final longitude = 30.0;
      final latitude = 40.0;
      final end = DateTime(2022, 2, 2);
      final uid = 'user456';

      // Create an instance of AvailableModel
      final availableModel = AvailableModel(
        id: id,
        name: name,
        start: start,
        longitude: longitude,
        latitude: latitude,
        end: end,
        uid: uid,
      );

      // Verify that the object properties are accessible and hold the expected values
      expect(availableModel.id, id);
      expect(availableModel.name, name);
      expect(availableModel.start, start);
      expect(availableModel.longitude, longitude);
      expect(availableModel.latitude, latitude);
      expect(availableModel.end, end);
      expect(availableModel.uid, uid);
    });
  });
}