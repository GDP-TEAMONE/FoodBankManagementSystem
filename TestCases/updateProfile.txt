import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MockSharedPreferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthService authService;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    authService = AuthService();
    SharedPreferences.setMockInitialValues({});
    when(mockSharedPreferences.getBool('isAuthenticated')).thenReturn(true);
    when(mockSharedPreferences.getString('Type')).thenReturn('Admin'); // Note the lowercase 'type'
    when(mockSharedPreferences.getString('dataee')).thenReturn(
      json.encode({
        'name': null,
        'phone': null,
        'id': null,
        'sts': true,
        'pass': null,
        'email': null,
        'address': null,
        'type': null, // Corrected to lowercase 'type'
      }),
    );
  });

  group('AuthService Integration Test', () {
    test('Test loadAuthenticationStatus', () async {
      await authService.loadAuthenticationStatus();

      expect(authService.isAuthenticated.value, false);
      expect(authService.type, '');
      expect(authService.user, null);
      expect(authService.user?.id, null);
      expect(authService.user?.name, null);
      expect(authService.user?.email, null);
      expect(authService.user?.address, null);
    });
  });
}