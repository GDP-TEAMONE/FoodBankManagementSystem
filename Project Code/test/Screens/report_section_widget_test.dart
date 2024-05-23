import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Model/User.dart';
import 'package:foodbankmanagementsystem/Screens/DashBoard/DashBoard.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MockFirebase.dart';
import 'package:get/get.dart';

import '../MockSharedPreferences.dart';

void main() {
  setupFirebaseAuthMocks();

  late MockSharedPreferences mockSharedPreferences;
  setUpAll(() async {
    mockSharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
    await Firebase.initializeApp();
    Get.put(AuthService());
  });

  setUp(() {
    final authService = Get.find<AuthService>();
    authService.updateAuthenticationStatus(
      Users(
        name: 'John Doe',
        phone: '1234567890',
        id: '123456',
        sts: true,
        pass: 'password',
        email: 'john@example.com',
        address: '123 Main St',
        type: 'Admin',
      ),
      false,
    );
  });

  const screenWidth = 1360.0;
  const screenHeight = 640.0;
  group('Dashboard Report Section', () {
    testWidgets('Dashboard shows correct donation summary',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              MediaQueryData mediaQueryData = const MediaQueryData(
                size: Size(screenWidth, screenHeight),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: DashBoard(),
              );
            },
          ),
        ),
      );

      expect(find.text('Donation Summary till'), findsOneWidget);
    });

    testWidgets('Dashboard shows correct yearly progress report',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              MediaQueryData mediaQueryData = const MediaQueryData(
                size: Size(screenWidth, screenHeight),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: DashBoard(),
              );
            },
          ),
        ),
      );
      expect(find.text('Yearly Progress Report'), findsOneWidget);
    });
  });
}
