import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Screens/register/register.dart';

void main() {
  testWidgets('Register page UI test', (WidgetTester tester) async {
    const screenWidth = 1360.0;
    const screenHeight = 640.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) { MediaQueryData mediaQueryData = const MediaQueryData(
            size: Size(screenWidth, screenHeight),
          );
            return MediaQuery(
              data: mediaQueryData.copyWith(size: Size(screenWidth, screenHeight)),
              child: RegisterPage(),
            );
          },
        ),
      ),
    );

    expect(find.text('Register to Account'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(5));
    expect(find.text('SIGN UP'), findsOneWidget);
  });

}