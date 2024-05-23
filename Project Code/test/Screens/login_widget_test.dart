import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Screens/login/login.dart';

void main() {
  testWidgets('Login page UI test', (WidgetTester tester) async {
    const screenWidth = 360.0;
    const screenHeight = 640.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            MediaQueryData mediaQueryData = const MediaQueryData(
              size: Size(screenWidth, screenHeight),
            );
            return MediaQuery(
              data: mediaQueryData,
              child: LoginPage(),
            );
          },
        ),
      ),
    );

    expect(find.text('Login in Account'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Keep me logged in'), findsOneWidget);
    expect(find.text('SIGN IN'), findsOneWidget);
  });


  testWidgets('Test email and password input', (WidgetTester tester) async {
    const screenWidth = 360.0;
    const screenHeight = 640.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            MediaQueryData mediaQueryData = const MediaQueryData(
              size: Size(screenWidth, screenHeight),
            );
            return MediaQuery(
              data: mediaQueryData,
              child: LoginPage(),
            );
          },
        ),
      ),
    );

    
    await tester.enterText(find.byKey(Key('emailTextField')), 'test@example.com');
    await tester.enterText(find.byKey(Key('passwordTextField')), 'password');

    
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
  });


  testWidgets('Test SIGN IN button onTap', (WidgetTester tester) async {
    const screenWidth = 360.0;
    const screenHeight = 640.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            MediaQueryData mediaQueryData = const MediaQueryData(
              size: Size(screenWidth, screenHeight),
            );
            return MediaQuery(
              data: mediaQueryData,
              child: LoginPage(),
            );
          },
        ),
      ),
    );
    expect(find.text('SIGN IN'), findsOneWidget);
    await tester.pump();
  });

}