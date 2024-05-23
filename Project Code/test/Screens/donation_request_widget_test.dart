import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodbankmanagementsystem/Screens/FoodDonorHome/DonationRequest.dart';

void main() {
  group('Donation Request Widget Tests', () {
    const screenWidth = 1260.0;
    const screenHeight = 640.0;

    testWidgets('Donation Request widget shows the correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              MediaQueryData mediaQueryData = const MediaQueryData(
                size: Size(screenWidth, screenHeight),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: DonationRequestForm(),
              );
            },
          ),
        ),
      );
      expect(find.text('Add The Details To Kick Of Donations'), findsOneWidget);
    });

    testWidgets('Donation Request widget shows donation form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              MediaQueryData mediaQueryData = const MediaQueryData(
                size: Size(screenWidth, screenHeight),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: DonationRequestForm(),
              );
            },
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsNWidgets(4));
    });

    testWidgets('Donation Request widget has a submit button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              MediaQueryData mediaQueryData = const MediaQueryData(
                size: Size(screenWidth, screenHeight),
              );
              return MediaQuery(
                data: mediaQueryData,
                child: DonationRequestForm(),
              );
            },
          ),
        ),
      );
      expect(find.widgetWithText(ElevatedButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

  });
}