import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodbankmanagementsystem/Screens/AssingAdmin/AssignAdmin.dart';
import 'package:foodbankmanagementsystem/Screens/RecipientBuy/RecipientBuy.dart';
import 'package:foodbankmanagementsystem/Screens/RecipientHome/RecipientHome.dart';
import 'package:foodbankmanagementsystem/Screens/VolunteerHome/VolunteerHome.dart';
import 'package:foodbankmanagementsystem/Screens/profile/profile.dart';
import 'package:foodbankmanagementsystem/Screens/register/register.dart';
import 'package:foodbankmanagementsystem/route.dart';
import 'package:get/get.dart';

import 'Screens/AboutUsPage/AboutUS.dart';
import 'Screens/AssingVolunteer/AssignVolunteer.dart';
import 'Screens/DashBoard/DashBoard.dart';
import 'Screens/Donations/DonationAdmin.dart';
import 'Screens/FoodDonorHome/DonationRequest.dart';
import 'Screens/FoodDonorHome/FoodDonorHome.dart';
import 'Screens/Inventory/Inventory.dart';
import 'Screens/login/login.dart';
import 'helper/auth_middleware.dart';
import 'helper/auth_service.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDaoOA7eA_tFJgyoM-D5AHIuYAxx0dAv0I",
        authDomain: "food-bank-management-system.firebaseapp.com",
        projectId: "food-bank-management-system",
        storageBucket: "food-bank-management-system.appspot.com",
        messagingSenderId: "996600627928",
        appId: "1:996600627928:web:87ce4487e7fcbec214cdad",
        measurementId: "G-V5T6SHKJ5E"),
  );
  await Get.put(AuthService());
  final authService = AuthService.to;
  await authService.loadAuthenticationStatus();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Bank Management System',
      defaultTransition: Transition.fadeIn,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      initialRoute: authenticationPageRoute,
      getPages: [
        GetPage(
          name: authenticationPageRoute,
          page: () => LoginPage(),
        ),
        GetPage(
          name: registerPageRoute,
          page: () => RegisterPage(),
        ),
        GetPage(
          name: aboutusPageRoute,
          page: () => AboutUsPage(),
        ),
        GetPage(
            name: homePageRoute,
            page: () => DashBoard(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: recipientBuyPageRoute,
            page: () => RecipientBuyPage(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: volunteerassignPageRoute,
            page: () => AssignVolunteer(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: inventoryPageRoute,
            page: () => InventoryPage(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: donationsPageRoute,
            page: () => DonationAdmin(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: adminassignPageRoute,
            page: () => AssignAdmin(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: fooddonorhomePageRoute,
            page: () => FoodDonorHome(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: volunteerhomePageRoute,
            page: () => VolunteerHome(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: recipienthomePageRoute,
            page: () => RecipientHome(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: profilePageRoute,
            page: () => ProfilePage(),
            middlewares: [AuthMiddleware()]),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
