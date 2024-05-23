import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../route.dart';
import 'auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!AuthService.to.isAuthenticated.value) {
      return const RouteSettings(name: authenticationPageRoute);
    }
    String userType = AuthService.to.type;
    List<String> adminPages = [
      homePageRoute,
      profilePageRoute,
      donationsPageRoute,
      inventoryPageRoute,
      adminassignPageRoute,
      volunteerassignPageRoute
    ];
    List<String> fooddonerPages = [
      fooddonorhomePageRoute,
      profilePageRoute,
    ];
    List<String> volunteerPages = [
      volunteerhomePageRoute,
      profilePageRoute,
    ];
    List<String> recipientPages = [
      recipienthomePageRoute,
      profilePageRoute,
      recipientBuyPageRoute
    ];
    if (userType == 'Admin' && !adminPages.contains(route)) {
      return const RouteSettings(name: homePageRoute);
    } else if (userType == 'Food Donor' && !fooddonerPages.contains(route)) {
      return const RouteSettings(name: fooddonorhomePageRoute);
    } else if (userType == 'Volunteer' && !volunteerPages.contains(route)) {
      return const RouteSettings(name: volunteerhomePageRoute);
    } else if (userType == 'Recipient' && !recipientPages.contains(route)) {
      return const RouteSettings(name: recipienthomePageRoute);
    }
    return null;
  }
}
