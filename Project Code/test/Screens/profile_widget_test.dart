import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:foodbankmanagementsystem/Screens/profile/profile.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:foodbankmanagementsystem/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MockSharedPreferences.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
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

  group('Profile Widget Tests', () {
    const screenWidth = 1260.0;
    const screenHeight = 640.0;

    Future<void> createWidgetUnderTest(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              MediaQueryData mediaQueryData = const MediaQueryData(
                size: Size(screenWidth, screenHeight),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: ProfilePage(),
              );
            },
          ),
        ),
      );
    }

    testWidgets('Profile widget shows the correct title', (WidgetTester tester) async {
      await createWidgetUnderTest(tester);
      await tester.pumpAndSettle();
      expect(find.text('Profile Page'), findsOneWidget);
    });

    testWidgets('Profile widget shows user details', (WidgetTester tester) async {
      await createWidgetUnderTest(tester);
      await tester.pumpAndSettle();
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('Profile widget has an edit button', (WidgetTester tester) async {
      await createWidgetUnderTest(tester);
      await tester.pumpAndSettle();
      expect(find.text('UPDATE'), findsOneWidget);
    });
  });
}