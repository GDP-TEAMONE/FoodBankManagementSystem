import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Model/User.dart';
import 'package:foodbankmanagementsystem/Screens/DashBoard/DashBoard.dart';
import 'package:foodbankmanagementsystem/Screens/Widgets/chat_box.dart';
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

  group('Dashboard Chat Section Tests', () {
    const screenWidth = 1260.0;
    const screenHeight = 640.0;

    testWidgets('Dashboard widget shows the correct title', (WidgetTester tester) async {
      await tester.pumpWidget( MaterialApp(
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
      ),);

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('Adding a user to chat updates the chat section', (WidgetTester tester) async {
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

      expect(find.byType(ChatBox), findsNothing);

      await tester.pumpAndSettle();

      expect(find.byType(DashBoard), findsOneWidget);

      final testUser = Users(
        name: 'John Doe',
        phone: '1234567890',
        id: '123456',
        sts: true,
        pass: 'password',
        email: 'john@example.com',
        address: '123 Main St',
        type: 'Admin',
      );

      await tester.pumpAndSettle (const Duration(milliseconds: 600));

      final DashBoardState state = tester.state(find.byType(DashBoard));
      state.addtochatuser(testUser);
      expect(state.chatuser.length, equals(1));
    });

    testWidgets('Removing a user from chat updates the chat section', (WidgetTester tester) async {
      await tester.pumpWidget( MaterialApp(
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
      ),);

      expect(find.byType(ChatBox), findsNothing);

      await tester.pumpAndSettle();

      expect(find.byType(DashBoard), findsOneWidget);

      final testUser = Users(
        name: 'John Doe',
        phone: '1234567890',
        id: '123456',
        sts: true,
        pass: 'password',
        email: 'john@example.com',
        address: '123 Main St',
        type: 'Admin',
      );

      await tester.pumpAndSettle (const Duration(milliseconds: 600));

      final DashBoardState state = tester.state(find.byType(DashBoard));
      state.addtochatuser(testUser);
      expect(state.chatuser.length, equals(1));

      state.removefromchatuser(testUser);

      await tester.pumpAndSettle();

      expect(find.byType(ChatBox), findsNothing);
    });
  });
}